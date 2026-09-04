#pragma once

#include <Windows.h>
#include <rpcndr.h>
#include <Unknwn.h>
#include <winerror.h>
#include <swift/bridging>

MIDL_INTERFACE("56FDF342-FD6D-11d0-958A-006097C9A090")
MyTaskbarList : public IUnknown
{
public:
    virtual HRESULT STDMETHODCALLTYPE HrInit(void) {
      return E_NOTIMPL;
    }
    
    virtual HRESULT STDMETHODCALLTYPE AddTab(HWND hwnd) {
      return E_NOTIMPL;
    }
    
    virtual HRESULT STDMETHODCALLTYPE DeleteTab(HWND hwnd) {
      return E_NOTIMPL;
    }
    
    virtual HRESULT STDMETHODCALLTYPE ActivateTab(HWND hwnd) {
      return E_NOTIMPL;
    }
    
    virtual HRESULT STDMETHODCALLTYPE SetActiveAlt(HWND hwnd) {
      return E_NOTIMPL;
    }
} SWIFT_SHARED_REFERENCE(COM_AddRef, COM_Release);

inline void COM_AddRef(MyTaskbarList* p) {
    if (p) p->AddRef();
}

inline void COM_Release(MyTaskbarList* p) {
    if (p) p->Release();
}

SWIFT_RETURNS_RETAINED MyTaskbarList* CreateTaskbarList(void);
