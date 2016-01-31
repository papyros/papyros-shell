/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
#ifndef APPLICATION_H
#define APPLICATION_H

#include <QtCore/QObject>
#include "../desktop/desktopfile.h"

class ApplicationAction;
class LauncherModel;

class Application : public QObject
{
    Q_OBJECT

    // Properties from the desktop file

    Q_PROPERTY(QString appId READ appId CONSTANT)
    Q_PROPERTY(DesktopFile *desktopFile READ desktopFile CONSTANT)
    Q_PROPERTY(bool valid READ isValid CONSTANT)
    // Q_PROPERTY(QList<ApplicationAction *> actions READ actions CONSTANT)

    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(bool running READ isRunning NOTIFY stateChanged)
    Q_PROPERTY(bool starting READ isStarting NOTIFY stateChanged)
    Q_PROPERTY(bool focused READ isFocused NOTIFY focusedChanged)
    Q_PROPERTY(bool pinned READ isPinned WRITE setPinned NOTIFY pinnedChanged)

    Q_ENUMS(State)

    friend LauncherModel;

public:
    enum State
    {
        //! The application is not running
        NotRunning,
        //! The application was launched and it's starting up.
        Starting,
        //! The application is currently running.
        Running,
        //! The application is in the background and it was suspended by
        //! the system to save resources.
        Suspended,
        //! The application is in the background and its activity was
        //! stopped by the system in order to save resources, acts as
        //! being closed but the state is saved on disk and can be
        //! restored.
        Stopped
    };

    Application(const QString &appId, QObject *parent = 0);
    Application(const QString &appId, bool pinned, QObject *parent = 0);

    bool isValid() const { return m_desktopFile != nullptr && m_desktopFile->isValid(); }

    /*!
     * \brief Application state.
     *
     * Holds the current state of the application.
     */
    State state() const { return m_state; }

    /*!
     * \brief Application identifier.
     *
     * Holds the application identifier according to the Freedesktop
     * Desktop Entry specification.
     */
    QString appId() const { return m_appId; }

    /*!
     * \brief Desktop entry file name.
     *
     * Returns the desktop entry file name.
     */
    DesktopFile *desktopFile() const { return m_desktopFile; }

    /*!
     * \brief Application focus state.
     *
     * Returns whether the application is currently focused or not.
     */
    bool isFocused() const { return m_focused; }

    bool isRunning() const { return m_state == Application::Running; }
    bool isStarting() const { return m_state == Application::Starting; }

    /*!
     * \brief Actions.
     *
     * Holds the list of actions for the quicklist.
     */
    // QList<ApplicationAction *> actions() const { return m_actions; }

    bool isPinned() const { return m_pinned; }

public slots:
    void setPinned(bool pinned);

    Q_INVOKABLE bool launch(const QStringList &urls);
    Q_INVOKABLE bool quit();

    Q_INVOKABLE bool launch() { return launch(QStringList()); }

protected slots:
    void setState(State state);
    void setFocused(bool focused);

signals:
    void stateChanged();
    void focusedChanged();
    void pinnedChanged();
    void launched();

protected:
    QSet<pid_t> m_pids;

private:
    QString m_appId;
    DesktopFile *m_desktopFile;
    bool m_focused;
    bool m_pinned;
    State m_state;
    // QList<ApplicationAction *> m_actions;
};

#endif // APPLICATION_H
