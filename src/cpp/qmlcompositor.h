/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QML_COMPOSITOR
#define QML_COMPOSITOR

#define PAPYROS_INSTALL_PATH "/usr/share/papyros-shell"

#include "qwaylandquickcompositor.h"
#include "qwaylandquicksurface.h"

#include <QtCompositor/qwaylandsurfaceitem.h>

#include <QGuiApplication>
#include <QTimer>
#include <QPainter>
#include <QMouseEvent>

#include <QQmlContext>

#include <QQuickItem>
#include <QQuickView>
#include <QQmlEngine>

class QmlCompositor : public QQuickView, public QWaylandQuickCompositor
{
    Q_OBJECT
    Q_PROPERTY(QWaylandQuickSurface* fullscreenSurface READ fullscreenSurface WRITE setFullscreenSurface NOTIFY fullscreenSurfaceChanged)

public:
    QmlCompositor();
    QWaylandQuickSurface *fullscreenSurface() const;
    Q_INVOKABLE QWaylandSurfaceItem *item(QWaylandSurface *surf);

signals:
    void windowAdded(QVariant window);
    void windowDestroyed(QVariant window);
    void windowResized(QVariant window);
    void fullscreenSurfaceChanged();

public slots:
    void init();
    void destroyWindow(QVariant window);
    void setFullscreenSurface(QWaylandQuickSurface *surface);

private slots:
    void surfaceMapped();
    void surfaceUnmapped();
    void surfaceDestroyed(QObject *object);
    void sendCallbacks();

protected:
    void resizeEvent(QResizeEvent *event);
    void surfaceCreated(QWaylandSurface *surface);

private:
    QWaylandQuickSurface *m_fullscreenSurface;
};

#endif
