import Interop

@main
struct COMTest {
    static func main() throws {
        CoInitialize(nil)
        defer { CoUninitialize() }

        let handle = CreateWindowExA(
          DWORD(WS_EX_APPWINDOW),
          "STATIC",
          "COM Taskbar Test",
          WS_OVERLAPPEDWINDOW | UINT(WS_VISIBLE),
          CW_USEDEFAULT,
          CW_USEDEFAULT,
          400,
          200,
          nil,
          nil,
          nil,
          nil,
        )
        guard let handle else {
          print("Window creation failed")
          exit(1)
        }
        defer { DestroyWindow(handle) }
        print("Window created")

        // Process initial messages
        windowsMessageLoop(milliseconds: 1000)
        
        let taskbar = try MyTaskbarList.create()
        let hrInit = taskbar.HrInit()
        guard hrInit == S_OK else {
          print("HrInit failed with HRESULT: \(hrInit)")
          exit(1)
        }
        print("Taskbar COM object created")

        print("Hiding taskbar icon for 3 seconds")
        _ = taskbar.DeleteTab(handle)
        windowsMessageLoop(milliseconds: 3000)

        print("Restoring taskbar icon")
        _ = taskbar.AddTab(handle)
        windowsMessageLoop(milliseconds: 1000)
    }
}

func windowsMessageLoop(milliseconds: DWORD) {
    let startTime = GetTickCount()
    var msg = MSG()
    while (GetTickCount() - startTime) < milliseconds {
        // Process any waiting messages
        while PeekMessageA(&msg, nil, 0, 0, UINT(PM_REMOVE)) {
            TranslateMessage(&msg)
            DispatchMessageA(&msg)
        }
        Sleep(10) // Brief yield so the CPU doesn't spike
    }
}

struct COMError: Error {
    let hresult: HRESULT
}

extension MyTaskbarList {
    static func create() throws(COMError) -> Self {
        return CreateTaskbarList()
    }
}
