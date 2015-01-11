/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3

/*!
  \internal
  Documentation is in CrossFadeImage.qdoc
*/
Item {
    id: crossFadeImage

    property url source

    property int fillMode : Image.PreserveAspectFit

    property int fadeDuration: 250

    // FIXME: Support resetting sourceSize
    property size sourceSize: internals.loadingImage ? Qt.size(internals.loadingImage.sourceSize.width, internals.loadingImage.sourceSize.height) : Qt.size(0, 0)

    property string fadeStyle: "overlay"

    readonly property bool running: nextImageFadeIn.running

    readonly property int status: internals.loadingImage ? internals.loadingImage.status : Image.Null

    Binding {
        target: crossFadeImage
        property: "sourceSize"
        value: internals.loadingImage ? Qt.size(internals.loadingImage.sourceSize.width, internals.loadingImage.sourceSize.height) : Qt.size(0, 0)
        when: internals.forcedSourceSize === undefined
    }

    /*!
      \internal
     */
    onSourceSizeChanged: {
        if (internals.loadingImage && (sourceSize != Qt.size(internals.loadingImage.sourceSize.width, internals.loadingImage.sourceSize.height))) {
            internals.forcedSourceSize = sourceSize;
        }
    }

    QtObject {
        id: internals

        /*! \internal
          Source size specified by the setting crossFadeImage.sourceSize.
         */
        property size forcedSourceSize

        /*! \internal
          Defines the image currently being shown
        */
        property Image currentImage: image1

        /*! \internal
          Defines the image being changed to
        */
        property Image nextImage: image2

        property Image loadingImage: currentImage

        function swapImages() {
            internals.currentImage.z = 0;
            internals.nextImage.z = 1;
            nextImageFadeIn.start();

            var tmpImage = internals.currentImage;
            internals.currentImage = internals.nextImage;
            internals.nextImage = tmpImage;
        }
    }

    QtObject {
        // dummy object used to disable crossfade animation
        id: fadeOutDummy
        property real opacity
    }

    Image {
        id: image1
        anchors.fill: parent
        cache: false
        asynchronous: true
        fillMode: parent.fillMode
        mipmap: true
        z: 1
        Binding {
            target: image1
            property: "sourceSize"
            value: internals.forcedSourceSize
            when: internals.forcedSourceSize !== undefined
        }
    }

    Image {
        id: image2
        anchors.fill: parent
        cache: false
        asynchronous: true
        fillMode: parent.fillMode
        mipmap: true
        z: 0
        Binding {
            target: image2
            property: "sourceSize"
            value: internals.forcedSourceSize
            when: internals.forcedSourceSize !== undefined
        }
    }

    /*!
      \internal
      Do the fading when the source is updated
    */
    onSourceChanged: {
        // On creation, the souce handler is called before image pointers are set.
        if (internals.currentImage === null) {
            internals.currentImage = image1;
            internals.nextImage = image2;
        }

        nextImageFadeIn.stop();

        // Don't fade in initial picture, only fade changes
        if (internals.currentImage.source == "") {
            internals.currentImage.source = source;
            internals.loadingImage = internals.currentImage;
        } else {
            nextImageFadeIn.stop();
            internals.nextImage.opacity = 0.0;
            internals.nextImage.source = source;
            internals.loadingImage = internals.nextImage;

            // If case the image is still in QML's cache, status will be "Ready" immediately
            if (internals.nextImage.status === Image.Ready || internals.nextImage.source === "") {
                internals.swapImages();
            }
        }
    }

    Connections {
        target: internals.nextImage
        onStatusChanged: {
            if (internals.nextImage.status == Image.Ready) {
                 internals.swapImages();
             }
        }
    }

    ParallelAnimation {
        id: nextImageFadeIn

        NumberAnimation {
            id: currentImageFadeOut
            target: fadeStyle == "cross" ? internals.currentImage : fadeOutDummy
            property: "opacity"
            to: 0.0
            duration: crossFadeImage.fadeDuration
        }

        NumberAnimation {
            target: internals.nextImage
            property: "opacity"
            to: 1.0
            duration: crossFadeImage.fadeDuration
        }

        onRunningChanged: {
            if (!running) {
                internals.nextImage.source = "";
            }
        }
    }
}
