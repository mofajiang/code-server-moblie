# 安装脚本使用指南

本目录包含两个安装脚本，分别针对不同的使用场景。

## 脚本对比

| 脚本                | 用途                   | 语言 | 特点                                   |
| ------------------- | ---------------------- | ---- | -------------------------------------- |
| `install.sh`        | 官方安装脚本的扩展版本 | 英文 | 支持 `--mobile` 参数，兼容原版所有功能 |
| `install-mobile.sh` | 专用移动端安装脚本     | 中文 | 中文输出、彩色提示、更友好的安装体验   |

## 使用方式

### install.sh（官方扩展版）

这是官方 `install.sh` 脚本的扩展版本，添加了 `--mobile` 参数支持。

#### 完整参数说明

```bash
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh -s -- [参数]
```

可用参数：

- `--dry-run` - 预览安装过程，不执行实际操作
- `--version X.X.X` - 安装指定版本（默认最新版）
- `--edge` - 安装最新 edge 版本
- `--mobile` - **新增**：安装移动端优化版本
- `--method detect|standalone` - 选择安装方式
- `--prefix <dir>` - 设置安装目录（默认 `~/.local`）
- `--rsh <bin>` - 指定远程 shell（默认 `ssh`）

#### 示例

```bash
# 安装移动端优化版本（推荐）
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh -s -- --mobile

# 预览安装过程
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh -s -- --mobile --dry-run

# 远程安装
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install.sh | sh -s -- --mobile user@host
```

---

### install-mobile.sh（专用中文版）

专门为中文用户优化的安装脚本，提供更友好的安装体验。

#### 特性

- ✅ 全中文输出，清晰易懂
- ✅ 彩色提示，关键信息醒目
- ✅ 自动检查依赖
- ✅ 智能错误处理
- ✅ 详细的安装后指引

#### 使用方法

```bash
# 基础安装
curl -fsSL https://raw.githubusercontent.com/mofajiang/code-server-moblie/260416-feat-optimize-mobile-pages/install-mobile.sh | bash

# 自定义安装目录
INSTALL_DIR=/opt/code-server curl -fsSL .../install-mobile.sh | bash

# 使用其他分支
MOBILE_BRANCH=main curl -fsSL .../install-mobile.sh | bash
```

#### 环境变量

| 变量名          | 默认值                                                | 说明     |
| --------------- | ----------------------------------------------------- | -------- |
| `MOBILE_REPO`   | `https://github.com/mofajiang/code-server-moblie.git` | 仓库地址 |
| `MOBILE_BRANCH` | `260416-feat-optimize-mobile-pages`                   | 分支名称 |
| `INSTALL_DIR`   | `$HOME/.local/lib/code-server-mobile`                 | 安装目录 |

---

## 安装后的步骤

### 1. 添加环境变量（二选一）

**临时生效**（当前终端）：

```bash
export PATH=$HOME/.local/bin:$PATH
```

**永久生效**：

```bash
# 添加到 ~/.bashrc（推荐）
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 或添加到 ~/.zshrc（如使用 zsh）
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

### 2. 启动 code-server

```bash
code-server
```

默认监听 `127.0.0.1:8080`，如需修改：

```bash
# 指定端口
code-server --port 3000

# 允许所有 IP 访问
code-server --bind-addr 0.0.0.0:8080
```

### 3. 移动端访问

1. 确保服务器防火墙开放对应端口
2. 手机浏览器访问 `http://服务器IP:8080`
3. 输入密码（首次安装时显示在终端）
4. 添加到主屏幕获得更好体验

---

## 故障排查

### 问题 1：curl 命令失败

**错误信息**：`curl: command not found`

**解决方案**：

```bash
# Debian/Ubuntu
sudo apt-get install curl

# CentOS/Fedora
sudo yum install curl

# macOS
brew install curl
```

### 问题 2：git 克隆失败

**错误信息**：`git: command not found`

**解决方案**：

```bash
# Debian/Ubuntu
sudo apt-get install git

# CentOS/Fedora
sudo yum install git

# macOS
brew install git
```

### 问题 3：npm install 失败

**可能原因**：

- Node.js 版本过低（需要 v20+）
- 网络连接问题
- 权限问题

**解决方案**：

```bash
# 检查 Node.js 版本
node -v

# 升级 Node.js（使用 nvm）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20

# 或使用系统包管理器
# Debian/Ubuntu
sudo apt-get install nodejs npm

# 如遇到权限问题，添加 --unsafe-perm
npm install -g code-server --unsafe-perm
```

### 问题 4：code-server 命令未找到

**错误信息**：`code-server: command not found`

**解决方案**：

```bash
# 确认环境变量已添加
echo $PATH

# 手动添加
export PATH=$HOME/.local/bin:$PATH

# 检查软链接是否存在
ls -la $HOME/.local/bin/code-server

# 重新创建软链接
ln -sf $HOME/.local/lib/code-server-mobile/bin/code-server $HOME/.local/bin/code-server
```

### 问题 5：移动端访问无法显示

**可能原因**：

- 防火墙阻止访问
- code-server 未正确绑定 IP
- 浏览器缓存问题

**解决方案**：

```bash
# 开放防火墙端口
sudo ufw allow 8080/tcp  # Ubuntu
sudo firewall-cmd --add-port=8080/tcp --permanent  # CentOS

# 使用 --bind-addr 允许所有 IP
code-server --bind-addr 0.0.0.0:8080

# 清除浏览器缓存或使用无痕模式
```

---

## 卸载

如需卸载 code-server：

```bash
# 删除安装目录
rm -rf $HOME/.local/lib/code-server-mobile

# 删除启动脚本
rm -f $HOME/.local/bin/code-server

# 删除缓存
rm -rf $HOME/.cache/code-server
rm -rf $HOME/.cache/code-server-mobile

# 从环境变量中移除（编辑 ~/.bashrc 或 ~/.zshrc）
nano ~/.bashrc  # 删除 PATH 相关行
```

---

## 其他安装资源

- [官方安装文档](https://coder.com/docs/code-server/latest/install)
- [Docker 部署指南](./guide.md)
- [iOS/iPadOS 使用指南](./ios.md)
- [Android 使用指南](./android.md)
- [Termux 移动开发](./termux.md)

---

**最后更新**: 2026-04-16
**适用分支**: `260416-feat-optimize-mobile-pages`
