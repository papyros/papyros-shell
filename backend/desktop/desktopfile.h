/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef DESKTOPFILE_H
#define DESKTOPFILE_H

#include <QObject>
#include <QSettings>

class DesktopFile : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name MEMBER m_name NOTIFY dataChanged)
    Q_PROPERTY(QString iconName MEMBER m_iconName NOTIFY dataChanged)
    Q_PROPERTY(QString comment MEMBER m_comment NOTIFY dataChanged)
    Q_PROPERTY(QString exec MEMBER m_exec NOTIFY dataChanged)
    Q_PROPERTY(QString darkColor MEMBER m_darkColor NOTIFY dataChanged)

    Q_PROPERTY(QString appId MEMBER m_appId WRITE setAppId NOTIFY appIdChanged);
    Q_PROPERTY(QString path MEMBER m_path WRITE setPath NOTIFY pathChanged)

    Q_PROPERTY(bool isValid MEMBER m_isValid NOTIFY isValidChanged)

public:
    explicit DesktopFile(QString path = "", QObject *parent = 0);

    static QString getEnvVar(int pid);

    Q_INVOKABLE void launch();

    QString m_appId;
    QString m_path;

    QString m_name;
    QString m_iconName;
    QString m_exec;
    QString m_darkColor;
    QString m_comment;
    bool m_isValid;

public slots:
    void setAppId(QString appId);
    void setPath(QString path);
    void load();

signals:
    void dataChanged();
    void isValidChanged();
    void pathChanged();
    void appIdChanged();

private:
    QString pathFromAppId(QString appId);
    QString findFileInPaths(QString fileName, QStringList paths);
    QVariant localizedValue(const QSettings &desktopFile, QString key);
};

#endif // DESKTOPFILE_H
