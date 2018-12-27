// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ipa-uploader",
    products: [
        .executable(name: "ipa-uploader", targets: ["ipa-uploader-cli"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ipa-uploader-cli",
            dependencies: [])
    ]
)
