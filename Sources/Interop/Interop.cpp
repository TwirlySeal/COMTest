#include <ShObjIdl_core.h>

void* __CreateTaskbarList(void) {
  void* p = nullptr;
  HRESULT hr = CoCreateInstance(
    CLSID_TaskbarList,
    nullptr,
    CLSCTX_INPROC_SERVER,
    IID_ITaskbarList,
    &p
  );
  if (FAILED(hr) || !p) {
    return nullptr;
  }
  return p;
}
