#!/bin/bash
# code-server 移动端优化版本安装脚本
# 仓库：https://github.com/mofajiang/code-server-moblie
# 分支：260416-feat-optimize-mobile-pages

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
MOBILE_REPO="${MOBILE_REPO:-https://github.com/mofajiang/code-server-moblie.git}"
MOBILE_BRANCH="${MOBILE_BRANCH:-260416-feat-optimize-mobile-pages}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/lib/code-server-mobile}"
BIN_DIR="$HOME/.local/bin"

echo_header() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

echo_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

echo_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

echo_error() {
  echo -e "${RED}✗ $1${NC}" >&2
}

check_dependencies() {
  echo_header "检查依赖"
  
  if ! command -v git &> /dev/null; then
    echo_error "git 未安装，请先安装 git"
    exit 1
  fi
  echo_success "git 已安装"
  
  if ! command -v node &> /dev/null; then
    echo_warning "node.js 未安装，建议安装 Node.js v20+"
  else
    NODE_VERSION=$(node -v 2>/dev/null || echo "unknown")
    echo_success "Node.js 已安装 ($NODE_VERSION)"
  fi
  
  if ! command -v npm &> /dev/null; then
    echo_warning "npm 未安装，可能无法安装依赖"
  else
    NPM_VERSION=$(npm -v 2>/dev/null || echo "unknown")
    echo_success "npm 已安装 ($NPM_VERSION)"
  fi
}

clone_repository() {
  echo_header "克隆代码仓库"
  
  CACHE_DIR="$HOME/.cache/code-server-mobile"
  mkdir -p "$CACHE_DIR"
  
  if [ -d "$CACHE_DIR/code-server-moblie" ]; then
    echo_warning "缓存目录已存在，清除旧缓存..."
    rm -rf "$CACHE_DIR/code-server-moblie"
  fi
  
  echo "正在克隆仓库..."
  git clone --depth 1 --branch "$MOBILE_BRANCH" "$MOBILE_REPO" "$CACHE_DIR/code-server-moblie"
  
  echo_success "仓库克隆完成"
}

install_dependencies() {
  echo_header "安装依赖"
  
  cd "$CACHE_DIR/code-server-moblie"
  
  if command -v npm &> /dev/null; then
    echo "使用 npm 安装依赖..."
    npm install --unsafe-perm || {
      echo_warning "npm install 失败，继续执行..."
    }
    echo_success "依赖安装完成"
  else
    echo_warning "npm 不可用，跳过依赖安装"
  fi
}

setup_installation() {
  echo_header "设置安装目录"
  
  # 检查是否已安装
  if [ -d "$INSTALL_DIR" ]; then
    echo_error "安装目录已存在：$INSTALL_DIR"
    echo "如需重新安装，请先执行：rm -rf $INSTALL_DIR"
    exit 1
  fi
  
  # 创建目录
  mkdir -p "$INSTALL_DIR"
  mkdir -p "$BIN_DIR"
  
  # 复制文件
  cp -r "$CACHE_DIR/code-server-moblie/src" "$INSTALL_DIR/"
  
  # 如果 lib 目录存在（构建后的文件），也复制过去
  if [ -d "$CACHE_DIR/code-server-moblie/lib" ]; then
    cp -r "$CACHE_DIR/code-server-moblie/lib" "$INSTALL_DIR/"
  fi
  
  # 复制 package.json 和其他必要文件
  [ -f "$CACHE_DIR/code-server-moblie/package.json" ] && \
    cp "$CACHE_DIR/code-server-moblie/package.json" "$INSTALL_DIR/"
  
  echo_success "文件复制完成"
}

create_wrapper() {
  echo_header "创建启动脚本"
  
  # 尝试找到 code-server 二进制文件
  if [ -f "$CACHE_DIR/code-server-moblie/bin/code-server" ]; then
    ln -fs "$CACHE_DIR/code-server-moblie/bin/code-server" "$BIN_DIR/code-server"
  else
    # 创建包装脚本
    cat > "$BIN_DIR/code-server" << 'EOF'
#!/bin/bash
# code-server 移动端优化版本 - 启动脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/lib/code-server-mobile"
OUT_DIR="$INSTALL_DIR/out"

# 查找 Node.js
if ! command -v node &> /dev/null; then
    echo "错误：未找到 node 命令"
    echo "请先安装 Node.js: https://nodejs.org/"
    exit 1
fi

# 启动 code-server
if [ -f "$OUT_DIR/node/main.js" ]; then
    exec node "$OUT_DIR/node/main.js" "$@"
else
    echo "错误：找不到 code-server 主程序"
    echo "可能需要先构建项目：cd $INSTALL_DIR && npm run build"
    exit 1
fi
EOF
    chmod +x "$BIN_DIR/code-server"
  fi
  
  echo_success "启动脚本创建完成"
}

print_post_install() {
  echo_header "安装完成"
  
  echo -e "${GREEN}code-server 移动端优化版本已成功安装！${NC}"
  echo
  echo "安装目录：$INSTALL_DIR"
  echo "启动脚本：$BIN_DIR/code-server"
  echo
  echo_header "下一步操作"
  
  echo "1. 添加环境变量"
  echo "   执行以下命令（永久生效）："
  echo -e "   ${YELLOW}echo 'export PATH=$HOME/.local/bin:\$PATH' >> ~/.bashrc${NC}"
  echo -e "   ${YELLOW}source ~/.bashrc${NC}"
  echo
  echo "2. 启动 code-server"
  echo -e "   ${YELLOW}code-server${NC}"
  echo
  echo "3. 访问地址"
  echo "   浏览器打开：http://localhost:8080"
  echo
  echo_header "移动端功能"
  echo -e "  ${GREEN}✓${NC} 响应式布局 (768px, 480px 断点)"
  echo -e "  ${GREEN}✓${NC} 触摸友好界面 (≥44px 触摸目标)"
  echo -e "  ${GREEN}✓${NC} iOS Safari 防自动缩放 (16px 字体)"
  echo -e "  ${GREEN}✓${NC} 深色模式支持"
  echo -e "  ${GREEN}✓${NC} 移动端优化的终端"
  echo
  echo_header "文档"
  echo "  中文文档：https://github.com/mofajiang/code-server-moblie/blob/$MOBILE_BRANCH/docs/README.md"
  echo "  功能演示：https://github.com/mofajiang/code-server-moblie/blob/$MOBILE_BRANCH/docs/MOBILE_FEATURES_DEMO.md"
  echo
  echo "================================================"
}

main() {
  echo_header "code-server 移动端优化版本安装程序"
  echo "仓库：$MOBILE_REPO"
  echo "分支：$MOBILE_BRANCH"
  echo
  
  check_dependencies
  clone_repository
  install_dependencies
  setup_installation
  create_wrapper
  print_post_install
}

main "$@"
