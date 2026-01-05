// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FLWhatsNew",
  defaultLocalization: "en",
  platforms: [.iOS(.v15), .macOS(.v12), .visionOS(.v1)],
  products: [
    .library(
      name: "FLWhatsNew",
      targets: ["FLWhatsNew"]),
  ],
  targets: [
    .target(
      name: "FLWhatsNew",
      resources: [
        .process("Resources")
      ]
    ),
  ]
)
