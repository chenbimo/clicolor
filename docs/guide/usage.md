# 用法

唯一写法:`@clicolor.<链首常量>.<链>.text(文本)`,看示例直接抄。

这条规则由三部分组成:链首从一个公开常量取值,链身往里叠能力,尾巴用 `text` 落串。全文没有第二种入口,也没有可省的花活。

## 链首

链首取实际存在的最前一项,按这个优先级走:

1. 有前景色:用前景常量起步,如 `@clicolor.red`
2. 没有前景但有背景:用背景常量起步,如 `@clicolor.bg_black`
3. 两色皆无:用 `default` 起步,比如纯修饰或运行期色值

修饰永远不当链首。`@clicolor.default.bold()` 是纯修饰的正解,`@clicolor.bold` 只在「把它存成值再叠加」的场景出现。

## 顺序

固定 **前景 > 背景 > 修饰**。

顺序是约定,库内部的位掩码表示对书写顺序不敏感,写反不报错也不炸。文档与 demo 里的示例全按规范排列,照抄即可。

零参链式方法要带括号,这是 moonbit 的语言规则。带参的方法只有两个:`hex(c)` 与 `bg_hex(c)`。收尾 `text(文本)` 带参,不可省。

## 前景十六色

八个常规色与八个亮色,常量与链上方法同名,链首用常量,中途叠加用方法:

| 常量        | 链上方法    | SGR |
| ----------- | ----------- | --- |
| `black`     | `.black()`  | 30  |
| `red`       | `.red()`    | 31  |
| `green`     | `.green()`  | 32  |
| `yellow`    | `.yellow()` | 33  |
| `blue`      | `.blue()`   | 34  |
| `magenta`   | `.magenta()`| 35  |
| `cyan`      | `.cyan()`   | 36  |
| `white`     | `.white()`  | 37  |
| `bright_*` 系列 | 同名 | 90 到 97 |

全部前景示例:

```moonbit
@clicolor.red.text("失败")
@clicolor.blue.underline().inverse().text("锁定")
```

## 背景十六色

与前景同名,前缀 `bg_`:

```moonbit
@clicolor.bg_black.text("纯背景起步")
@clicolor.red.bg_blue().text("红字蓝底")
@clicolor.green.bg_bright_black().text("绿字罕见深底")
```

## 修饰五项

| 属性            | SGR |
| --------------- | --- |
| `bold`          | 1   |
| `italic`        | 3   |
| `underline`     | 4   |
| `inverse`       | 7   |
| `strikethrough` | 9   |

```moonbit
@clicolor.default.bold().underline().text("当前路径")
@clicolor.red.bold().italic().text("双重强调的错误")
```

## 预设

五个高频组合,就是普通常量:

| 预设         | 组成                 | 典型场景         |
| ------------ | -------------------- | ---------------- |
| `error`      | bold + red           | 失败、报错        |
| `warn`       | yellow               | 警告、耗尽        |
| `ok`         | green                | 通过、完成        |
| `info`       | blue                 | 提示、说明        |
| `dim`        | bright_black         | 时间戳、次要信息  |

```moonbit
@clicolor.error.text("文件缺失")
@clicolor.warn.text("磁盘将满")
@clicolor.ok.text("部署完成")
@clicolor.info.text("提示")
@clicolor.dim.text("2026-10-16 09:00")
```

## 真彩色

`hex` 接前景,`bg_hex` 接背景,两者都接受 `#RRGGBB` 与 `#RGB` 短写。真彩是这库仅有的两类带参调用之一,另一个是收尾的 `text`:

```moonbit
@clicolor.hex("#FFA500").bold().text("真彩橙")
@clicolor.blue.bg_hex("#101010").text("深底")
```

坏色值的处理是「降级为黑色」而不是中断:

```moonbit
@clicolor.red.hex("#zzz").text("仍能产出文本")   // 渲染成 38;2;0;0;0
```

解析规则:非法字符跳过,收集不满按黑。空白、大写小写都容,`#f0a` 等价 `#ff00aa`。

## 运行期色值

色值来自配置、主题、用户数据这类运行期来源时,没有对应常量,从 `default` 起步挂 `hex`:

```moonbit
let c = theme.danger_color
@clicolor.default.hex(c).text(t)
```

运行期色值不需要单独入口,`Style::new` 已被 `default` 吸收,常量表里找不到的那个色,就从 `default.hex(c)` 走。

## 样式当值复用

每条链都是不可变值,不存不传,组织风格由小到大任意扩展:

```moonbit
let label = @clicolor.bold.cyan()
println(label.text("[标签]") + " " + label.underline().text("复用"))
```

叠加生成变体时本体不动,适合把一套品牌色存成常量表:

```moonbit
let brand = @clicolor.hex("#04B575")
let brand_dim = brand.italic()
let brand_strong = brand.bold()
```

## 输出开关

库保持纯函数,不读 TTY 与环境变量。上层判定后显式关:

```moonbit
let prev = @clicolor.set_enabled(false)   // 返回旧值,方便恢复
print(@clicolor.red.text("管道输出,原样返回"))
@clicolor.set_enabled(prev)

@clicolor.is_enabled()
```

关闭后所有 `text` 原样返回文本,连 StringBuilder 都不建。常见搭配:检测 `NO_COLOR` 或非交互流,关一次,整段程序不再两套路径。

## OSC 8 超链接

```moonbit
@clicolor.hyperlink("https://mooncakes.io", "打开 mooncakes")
```

文本支持时可在终端点击,不支持时退化为纯文本。与样式可自由组合:

```moonbit
@clicolor.cyan.underline().text(@clicolor.hyperlink(url, "文档"))
```

## 与 clitable 一起用

样式全是 `Style` 值,表格库直接接收:

```moonbit
let table = @clitable.Table::new(cols)
  .with_head_style(@clicolor.green.bold())
  .with_border_style(@clicolor.blue)
  .push([
    @clitable.Cell::text("alpha"),
    @clitable.Cell::text("failing").color(@clicolor.error),
  ])
```

## demo

`moon run src/main` 跑十段实景,对应十类用法,颜色在本机终端直接可见。
