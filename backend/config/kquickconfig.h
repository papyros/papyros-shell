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

#ifndef KQUICKCONFIG_H
#define KQUICKCONFIG_H

#include <QObject>
#include <QVariantMap>
#include <QtQml>
#include <QQmlParserStatus>
#include <QFileSystemWatcher>

#include <KConfigCore/KConfig>
#include <KConfigCore/KSharedConfig>

class KQuickConfig: public QQmlPropertyMap, public QQmlParserStatus
{
    Q_OBJECT

    Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged)
    Q_PROPERTY(QString group READ group WRITE setGroup NOTIFY groupChanged)
    Q_PROPERTY(QVariantMap defaults READ defaults WRITE setDefaults NOTIFY defaultsChanged)

public:
    KQuickConfig(QObject *parent = nullptr);
    ~KQuickConfig();

    QString file() const { return m_file; }
    QString group() const { return m_group; }
    QVariantMap defaults() const { return m_defaults; }

    bool isEditable(const QString &key);

    void classBegin();
    void componentComplete();

public slots:
    void setFile(QString file);
    void setGroup(QString group);
    void setDefaults(QVariantMap defaults);

Q_SIGNALS:
    void fileChanged();
    void groupChanged();
    void defaultsChanged();
    void changed(const QString &key, const QVariant &value);

private slots:
    void settingsChanged();
    void update();

private:
    QVariant getConfigEntry(const QString &key);
    QVariant updateValue(const QString& key, const QVariant &value);

    QString m_file;
    QString m_group;
    QVariantMap m_defaults;

    KSharedConfigPtr m_config;
    QFileSystemWatcher *dirWatcher;
};

#endif // KQUICKCONFIG_H
