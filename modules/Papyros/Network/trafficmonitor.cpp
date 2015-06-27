/*
    Copyright 2010 Sebastian Kügler <sebas@kde.org>
    Copyright 2010-2013 Lamarque V. Souza <lamarque@kde.org>
    Copyright 2013 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "trafficmonitor.h"

#include <Plasma/DataEngineManager>

#include <QLabel>
#include <QGraphicsLinearLayout>

#include <KLocale>
#include <KGlobalSettings>

#include <NetworkManagerQt/Manager>

#include "globalconfig.h"

TrafficMonitor::TrafficMonitor(QGraphicsItem* parent)
    : QGraphicsWidget(parent, 0)
    , m_device(0)
    , m_updateEnabled(false)
{
    QGraphicsLinearLayout * layout = new QGraphicsLinearLayout(this);
    layout->setOrientation(Qt::Vertical);

    m_txColor.setAlphaF(0.6);
    m_txColor = QColor("#0099FF");
    m_rxColor = QColor("#91FF00");

    m_trafficPlotter = new Plasma::SignalPlotter(this);
    m_trafficPlotter->setFont(KGlobalSettings::smallestReadableFont());
    m_trafficPlotter->addPlot(m_rxColor);
    m_trafficPlotter->addPlot(m_txColor);
    m_trafficPlotter->setThinFrame(true);
    m_trafficPlotter->setShowLabels(true);
    m_trafficPlotter->setShowTopBar(true);
    m_trafficPlotter->setShowVerticalLines(false);
    m_trafficPlotter->setShowHorizontalLines(true);
    m_trafficPlotter->setHorizontalLinesCount(2);
    m_trafficPlotter->setUseAutoRange(true);
    m_trafficPlotter->setSizePolicy(QSizePolicy::QSizePolicy::Expanding, QSizePolicy::QSizePolicy::Expanding);
    m_trafficPlotter->setMinimumHeight(100);

    layout->addItem(m_trafficPlotter);

    m_traffic = new Plasma::Label(this);
    m_traffic->setFont(KGlobalSettings::smallestReadableFont());
    m_traffic->nativeWidget()->setWordWrap(false);
    m_traffic->nativeWidget()->setTextInteractionFlags(Qt::TextSelectableByMouse);

    layout->addItem(m_traffic);

    setLayout(layout);

    Plasma::DataEngineManager::self()->loadEngine("systemmonitor");

    connect(m_traffic, SIGNAL(heightChanged()), this, SIGNAL(heightChanged()));
}

TrafficMonitor::~TrafficMonitor()
{
}

void TrafficMonitor::setDevice(const QString& device)
{
    if (m_device && m_device->uni() == device) {
        return;
    }

    if (device.isEmpty()) {
        resetMonitor();
        setUpdateEnabled(false);
        return;
    }

    m_device = NetworkManager::findNetworkInterface(device);

    if (!m_device) {
        resetMonitor();
        setUpdateEnabled(false);
        return;
    }

    QString interfaceName = m_device->ipInterfaceName();
    if (interfaceName.isEmpty()) {
        interfaceName = m_device->interfaceName();
    }

    m_rxSource = QString("network/interfaces/%1/receiver/data").arg(interfaceName);
    m_txSource = QString("network/interfaces/%1/transmitter/data").arg(interfaceName);
    m_rxTotalSource = QString("network/interfaces/%1/receiver/dataTotal").arg(interfaceName);
    m_txTotalSource = QString("network/interfaces/%1/transmitter/dataTotal").arg(interfaceName);
    m_rxTotal = m_txTotal = 0;

    Plasma::DataEngine * engine = Plasma::DataEngineManager::self()->engine("systemmonitor");
    if (engine->isValid() && engine->query(m_rxSource).empty()) {
        Plasma::DataEngineManager::self()->unloadEngine("systemmonitor");
        Plasma::DataEngineManager::self()->loadEngine("systemmonitor");
    }

    setUpdateEnabled(true);
}

QString TrafficMonitor::device() const
{
    if (m_device)
        return m_device->uni();

    return QString();
}

qreal TrafficMonitor::height() const
{
    return m_trafficPlotter->geometry().height() + m_traffic->geometry().height() + 5;
}

void TrafficMonitor::resetMonitor()
{
    const QString format = "<b>%1:</b>&nbsp;%2";
    QString temp;

    temp = QString("<qt><table align=\"left\" border=\"0\"><tr><td align=\"right\" width=\"50%\">");
    temp += QString(format).arg(i18nc("traffic received empty", "Received")).arg("-");
    temp += QString("</td></tr><tr><td width=\"50%\">&nbsp;");
    temp += QString(format).arg(i18nc("traffic transmitted empty", "Transmitted")).arg("-");
    temp += QString("</td></tr></table></qt>");
    m_traffic->setText(temp);

    m_trafficPlotter->removePlot(0);
    m_trafficPlotter->removePlot(1);
    m_trafficPlotter->addPlot(m_rxColor);
    m_trafficPlotter->addPlot(m_txColor);
}

void TrafficMonitor::dataUpdated(const QString& sourceName, const Plasma::DataEngine::Data& data)
{
    if (sourceName == m_txSource) {
        m_tx = data["value"].toString();
        m_txUnit = data["units"].toString();
    } else if (sourceName == m_rxSource) {
        m_rx = data["value"].toString();
        m_rxUnit = data["units"].toString();
    } else if (sourceName == m_rxTotalSource) {
        m_rxTotal = data["value"].toString().toLong();
    } else if (sourceName == m_txTotalSource) {
        m_txTotal = data["value"].toString().toLong();
    }
    updateTraffic();
}

void TrafficMonitor::setUpdateEnabled(bool enable)
{
    Plasma::DataEngine * engine = Plasma::DataEngineManager::self()->engine("systemmonitor");
    if (engine->isValid()) {
        int interval = 2000;
        if (enable) {
            if (m_device) {
                engine->connectSource(m_rxSource, this, interval);
                engine->connectSource(m_txSource, this, interval);
                engine->connectSource(m_rxTotalSource, this, interval);
                engine->connectSource(m_txTotalSource, this, interval);
            }
        } else {
            engine->disconnectSource(m_rxSource, this);
            engine->disconnectSource(m_txSource, this);
            engine->disconnectSource(m_rxTotalSource, this);
            engine->disconnectSource(m_txTotalSource, this);
        }
    }
    m_updateEnabled = enable;
}

void TrafficMonitor::updateTraffic()
{
    double _r;
    double _t;
    QString r, t;
    int precision = 0;

    if (GlobalConfig().networkSpeedUnit() == GlobalConfig::KBits) {
        _r = m_rx.toInt() << 3;
        _t = m_tx.toInt() << 3;

        if (_r < 1000) {
            m_rxUnit = i18n("KBit/s");
        } else if (_r < 1000000) {
            m_rxUnit = i18n("MBit/s");
            _r /= 1000;
            _t /= 1000;
            precision = 2;
        } else {
            m_rxUnit = i18n("GBit/s");
            _r /= 1000000;
            _t /= 1000000;
            precision = 2;
        }

        m_txUnit = m_rxUnit;
        r = QString("%1 %2").arg(QString::number(_r, 'f', precision), m_rxUnit);
        t = QString("%1 %2").arg(QString::number(_t, 'f', precision), m_txUnit);
    } else {
        _r = m_rx.toDouble();
        _t = m_tx.toDouble();

        r = KLocale::global()->formatByteSize(_r*1024);
        r.append("/s");
        t = KLocale::global()->formatByteSize(_t*1024);
        t.append("/s");
    }

    QList<double> v;
    v << _r << _t;
    m_trafficPlotter->addSample(v);
    m_trafficPlotter->setUnit(m_rxUnit);

    const QString s = i18nc("traffic, e.g. n KB/s\n m KB/s", "%1 %2", r, t);
    m_trafficPlotter->setTitle(s);

    const QString format = "<b>%1:</b>&nbsp;%2";
    QString temp;

    temp = QString("<qt><table align=\"left\" border=\"0\"><tr>");
    temp += QString("<td width=\"20pt\" bgcolor=\"%1\">&nbsp;&nbsp;").arg(m_rxColor.name());
    temp += QString("</td><td width=\"50%\">");
    temp += QString(format).arg(i18n("Received"), KLocale::global()->formatByteSize(m_rxTotal*1000, 2));
    temp += QString("&nbsp;&nbsp;</td></tr><tr><td width=\"20pt\" bgcolor=\"%1\">&nbsp;&nbsp;").arg(m_txColor.name());
    temp += QString("</td><td width=\"50%\">");
    temp += QString(format).arg(i18n("Transmitted"), KLocale::global()->formatByteSize(m_txTotal*1000, 2));
    temp += QString("</td></tr></table></qt>");
    m_traffic->setText(temp);
}
