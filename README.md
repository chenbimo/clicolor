# clicolor

终端颜色与超链接转义序列库，[moonbit](../) 工作区里渲染类模块（clitable 等）的基建。

样式是不可变的 `Style` 值：颜色、属性、背景色是公开常量，链式返回新值，`text` 收尾产出串。坏色值按黑色降级，不中断渲染。

## 用法

发布到 mooncakes 之后：

```bash
moon add chensuiyi/clicolor
```

唯一写法：`@clicolor.<链首常量>.<链>.text(文本)`。链首取实际存在的最前一项：有前景用前景色，没有前景用背景色，两色皆无才用 `default`（专供纯修饰与运行期色值）。固定顺序 **前景 > 背景 > 修饰** 不变。链步零参带括号（moonbit 语言规则），带参的只有 `hex` / `bg_hex`，收尾永远 `text`。

```moonbit
// 前景
@clicolor.red.text("失败")
@clicolor.blue.underline().inverse().text("锁定")

// 前景 > 背景
@clicolor.red.bg_blue().text("失败")

// 前景 > 背景 > 修饰
@clicolor.red.bg_blue().bold().text("失败")
@clicolor.green.bold().underline().text("成功")

// 纯背景起步：没有前景，背景常量直接当链首
@clicolor.bg_red.text("背景")

// 两色皆无：default 起步（纯修饰、运行期色值）
@clicolor.default.bold().text("加强")
@clicolor.default.underline().italic().text("标注")

// 预设
@clicolor.error.text("文件缺失")
@clicolor.warn.text("磁盘将满")
@clicolor.ok.text("部署完成")
@clicolor.info.text("提示")
@clicolor.dim.text("2026-10-15 07:00")
```

常量一览：前景色 `red` `green` `yellow` `blue` `magenta` `cyan` `white` 与对应 `bright_*`；背景色 `bg_*` 全套同上；修饰 `bold` `italic` `underline` `inverse` `strikethrough`；预设 `error` `warn` `ok` `info` `dim`；起步兜底 `default`。

运行期色值与运行期背景：

```moonbit
@clicolor.default.hex(c).text(t)
@clicolor.red.bg_hex("#101010").text("hi")
```

OSC 8 可点击超链接：

```moonbit
@clicolor.hyperlink("https://mooncakes.io", "docs")
```

## 输出开关

不做 TTY 与 `NO_COLOR` 自动探测，本库保持纯函数。上层调用方自己判定后显式关掉：

```moonbit
@clicolor.set_enabled(false)   // 返回旧值，方便恢复
```

关闭后所有 `text` 原样返回文本。

## 迁移

`Ansi` 枚举、`wrap_ansi` 数组入口、`Color::paint`、`Style::new` 均已除名，统一收敛到上面的唯一写法。

## 设计要点

**攒样式与产串分离。** 链上每步只拷贝一个小记录（前景 4 bit、背景 4 bit、属性 5 bit 的位掩码），零字符串分配；`text` 阶段单个缓冲区一遍走完，发射顺序与书写顺序一致。

**空样式不添字节。** `default` 与关闭开关时 `text` 都原样返回，一字节转义都不输出。

**分工纪律。** 转义序列与宽度是两件事：本包只管序列（生成与收尾），宽度、截断、断行由引用它的库自己处理，`strip_ansi` 一类的宽度剥离不进本包，避免互相依赖成环。

**边界（当前明确不做）。** 嵌套样式（富文本树，内层关闭时重开外层）暂不实现，等 clitable 出现带色单元格截断的实需求再动；届时会新增独立的组合层，不复用 `Style`。256 色降级、TTY 自动探测同样在边界外。

## demo

`src/main/demo.mbt` 是全部写法的实景展示，十段对应用法各一，直接跑：

```bash
moon run src/main
```

## 许可证

MIT。
