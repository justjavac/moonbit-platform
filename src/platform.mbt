///|
/// Operating systems identified by the native platform detector.
pub(all) enum Os {
  Windows
  MacOS
  Linux
  UnknownOs
} derive(Debug, Eq)

///|
/// CPU architectures identified by the native platform detector.
pub(all) enum Arch {
  X86
  X64
  Arm
  Arm64
  Riscv64
  UnknownArch
} derive(Debug, Eq)

///|
/// Core platform facts for the current native binary.
///
/// The values are derived from compile-time C macros. No filesystem,
/// environment, shell, or desktop APIs are touched.
pub(all) struct Info {
  os : Os
  arch : Arch
} derive(Debug, Eq)

///|
/// Write a debug representation into a show logger.
fn[T : Debug] write_debug_show(value : T, logger : &Logger) -> Unit {
  logger.write_string(value.to_repr().to_string())
}

///|
/// Render an operating system using its debug representation.
pub impl Show for Os with output(self, logger : &Logger) -> Unit {
  write_debug_show(self, logger)
}

///|
/// Render an architecture using its debug representation.
pub impl Show for Arch with output(self, logger : &Logger) -> Unit {
  write_debug_show(self, logger)
}

///|
/// Render platform info using its debug representation.
pub impl Show for Info with output(self, logger : &Logger) -> Unit {
  write_debug_show(self, logger)
}

///|
/// Ask the C stub for the compile-time operating-system code.
extern "c" fn native_os_code() -> Int = "moonbit_native_platform_code"

///|
/// Ask the C stub for the compile-time CPU-architecture code.
extern "c" fn native_arch_code() -> Int = "moonbit_native_platform_architecture_code"

///|
/// Convert a native operating-system code into the public enum.
fn os_from_code(code : Int) -> Os {
  match code {
    1 => Windows
    2 => MacOS
    3 => Linux
    _ => UnknownOs
  }
}

///|
/// Convert a native architecture code into the public enum.
fn arch_from_code(code : Int) -> Arch {
  match code {
    1 => X86
    2 => X64
    3 => Arm
    4 => Arm64
    5 => Riscv64
    _ => UnknownArch
  }
}

///|
/// Return the operating system detected for this native binary.
pub fn os() -> Os {
  os_from_code(native_os_code())
}

///|
/// Return the CPU architecture detected for this native binary.
pub fn arch() -> Arch {
  arch_from_code(native_arch_code())
}

///|
/// Return the complete platform identity for this native binary.
pub fn current() -> Info {
  { os: os(), arch: arch() }
}

///|
/// Return a stable lowercase operating-system name.
pub fn Os::name(self : Os) -> String {
  match self {
    Windows => "windows"
    MacOS => "macos"
    Linux => "linux"
    UnknownOs => "unknown"
  }
}

///|
/// Return the broad operating-system family: `windows`, `unix`, or `unknown`.
pub fn Os::family(self : Os) -> String {
  match self {
    Windows => "windows"
    MacOS | Linux => "unix"
    UnknownOs => "unknown"
  }
}

///|
/// Return whether this operating system is known.
pub fn Os::is_known(self : Os) -> Bool {
  self != UnknownOs
}

///|
/// Return whether this operating system is Windows.
pub fn Os::is_windows(self : Os) -> Bool {
  self == Windows
}

///|
/// Return whether this operating system is Unix-like.
pub fn Os::is_unix(self : Os) -> Bool {
  match self {
    MacOS | Linux => true
    _ => false
  }
}

///|
/// Return the executable suffix used by this operating system.
pub fn Os::executable_suffix(self : Os) -> String {
  match self {
    Windows => ".exe"
    _ => ""
  }
}

///|
/// Return the path separator used by this operating system.
pub fn Os::path_separator(self : Os) -> String {
  match self {
    Windows => "\\"
    _ => "/"
  }
}

///|
/// Return the line ending convention used by this operating system.
pub fn Os::line_ending(self : Os) -> String {
  match self {
    Windows => "\r\n"
    _ => "\n"
  }
}

///|
/// Return a stable lowercase architecture name.
pub fn Arch::name(self : Arch) -> String {
  match self {
    X86 => "x86"
    X64 => "x86_64"
    Arm => "arm"
    Arm64 => "aarch64"
    Riscv64 => "riscv64"
    UnknownArch => "unknown"
  }
}

///|
/// Return whether this architecture is known.
pub fn Arch::is_known(self : Arch) -> Bool {
  self != UnknownArch
}

///|
/// Return the operating-system name for this platform info.
pub fn Info::os_name(self : Info) -> String {
  self.os.name()
}

///|
/// Return the architecture name for this platform info.
pub fn Info::arch_name(self : Info) -> String {
  self.arch.name()
}

///|
/// Return a compact `os-arch` target string.
pub fn Info::target(self : Info) -> String {
  let os_name = self.os.name()
  let arch_name = self.arch.name()
  "\{os_name}-\{arch_name}"
}

///|
/// Return the broad operating-system family for this platform info.
pub fn Info::family(self : Info) -> String {
  self.os.family()
}

///|
/// Return whether both OS and architecture were detected.
pub fn Info::is_known(self : Info) -> Bool {
  self.os.is_known() && self.arch.is_known()
}

///|
/// Return whether this platform info represents Windows.
pub fn Info::is_windows(self : Info) -> Bool {
  self.os.is_windows()
}

///|
/// Return whether this platform info represents a Unix-like OS.
pub fn Info::is_unix(self : Info) -> Bool {
  self.os.is_unix()
}

///|
/// Return the executable suffix for this platform info.
pub fn Info::executable_suffix(self : Info) -> String {
  self.os.executable_suffix()
}

///|
/// Return the path separator for this platform info.
pub fn Info::path_separator(self : Info) -> String {
  self.os.path_separator()
}

///|
/// Return the line ending convention for this platform info.
pub fn Info::line_ending(self : Info) -> String {
  self.os.line_ending()
}
