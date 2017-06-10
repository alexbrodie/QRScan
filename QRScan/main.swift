//
//  main.swift
//  QRScan
//
//  Created by Alexander Brodie on 6/6/17.
//  Copyright © 2017 Alexander Brodie. All rights reserved.
//

import Foundation
import CoreImage

if (CommandLine.argc != 2) {
    fputs("Usage: qrscan filename\n", stderr)
    exit(1)
}

// Load image
let path = CommandLine.arguments[1]
let image = CIImage(contentsOf: URL(fileURLWithPath: path))
if (image == nil) {
    fputs("Couldn't load '\(path)'\n", stderr)
    exit(1)
}

// Scale to fit in destSize (QR code detector doesn't work on big images)
let destSize = CGSize(width: 500, height: 500)
let sourceSize = image!.extent.size
let scale = (destSize.width / destSize.height < sourceSize.width / sourceSize.height) ? (destSize.width / sourceSize.width) : (destSize.height / destSize.height)
let trans = CGAffineTransform(scaleX: scale, y: scale)
let scaledImage = image!.applying(trans)

// Extract QR code features
let context = CIContext()
let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)!
let features = detector.features(in: scaledImage)

// Process each QR code found
for feature in features as! [CIQRCodeFeature] {
    print("Message: \(feature.messageString!)")
}

