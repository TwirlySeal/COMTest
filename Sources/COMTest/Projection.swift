import Interop

struct COMError: Error {
    let hresult: HRESULT
}

/// - Throws: `COMError` if COM initialization fails.
func withCOMContext(_ body: () throws -> Void) throws {
    let hr = coInitialize(nil)
    guard hr == S_OK else {
        throw COMError(hresult: hr)
    }

    defer { coUninitialize() }

    try body()
}

protocol COMInterface {
    /// Interface ID
    static var iid: GUID { get }
}

// Swift C++ interop currently does not preserve the inheritance relationship,
// so this is defined on the Swift protocol instead of IUnknown
extension COMInterface {
    func queryInterface<T: COMInterface>(_ type: T.Type = T.self) throws(COMError) -> T {
        let iid = T.iid

        // Compiler warning 'unsafeBitCast' from 'Self' to 'IUnknown' can be
        // replaced with 'unsafeDowncast' is incorrect
        let selfUnknown = unsafeBitCast(self, to: IUnknown.self)

        var rawResult: IUnknown? = nil
        let hr = selfUnknown.__QueryInterface(iid, &rawResult)

        guard hr == S_OK, let interfaceUnknown = rawResult else {
            throw COMError(hresult: hr)
        }

        return unsafeBitCast(interfaceUnknown, to: T.self)
    }
}

// win32metadata includes empty coclass definitions which omit `I` from the
// interface name
protocol COMCoClass {
    /// Class ID
    static var clsid: GUID { get }

    // win32metadata includes default interfaces for coclasses
    associatedtype DefaultInterface: COMInterface
}

extension COMCoClass {
    static func create<T: COMInterface>(
        as interface: T.Type = DefaultInterface.self
    ) throws(COMError) -> T {
        let CLSCTX_INPROC_SERVER: DWORD = 0x1

        var rawResult: IUnknown? = nil
        let hr = __CoCreateInstance(
            Self.clsid,
            nil,
            CLSCTX_INPROC_SERVER,
            T.iid,
            &rawResult
        )
        guard hr == S_OK, let instance = rawResult else {
            throw COMError(hresult: hr)
        }
        return unsafeBitCast(instance, to: T.self)
    }
}

extension IUnknown: COMInterface {
    static let iid = GUID(
        Data1: 0x00000000,
        Data2: 0x0000,
        Data3: 0x0000,
        Data4: (0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46)
    )
}

enum TaskbarList: COMCoClass {
    static let clsid = GUID(
        Data1: 0x56FDF344,
        Data2: 0xFD6D,
        Data3: 0x11D0,
        Data4: (0x95, 0x8A, 0x00, 0x60, 0x97, 0xC9, 0xA0, 0x90)
    )
    typealias DefaultInterface = ITaskbarList
}

extension ITaskbarList: COMInterface {
    static let iid = GUID(
        Data1: 0x56FDF342,
        Data2: 0xFD6D,
        Data3: 0x11D0,
        Data4: (0x95, 0x8A, 0x00, 0x60, 0x97, 0xC9, 0xA0, 0x90)
    )
}

extension ITaskbarList {
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
