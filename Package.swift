// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "lambda-swift-sls",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0"),
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
  ],
  targets: [
    .target(
      name: "LambdaSwiftServerless",
      dependencies: [
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
        .product(name: "NIOHTTP1", package: "swift-nio"),
        .product(name: "NIOFoundationCompat", package: "swift-nio"),
      ])
  ]
)
