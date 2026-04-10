# justjavac/platform

Minimal native platform detection for MoonBit packages.

```mbt nocheck
let current = @platform.current()
println(current.target())
```

Run checks with:

```bash
moon check --target native
moon test --target native
```
