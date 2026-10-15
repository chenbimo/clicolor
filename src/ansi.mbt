///|
/// 终端样式。不可变值，链式方法返回新值并与顺序无关，后续设的覆盖先设的。
///
/// 实现视图：fg / bg / attrs 三个 Int 位掩码（前景 4 bit、背景 4 bit、属性 5 bit），真彩色以字符串跟随；攒样式阶段零字符串分配，`text` 阶段一个
/// StringBuilder 一遍走完。
///
/// 模块视图：本包是终端转义序列的唯一来源。会算宽、会截断、会断行的库引用它，
/// 自己保持「序列不管宽度、宽度不管序列」的分工。
pub struct Style {
  priv fg : Int32 // 前景色 0..15（SGR 30..37 / 90..97），-1 无，-2 真彩看 hex_fg
  priv bg : Int32 // 背景色同上，-2 真彩看 hex_bg
  priv attrs : Int32 // 位 1 bold / 2 italic / 4 underline / 8 inverse / 16 strikethrough
  priv hex_fg : String
  priv hex_bg : String
} derive(Debug)

///|
pub extend Style with Debug::{to_repr}

///|
/// 空 Style，即无任何颜色与修饰的底座：前景不动、背景不动、无修饰。
/// 写法唯一化后，纯修饰、纯背景、运行期色值都从这里起步。
let base : Style = { fg: -1, bg: -1, attrs: 0, hex_fg: "", hex_bg: "", }

///|
fn Style::with_fg(self : Style, fg : Int32) -> Style {
  { ..self, fg, }
}

///|
fn Style::with_bg(self : Style, bg : Int32) -> Style {
  { ..self, bg, }
}

///|
fn Style::set_attr(self : Style, bit : Int32) -> Style {
  { ..self, attrs: self.attrs.lor(bit), }
}

///|
// 前景 16 色：链上方法与同名常量并存，`@clcolor.red.text("x")` 与
// `@clcolor.bold.red.text("x")` 两个方向都成立。
pub fn Style::black(self : Style) -> Style {
  self.with_fg(0)
}

///|
pub let default : Style = base

///|
/// 链首只从常量取值，方法仅供链身后继续叠加。
pub let black : Style = base.black()

///|
pub fn Style::red(self : Style) -> Style {
  self.with_fg(1)
}

///|
pub let red : Style = base.red()

///|
pub fn Style::green(self : Style) -> Style {
  self.with_fg(2)
}

///|
pub let green : Style = base.green()

///|
pub fn Style::yellow(self : Style) -> Style {
  self.with_fg(3)
}

///|
pub let yellow : Style = base.yellow()

///|
pub fn Style::blue(self : Style) -> Style {
  self.with_fg(4)
}

///|
pub let blue : Style = base.blue()

///|
pub fn Style::magenta(self : Style) -> Style {
  self.with_fg(5)
}

///|
pub let magenta : Style = base.magenta()

///|
pub fn Style::cyan(self : Style) -> Style {
  self.with_fg(6)
}

///|
pub let cyan : Style = base.cyan()

///|
pub fn Style::white(self : Style) -> Style {
  self.with_fg(7)
}

///|
pub let white : Style = base.white()

///|
pub fn Style::bright_black(self : Style) -> Style {
  self.with_fg(8)
}

///|
pub let bright_black : Style = base.bright_black()

///|
pub fn Style::bright_red(self : Style) -> Style {
  self.with_fg(9)
}

///|
pub let bright_red : Style = base.bright_red()

///|
pub fn Style::bright_green(self : Style) -> Style {
  self.with_fg(10)
}

///|
pub let bright_green : Style = base.bright_green()

///|
pub fn Style::bright_yellow(self : Style) -> Style {
  self.with_fg(11)
}

///|
pub let bright_yellow : Style = base.bright_yellow()

///|
pub fn Style::bright_blue(self : Style) -> Style {
  self.with_fg(12)
}

///|
pub let bright_blue : Style = base.bright_blue()

///|
pub fn Style::bright_magenta(self : Style) -> Style {
  self.with_fg(13)
}

///|
pub let bright_magenta : Style = base.bright_magenta()

///|
pub fn Style::bright_cyan(self : Style) -> Style {
  self.with_fg(14)
}

///|
pub let bright_cyan : Style = base.bright_cyan()

///|
pub fn Style::bright_white(self : Style) -> Style {
  self.with_fg(15)
}

///|
pub let bright_white : Style = base.bright_white()

///|
// 背景 16 色。
pub fn Style::bg_black(self : Style) -> Style {
  self.with_bg(0)
}

///|
pub let bg_black : Style = base.bg_black()

///|
pub fn Style::bg_red(self : Style) -> Style {
  self.with_bg(1)
}

///|
pub let bg_red : Style = base.bg_red()

///|
pub fn Style::bg_green(self : Style) -> Style {
  self.with_bg(2)
}

///|
pub let bg_green : Style = base.bg_green()

///|
pub fn Style::bg_yellow(self : Style) -> Style {
  self.with_bg(3)
}

///|
pub let bg_yellow : Style = base.bg_yellow()

///|
pub fn Style::bg_blue(self : Style) -> Style {
  self.with_bg(4)
}

///|
pub let bg_blue : Style = base.bg_blue()

///|
pub fn Style::bg_magenta(self : Style) -> Style {
  self.with_bg(5)
}

///|
pub let bg_magenta : Style = base.bg_magenta()

///|
pub fn Style::bg_cyan(self : Style) -> Style {
  self.with_bg(6)
}

///|
pub let bg_cyan : Style = base.bg_cyan()

///|
pub fn Style::bg_white(self : Style) -> Style {
  self.with_bg(7)
}

///|
pub let bg_white : Style = base.bg_white()

///|
pub fn Style::bg_bright_black(self : Style) -> Style {
  self.with_bg(8)
}

///|
pub let bg_bright_black : Style = base.bg_bright_black()

///|
pub fn Style::bg_bright_red(self : Style) -> Style {
  self.with_bg(9)
}

///|
pub let bg_bright_red : Style = base.bg_bright_red()

///|
pub fn Style::bg_bright_green(self : Style) -> Style {
  self.with_bg(10)
}

///|
pub let bg_bright_green : Style = base.bg_bright_green()

///|
pub fn Style::bg_bright_yellow(self : Style) -> Style {
  self.with_bg(11)
}

///|
pub let bg_bright_yellow : Style = base.bg_bright_yellow()

///|
pub fn Style::bg_bright_blue(self : Style) -> Style {
  self.with_bg(12)
}

///|
pub let bg_bright_blue : Style = base.bg_bright_blue()

///|
pub fn Style::bg_bright_magenta(self : Style) -> Style {
  self.with_bg(13)
}

///|
pub let bg_bright_magenta : Style = base.bg_bright_magenta()

///|
pub fn Style::bg_bright_cyan(self : Style) -> Style {
  self.with_bg(14)
}

///|
pub let bg_bright_cyan : Style = base.bg_bright_cyan()

///|
pub fn Style::bg_bright_white(self : Style) -> Style {
  self.with_bg(15)
}

///|
pub let bg_bright_white : Style = base.bg_bright_white()

///|
// 属性 5 项。
pub fn Style::bold(self : Style) -> Style {
  self.set_attr(1)
}

///|
pub let bold : Style = base.bold()

///|
pub fn Style::italic(self : Style) -> Style {
  self.set_attr(2)
}

///|
pub let italic : Style = base.italic()

///|
pub fn Style::underline(self : Style) -> Style {
  self.set_attr(4)
}

///|
pub let underline : Style = base.underline()

///|
pub fn Style::inverse(self : Style) -> Style {
  self.set_attr(8)
}

///|
pub let inverse : Style = base.inverse()

///|
pub fn Style::strikethrough(self : Style) -> Style {
  self.set_attr(16)
}

///|
pub let strikethrough : Style = base.strikethrough()

///|
// 高频预设，只是普通常量。
pub let error : Style = base.bold().red()

///|
pub let warn : Style = base.yellow()

///|
pub let ok : Style = base.green()

///|
pub let info : Style = base.blue()

///|
pub let dim : Style = base.bright_black()

///|
/// 真彩色前景，接受 `#RGB` 与 `#RRGGBB`，坏值渲染时按黑色降级。
pub fn Style::hex(self : Style, hex : String) -> Style {
  { ..self, fg: -2, hex_fg: hex, }
}

///|
/// 真彩色背景。
pub fn Style::bg_hex(self : Style, hex : String) -> Style {
  { ..self, bg: -2, hex_bg: hex, }
}

///|
priv struct Flag {
  mut on : Bool
}

///|
let flag : Flag = { on: true, }

///|
/// 显式输出开关。默认 true；设为 false 后所有 `text` 原样返回文本。
/// NO_COLOR / isatty 判断由上层调用方自己决定，本库保持纯函数。
/// 返回旧值，方便改完再恢复。
pub fn set_enabled(on : Bool) -> Bool {
  let prev = flag.on
  flag.on = on
  prev
}

///|
/// 当前输出开关状态。
pub fn is_enabled() -> Bool {
  flag.on
}

///|
/// ESC 字符。转义序列一律以它开头。
pub const ESC : Char = '\u{1B}'

///|
/// 重置所有样式。
const RESET : String = "\u{1B}[0m"

///|
/// 把实例化好的 Style 装上文本、产出串。空 Style 原样返回，一字节转义都不添。
pub fn Style::text(self : Style, s : String) -> String {
  if !flag.on {
    return s
  }
  if self.fg == -1 && self.bg == -1 && self.attrs == 0 {
    return s
  }
  let buf = StringBuilder()
  if self.fg >= 0 {
    emit_sgr(
      buf,
      (if self.fg < 8 { 30 + self.fg } else { 90 + self.fg - 8 }).to_string(),
    )
  } else if self.fg == -2 {
    emit_sgr(buf, "38;2;" + rgb_params(self.hex_fg))
  }
  if self.bg >= 0 {
    emit_sgr(
      buf,
      (if self.bg < 8 { 40 + self.bg } else { 100 + self.bg - 8 }).to_string(),
    )
  } else if self.bg == -2 {
    emit_sgr(buf, "48;2;" + rgb_params(self.hex_bg))
  }
  if self.attrs.land(1) != 0 {
    emit_sgr(buf, "1")
  }
  if self.attrs.land(2) != 0 {
    emit_sgr(buf, "3")
  }
  if self.attrs.land(4) != 0 {
    emit_sgr(buf, "4")
  }
  if self.attrs.land(8) != 0 {
    emit_sgr(buf, "7")
  }
  if self.attrs.land(16) != 0 {
    emit_sgr(buf, "9")
  }
  buf.write_string(s)
  buf.write_string(RESET)
  buf.to_string()
}

///|
/// 写一段 `ESC[<params>m`。
fn emit_sgr(buf : StringBuilder, params : String) -> Unit {
  buf.write_string("\u{1B}[")
  buf.write_string(params)
  buf.write_string("m")
}

///|
/// 把 `#RRGGBB` 或 `#RGB` 拆成 `r;g;b` 三个字节。取不到合法值时按黑色处理，
/// 保证渲染不会因为一个坏色值中断。
fn rgb_params(hex : String) -> String {
  let (r, g, b) = hex_bytes(hex)
  r.to_string() + ";" + g.to_string() + ";" + b.to_string()
}

///|
/// hex 字符串转三个字节：`#RRGGBB` 两位一组合成字节，`#RGB` 每位 ×17 展开成
/// 等价字节。非法字符一律跳过，收集不满就按黑色。
fn hex_bytes(hex : String) -> (Int32, Int32, Int32) {
  let digits : Array[Int32] = []
  for c in hex {
    match hex_value(c) {
      Some(v) => digits.push(v)
      None => ()
    }
  }
  match digits.length() {
    3 => (digits[0] * 17, digits[1] * 17, digits[2] * 17)
    6 =>
      (
        digits[0] * 16 + digits[1],
        digits[2] * 16 + digits[3],
        digits[4] * 16 + digits[5],
      )
    _ => (0, 0, 0)
  }
}

///|
/// 单个十六进制字符的取值。
fn hex_value(c : Char) -> Int32? {
  let code = c.to_int()
  if code >= 48 && code <= 57 {
    Some(code - 48)
  } else if code >= 97 && code <= 102 {
    Some(code - 97 + 10)
  } else if code >= 65 && code <= 70 {
    Some(code - 65 + 10)
  } else {
    None
  }
}

///|
/// OSC 8 超链接的起始序列前缀。截断或分包的库在切断内容后要用它判断
/// 链接是否还开着，开着就补上收尾序列。
pub const OSC8_PREFIX : String = "\u{1B}]8;;"

///|
/// 关掉当前 OSC 8 超链接的收尾序列。
pub const OSC8_SUFFIX : String = "\u{1B}]8;;\u{7}"

///|
/// 把文本包成 OSC 8 超链接。终端支持时文本可以点击，不支持时按普通文本显示。
pub fn hyperlink(url : String, text : String) -> String {
  OSC8_PREFIX + url + "\u{7}" + text + OSC8_SUFFIX
}
