# COMTest

This Swift program uses C++ interop to call the
[ITaskbarList](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-itaskbarlist)
COM interface to show and hide the taskbar icon for a window.

Because of [this
issue](https://github.com/swiftlang/swift-package-manager/issues/9010),
currently the paths for the `<swift/bridging>` header are hardcoded in
`Package.swift` and `.clangd`. You will need to change them to work on your
system.
