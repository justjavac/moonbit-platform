///|
test "show implementations render debug representations" {
  let os : Os = Windows
  let arch : Arch = X64
  let info = Info::{ os, arch }
  inspect("\{os}", content="Windows")
  inspect("\{arch}", content="X64")
  inspect("\{info}", content="{ os: Windows, arch: X64 }")
}

///|
test "native os codes map to all public os variants" {
  inspect(os_from_code(1) == Windows, content="true")
  inspect(os_from_code(2) == MacOS, content="true")
  inspect(os_from_code(3) == Linux, content="true")
  inspect(os_from_code(0) == UnknownOs, content="true")
  inspect(os_from_code(-1) == UnknownOs, content="true")
}

///|
test "native architecture codes map to all public arch variants" {
  inspect(arch_from_code(1) == X86, content="true")
  inspect(arch_from_code(2) == X64, content="true")
  inspect(arch_from_code(3) == Arm, content="true")
  inspect(arch_from_code(4) == Arm64, content="true")
  inspect(arch_from_code(5) == Riscv64, content="true")
  inspect(arch_from_code(0) == UnknownArch, content="true")
  inspect(arch_from_code(-1) == UnknownArch, content="true")
}
