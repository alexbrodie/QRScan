//
//  main.swift
//  QRScan
//
//  Created by Alexander Brodie on 6/6/17.
//  Copyright © 2017 Alexander Brodie. All rights reserved.
//

import Foundation
import CoreImage

print("Hello, World!")

if (CommandLine.argc != 2) {
    print("Usage: qrscan filename")
    abort()
}

let path = CommandLine.arguments[1]
let image = CIImage(contentsOf: URL(fileURLWithPath: path))
if (image == nil) {
    print("Couldn't load '\(path)'")
    abort()
}

//let trans = CGAffineTransform(scaleX: <#T##CGFloat#>, y: <#T##CGFloat#>)
let context = CIContext()
let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)!
let features = detector.features(in: image!)

/*
if let detector = detector {
    let features = detector.featuresInImage(image)
    for feature in features as! [CIQRCodeFeature] {
        resultImage = drawHighlightOverlayForPoints(
            image,
            topLeft: feature.topLeft, topRight: feature.topRight,
            bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
        
        print(feature.messageString)
    }
}
*/

print("Fin!")
