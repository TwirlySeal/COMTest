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
