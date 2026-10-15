# 安装与引入

clicolor 发布到 [mooncakes](https://mooncakes.io)。把它加进模块的 `moon.mod`:

```moonbit
import {
  "chensuiyi/clicolor",
}
```

或者用命令安装:

```bash
moon add chensuiyi/clicolor
```

之后在模块内以 `@clicolor` 前缀使用:

```moonbit
@clicolor.red.text("失败")
```

## 运行目标

- 纯逻辑、无 FFI、零依赖:`wasm-gc` / `js` / `native` 三端可跑,无须额外配置

## 版本

文档右上角的版本号取自 `moon.mod` 的 `version` 字段,与发布保持一致。
