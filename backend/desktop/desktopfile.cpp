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

#include <qt5xdg/xdgdesktopfile.h>

DesktopFile::DesktopFile(QString path, QObject *parent)
        : QObject(parent)
{
    setPath(path);
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
    setPath(appId);
}

void DesktopFile::setPath(QString path)
{
    m_path = path;

    // Extracts "papyros-files" from "/path/to/papyros-files.desktop"
    m_appId = QFileInfo(path).baseName();

    emit pathChanged();
    emit appIdChanged();

    load();
}

void DesktopFile::load() {
    m_desktopFile = XdgDesktopFileCache::getFile(m_path);
    emit dataChanged();
}

void DesktopFile::launch(const QStringList& urls) const
{
    if (m_desktopFile) {
        m_desktopFile->startDetached(urls);
    }

    // TODO: Set DESKTOP_FILE env variable
    // TODO: Set Qt and Gtk env variables to force the use of Wayland
}

QString DesktopFile::name() const {
    return m_desktopFile ? m_desktopFile->name() : "";
}

QString DesktopFile::iconName() const {
    return m_desktopFile ? m_desktopFile->iconName() : "";
}

QIcon DesktopFile::icon() const {
    return m_desktopFile ? m_desktopFile->icon() : QIcon();
}

QString DesktopFile::comment() const {
    return m_desktopFile ? m_desktopFile->comment() : "";
}

bool DesktopFile::isValid() const {
    return m_desktopFile ? m_desktopFile->isValid() : false;
}

bool DesktopFile::isShown(const QString &environment) const {
    return m_desktopFile ? m_desktopFile->isShown(environment) : false;
}
