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

#include "desktopscrobbler.h"

DesktopScrobbler::DesktopScrobbler(QQuickItem *parent)
        : QQuickItem(parent) {}

QStringList DesktopScrobbler::filesInPaths(QStringList paths, QStringList filters)
{
    QStringList allFiles;

    for (QString path : paths) {
        QStringList fileNames = QDir(path).entryList(filters);

        for (QString fileName : fileNames) {
            allFiles << path + "/" + fileName;
        }
    }

    return allFiles;
}

void DesktopScrobbler::componentComplete()
{
    QStringList paths; paths << "~/.local/share/applications"
                             << "/usr/local/share/applications"
                             << "/usr/share/applications";
    QStringList filter; filter << "*.desktop";

    QStringList files = filesInPaths(paths, filter);

    for (QString fileName : files) {
        DesktopFile *desktopFile = new DesktopFile(fileName, this);

        if (desktopFile->isShown())
            desktopList << desktopFile;
    }

    desktopList.sort(DesktopScrobbler::compare);

    fileWatcher = new QFileSystemWatcher(files, this);
    dirWatcher = new QFileSystemWatcher(paths, this);

    connect(fileWatcher, &QFileSystemWatcher::fileChanged,
            this, &DesktopScrobbler::onFileChanged);
    connect(dirWatcher, &QFileSystemWatcher::directoryChanged,
            this, &DesktopScrobbler::onDirectoryChanged);
}

void DesktopScrobbler::onFileChanged(const QString &path)
{
    if (QFile::exists(path)) {
        for (DesktopFile *desktopFile : desktopList) {
            if (desktopFile->m_path == path) {
                desktopFile->load();
                break;
            }
        }
    } else {
        for (DesktopFile *desktopFile : desktopList) {
            if (desktopFile->m_path == path) {
                desktopList.removeOne(desktopFile);
                fileWatcher->removePath(path);
                delete desktopFile;

                break;
            }
        }
    }

    desktopList.sort(DesktopScrobbler::compare);

    emit desktopFilesChanged(desktopFiles());
}

DesktopFile *DesktopScrobbler::desktopFileForPath(const QString &path)
{
    for (DesktopFile *desktopFile : desktopList) {
        if (desktopFile->m_path == path)
            return desktopFile;
    }

    return nullptr;
}

void DesktopScrobbler::onDirectoryChanged(const QString &directory)
{
    QStringList files = QDir(directory).entryList(QStringList() << "*.desktop");

    for (QString file : files) {
        QString path = directory + "/" + file;

        if (desktopFileForPath(path) == nullptr) {
            desktopList << new DesktopFile(path, this);
            desktopList.sort(DesktopScrobbler::compare);

            emit desktopFilesChanged(desktopFiles());

            fileWatcher->addPath(path);
        }
    }
}

bool DesktopScrobbler::compare(const DesktopFile *a, const DesktopFile *b)
{
    return a->name().toLower() < b->name().toLower();
}

int DesktopScrobbler::indexOfName(QString name)
{
    for (int i = 0; i < desktopList.length(); i++) {
        DesktopFile *desktopFile = desktopList.at(i);

        if (desktopFile->name().startsWith(name, Qt::CaseInsensitive))
            return i;
    }
    return -1;
}
