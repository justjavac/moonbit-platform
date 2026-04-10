# justjavac/platform

Minimal native platform detection for Windows, Linux, and macOS.

```mbt check
///|
test {
  let current = @platform.current()
  inspect(current.os_name() != "", content="true")
  inspect(current.arch_name() != "", content="true")
}
```
