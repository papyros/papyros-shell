/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2015-2016 Michael Spencer <sonrisesoftware@gmail.com>
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

#ifndef LAUNCHERMODEL_H
#define LAUNCHERMODEL_H

#include <QtCore/QAbstractListModel>
#include <QtQml/QQmlComponent>
#include <KConfigCore/KConfig>
#include <KConfigCore/KSharedConfig>

#include <GreenIsland/Server/ApplicationManager>

using namespace GreenIsland::Server;

class Application;

class LauncherModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(ApplicationManager *applicationManager READ applicationManager WRITE setApplicationManager
               NOTIFY applicationManagerChanged)
    Q_PROPERTY(bool includePinnedApplications READ includePinnedApplications WRITE setIncludePinnedApplications
               NOTIFY includePinnedApplicationsChanged)

public:
    enum Roles {
        AppIdRole = Qt::UserRole + 1,
        DesktopFileRole,
        ActionsRole,
        StateRole,
        RunningRole,
        FocusedRole,
        PinnedRole
    };
    Q_ENUM(Roles)

    LauncherModel(QObject *parent = 0);
    ~LauncherModel();

    ApplicationManager *applicationManager() const;
    bool includePinnedApplications() const;

    QHash<int, QByteArray> roleNames() const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE Application *get(int index) const;
    Q_INVOKABLE int indexFromAppId(const QString &appId) const;

    Q_INVOKABLE void pin(const QString &appId);
    Q_INVOKABLE void unpin(const QString &appId);

public slots:
    void setApplicationManager(ApplicationManager *appManager);
    void setIncludePinnedApplications(bool includePinnedApps);

signals:
    void applicationManagerChanged();
    void includePinnedApplicationsChanged();

private slots:
    void handleApplicationAdded(const QString &appId, pid_t pid);
    void handleApplicationRemoved(const QString &appId, pid_t pid);
    void handleApplicationFocused(const QString &appId);
    void handleApplicationUnfocused(const QString &appId);

private:
    QList<Application *> m_list;
    KSharedConfigPtr m_config;
    ApplicationManager *m_applicationManager;
    bool m_includePinnedApps = false;

    QStringList defaultPinnedApps();

    void pinLauncher(const QString &appId, bool pinned);

    bool moveRows(int sourceRow, int count, int destinationChild);
    bool moveRows(const QModelIndex & sourceParent, int sourceRow, int count, const QModelIndex & destinationParent, int destinationChild) Q_DECL_OVERRIDE;
};

QML_DECLARE_TYPE(LauncherModel)

#endif // LAUNCHERMODEL_H
