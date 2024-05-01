// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AlfredJSONEncoder",
    products: [
        .library(
            name: "AlfredJSONEncoder",
            targets: ["AlfredJSONEncoder"]),
    ],
    targets: [
        .target(
            name: "AlfredJSONEncoder"),
        .testTarget(
            name: "AlfredJSONEncoderTests",
            dependencies: ["AlfredJSONEncoder"]),
    ]
)
