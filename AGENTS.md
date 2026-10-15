# clicolor 仓库约定

终端颜色与超链接转义序列库，moonbit 工作区渲染类模块的基建。无依赖、无 FFI，多 target。

通用规范（工具链、devkit、提交格式、命名）见工作区脚本中心 `moonbit/scripts/NEW-PROJECT.md`，这里只写本项目特有的值。

## 目录地图

| 文件 | 职责 |
| --- | --- |
| `src/ansi.mbt` | 不可变 `Style` 值与公开常量、SGR 序列生成、`text` 收尾、输出开关、OSC 8 常量与 `hyperlink` |
| `src/ansi_test.mbt` | 黑盒测试（序列字节级断言） |

## 设计约定

- 转义序列与宽度分家：本包只管序列，宽度剥离、截断、断行归引用它的库。两边不互相依赖。
- 唯一写法：`@clicolor.<链首常量>.<链>.text(文本)`。链首取实际存在的最前一项：有前景用前景色，没前景用背景色，两色皆无才 `default`（纯修饰、运行期色值）；固定顺序前景 > 背景 > 修饰。写法是约定不做机器拦序，库内部仍与顺序无关。
- 零参链式方法要带括号（moonbit 语言规则）；带参的只有 `hex` / `bg_hex`，`text` 收尾。
- 样式值用三个 `Int` 位掩码 + 真彩字符串承载，攒样式阶段零字符串分配；坏 `hex` 渲染时按黑色降级，不因坏值中断。
- 不做 TTY / `NO_COLOR` 自动探测，保持纯函数；进出总开关 `set_enabled` / `is_enabled`，由上层调用方决定。
- 空 Style 原样返回，不产生任何转义字节；关闭开关时同样原样返回。

## 测试

每条 SGR 序列有字节级黑盒断言；改序列行为必须同步改测试名里的覆盖点。

## 文档站

- VitePress 站点在 `docs/`，中文单语；构建命令 `bun install --frozen-lockfile && bun run build`，输出 `dist`
- 托管于 Cloudflare Pages 项目 `moonbit-clicolor`，自定义域 `clicolor.moonbitlang.dev`（CNAME 指向 `moonbit-clicolor.pages.dev`），监听路径 `docs/*` 与 `moon.mod`——发版时改了 version 站点才会跟着更新
- 构建环境变量 `BUN_VERSION=1.4.3` 与 `SKIP_DEPENDENCY_INSTALL=1`，production 与 preview 都设，原因见工作区规范 `NEW-PROJECT.md`
- 依赖与构建可本地跑（`bun install && bun run build`），`node_modules` 与 `dist` 不跟踪
- 部署只靠 GitHub App「Cloudflare Workers and Pages」的 push 自动化，仓库里不存凭据，不加 workflow
