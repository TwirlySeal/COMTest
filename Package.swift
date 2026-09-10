// swift-tools-version: 6.3

import PackageDescription

let bridgingHeaderFlags = [
    "-I",
    #"C:\Users\ethan\AppData\Local\Programs\Swift\Toolchains\6.3.0+Asserts\usr\include"#
]

let package = Package(
    name: "COMTest",
    targets: [
        .target(
            name: "Interop",
            cxxSettings: [.unsafeFlags(bridgingHeaderFlags)]
        ),
        .executableTarget(
            name: "COMTest",
            dependencies: ["Interop"],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(bridgingHeaderFlags),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
