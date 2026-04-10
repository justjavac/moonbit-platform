///|
test "current platform has stable metadata" {
  let current = @platform.current()
  let os_name = current.os_name()
  let arch_name = current.arch_name()
  inspect(
    os_name == "windows" ||
    os_name == "macos" ||
    os_name == "linux" ||
    os_name == "unknown",
    content="true",
  )
  inspect(
    arch_name == "x86" ||
    arch_name == "x86_64" ||
    arch_name == "arm" ||
    arch_name == "aarch64" ||
    arch_name == "riscv64" ||
    arch_name == "unknown",
    content="true",
  )
  inspect(current.target(), content="\{os_name}-\{arch_name}")
}

///|
test "os methods are deterministic" {
  let windows : @platform.Os = Windows
  let macos : @platform.Os = MacOS
  let linux : @platform.Os = Linux
  let unknown : @platform.Os = UnknownOs
  inspect(windows.name(), content="windows")
  inspect(macos.name(), content="macos")
  inspect(linux.name(), content="linux")
  inspect(unknown.name(), content="unknown")
  inspect(windows.family(), content="windows")
  inspect(macos.family(), content="unix")
  inspect(linux.family(), content="unix")
  inspect(unknown.family(), content="unknown")
  inspect(windows.is_windows(), content="true")
  inspect(linux.is_windows(), content="false")
  inspect(macos.is_unix(), content="true")
  inspect(unknown.is_known(), content="false")
}

///|
test "os conventions are deterministic" {
  let windows : @platform.Os = Windows
  let macos : @platform.Os = MacOS
  let linux : @platform.Os = Linux
  inspect(windows.executable_suffix(), content=".exe")
  inspect(linux.executable_suffix(), content="")
  inspect(windows.path_separator(), content="\\")
  inspect(macos.path_separator(), content="/")
  inspect(windows.line_ending(), content="\r\n")
  inspect(linux.line_ending(), content="\n")
}

///|
test "arch methods are deterministic" {
  let x86 : @platform.Arch = X86
  let x64 : @platform.Arch = X64
  let arm : @platform.Arch = Arm
  let arm64 : @platform.Arch = Arm64
  let riscv64 : @platform.Arch = Riscv64
  let unknown : @platform.Arch = UnknownArch
  inspect(x86.name(), content="x86")
  inspect(x64.name(), content="x86_64")
  inspect(arm.name(), content="arm")
  inspect(arm64.name(), content="aarch64")
  inspect(riscv64.name(), content="riscv64")
  inspect(unknown.name(), content="unknown")
  inspect(x64.is_known(), content="true")
  inspect(unknown.is_known(), content="false")
}

///|
test "info delegates to os and arch methods" {
  let windows : @platform.Os = Windows
  let x64 : @platform.Arch = X64
  let info = @platform.Info::{ os: windows, arch: x64 }
  inspect(info.os_name(), content="windows")
  inspect(info.arch_name(), content="x86_64")
  inspect(info.target(), content="windows-x86_64")
  inspect(info.family(), content="windows")
  inspect(info.is_known(), content="true")
  inspect(info.is_windows(), content="true")
  inspect(info.is_unix(), content="false")
  inspect(info.executable_suffix(), content=".exe")
  inspect(info.path_separator(), content="\\")
  inspect(info.line_ending(), content="\r\n")
}
