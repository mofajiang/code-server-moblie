# code-server 移动版优化

[![GitHub Discussions](https://img.shields.io/badge/%20GitHub-%20Discussions-gray.svg?longCache=true&logo=github&colorB=purple)](https://github.com/coder/code-server/discussions) [![Join us on Slack](https://img.shields.io/badge/join-us%20on%20slack-gray.svg?longCache=true&logo=slack&colorB=brightgreen)](https://coder.com/community) [![Twitter Follow](https://img.shields.io/twitter/follow/CoderHQ?label=%40CoderHQ&style=social)](https://twitter.com/coderhq) [![Discord](https://img.shields.io/discord/747933592273027093)](https://discord.com/invite/coder)

在任何设备上通过浏览器运行完整的 VS Code，并获得针对移动端优化的编程体验。

![移动端优化](./assets/screenshot-1.png)

## 📱 本分支特性

本分支专注于 **移动端页面优化**，让智能手机和平板用户获得接近桌面端的编程体验。

### 核心优化

- ✅ **响应式布局** - 自动适配手机、平板和桌面设备
- ✅ **触摸友好** - 所有交互元素 ≥44px，精准触控
- ✅ **防 iOS 缩放** - 输入框字体固定 16px，布局稳定
- ✅ **紧凑界面** - 优化标题栏、状态栏，释放更多编辑空间
- ✅ **全宽模式** - 小屏设备侧边栏自动全宽显示
- ✅ **横屏优化** - 横向模式下自动调整布局

### 优化范围

| 组件           | 优化内容                                  |
| -------------- | ----------------------------------------- |
| 登录/错误页面  | 全宽布局、响应式字体、触摸友好按钮        |
| VS Code 主界面 | 响应式活动栏、侧边栏、编辑器标签          |
| 移动端 UI      | 增大的触摸区域、优化的列表间距            |
| 状态栏/面板    | 紧凑布局、可隐藏的次要元素                |
| 输入框/按钮    | 16px 字体防止 iOS 缩放、最小触摸高度 44px |

## 🚀 快速开始

### 使用安装脚本（推荐）

```bash
# 预览安装过程
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh -s -- --dry-run

# 执行安装
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh
```

> **注意**：以上命令使用当前分支的安装脚本，包含最新的移动端优化。

### 使用 Docker

```bash
docker run -it -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  codercom/code-server:latest
```

### 使用 npm

```bash
npm install -g code-server
```

## 📲 移动端访问

### iOS/iPadOS

1. 安装 code-server 到服务器
2. 使用 Safari 访问 `http://your-server:8080`
3. 点击「分享」→「添加到主屏幕」
4. 横屏使用获得最佳体验

### Android

1. 安装 code-server 到服务器
2. 使用 Chrome 访问
3. 添加到主屏幕获得应用式体验

### 配件推荐

- 蓝牙键盘 - 大幅提升编程效率
- 蓝牙鼠标 - 精确操作
- 手机/平板支架 - 舒适的角度

## 🔧 移动端优化细节

### 响应式断点

```css
/* 平板和大屏手机 */
@media (max-width: 768px) { ... }

/* 小屏手机 */
@media (max-width: 480px) { ... }

/* 横屏模式 */
@media (max-height: 500px) and (orientation: landscape) { ... }
```

### 主要改进

- **标题栏**: 44px → 40px（小屏）
- **活动栏**: 48px 宽度，24px 图标
- **状态栏**: 26px → 24px 高度
- **编辑器标签**: 44px → 40px 高度
- **列表项**: 最小 32px 行高
- **输入框**: 固定 16px 字体（防止 iOS 缩放）
- **按钮**: 最小 44px 触摸区域

## 📖 安装指南

### 使用安装脚本

```bash
curl -fsSL https://github.com/coder/code-server/raw/main/install.sh | sh
```

安装完成后，脚本会显示启动说明。

### 系统要求

- **最低配置**: 1 GB RAM, 2 vCPUs
- **推荐配置**: 2 GB RAM, 4 vCPUs
- **支持系统**: Linux (Debian/Ubuntu/Fedora/CentOS/Arch), macOS

### 配置

配置文件位置：`~/.config/code-server/config.yaml`

```yaml
bind-addr: 127.0.0.1:8080
auth: password
password: your_password_here
cert: true
```

### 启动

```bash
code-server
```

访问：http://127.0.0.1:8080

## 🌐 移动端使用技巧

### 最佳实践

1. **使用横屏模式** - 获得更多编辑空间
2. **添加到主屏幕** - 获得原生应用体验
3. **配合外接键盘** - 使用 VS Code 快捷键
4. **深色模式** - 省电（AMOLED 屏幕）

### 快捷键（外接键盘）

```
Ctrl/Cmd + P          - 快速搜索文件
Ctrl/Cmd + Shift + P  - 命令面板
Ctrl/Cmd + `          - 打开终端
Ctrl/Cmd + B          - 切换侧边栏
Ctrl/Cmd + S          - 保存文件
Ctrl/Cmd + W          - 关闭编辑器
```

## ⚠️ 已知限制

- 部分 VS Code 扩展的 UI 在移动端可能显示不完整
- 某些桌面级功能在触摸屏上操作不便
- 建议屏幕尺寸 ≥ 6 英寸获得最佳体验

## 📝 分支信息

- **分支名**: `260416-feat-optimize-mobile-pages`
- **当前版本**: v4.97.0 + VS Code 1.116.0
- **主要修改**:
  - `src/browser/pages/*.css` - 登录/错误页面优化
  - `lib/vscode/src/vs/workbench/browser/media/mobile.css` - VS Code 主界面移动端样式
- **项目仓库**: https://github.com/mofajiang/code-server-moblie/tree/260416-feat-optimize-mobile-pages

## 🤝 贡献

本分支基于官方的 [code-server](https://github.com/coder/code-server) 项目进行移动端优化。

如需报告移动端相关的问题或提出改进建议，请访问：

- 本仓库 Issues: https://github.com/mofajiang/code-server-moblie/issues
- 官方 Issues: https://github.com/coder/code-server/issues
- 官方讨论：https://github.com/coder/code-server/discussions

## 🔗 更多资源

- [官方文档](https://coder.com/docs/code-server)
- [安装指南](https://coder.com/docs/code-server/latest/install)
- [配置指南](https://coder.com/docs/code-server/latest/guide)
- [移动端使用指南](https://coder.com/docs/code-server/latest/ipad)
- [FAQ](https://coder.com/docs/code-server/latest/FAQ)

---

**版本**: v4.97.0 (移动端优化分支)  
**最后更新**: 2026-04-16  
**当前分支**: [260416-feat-optimize-mobile-pages](https://github.com/mofajiang/code-server-moblie/tree/260416-feat-optimize-mobile-pages)
