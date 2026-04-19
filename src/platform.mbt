///|
/// Operating systems recognized by the native platform detector.
///
/// `Os` is a compact enum for platform branches that usually need different
/// filenames, separators, line endings, or feature choices. The detector
/// currently distinguishes Windows, macOS, Linux, and `UnknownOs` for every
/// other native target. Prefer the helper methods on `Os` when you need stable
/// lowercase names or coarse family checks.
pub(all) enum Os {
  Windows
  MacOS
  Linux
  UnknownOs
} derive(Debug, Eq)

///|
/// CPU architectures recognized by the native platform detector.
///
/// `Arch` describes the processor family that the native binary was compiled
/// for. The names returned by `Arch::name` are stable lowercase target labels,
/// so they are suitable for logs, cache keys, and combined target strings.
/// Targets outside the known set are represented as `UnknownArch`.
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
/// `Info` keeps the operating system and architecture together so callers can
/// pass a single value around instead of querying both dimensions repeatedly.
/// The values are derived from compile-time C macros. No filesystem,
/// environment, shell, or desktop APIs are touched, which makes the result
/// deterministic for a given compiled binary.
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
/// Render an operating system using the same spelling as its debug
/// representation.
///
/// This implementation is intended for diagnostic output. Use `Os::name` when
/// you need the stable lowercase label intended for target strings or file
/// names.
pub impl Show for Os with output(self, logger : &Logger) -> Unit {
  write_debug_show(self, logger)
}

///|
/// Render an architecture using the same spelling as its debug representation.
///
/// This implementation is intended for diagnostic output. Use `Arch::name`
/// when you need the stable lowercase label intended for target strings or
/// file names.
pub impl Show for Arch with output(self, logger : &Logger) -> Unit {
  write_debug_show(self, logger)
}

///|
/// Render platform info using the same spelling as its debug representation.
///
/// This implementation is useful while debugging because it exposes both
/// fields at once. Use `Info::target` when you need a compact stable string for
/// machine-readable output.
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
///
/// The value comes from native compile-time macros through the bundled C stub.
/// A known target returns one of `Windows`, `MacOS`, or `Linux`; every other
/// target returns `UnknownOs` so callers can decide their own fallback.
pub fn os() -> Os {
  os_from_code(native_os_code())
}

///|
/// Return the CPU architecture detected for this native binary.
///
/// The value comes from native compile-time macros through the bundled C stub.
/// Known targets include x86, x86_64, arm, aarch64, and riscv64. Every other
/// target returns `UnknownArch` so callers can decide their own fallback.
pub fn arch() -> Arch {
  arch_from_code(native_arch_code())
}

///|
/// Return the complete platform identity for this native binary.
///
/// This is the preferred entry point when you need both OS and architecture,
/// because the returned `Info` value can produce names, families, target
/// strings, and OS conventions without repeating the top-level queries.
pub fn current() -> Info {
  { os: os(), arch: arch() }
}

///|
/// Return a stable lowercase operating-system name.
///
/// The returned strings are `windows`, `macos`, `linux`, or `unknown`. They are
/// intended for logs, target identifiers, filenames, and other places where the
/// enum constructor spelling would be too presentation-oriented.
pub fn Os::name(self : Os) -> String {
  match self {
    Windows => "windows"
    MacOS => "macos"
    Linux => "linux"
    UnknownOs => "unknown"
  }
}

///|
/// Return the broad operating-system family.
///
/// Windows maps to `windows`, macOS and Linux map to `unix`, and unknown
/// targets map to `unknown`. This is useful when code only needs to choose
/// between Windows-style and Unix-style conventions.
pub fn Os::family(self : Os) -> String {
  match self {
    Windows => "windows"
    MacOS | Linux => "unix"
    UnknownOs => "unknown"
  }
}

///|
/// Return whether this operating system is known.
///
/// This is a lightweight guard for code that wants to use specific platform
/// behavior only when the detector recognized the target. `UnknownOs` returns
/// `false`; every other `Os` value returns `true`.
pub fn Os::is_known(self : Os) -> Bool {
  self != UnknownOs
}

///|
/// Return whether this operating system is Windows.
///
/// Use this helper instead of comparing names when choosing Windows-specific
/// paths, executable suffixes, or command-line behavior.
pub fn Os::is_windows(self : Os) -> Bool {
  self == Windows
}

///|
/// Return whether this operating system is Unix-like.
///
/// macOS and Linux return `true`. Windows and unknown targets return `false`,
/// which keeps fallback behavior conservative on targets the package does not
/// explicitly recognize.
pub fn Os::is_unix(self : Os) -> Bool {
  match self {
    MacOS | Linux => true
    _ => false
  }
}

///|
/// Return the executable suffix used by this operating system.
///
/// Windows returns `.exe`; all other values return an empty string. The method
/// is intentionally simple and mirrors the common convention needed when
/// composing executable filenames.
pub fn Os::executable_suffix(self : Os) -> String {
  match self {
    Windows => ".exe"
    _ => ""
  }
}

///|
/// Return the path separator used by this operating system.
///
/// Windows returns `\`; all other values return `/`. Unknown targets use the
/// Unix-style separator as the package's conservative default.
pub fn Os::path_separator(self : Os) -> String {
  match self {
    Windows => "\\"
    _ => "/"
  }
}

///|
/// Return the line ending convention used by this operating system.
///
/// Windows returns CRLF and all other values return LF. Unknown targets use LF
/// as the package's conservative default.
pub fn Os::line_ending(self : Os) -> String {
  match self {
    Windows => "\r\n"
    _ => "\n"
  }
}

///|
/// Return a stable lowercase architecture name.
///
/// The returned strings are `x86`, `x86_64`, `arm`, `aarch64`, `riscv64`, or
/// `unknown`. They are intended for logs, target identifiers, filenames, and
/// combined target strings.
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
///
/// This is a lightweight guard for code that wants architecture-specific
/// behavior only when the detector recognized the target. `UnknownArch` returns
/// `false`; every other `Arch` value returns `true`.
pub fn Arch::is_known(self : Arch) -> Bool {
  self != UnknownArch
}

///|
/// Return the operating-system name for this platform info.
///
/// This delegates to `Os::name` on the contained `os` value and returns the
/// same stable lowercase strings: `windows`, `macos`, `linux`, or `unknown`.
pub fn Info::os_name(self : Info) -> String {
  self.os.name()
}

///|
/// Return the architecture name for this platform info.
///
/// This delegates to `Arch::name` on the contained `arch` value and returns the
/// same stable lowercase strings used by the architecture enum.
pub fn Info::arch_name(self : Info) -> String {
  self.arch.name()
}

///|
/// Return a compact `os-arch` target string.
///
/// The result combines `Info::os_name` and `Info::arch_name`, for example
/// `windows-x86_64`, `linux-aarch64`, or `unknown-unknown`. It is suitable for
/// diagnostics, cache keys, and simple platform labels.
pub fn Info::target(self : Info) -> String {
  let os_name = self.os.name()
  let arch_name = self.arch.name()
  "\{os_name}-\{arch_name}"
}

///|
/// Return the broad operating-system family for this platform info.
///
/// This delegates to `Os::family` on the contained `os` value and returns
/// `windows`, `unix`, or `unknown`.
pub fn Info::family(self : Info) -> String {
  self.os.family()
}

///|
/// Return whether both OS and architecture were detected.
///
/// This returns `true` only when neither field is unknown. Use it when callers
/// need to reject or special-case targets that the package cannot identify
/// precisely.
pub fn Info::is_known(self : Info) -> Bool {
  self.os.is_known() && self.arch.is_known()
}

///|
/// Return whether this platform info represents Windows.
///
/// This delegates to `Os::is_windows` on the contained `os` value. It is a
/// convenient shorthand when code already carries an `Info` value.
pub fn Info::is_windows(self : Info) -> Bool {
  self.os.is_windows()
}

///|
/// Return whether this platform info represents a Unix-like OS.
///
/// This delegates to `Os::is_unix` on the contained `os` value. macOS and Linux
/// return `true`; Windows and unknown targets return `false`.
pub fn Info::is_unix(self : Info) -> Bool {
  self.os.is_unix()
}

///|
/// Return the executable suffix for this platform info.
///
/// This delegates to `Os::executable_suffix` on the contained `os` value, so
/// Windows returns `.exe` and all other values return an empty string.
pub fn Info::executable_suffix(self : Info) -> String {
  self.os.executable_suffix()
}

///|
/// Return the path separator for this platform info.
///
/// This delegates to `Os::path_separator` on the contained `os` value, so
/// Windows returns `\` and all other values return `/`.
pub fn Info::path_separator(self : Info) -> String {
  self.os.path_separator()
}

///|
/// Return the line ending convention for this platform info.
///
/// This delegates to `Os::line_ending` on the contained `os` value, so Windows
/// returns CRLF and all other values return LF.
pub fn Info::line_ending(self : Info) -> String {
  self.os.line_ending()
}
