# justjavac/platform

[![coverage](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?label=coverage)](https://codecov.io/gh/justjavac/moonbit-platform)
[![linux](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=linux&label=linux)](https://codecov.io/gh/justjavac/moonbit-platform)
[![macos](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=macos&label=macos)](https://codecov.io/gh/justjavac/moonbit-platform)
[![windows](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=windows&label=windows)](https://codecov.io/gh/justjavac/moonbit-platform)

`justjavac/platform` is a small native-only MoonBit package for detecting basic
platform identity.

## Scope

The package exposes only compile-time native platform facts:

- `Os`: Windows, macOS, Linux, or unknown
- `Arch`: x86, x86_64, arm, aarch64, riscv64, or unknown
- `Info`: the current `{ os, arch }` pair
- convenience methods for names, family, target string, executable suffix,
  path separator, and line ending

The implementation is a tiny C stub plus a MoonBit wrapper. It does not inspect
environment variables or call host services.

## Quick Start

```mbt
///|
fn main {
  let current = @platform.current()
  println("target: \{current.target()}")
  println("os: \{current.os_name()}")
  println("arch: \{current.arch_name()}")
}
```

Run the included example:

```bash
moon run src/examples/overview --target native
```

## API

Primary entry points:

- `current() -> Info`
- `os() -> Os`
- `arch() -> Arch`

Core methods:

- `Os::name()`, `Os::family()`, `Os::is_known()`
- `Os::is_windows()`, `Os::is_unix()`
- `Os::executable_suffix()`, `Os::path_separator()`, `Os::line_ending()`
- `Arch::name()`, `Arch::is_known()`
- `Info::os_name()`, `Info::arch_name()`, `Info::target()`
- `Info::family()`, `Info::is_known()`
- `Info::is_windows()`, `Info::is_unix()`
- `Info::executable_suffix()`, `Info::path_separator()`, `Info::line_ending()`

## Development

```bash
moon check --target native
moon test --target native
moon test --target native --enable-coverage
moon coverage analyze -p justjavac/platform -- -f cobertura -o coverage.xml
moon fmt
moon info --target native
```

Coverage is uploaded on Linux, macOS, and Windows in GitHub Actions. Badge
values update after Codecov processes the default branch.

## License

MIT.
