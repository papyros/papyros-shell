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

#ifndef DESKTOPSCROBBLER
#define DESKTOPSCROBBLER

#include <QQuickItem>
#include <QFileSystemWatcher>
#include <QDir>
#include <QQmlParserStatus>
#include <cmath>

#include "../qquicklist/qquicklist.h"
#include "desktopfile.h"

class DesktopScrobbler : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QObjectListModel *desktopFiles READ desktopFiles NOTIFY desktopFilesChanged)
    Q_INTERFACES(QQmlParserStatus)

public:
    DesktopScrobbler(QQuickItem *parent = 0);

    QObjectListModel *desktopFiles()
    {
        return desktopList.getModel();
    }

    static bool compare(const DesktopFile *a, const DesktopFile *b);

    Q_INVOKABLE int indexOfName(QString name);

    virtual void componentComplete();

signals:
    void desktopFilesChanged(QObjectListModel *);

private slots:
    void onFileChanged(const QString &path);
    void onDirectoryChanged(const QString &directory);

private:
    QFileSystemWatcher *fileWatcher;
    QFileSystemWatcher *dirWatcher;
    QQuickList<DesktopFile> desktopList;
    DesktopFile *desktopFileForPath(const QString &path);
    QStringList filesInPaths(QStringList paths, QStringList filters);
};

#endif // DESKTOPSCROBBLER
