# 用法

唯一写法:`@clicolor.<链首常量>.<链>.text(文本)`。

链首取实际存在的最前一项:有前景用前景色,没有前景用背景色,两色皆无才用 `default`(纯修饰、运行期色值)。固定顺序 **前景 > 背景 > 修饰**。链步零参方法带括号(moonbit 语言规则),带参的只有 `hex` / `bg_hex`,收尾永远 `text`。

## 前景

```moonbit
@clicolor.red.text("失败")
@clicolor.blue.underline().inverse().text("锁定")
```

## 前景 > 背景

```moonbit
@clicolor.red.bg_blue().text("失败")
```

## 前景 > 背景 > 修饰

```moonbit
@clicolor.red.bg_blue().bold().text("失败")
@clicolor.green.bold().underline().text("成功")
```

## 纯背景、纯修饰、运行期色值:default 起步

```moonbit
@clicolor.bg_black.text("深色底")     // 无前景,背景常量直接起步
@clicolor.default.bold().text("加强")
@clicolor.default.hex(c).text(t)      // 色值运行期才确定时
```

## 常量一览

- 前景:`black` 到 `white` 与 `bright_*` 一套十六个
- 背景:`bg_black` 到 `bg_bright_white` 同样一套
- 修饰:`bold` `italic` `underline` `inverse` `strikethrough`
- 预设:`error`(bold+red) `warn` `ok` `info` `dim`
- 起步兜底:`default`

## 便捷常量起步与复用

```moonbit
let label = @clicolor.bold.cyan()      // 样式是值,可存可传
println(label.text("[标签]") + label.underline().text("复用"))
```

## 真彩色

接受 `#RGB` 与 `#RRGGBB`,坏值渲染时按黑色降级,不因坏值中断:

```moonbit
@clicolor.hex("#FFA500").bold().text("真彩橙")
@clicolor.blue.bg_hex("#101010").text("深底")
```

## OSC 8 超链接

```moonbit
@clicolor.cyan.underline().text(@clicolor.hyperlink("https://mooncakes.io", "打开 mooncakes"))
```

## 输出开关

不做 TTY 与 `NO_COLOR` 自动探测,库是纯函数,判定归调用方:

```moonbit
let prev = @clicolor.set_enabled(false)   // 返回旧值,方便恢复
print(@clicolor.red.text("管道输出,原样返回"))
@clicolor.set_enabled(prev)

@clicolor.is_enabled()
```

关闭后所有 `text` 原样返回文本,一字节转义不输出。
