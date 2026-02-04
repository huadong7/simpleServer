#!/bin/bash

# SimpleServer 健康检查脚本
# 用于定时检查应用状态并自动重启

APP_HOME="/home/simpleServer"
CHECK_LOG="${APP_HOME}/health-check.log"
MAX_RETRIES=3
RETRY_COUNT=0

# 记录日志函数
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$CHECK_LOG"
}

log_message "开始健康检查..."

cd "$APP_HOME" || {
    log_message "错误: 无法切换到目录 $APP_HOME"
    exit 1
}

# 检查进程是否存在
if [ ! -f "application.pid" ]; then
    log_message "警告: PID文件不存在"
    ./start-simpleServer.sh start
    exit 0
fi

PID=$(cat "application.pid")

if ! ps -p "$PID" > /dev/null 2>&1; then
    log_message "错误: 进程 $PID 不存在，尝试重启应用"
    ./start-simpleServer.sh start
    exit 1
fi

# 检查HTTP响应
HEALTH_URL="http://localhost:37210/actuator/health"
if command -v curl >/dev/null 2>&1; then
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        if curl -s -f -m 5 "$HEALTH_URL" >/dev/null 2>&1; then
            log_message "健康检查通过"
            exit 0
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            log_message "健康检查失败，重试 $RETRY_COUNT/$MAX_RETRIES"
            sleep 10
        fi
    done
    
    log_message "健康检查持续失败，重启应用"
    ./start-simpleServer.sh restart
else
    log_message "警告: 未安装curl，仅检查进程状态"
    log_message "进程运行正常 (PID: $PID)"
fi