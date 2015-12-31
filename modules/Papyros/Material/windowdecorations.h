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

#ifndef WINDOWDECORATIONS_H
#define WINDOWDECORATIONS_H

#include <QObject>
#include <QWindow>
#include "materialdecoration.h"

class WindowDecorations : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor
               NOTIFY backgroundColorChanged)
   Q_PROPERTY(QColor textColor READ textColor WRITE setTextColor
               NOTIFY textColorChanged)
   Q_PROPERTY(QColor iconColor READ textColor WRITE setIconColor
               NOTIFY iconColorChanged)
    Q_PROPERTY(QWindow *window READ window WRITE setWindow NOTIFY windowChanged)

public:
    WindowDecorations(QObject *parent = 0);

    QColor backgroundColor() const { return mBackgroundColor; }
    QColor textColor() const { return mTextColor; }
    QColor iconColor() const { return mIconColor; }
    QWindow *window() const { return mWindow; }

public slots:
    void update();
    
    void setBackgroundColor(QColor color) {
        if (mBackgroundColor != color) {
            mBackgroundColor = color;
            emit backgroundColorChanged();
        }
    }

    void setTextColor(QColor color) {
        if (mTextColor != color) {
            mTextColor = color;
            emit textColorChanged();
        }
    }

    void setIconColor(QColor color) {
        if (mIconColor != color) {
            mIconColor = color;
            emit iconColorChanged();
        }
    }

    void setWindow(QWindow *window) {
        if (mWindow != window) {
            mWindow = window;
            emit windowChanged();
            update();
        }
    }

signals:
    void backgroundColorChanged();
    void textColorChanged();
    void iconColorChanged();
    void windowChanged();

private:
    QColor mBackgroundColor;
    QColor mTextColor;
    QColor mIconColor;
    QWindow *mWindow;
};

#endif // WINDOWDECORATIONS_H
