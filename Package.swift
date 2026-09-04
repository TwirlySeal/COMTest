// swift-tools-version: 6.3

import PackageDescription

var cxxSettings: [CXXSetting] = [
    .unsafeFlags([
        "-I",
        #"C:\Users\ethan\AppData\Local\Programs\Swift\Toolchains\6.3.0+Asserts\usr\include"#
    ])
]

let package = Package(
    name: "COMTest",
    targets: [
        .target(
            name: "Interop",
            cxxSettings: cxxSettings
        ),
        .executableTarget(
            name: "COMTest",
            dependencies: ["Interop"],
            cxxSettings: cxxSettings,
            swiftSettings: [
                .interoperabilityMode(.Cxx),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
