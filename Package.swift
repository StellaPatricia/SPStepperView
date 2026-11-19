// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SPStepperView",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "SPStepperView", targets: ["SPStepperView"]),
    ],
    targets: [
        .target(
            name: "SPStepperView",
            path: "SPStepperView",
            exclude: ["SPStepperView.h"]
        ),
        .testTarget(
            name: "SPStepperViewTests",
            dependencies: ["SPStepperView"],
            path: "SPStepperViewTests"
        ),
    ]
)
