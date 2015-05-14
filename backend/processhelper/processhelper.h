/*
 * QML Desktop - Set of tools written in C++ for QML
 * 
 * Copyright (C) 2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
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

#ifndef PROCESSHELPER
#define PROCESSHELPER

#include <QObject>
#include <QProcess>
#include <QQmlEngine>
#include <QJSEngine>

class ProcessHelper : public QObject {
  
    Q_OBJECT
  
public:
  
    explicit ProcessHelper(QObject *parent = 0) : QObject(parent) {
    }
  
    static QObject *process_helper(QQmlEngine *engine, QJSEngine *scriptEngine) {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        ProcessHelper *helper = new ProcessHelper();
        return helper;
    }
  
    Q_INVOKABLE bool startDetached(QString exec) {
        return QProcess::startDetached(exec);
    }
};

#endif // PROCESSHELPER