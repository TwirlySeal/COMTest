#pragma once
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "user32.lib")

#include <cstdint>
#include <swift/bridging>

// C types
struct HWND__;
using HWND = HWND__*;

struct HMENU__;
using HMENU = HMENU__*;

struct HINSTANCE__;
using HINSTANCE = HINSTANCE__*;

struct LPVOID__;
using LPVOID = LPVOID__*;

using DWORD = std::uint32_t;
using LPCWSTR = const wchar_t*;

struct POINT {
    std::int32_t x;
    std::int32_t y;
};

// Message structure
struct MSG {
    HWND hwnd;
    std::uint32_t message;
    std::uintptr_t wParam;
    std::intptr_t lParam;
    DWORD time;
    POINT pt;
};

constexpr int CW_USEDEFAULT = 0x80000000;


// C APIs
extern "C" __declspec(dllimport) HWND __stdcall CreateWindowExW(
    DWORD dwExStyle,
    LPCWSTR lpClassName,
    LPCWSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam
) SWIFT_NAME(createWindowExW(_:_:_:_:_:_:_:_:_:_:_:_:));

extern "C" __declspec(dllimport) bool __stdcall DestroyWindow(HWND hWnd)
SWIFT_NAME(destroyWindow(_:));

// `GetTickCount` overflows roughly every 49 days. Code that does not take that
// into account can loop indefinitely.  `GetTickCount64` operates on 64 bit
// values and does not have that problem.
extern "C" __declspec(dllimport) DWORD __stdcall GetTickCount(void)
SWIFT_NAME(getTickCount());

extern "C" __declspec(dllimport) bool __stdcall PeekMessageW(
  MSG* lpMsg,
  HWND hWnd,
  std::uint32_t wMsgFilterMin,
  std::uint32_t wMsgFilterMax,
  std::uint32_t wRemoveMsg
) SWIFT_NAME(peekMessageW(_:_:_:_:_:));

extern "C" __declspec(dllimport) bool __stdcall TranslateMessage(const MSG* lpMsg)
SWIFT_NAME(translateMessage(_:));

extern "C" __declspec(dllimport) std::intptr_t __stdcall DispatchMessageW(const MSG* lpMsg)
SWIFT_NAME(dispatchMessageW(_:));

extern "C" __declspec(dllimport) void __stdcall Sleep(DWORD dwMilliseconds)
SWIFT_NAME(sleep(_:));


// COM types
struct GUID {
  std::uint32_t Data1;
  std::uint16_t Data2;
  std::uint16_t Data3;
  std::uint8_t  Data4[8];
};

using HRESULT = std::int32_t;
constexpr HRESULT S_OK = 0;

// COM init/deinit
extern "C" __declspec(dllimport) HRESULT __stdcall CoInitialize(
  LPVOID pvReserved
) SWIFT_NAME(coInitialize(_:));

extern "C" __declspec(dllimport) void __stdcall CoUninitialize(void)
SWIFT_NAME(coUninitialize());


// COM APIs
struct __declspec(uuid("00000000-0000-0000-C000-000000000046"))
__declspec(novtable) IUnknown
{
    virtual HRESULT __stdcall QueryInterface(
        const GUID& riid,
        void** ppvObject
    );

    virtual std::uint32_t __stdcall AddRef(void) = 0;

    virtual std::uint32_t __stdcall Release(void) = 0;
};

void* __CreateTaskbarList(void);

struct __declspec(uuid("56FDF342-FD6D-11d0-958A-006097C9A090"))
__declspec(novtable) TaskbarList : public IUnknown
{
    virtual HRESULT __stdcall __HrInit(void);
  
    virtual HRESULT __stdcall __AddTab(HWND hwnd);
  
    virtual HRESULT __stdcall __DeleteTab(HWND hwnd);
  
    virtual HRESULT __stdcall __ActivateTab(HWND hwnd);
  
    virtual HRESULT __stdcall __SetActiveAlt(HWND hwnd);

    static SWIFT_RETURNS_RETAINED TaskbarList* create() SWIFT_NAME(init()) {
      return reinterpret_cast<TaskbarList*>(__CreateTaskbarList());
    };

} SWIFT_SHARED_REFERENCE(__COM_AddRef, __COM_Release);

inline void __COM_AddRef(TaskbarList* p) {
    if (p) p->AddRef();
}

inline void __COM_Release(TaskbarList* p) {
    if (p) p->Release();
}
