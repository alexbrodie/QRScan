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
let destSize = CGSize(width: 1000, height: 1000)
let sourceSize = image!.extent.size
var scale = (destSize.width / destSize.height < sourceSize.width / sourceSize.height) ? (destSize.width / sourceSize.width) : (destSize.height / destSize.height)
scale = min(scale, 1)

let scanImage = image!.applying(CGAffineTransform(scaleX: scale, y: scale))

/*
let transforms: [CGAffineTransform] = [
    CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: 0), // 0 degrees
    CGAffineTransform(a: 0, b: scale, c: -scale, d: 0, tx: 0, ty: 0), // 90 degrees
    CGAffineTransform(a: -scale, b: 0, c: 0, d: -scale, tx: 0, ty: 0), // 180 degrees
    CGAffineTransform(a: 0, b: -scale, c: scale, d: 0, tx: 0, ty: 0)] // 270 degrees

for transform in transforms {
    let scanImage = image!.applying(transform)
*/

// Extract QR code features
let context = CIContext()
let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)!
let features = detector.features(in: scanImage)

// Process each QR code found
for feature in features as! [CIQRCodeFeature] {
    print("Message: \(feature.messageString!)")
}

