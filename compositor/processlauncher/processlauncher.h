/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#ifndef PROCESSLAUNCHER_H
#define PROCESSLAUNCHER_H

#include <QtCore/QLoggingCategory>
#include <QtCore/QMap>
#include <QtCore/QObject>

Q_DECLARE_LOGGING_CATEGORY(LAUNCHER)

class QProcess;
class XdgDesktopFile;

typedef QMap<QString, QProcess *> ApplicationMap;
typedef QMutableMapIterator<QString, QProcess *> ApplicationMapIterator;

class ProcessLauncher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString waylandSocketName READ waylandSocketName WRITE setWaylandSocketName NOTIFY waylandSocketNameChanged)
public:
    ProcessLauncher(QObject *parent = 0);
    ~ProcessLauncher();

    QString waylandSocketName() const;
    void setWaylandSocketName(const QString &name);

    void closeApplications();

    static bool registerWithDBus(ProcessLauncher *instance);

Q_SIGNALS:
    void waylandSocketNameChanged();

public Q_SLOTS:
    bool launchApplication(const QString &appId);
    bool launchDesktopFile(const QString &fileName);

    bool closeApplication(const QString &appId);
    bool closeDesktopFile(const QString &fileName);

private:
    QString m_waylandSocketName;
    ApplicationMap m_apps;

    bool launchEntry(XdgDesktopFile *entry);
    bool closeEntry(const QString &fileName);

private Q_SLOTS:
    void finished(int exitCode);
};

#endif // PROCESSLAUNCHER_H
