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

#include "desktopfile.h"

#include "desktopfiles.h"

#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QTextStream>
#include <QLocale>
#include <QProcess>
#include <QDebug>

#include <qt5xdg/xdgdesktopfile.h>
#include <qt5xdg/xdgdirs.h>

DesktopFile::DesktopFile(QString path, QObject *parent) : QObject(parent)
{
    if (path.endsWith(".desktop"))
        setPath(path);
    else
        setAppId(path);
}

QString DesktopFile::getEnvVar(int pid)
{
    QFile envFile(QString("/proc/%1/environ").arg(pid));
    if (!envFile.open(QIODevice::ReadOnly | QIODevice::Text))
        return "";
    QTextStream in(&envFile);
    QString content = in.readAll();
    QRegExp rx("DESKTOP_FILE=(.+)");
    int pos = rx.indexIn(content);
    if (pos == -1)
        return "";
    return rx.cap(1);
}

void DesktopFile::setAppId(QString appId)
{
    appId = canonicalAppId(appId);
    setPath(appId + ".desktop");
}

QString DesktopFile::canonicalAppId(QString appId)
{
    bool notFound = pathFromAppId(appId).isEmpty();

    if (notFound && appId.startsWith("papyros-")) {
        QString name = appId.mid(8);

        if (name == "appcenter") {
            name = "AppCenter";
        } else {
            name = name.left(1).toUpper() + name.mid(1);
        }

        appId = "io.papyros." + name;

        qDebug() << appId;
    }

    return appId;
}

QString DesktopFile::pathFromAppId(QString appId)
{
    QStringList paths;
    paths << QDir::homePath() + "/.local/share/applications"
          << "/usr/local/share/applications"
          << "/usr/share/applications";

    return findFileInPaths(appId + ".desktop", paths);
}

QString DesktopFile::findFileInPaths(QString fileName, QStringList paths)
{
    for (QString path : paths) {
        if (QFile::exists(path + "/" + fileName)) {
            return path + "/" + fileName;
        }
    }

    return "";
}

void DesktopFile::setPath(QString path)
{
    m_path = path;

    // Extracts "papyros-files" from "/path/to/papyros-files.desktop"
    m_appId = QFileInfo(path).completeBaseName();

    if (!m_path.startsWith("/"))
        m_path = pathFromAppId(m_appId);

    emit pathChanged();
    emit appIdChanged();

    load();
}

void DesktopFile::load()
{
    m_desktopFile = XdgDesktopFileCache::getFile(m_path);
    emit dataChanged();
}

bool DesktopFile::launch(const QStringList &urls) const
{
    return DesktopFiles::sharedInstance()->launchApplication(m_appId, urls);
}

QString DesktopFile::name() const { return m_desktopFile ? m_desktopFile->name() : ""; }

QString DesktopFile::iconName() const { return m_desktopFile ? m_desktopFile->iconName() : ""; }

bool DesktopFile::hasIcon() const { return !QIcon::fromTheme(iconName()).isNull(); }

QString DesktopFile::comment() const { return m_desktopFile ? m_desktopFile->comment() : ""; }

bool DesktopFile::isValid() const { return m_desktopFile ? m_desktopFile->isValid() : false; }

bool DesktopFile::isShown(const QString &environment) const
{
    return m_desktopFile ? m_desktopFile->isShown(environment) : false;
}
