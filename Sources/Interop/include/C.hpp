#pragma once

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
