# clicolor

终端颜色与超链接转义序列库。

样式是不可变的 `Style` 值。颜色、背景、修饰全是公开常量，链式叠加后由 `text` 收尾产出串。

## 安装

```bash
moon add chensuiyi/clicolor
```

## 最小示例

```moonbit
@clicolor.red.text("失败")
@clicolor.red.bg_blue().bold().text("失败")
@clicolor.error.text("文件缺失")
```

## 规则

链首取实际存在的最前一项:有前景用前景色,没有前景用背景色,两色皆无用 `default`。

固定顺序:前景 > 背景 > 修饰。

收尾永远是 `text(文本)`,空样式原样返回。

## 常量

前景十六色 `red` 到 `bright_white`,背景同套前缀 `bg_`,修饰 `bold` `italic` `underline` `inverse` `strikethrough`,预设 `error` `warn` `ok` `info` `dim`。

## 更多

- 完整用法:文档站 `https://clicolor.moonbitlang.dev`
- 全部写法的实景展示:`moon run src/main`
- 桌面终端有颜色,管道输出记得 `set_enabled(false)`

## 许可证

MIT。
