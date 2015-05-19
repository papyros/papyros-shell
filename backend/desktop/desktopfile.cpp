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

#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QLocale>
#include <QProcess>

DesktopFile::DesktopFile(QString path, QObject *parent)
        : QObject(parent)
{
    if (path.startsWith("/")) {
        setPath(path);
    } else {
        setAppId(path);
    }
}

QString DesktopFile::pathFromAppId(QString appId)
{
    QStringList paths;
    paths << "~/.local/share/applications"
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

QString DesktopFile::getEnvVar(int pid)
{
    QFile envFile(QString("/proc/%1/environ").arg(pid));
    if(!envFile.open(QIODevice::ReadOnly | QIODevice::Text))
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
    setPath(pathFromAppId(appId));
}

void DesktopFile::setPath(QString path)
{
    m_path = path;
    m_isValid = m_path != "";

    // Extracts "papyros-files" from "/path/to/papyros-files.desktop"
    m_appId = QFileInfo(path).baseName();

    emit pathChanged();
    emit isValidChanged();

    load();
}

void DesktopFile::launch()
{
    QString tempString = m_exec;
    tempString.replace("%f", "", Qt::CaseInsensitive);
    tempString.replace("%u", "", Qt::CaseInsensitive);
    QProcess::startDetached(tempString);

    // TODO: Set DESKTOP_FILE env variable
    // TODO: Set Qt and Gtk env variables to force the use of Wayland
}

QVariant DesktopFile::localizedValue(const QSettings &desktopFile, QString key)
{
    QLocale locale;
    QString fullLocale = locale.name();
    QString onlyLocale = fullLocale;
    onlyLocale.truncate(2);

    QStringList keys;
    keys << QString("%1[%2]").arg(key).arg(fullLocale)
         << QString("%1[%2]").arg(key).arg(onlyLocale)
         << key;

    for (QString keyName : keys) {
        QVariant value = desktopFile.value(keyName);

        if (!value.isNull())
            return value;
    }

    return QVariant();
}

void DesktopFile::load()
{
    if (m_path == "") {
        m_name = "";
        m_exec = "";
        m_comment = "";
        m_darkColor = "";
        m_iconName = "";
    } else {
        QSettings desktopFile(m_path, QSettings::IniFormat);
        desktopFile.setIniCodec("UTF-8");
        desktopFile.beginGroup("Desktop Entry");

        m_name = localizedValue(desktopFile, "Name").toString();
        m_exec = desktopFile.value("Exec").toString();
        m_comment = localizedValue(desktopFile, "Comment").toString();
        m_darkColor = desktopFile.value("X-Papyros-DarkColor").toString();
        m_iconName = desktopFile.value("Icon").toString();
    }

    emit dataChanged();
}
