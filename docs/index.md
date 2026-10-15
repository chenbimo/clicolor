---
layout: home

hero:
  name: clicolor
  text: 终端颜色与超链接库
  tagline: 样式是不可变的 `Style` 值,颜色、背景、修饰是公开常量,链式叠加,`text` 收尾产出串。纯函数、无 FFI,wasm-gc / js / native 三端可跑。
  actions:
    - theme: brand
      text: 快速上手
      link: /guide/usage
    - theme: alt
      text: 设计与语义
      link: /guide/design

---

## clicolor 与手拼转义序列对比

| 对比项 | clicolor | 手拼转义序列 |
| --- | --- | --- |
| 拼错样名 | 常量与编译期报错 | 运行期输出错序列,肉眼查 |
| 样式组合 | 链式叠加,与顺序无关 | 手抄参数号,组合就乱 |
| 降级 | 坏色值按黑色渲染,不中断 | 一个坏值毁整段输出 |
| 关色输出 | 显式开关,关闭后零转义字节 | 手动 if everywhere |
| 运行目标 | wasm-gc / js / native 三端 | 通常只测一端 |

## 它不做的事

不做 TTY 与 `NO_COLOR` 自动探测(保持纯函数,判定归调用方)、不做 256 色降级、不做嵌套富文本(等有真实需求再加)。
宽度、截断、断行归引用它的库(如 clitable),两边不互相依赖。
