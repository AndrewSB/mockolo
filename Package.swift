// swift-tools-version:5.7
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-tools-support-core.git", .exact("0.2.7")),
]
var mockoloFrameworkTargetDependencies: [Target.Dependency] = [
    .product(name: "SwiftSyntax", package: "SwiftSyntax"),
]

#if swift(>=5.6)
    dependencies.append(.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"))
#else
    dependencies.append(.package(url: "https://github.com/apple/swift-argument-parser", "1.0.1" ... "1.0.3"))
#endif

#if swift(>=5.7)
    dependencies.append(.package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("509.0.2")))
    mockoloFrameworkTargetDependencies.append(.product(name: "SwiftSyntaxParser", package: "SwiftSyntax"))
#elseif swift(>=5.6)
    dependencies.append(.package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50600.1")))
    mockoloFrameworkTargetDependencies.append(.product(name: "SwiftSyntaxParser", package: "SwiftSyntax"))
#elseif swift(>=5.5)
    dependencies.append(.package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50500.0")))
#else
    dependencies.append(.package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50400.0")))
#endif

let package = Package(
    name: "Mockolo",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "mockolo", targets: ["Mockolo"]),
        .library(name: "MockoloFramework", targets: ["MockoloFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "509.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
    ],
    targets: [
        .executableTarget(
            name: "Mockolo",
            dependencies: [
                "MockoloFramework",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "MockoloFramework",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "MockoloTests",
            dependencies: [
                "MockoloFramework",
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
