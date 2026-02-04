#!/bin/bash

# SimpleServer 启动脚本 for /home/simpleServer directory
# 适用于CentOS服务器部署

# 应用基本信息
APP_NAME="simpleServer"
APP_VERSION="1.0.0"
APP_HOME="/home/simpleServer"
JAR_FILE="${APP_NAME}-${APP_VERSION}.jar"
CONFIG_FILE="application.properties"
LOG_FILE="application.log"
PID_FILE="application.pid"

# Java配置
JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
JAVA_OPTS="-Xms512m -Xmx1024m -server"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=prod"
JAVA_OPTS="$JAVA_OPTS -Dlogging.file.name=${APP_HOME}/${LOG_FILE}"

# 应用配置
APP_PORT="37210"
APP_HOST="0.0.0.0"

# 颜色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 使用说明
usage() {
    echo "SimpleServer 应用管理脚本"
    echo "用法: $0 {start|stop|restart|status|health|logs}"
    echo ""
    echo "命令说明:"
    echo "  start   - 启动应用"
    echo "  stop    - 停止应用"
    echo "  restart - 重启应用"
    echo "  status  - 查看应用状态"
    echo "  health  - 检查应用健康状态"
    echo "  logs    - 查看应用日志"
    echo ""
    echo "应用信息:"
    echo "  应用目录: $APP_HOME"
    echo "  应用端口: $APP_PORT"
    echo "  配置文件: $APP_HOME/$CONFIG_FILE"
    echo "  日志文件: $APP_HOME/$LOG_FILE"
    exit 1
}

# 检查Java环境
check_java() {
    if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
        JAVA_CMD="$JAVA_HOME/bin/java"
    elif command -v java >/dev/null 2>&1; then
        JAVA_CMD="java"
    else
        log_error "未找到Java运行环境"
        log_error "请安装OpenJDK 8或设置JAVA_HOME环境变量"
        exit 1
    fi
    
    JAVA_VERSION=$($JAVA_CMD -version 2>&1 | head -n 1 | cut -d'"' -f2)
    log_info "使用Java版本: $JAVA_VERSION"
}

# 检查应用目录
check_directory() {
    if [ ! -d "$APP_HOME" ]; then
        log_error "应用目录不存在: $APP_HOME"
        log_info "请创建目录: mkdir -p $APP_HOME"
        exit 1
    fi
    
    cd "$APP_HOME" || {
        log_error "无法切换到应用目录: $APP_HOME"
        exit 1
    }
}

# 检查必要文件
check_files() {
    if [ ! -f "$JAR_FILE" ]; then
        log_error "找不到应用jar文件: $APP_HOME/$JAR_FILE"
        log_info "请将 $JAR_FILE 文件放置到 $APP_HOME 目录下"
        exit 1
    fi
    
    if [ ! -f "$CONFIG_FILE" ]; then
        log_warn "配置文件不存在: $APP_HOME/$CONFIG_FILE"
        log_info "将使用默认配置启动应用"
    fi
}

# 启动应用
start_app() {
    check_java
    check_directory
    check_files
    
    # 检查是否已在运行
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            log_warn "应用已在运行 (PID: $PID)"
            exit 1
        else
            # 清理无效的PID文件
            rm -f "$PID_FILE"
        fi
    fi
    
    log_info "正在启动 $APP_NAME..."
    
    # 构建启动命令
    START_CMD="$JAVA_CMD $JAVA_OPTS -jar $JAR_FILE"
    
    # 如果配置文件存在，则指定配置文件位置
    if [ -f "$CONFIG_FILE" ]; then
        START_CMD="$START_CMD --spring.config.location=file:$APP_HOME/$CONFIG_FILE"
    fi
    
    # 后台启动应用
    nohup $START_CMD > "${APP_HOME}/startup.log" 2>&1 &
    NEW_PID=$!
    
    # 保存PID
    echo $NEW_PID > "$PID_FILE"
    
    # 等待应用启动
    log_info "等待应用启动..."
    sleep 10
    
    # 检查启动状态
    if ps -p "$NEW_PID" > /dev/null 2>&1; then
        log_success "$APP_NAME 启动成功 (PID: $NEW_PID)"
        log_info "访问地址: http://$(hostname -I | awk '{print $1}'):$APP_PORT"
        log_info "日志文件: $APP_HOME/$LOG_FILE"
    else
        log_error "$APP_NAME 启动失败"
        log_info "请检查启动日志: $APP_HOME/startup.log"
        rm -f "$PID_FILE"
        exit 1
    fi
}

# 停止应用
stop_app() {
    check_directory
    
    if [ ! -f "$PID_FILE" ]; then
        log_warn "应用未在运行或PID文件不存在"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    
    if ! ps -p "$PID" > /dev/null 2>&1; then
        log_warn "进程 $PID 不存在，清理PID文件"
        rm -f "$PID_FILE"
        exit 1
    fi
    
    log_info "正在停止 $APP_NAME (PID: $PID)..."
    
    # 优雅停止
    kill "$PID"
    sleep 5
    
    # 如果还在运行则强制停止
    if ps -p "$PID" > /dev/null 2>&1; then
        log_warn "优雅停止超时，强制终止进程"
        kill -9 "$PID"
    fi
    
    # 清理PID文件
    rm -f "$PID_FILE"
    log_success "$APP_NAME 已停止"
}

# 重启应用
restart_app() {
    log_info "重启 $APP_NAME..."
    stop_app
    sleep 2
    start_app
}

# 查看应用状态
status_app() {
    check_directory
    
    if [ ! -f "$PID_FILE" ]; then
        log_info "$APP_NAME 未运行"
        return
    fi
    
    PID=$(cat "$PID_FILE")
    
    if ps -p "$PID" > /dev/null 2>&1; then
        log_success "$APP_NAME 正在运行 (PID: $PID)"
        
        # 显示端口监听状态
        if command -v netstat >/dev/null 2>&1; then
            PORT_STATUS=$(netstat -tlnp 2>/dev/null | grep ":$APP_PORT " | head -1)
            if [ -n "$PORT_STATUS" ]; then
                log_info "监听端口: $PORT_STATUS"
            else
                log_warn "端口 $APP_PORT 未监听"
            fi
        fi
        
        # 显示内存使用
        MEM_USAGE=$(ps -p "$PID" -o rss= 2>/dev/null | awk '{printf "%.1f MB", $1/1024}')
        if [ -n "$MEM_USAGE" ]; then
            log_info "内存使用: $MEM_USAGE"
        fi
    else
        log_error "$APP_NAME 进程不存在 (PID: $PID)"
        log_info "清理无效PID文件"
        rm -f "$PID_FILE"
    fi
}

# 健康检查
health_check() {
    check_directory
    
    if [ ! -f "$PID_FILE" ]; then
        log_error "$APP_NAME 未运行"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    if ! ps -p "$PID" > /dev/null 2>&1; then
        log_error "$APP_NAME 进程不存在"
        exit 1
    fi
    
    # 检查HTTP响应
    HEALTH_URL="http://localhost:$APP_PORT/actuator/health"
    if command -v curl >/dev/null 2>&1; then
        RESPONSE=$(curl -s -f -m 5 "$HEALTH_URL" 2>/dev/null)
        if [ $? -eq 0 ]; then
            log_success "$APP_NAME 健康检查通过"
            echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
        else
            log_error "$APP_NAME 健康检查失败"
            exit 1
        fi
    else
        log_warn "未安装curl，跳过HTTP健康检查"
        log_success "$APP_NAME 进程运行正常 (PID: $PID)"
    fi
}

# 查看日志
view_logs() {
    check_directory
    
    if [ ! -f "$LOG_FILE" ]; then
        log_error "日志文件不存在: $APP_HOME/$LOG_FILE"
        log_info "请先启动应用"
        exit 1
    fi
    
    log_info "显示最近50行日志:"
    tail -n 50 "$LOG_FILE"
    echo ""
    log_info "实时跟踪日志 (按Ctrl+C退出):"
    tail -f "$LOG_FILE"
}

# 主程序逻辑
case "$1" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        restart_app
        ;;
    status)
        status_app
        ;;
    health)
        health_check
        ;;
    logs)
        view_logs
        ;;
    *)
        usage
        ;;
esac