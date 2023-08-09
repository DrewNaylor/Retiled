// Note: This file was extracted from here and ported to Qt6 by Drew Naylor,
// and it was subsequently modified a bit for Retiled's usecase:
// https://github.com/219-design/qt-qml-project-template-with-ci/blob/433d4898fdddf052a532f9cf8ebe8b4f721e1af7/src/lib_app/qml/ImageSvgHelper.qml

// The following is the license available in "LICENSE.txt" in the linked repo's root:
// BSD 2-Clause License
// 
// Copyright (c) 2020, 219 Design, LLC
// All rights reserved.
// 219design.com
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// --------------------------------------------------------------------------------
// 
// This license file is part of the project:
//     https://github.com/219-design/qt-qml-project-template-with-ci
// 
// The project is a github template. After you clone the template, you should
// carefully choose YOUR OWN license terms for your own code. This BSD 2-Clause
// License applies to the original 219-design source files in the github template,
// not any novel files that you add later on. To comply with this license, please
// simply keep the copyright headers intact on any of the 219-design cc and h files
// you use from the original github template.



import QtQuick
import QtQuick.Controls

Item {
  id: root

  // We cannot use 'alias', since these must be available to the Image AND the AnimatedImage
  property var fillMode: Image.Pad
  property url source: ""

  Image {
    id: nonGif

    visible: !(source + "").endsWith("gif")
    anchors.fill: parent
    source: root.source
    fillMode: {
      if (!!root.fillMode)
        root.fillMode
      else
        Image.Stretch
    }

    // Without telling Qt to consider that the sourceSize is as follows, we
    // would at times fall into the trap where an SVG contains TINY values
    // in the SVG code for 'width/height/viewBox', and Qt will take those to be
    // the definitive size of the image, which will lead to a horribly pixelated
    // outcome such as that shown: https://github.com/219-design/qt-qml-project-template-with-ci/pull/6
    // (See also: https://forum.qt.io/topic/52161/properly-scaling-svg-images/5)
    sourceSize: Qt.size(nonGif.height/1.6, nonGif.height/1.6)

    Image {
      id: hiddenImg

      source: parent.source
      width: 0
      height: 0
    }
  }

  AnimatedImage {
    id: gif

    visible: !nonGif.visible
    source: root.source
    anchors.fill: parent
    fillMode: {
      if (!!root.fillMode)
        root.fillMode
      else
        Image.Stretch
    }
  }
}