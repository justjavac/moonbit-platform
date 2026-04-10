#include <moonbit.h>

#include <stdint.h>

MOONBIT_FFI_EXPORT
int32_t moonbit_native_platform_code(void) {
#if defined(_WIN32) || defined(_WIN64)
  return 1;
#elif defined(__APPLE__)
  return 2;
#elif defined(__linux__)
  return 3;
#else
  return 0;
#endif
}

MOONBIT_FFI_EXPORT
int32_t moonbit_native_platform_architecture_code(void) {
#if defined(__i386__) || defined(_M_IX86)
  return 1;
#elif defined(__x86_64__) || defined(_M_X64)
  return 2;
#elif defined(__arm__) || defined(_M_ARM)
  return 3;
#elif defined(__aarch64__) || defined(_M_ARM64)
  return 4;
#elif defined(__riscv) && defined(__riscv_xlen) && __riscv_xlen == 64
  return 5;
#else
  return 0;
#endif
}
