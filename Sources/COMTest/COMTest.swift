import Interop

@main
struct COMTest {
    static func main() throws {
        coInitialize(nil)
        defer { coUninitialize() }

        let handle = createWindow(
            exStyle: [.APPWINDOW],
            style: [.OVERLAPPED, .VISIBLE],
            name: "COM Taskbar Test"
        )
        guard let handle else {
          print("Window creation failed")
          exit(1)
        }
        defer { destroyWindow(handle) }

        // Process initial messages
        windowsMessageLoop(milliseconds: 1000)
        
        guard let taskbar = TaskbarList() else {
            print("TaskbarList init failed")
            exit(1)
        }
        try taskbar.hrInit()

        if let unknown = taskbar.queryInterface(IUnknown.self) {
            print("TaskbarList conforms to \(unknown)")
        }

        print("Hiding taskbar icon for 3 seconds")
        try taskbar.deleteTab(handle)
        windowsMessageLoop(milliseconds: 3000)

        print("Restoring taskbar icon")
        try taskbar.addTab(handle)
        windowsMessageLoop(milliseconds: 1000)
    }
}

struct COMError: Error {
    let hresult: HRESULT
}

extension TaskbarList {
    func hrInit() throws(COMError) {
        let hr = __HrInit()
        guard hr == S_OK else {
          throw COMError(hresult: hr)
        }
    }

    func deleteTab(_ handle: HWND) throws(COMError) {
        let hr = __DeleteTab(handle)
        guard hr == S_OK else {
            throw COMError(hresult: hr)
        }
    }

    func addTab(_ handle: HWND) throws(COMError) {
        let hr = __AddTab(handle)
        guard hr == S_OK else {
            throw COMError(hresult: hr)
        }
    }

    func activateTab(_ handle: HWND) throws(COMError) {
        let hr = __ActivateTab(handle)
        guard hr == S_OK else {
            throw COMError(hresult: hr)
        }
    }

    func setActiveAlt(_ handle: HWND) throws(COMError) {
        let hr = __SetActiveAlt(handle)
        guard hr == S_OK else {
            throw COMError(hresult: hr)
        }
    }
}

protocol COMInterface {
    static var iid: GUID { get }
}

extension IUnknown: COMInterface {
    static var iid: GUID {
        GUID(
            Data1: 0x00000000,
            Data2: 0x0000,
            Data3: 0x0000,
            Data4: (0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46)
        )
    }
}

extension TaskbarList: COMInterface {
    static var iid: GUID {
        GUID(
            Data1: 0x56FDF342,
            Data2: 0xFD6D,
            Data3: 0x11D0,
            Data4: (0x95, 0x8A, 0x00, 0x60, 0x97, 0xC9, 0xA0, 0x90)
        )
    }
}

// Swift C++ interop currently does not preserve the inheritance relationship,
// so this is type-specific
extension TaskbarList {
    func queryInterface<T: COMInterface>(_ type: T.Type = T.self) -> T? {
        let iid = T.iid
        let selfUnknown = unsafeBitCast(self, to: IUnknown.self)
        guard let interfaceUnknown = __COM_QueryInterface(selfUnknown, iid) else {
            return nil
        }

        return unsafeBitCast(interfaceUnknown, to: T.self)
    }
}
