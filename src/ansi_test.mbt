///|
test "text wraps a single color" {
  assert_eq(@clicolor.red.text("hi"), "\u{1B}[31mhi\u{1B}[0m")
}

///|
test "chain is order independent" {
  assert_eq(@clicolor.bold.red().text("hi"), @clicolor.red.bold().text("hi"))
}

///|
test "chain emits attrs first then fg then bg" {
  assert_eq(@clicolor.bold.red().text("hi"), "\u{1B}[31m\u{1B}[1mhi\u{1B}[0m")
}

///|
test "background color uses its own sequence" {
  assert_eq(
    @clicolor.red.bg_blue().text("hi"),
    "\u{1B}[31m\u{1B}[44mhi\u{1B}[0m",
  )
}

///|
test "bright colors hit the 90 range" {
  assert_eq(@clicolor.bright_black.text("hi"), "\u{1B}[90mhi\u{1B}[0m")
}

///|
test "hex expands to truecolor RGB" {
  assert_eq(
    @clicolor.red.hex("#FFA500").text("hi"),
    "\u{1B}[38;2;255;165;0mhi\u{1B}[0m",
  )
}

///|
test "three digit hex expands like the six digit form" {
  assert_eq(
    @clicolor.red.hex("#f0a").text("hi"),
    "\u{1B}[38;2;255;0;170mhi\u{1B}[0m",
  )
}

///|
test "bad hex falls back to black instead of breaking the render" {
  assert_eq(
    @clicolor.red.hex("#zzz").text("hi"),
    "\u{1B}[38;2;0;0;0mhi\u{1B}[0m",
  )
}

///|
test "bg hex uses the 48 family" {
  assert_eq(
    @clicolor.red.bg_hex("#101010").text("hi"),
    "\u{1B}[31m\u{1B}[48;2;16;16;16mhi\u{1B}[0m",
  )
}

///|
test "default carries runtime hex through the chain" {
  assert_eq(
    @clicolor.default.hex("#FFA500").text("hi"),
    "\u{1B}[38;2;255;165;0mhi\u{1B}[0m",
  )
}

///|
test "empty style keeps the text untouched" {
  assert_eq(@clicolor.default.text("hi"), "hi")
}

///|
test "presets are ordinary constants" {
  assert_eq(@clicolor.error.text("x"), "\u{1B}[31m\u{1B}[1mx\u{1B}[0m")
  assert_eq(@clicolor.warn.text("x"), "\u{1B}[33mx\u{1B}[0m")
  assert_eq(@clicolor.ok.text("x"), "\u{1B}[32mx\u{1B}[0m")
  assert_eq(@clicolor.info.text("x"), "\u{1B}[34mx\u{1B}[0m")
  assert_eq(@clicolor.dim.text("x"), "\u{1B}[90mx\u{1B}[0m")
}

///|
test "disabled output returns text as-is" {
  let prev = @clicolor.set_enabled(false)
  assert_eq(@clicolor.red.bold().text("hi"), "hi")
  let _ = @clicolor.set_enabled(prev)
}

///|
test "hyperlink is the full OSC 8 sequence" {
  assert_eq(
    @clicolor.hyperlink("https://mooncakes.io", "docs"),
    "\u{1B}]8;;https://mooncakes.io\u{7}docs\u{1B}]8;;\u{7}",
  )
}

///|
test "default starts pure-attr and pure-bg chains, never a modifier" {
  assert_eq(@clicolor.default.bold().text("hi"), "\u{1B}[1mhi\u{1B}[0m")
  assert_eq(@clicolor.default.bg_red().text("hi"), "\u{1B}[41mhi\u{1B}[0m")
  assert_eq(
    @clicolor.default.underline().italic().text("hi"),
    "\u{1B}[3m\u{1B}[4mhi\u{1B}[0m",
  )
}

///|
test "emission order is fg then bg then attrs, same as written order" {
  assert_eq(
    @clicolor.red.bg_blue().bold().underline().text("hi"),
    "\u{1B}[31m\u{1B}[44m\u{1B}[1m\u{1B}[4mhi\u{1B}[0m",
  )
}
