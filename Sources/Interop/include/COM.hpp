#pragma once
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "user32.lib")

#include <cstdint>
#include <swift/bridging>

#include "C.hpp"


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
  LPVOID _Nullable pvReserved
) SWIFT_NAME(coInitialize(_:));

extern "C" __declspec(dllimport) void __stdcall CoUninitialize(void)
SWIFT_NAME(coUninitialize());


// COM APIs
// 
// Methods that need to be accessible from Swift are virtual and forward
// declared because C++ interop does not support calling pure virtual methods

struct __declspec(novtable) IUnknown {
    virtual HRESULT __stdcall __QueryInterface(
        const GUID& riid,
        IUnknown* _Nullable * _Nonnull ppvObject
    );

    virtual std::uint32_t __stdcall AddRef(void) = 0;

    virtual std::uint32_t __stdcall Release(void) = 0;

} SWIFT_SHARED_REFERENCE(__COM_AddRef, __COM_Release);

inline void __COM_AddRef(IUnknown* _Nonnull p) {
    if (p) p->AddRef();
}

inline void __COM_Release(IUnknown* _Nonnull p) {
    if (p) p->Release();
}

extern "C" HRESULT CoCreateInstance(
  const GUID& rclsid,
  IUnknown* _Nullable pUnkOuter,
  DWORD dwClsContext,
  const GUID& riid,
  IUnknown* _Nullable * _Nonnull ppv
) SWIFT_NAME(__CoCreateInstance(_:_:_:_:_:));

struct __declspec(novtable) ITaskbarList : public IUnknown {
    virtual HRESULT __stdcall __HrInit(void);
  
    virtual HRESULT __stdcall __AddTab(HWND _Nonnull hwnd);
  
    virtual HRESULT __stdcall __DeleteTab(HWND _Nonnull hwnd);
  
    virtual HRESULT __stdcall __ActivateTab(HWND _Nonnull hwnd);
  
    virtual HRESULT __stdcall __SetActiveAlt(HWND _Nonnull hwnd);
};
