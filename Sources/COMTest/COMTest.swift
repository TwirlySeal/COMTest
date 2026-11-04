import Interop

@main
struct COMTest {
    static func main() throws {
        try withCOMContext(run)
    }

    static func run() throws {
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

        let taskbar = try TaskbarList.create(as: ITaskbarList.self)
        try taskbar.hrInit()

        if let unknown = try? taskbar.queryInterface(IUnknown.self) {
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
