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

#include <qt5xdg/xdgdesktopfile.h>

class DesktopFile : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY dataChanged)
    Q_PROPERTY(QString iconName READ iconName NOTIFY dataChanged)
    Q_PROPERTY(bool hasIcon READ hasIcon NOTIFY dataChanged)
    Q_PROPERTY(QString comment READ comment NOTIFY dataChanged)
    Q_PROPERTY(QString darkColor MEMBER m_darkColor NOTIFY dataChanged)

    Q_PROPERTY(QString appId MEMBER m_appId WRITE setAppId NOTIFY appIdChanged)
    Q_PROPERTY(QString path MEMBER m_path WRITE setPath NOTIFY pathChanged)

    Q_PROPERTY(bool isValid READ isValid NOTIFY dataChanged)
    Q_PROPERTY(bool isShown READ isShown NOTIFY dataChanged)

public:
    explicit DesktopFile(QString path = "", QObject *parent = 0);

    static QString getEnvVar(int pid);

    Q_INVOKABLE bool launch(const QStringList &urls) const;

    QString m_appId;
    QString m_path;
    QString m_darkColor;

    QString name() const;
    QString iconName() const;
    bool hasIcon() const;
    QString comment() const;
    bool isValid() const;
    bool isShown(const QString &environment = QString()) const;

    static QString canonicalAppId(QString appId);

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
    static QString pathFromAppId(QString appId);
    static QString findFileInPaths(QString fileName, QStringList paths);
    static QVariant localizedValue(const QSettings &desktopFile, QString key);

    XdgDesktopFile *m_desktopFile;
};

#endif // DESKTOPFILE_H
