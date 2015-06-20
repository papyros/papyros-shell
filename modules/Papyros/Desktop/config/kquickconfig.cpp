/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "kquickconfig.h"

#include <QDebug>
#include <QStandardPaths>
#include <QThread>

#include <KConfigCore/KConfigGroup>

KQuickConfig::KQuickConfig(QObject *parent)
        : QQmlPropertyMap(this, parent)
{
    connect(this, &KQuickConfig::fileChanged, this, &KQuickConfig::update);
    connect(this, &KQuickConfig::groupChanged, this, &KQuickConfig::update);
    connect(this, &KQuickConfig::defaultsChanged, this, &KQuickConfig::update);
}

KQuickConfig::~KQuickConfig() {
    delete dirWatcher;
}

void KQuickConfig::setFile(QString file)
{
    if (m_file != file) {
        m_file = file;
        emit fileChanged();
    }
}

void KQuickConfig::setGroup(QString group)
{
    if (m_group != group) {
        m_group = group;
        emit groupChanged();
    }
}

void KQuickConfig::setDefaults(QVariantMap defaults)
{
    if (m_defaults != defaults) {
        m_defaults = defaults;
        emit defaultsChanged();
    }
}

QVariant KQuickConfig::getConfigEntry(const QString &key)
{
    return m_config->group(group()).readEntry(key, defaults().value(key));
}

bool KQuickConfig::isEditable(const QString &key)
{
    return !m_config->group(group()).isEntryImmutable(key);
}

void KQuickConfig::update()
{
    delete dirWatcher;
    dirWatcher = nullptr;

    if (file().isEmpty() || group().isEmpty()) {
        return;
    }

    m_config = KSharedConfig::openConfig(file(), KConfig::NoGlobals);

    settingsChanged();

    QStringList files;

    if (QDir::isAbsolutePath(file())) {
        files << file();
    } else {
        Q_FOREACH(const QString &f,
                QStandardPaths::locateAll(QStandardPaths::GenericConfigLocation, file())) {
            files.prepend(f);
        }
    }

    dirWatcher = new QFileSystemWatcher(files, this);

    connect(dirWatcher, &QFileSystemWatcher::fileChanged, this, [this](const QString& path) {
        QFileInfo checkFile(path);
        while(!checkFile.exists()) {
            QThread::msleep(10);
        }

        dirWatcher->addPath(path);
        settingsChanged();
    });
}

void KQuickConfig::settingsChanged()
{
    m_config->reparseConfiguration();

    Q_FOREACH(QString key, defaults().keys()) {
        QVariant value = getConfigEntry(key);
        if (!contains(key) || this->value(key) != value) {
            this->insert(key, value);
            emit valueChanged(key, value);
        }
    }
}

QVariant KQuickConfig::updateValue(const QString& key, const QVariant &value)
{
    KConfigGroup group = m_config->group(this->group());

    if (m_config == nullptr)
        return QVariant();

    if (isEditable(key)) {
        group.writeEntry(key, value);
        m_config->sync();
        return value;
    } else {
        qWarning("unable to set key '%s' to value '%s'",
                key.toUtf8().constData(),
                value.toString().toUtf8().constData());
        return getConfigEntry(key);
    }
}
