#include "include/Interop.hpp"
#include <ShObjIdl_core.h>

MyTaskbarList* CreateTaskbarList(void) {
  MyTaskbarList* p = nullptr;
  HRESULT hr = CoCreateInstance(
    CLSID_TaskbarList,
    nullptr,
    CLSCTX_INPROC_SERVER,
    IID_ITaskbarList,
    reinterpret_cast<void**>(&p)
  );
  if (FAILED(hr) || !p) {
    return nullptr;
  }
  return reinterpret_cast<MyTaskbarList*>(p);
}
