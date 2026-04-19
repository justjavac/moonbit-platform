# justjavac/platform

[![coverage](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?label=coverage)](https://codecov.io/gh/justjavac/moonbit-platform)
[![linux](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=linux&label=linux)](https://codecov.io/gh/justjavac/moonbit-platform)
[![macos](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=macos&label=macos)](https://codecov.io/gh/justjavac/moonbit-platform)
[![windows](https://img.shields.io/codecov/c/github/justjavac/moonbit-platform/main?flag=windows&label=windows)](https://codecov.io/gh/justjavac/moonbit-platform)

`justjavac/platform` is a small native-only MoonBit package for detecting basic
platform identity at compile time. It reports the operating system and CPU
architecture that the current native binary was built for, then provides a few
convenience helpers for common platform-specific strings.

The package is intentionally narrow: it does not inspect environment variables,
read files, spawn shell commands, or call desktop services. All values come from
native compiler macros through a tiny C stub.

## Quick Start

```mbt nocheck
let current = @platform.current()
println(current.target())
println(current.os_name())
println(current.arch_name())
```
