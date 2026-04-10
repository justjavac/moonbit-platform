///|
fn main {
  let current = @platform.current()
  println("target: \{current.target()}")
  println("os: \{current.os_name()}")
  println("arch: \{current.arch_name()}")
  println("family: \{current.family()}")
  println("path separator: \{current.path_separator()}")
}
