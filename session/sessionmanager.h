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

#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QtCore/QObject>
#include <QtCore/QLoggingCategory>

class SessionManager : public QObject
{
    Q_OBJECT
public:
    SessionManager(QObject *parent = 0);
    static SessionManager *instance();

    bool initialize();

    bool isIdle() const;
    void setIdle(bool value);

    bool isLocked() const;
    void setLocked(bool value);

    static constexpr const char *interfaceName = "io.papyros.Session";
    static constexpr const char *objectPath = "/PapyrosSession";

Q_SIGNALS:
    void idleChanged(bool value);
    void lockedChanged(bool value);
    void loggedOut();

public Q_SLOTS:
    void logOut();

private:
    bool m_idle;
    bool m_locked;

    void setupEnvironment();
    bool registerDBus();

private Q_SLOTS:
    void autostart();
};

#endif // SESSIONMANAGER_H
