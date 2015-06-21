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

#ifndef DESKTOP_FILES_H
#define DESKTOP_FILES_H

#include <QObject>
#include <QFileSystemWatcher>

#include "../qquicklist/qquicklist.h"
#include "desktopfile.h"

typedef QMap<QString, QProcess *> ApplicationMap;
typedef QMutableMapIterator<QString, QProcess *> ApplicationMapIterator;

class DesktopFiles : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObjectListModel *desktopFiles READ desktopFiles NOTIFY desktopFilesChanged)
    Q_PROPERTY(QString iconTheme READ iconTheme WRITE setIconTheme NOTIFY iconThemeChanged)

public:
    DesktopFiles(QObject *parent = 0);

    QObjectListModel *desktopFiles()
    {
        return desktopList.getModel();
    }

    QString iconTheme() const { return QIcon::themeName(); }

    static bool compare(const DesktopFile *a, const DesktopFile *b);

    Q_INVOKABLE int indexOfName(QString name);

    static DesktopFiles *sharedInstance();
    static QObject *qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    void setIconTheme(const QString &name) {
        QIcon::setThemeName(name);
        iconThemeChanged(name);
    }

    bool launchApplication(XdgDesktopFile *entry, const QStringList& urls);
    bool closeApplication(const QString &fileName);
    void closeApplications();

signals:
    void desktopFilesChanged(QObjectListModel *);
    void iconThemeChanged(const QString &name);

private slots:
    void onFileChanged(const QString &path);
    void onDirectoryChanged(const QString &directory);
    void processFinished(int exitCode);

private:
    ApplicationMap m_apps;
    QFileSystemWatcher *fileWatcher;
    QFileSystemWatcher *dirWatcher;
    QQuickList<DesktopFile> desktopList;
    DesktopFile *desktopFileForPath(const QString &path);
    QStringList filesInPaths(QStringList paths, QStringList filters);
};

#endif // DESKTOP_FILES_H
