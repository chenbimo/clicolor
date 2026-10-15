// demo：clicolor 唯一写法的实景展示，每段说明在前、效果在后。
// 跑法：moon run src/main

///|
fn section(title : String) -> Unit {
  println("【" + title + "】")
}

///|
fn main {
  section("1 前景：16 色，从常量起步，text 收尾")
  println(
    @clicolor.black.text("black") +
    " " +
    @clicolor.red.text("red") +
    " " +
    @clicolor.green.text("green") +
    " " +
    @clicolor.yellow.text("yellow") +
    " " +
    @clicolor.blue.text("blue") +
    " " +
    @clicolor.magenta.text("magenta") +
    " " +
    @clicolor.cyan.text("cyan") +
    " " +
    @clicolor.white.text("white"),
  )
  println(
    @clicolor.bright_black.text("bright_black") +
    " " +
    @clicolor.bright_red.text("bright_red") +
    " " +
    @clicolor.bright_green.text("bright_green") +
    " " +
    @clicolor.bright_yellow.text("bright_yellow") +
    " " +
    @clicolor.bright_blue.text("bright_blue") +
    " " +
    @clicolor.bright_magenta.text("bright_magenta") +
    " " +
    @clicolor.bright_cyan.text("bright_cyan") +
    " " +
    @clicolor.bright_white.text("bright_white"),
  )

  section("2 前景 > 背景")
  println(
    @clicolor.bg_black.text("深色底") +
    " " +
    @clicolor.red.bg_blue().text("红字蓝底") +
    " " +
    @clicolor.black.bg_yellow().text("黑黄警示"),
  )

  section("3 前景 > 背景 > 修饰，固定顺序全叠")
  println(
    @clicolor.green.bold().underline().text("成功且强调") +
    "  " +
    @clicolor.red.bg_blue().bold().text("全叠"),
  )

  section("4 无色起步：default 起修饰链")
  println(
    @clicolor.default.bold().text("bold") +
    " " +
    @clicolor.default.italic().text("italic") +
    " " +
    @clicolor.default.underline().text("underline") +
    " " +
    @clicolor.default.inverse().text("inverse") +
    " " +
    @clicolor.default.strikethrough().text("strike"),
  )

  section("5 预设")
  println(
    @clicolor.error.text("文件缺失") +
    "  " +
    @clicolor.warn.text("磁盘将满") +
    "  " +
    @clicolor.ok.text("部署完成") +
    "  " +
    @clicolor.info.text("提示") +
    "  " +
    @clicolor.dim.text("2026-10-15 07:00"),
  )

  section("6 真彩色与坏值降级")
  println(
    @clicolor.default.hex("#FFA500").bold().text("真彩橙") +
    "  " +
    @clicolor.blue.bg_hex("#101010").text("深底") +
    "  " +
    @clicolor.red.hex("#zzz").text("坏值降黑"),
  )

  section("7 运行期色值：default.hex(c)")
  for c in ["#04B575", "#E06C75", "#61AFEF"] {
    println(@clicolor.default.bold().hex(c).text("动态色值 " + c))
  }

  section("8 样式当值复用")
  let label = @clicolor.bold.cyan()
  println(
    label.text("[clicolor]") +
    @clicolor.default.text(" 样式是值，可存可传可叠加 ") +
    label.underline().text("复用"),
  )

  section("9 关闭开关：全部原样返回")
  let _ = @clicolor.set_enabled(false)
  println(
    @clicolor.red.bold().text("管道输出，无转义字节") +
    " <- 应为纯文本",
  )
  let _ = @clicolor.set_enabled(true)
  println(@clicolor.red.text("恢复后重新上色"))

  section("10 OSC 8 超链接")
  println(
    @clicolor.cyan
    .underline()
    .text(@clicolor.hyperlink("https://mooncakes.io", "打开 mooncakes")),
  )
}
