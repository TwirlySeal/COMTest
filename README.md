# COMTest

This Swift program uses C++ interop to call the
[ITaskbarList](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-itaskbarlist)
COM interface to show and hide the taskbar icon for a window.

## Known issues

Because of
[this issue](https://github.com/swiftlang/swift-package-manager/issues/9010),
currently the paths for the `<swift/bridging>` header are hardcoded in
`Package.swift` and `.clangd`. You will need to change them to work on your
system.

Build works on Swift 6.3.3 but fails on Swift 6.4.0-6.4.2 with this error (after
updating the header path for `<swift/bridging>`). This may be a regression in
the Swift toolchain.

> error: Build input file cannot be found:
> './.build/out/Products/Debug-windows-x86_64/Interop.objlib'. Did you forget to
> declare this file as an output of a script phase or custom build rule which
> produces it?
> 
> error: `Ld .\.build\out\Products\Debug-windows-x86_64\COMTest.exe normal`
> failed with a nonzero exit code.
> 
> error: Build failed

Compiler invocation (wrapped for readability):

```
~\AppData\Local\Programs\Swift\Toolchains\6.4.2+Asserts\usr\bin\swiftc.exe
-target x86_64-unknown-windows-msvc -emit-executable
-sdk ~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\SDKs\Windows.sdk
-L.\.build\out\Intermediates.noindex\EagerLinkingTBDs\Debug-windows-x86_64
-L.\.build\out\Products\Debug-windows-x86_64
-L~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\SDKs\Windows.sdk\usr\lib\swift\windows\x86_64
-L~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\Library\Testing-6.4.2\usr\lib\swift\windows
-L~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\Library\Testing-6.4.2\usr\lib\swift\windows\x86_64
-L~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\Library\XCTest-6.4.2\usr\lib\swift\windows\x86_64
-L~\AppData\Local\Programs\Swift\Platforms\6.4.2\Windows.platform\Developer\Library\XCTest-6.4.2\usr\lib\swift\windows
@.\.build\out\Intermediates.noindex\COMTest.build\Debug-windows-x86_64\COMTest-p.build\Objects-normal\x86_64\COMTest.LinkFileList
-Xlinker /OPT:REF
-L~\AppData\Local\Programs\Swift\Toolchains\6.4.2+Asserts\usr\lib\swift
-L/usr/lib/swift -use-ld=lld-link -Xlinker -debug:dwarf
@.\.build\out\Products\Debug-windows-x86_64\Interop.objlib\args.resp
-o .\.build\out\Products\Debug-windows-x86_64\COMTest.exe
```
