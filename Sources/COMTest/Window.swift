import Interop

func createWindow(
    exStyle: ExtendedWindowStyle,
    style: WindowStyle,
    name windowName: String,
) -> HWND? {
    let className = "STATIC"

    return className.withCString(encodedAs: UTF16.self) { lpClassName in
        windowName.withCString(encodedAs: UTF16.self) { lpWindowName in
            return createWindowExW(
                exStyle.rawValue,
                lpClassName,
                lpWindowName,
                style.rawValue,
                CW_USEDEFAULT,
                CW_USEDEFAULT,
                400,
                200,
                nil,
                nil,
                nil,
                nil,
            )
        }
    }
}

func windowsMessageLoop(milliseconds: UInt32) {
    let startTime = getTickCount()
    var msg = MSG()
    while (getTickCount() - startTime) < milliseconds {
        // Process any waiting messages
        while peekMessageW(&msg, nil, 0, 0, PeekMessageOptions.REMOVE.rawValue) {
            translateMessage(&msg)
            dispatchMessageW(&msg)
        }
        sleep(10) // Brief yield so the CPU doesn't spike
    }
}

struct ExtendedWindowStyle: OptionSet {
    let rawValue: UInt32

    static let DLGMODALFRAME = Self(rawValue: 1)
    static let NOPARENTNOTIFY = Self(rawValue: 1 << 2)
    static let TOPMOST = Self(rawValue: 1 << 3)
    static let ACCEPTFILES = Self(rawValue: 1 << 4)
    static let TRANSPARENT = Self(rawValue: 1 << 5)
    static let MDICHILD = Self(rawValue: 1 << 6)
    static let TOOLWINDOW = Self(rawValue: 1 << 7)
    static let WINDOWEDGE = Self(rawValue: 1 << 8)
    static let CLIENTEDGE = Self(rawValue: 1 << 9)
    static let CONTEXTHELP = Self(rawValue: 1 << 10)
    static let RIGHT = Self(rawValue: 1 << 12)
    static let RTLREADING = Self(rawValue: 1 << 13)
    static let LEFTSCROLLBAR = Self(rawValue: 1 << 14)
    static let CONTROLPARENT = Self(rawValue: 1 << 15)
    static let STATICEDGE = Self(rawValue: 1 << 16)
    static let APPWINDOW = Self(rawValue: 1 << 17)
    static let LAYERED = Self(rawValue: 1 << 18)
    static let NOINHERITLAYOUT = Self(rawValue: 1 << 19)
    static let NOREDIRECTIONBITMAP = Self(rawValue: 1 << 20)
    static let LAYOUTRTL = Self(rawValue: 1 << 21)
    static let COMPOSITED = Self(rawValue: 1 << 22)
    static let NOACTIVATE = Self(rawValue: 1 << 23)
}

struct WindowStyle: OptionSet {
    let rawValue: UInt32
    
    static let OVERLAPPED = Self()
    static let ACTIVECAPTION = Self(rawValue: 1)
    static let TABSTOP = Self(rawValue: 1 << 16)
    static let GROUP = Self(rawValue: 1 << 17)
    static let THICKFRAME = Self(rawValue: 1 << 18)
    static let SYSMENU = Self(rawValue: 1 << 19)
    static let HSCROLL = Self(rawValue: 1 << 20)
    static let VSCROLL = Self(rawValue: 1 << 21)
    static let DLGFRAME = Self(rawValue: 1 << 22)
    static let BORDER = Self(rawValue: 1 << 23)
    static let MAXIMIZE = Self(rawValue: 1 << 24)
    static let CLIPCHILDREN = Self(rawValue: 1 << 25)
    static let CLIPSIBLINGS = Self(rawValue: 1 << 26)
    static let DISABLED = Self(rawValue: 1 << 27)
    static let VISIBLE = Self(rawValue: 1 << 28)
    static let MINIMIZE = Self(rawValue: 1 << 29)
    static let CHILD = Self(rawValue: 1 << 30)
    static let POPUP = Self(rawValue: 1 << 31)
    // MINIMIZEBOX (bit index 17) conflicts with GROUP
    // MAXIMIZEBOX (bit index 16) conflicts with TABSTOP
    // ICONIC (bit index 29) conflicts with MINIMIZE
    // SIZEBOX (bit index 18) conflicts with THICKFRAME
    // CHILDWINDOW (bit index 30) conflicts with CHILD
};

struct PeekMessageOptions: OptionSet {
    let rawValue: UInt32

    static let NOREMOVE = Self()
    static let REMOVE = Self(rawValue: 0x0001)
    static let NOYIELD = Self(rawValue: 0x0002)
}
