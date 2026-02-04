#!/bin/bash

# SimpleServer CentOS部署脚本
# 用于在CentOS服务器上部署和管理SimpleServer应用

APP_NAME="simpleServer"
APP_VERSION="1.0.0"
JAR_FILE="${APP_NAME}-${APP_VERSION}.jar"
APP_HOME="/opt/${APP_NAME}"
LOG_DIR="/var/log/${APP_NAME}"
CONFIG_DIR="/etc/${APP_NAME}"

# Java相关配置
JAVA_OPTS="-Xms512m -Xmx1024m -server"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=prod"

# 应用配置
APP_PORT="37210"
APP_HOST="0.0.0.0"

usage() {
    echo "用法: $0 {start|stop|restart|status|deploy}"
    echo "  start   - 启动应用"
    echo "  stop    - 停止应用" 
    echo "  restart - 重启应用"
    echo "  status  - 查看应用状态"
    echo "  deploy  - 部署新版本"
    exit 1
}

check_java() {
    if ! command -v java &> /dev/null; then
        echo "错误: 未找到Java运行环境"
        echo "请安装OpenJDK 8或更高版本"
        exit 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo "检测到Java版本: $JAVA_VERSION"
}

create_directories() {
    # 创建必要的目录
    mkdir -p $APP_HOME
    mkdir -p $LOG_DIR
    mkdir -p $CONFIG_DIR
    
    # 设置权限
    chown -R $(whoami):$(whoami) $APP_HOME $LOG_DIR $CONFIG_DIR
}

deploy_app() {
    echo "开始部署应用..."
    
    # 检查jar文件是否存在
    if [ ! -f "$JAR_FILE" ]; then
        echo "错误: 找不到jar文件 $JAR_FILE"
        echo "请确保在包含jar文件的目录下运行此脚本"
        exit 1
    fi
    
    # 备份当前版本
    if [ -f "$APP_HOME/$JAR_FILE" ]; then
        echo "备份当前版本..."
        cp "$APP_HOME/$JAR_FILE" "$APP_HOME/${JAR_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # 部署新版本
    echo "部署新版本..."
    cp "$JAR_FILE" "$APP_HOME/"
    
    # 创建配置文件
    create_config
    
    echo "部署完成！"
    echo "应用位置: $APP_HOME/$JAR_FILE"
    echo "日志位置: $LOG_DIR"
    echo "配置位置: $CONFIG_DIR"
}

create_config() {
    # 创建应用配置文件
    cat > "$CONFIG_DIR/application-prod.properties" << EOF
# 生产环境配置
server.port=$APP_PORT
server.address=$APP_HOST

# 数据库配置 - 请根据实际情况修改
spring.datasource.url=jdbc:mysql://localhost:3306/simpleserver?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
spring.datasource.username=simpleserver_user
spring.datasource.password=your_password_here
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# 连接池配置
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000

# JPA配置
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL57Dialect

# 日志配置
logging.level.root=INFO
logging.level.com.example.simpleserver=INFO
logging.file.name=$LOG_DIR/application.log
logging.logback.rollingpolicy.max-file-size=10MB
logging.logback.rollingpolicy.max-history=30

# 应用配置
spring.application.name=$APP_NAME
EOF

    echo "已创建配置文件: $CONFIG_DIR/application-prod.properties"
    echo "请根据实际情况修改数据库连接信息"
}

start_app() {
    check_java
    
    if [ ! -f "$APP_HOME/$JAR_FILE" ]; then
        echo "错误: 应用未部署，请先运行 deploy 命令"
        exit 1
    fi
    
    # 检查是否已经在运行
    if pgrep -f "$JAR_FILE" > /dev/null; then
        echo "应用已在运行中"
        exit 1
    fi
    
    echo "启动应用..."
    
    # 启动应用
    nohup java $JAVA_OPTS \
        -Dspring.config.location=file:$CONFIG_DIR/application-prod.properties \
        -jar "$APP_HOME/$JAR_FILE" \
        > "$LOG_DIR/startup.log" 2>&1 &
    
    # 等待应用启动
    sleep 10
    
    # 检查启动状态
    if pgrep -f "$JAR_FILE" > /dev/null; then
        echo "应用启动成功！"
        echo "访问地址: http://$(hostname -I | awk '{print $1}'):$APP_PORT"
        echo "日志文件: $LOG_DIR/application.log"
    else
        echo "应用启动失败，请检查日志: $LOG_DIR/startup.log"
        exit 1
    fi
}

stop_app() {
    echo "停止应用..."
    
    # 查找并终止进程
    PID=$(pgrep -f "$JAR_FILE")
    if [ -n "$PID" ]; then
        kill $PID
        sleep 5
        
        # 强制终止如果还在运行
        if pgrep -f "$JAR_FILE" > /dev/null; then
            kill -9 $PID
        fi
        
        echo "应用已停止"
    else
        echo "应用未在运行"
    fi
}

status_app() {
    if pgrep -f "$JAR_FILE" > /dev/null; then
        PID=$(pgrep -f "$JAR_FILE")
        echo "应用正在运行 (PID: $PID)"
        echo "监听端口: $APP_PORT"
        netstat -tlnp | grep ":$APP_PORT " 2>/dev/null || echo "端口状态未知"
    else
        echo "应用未运行"
    fi
}

case "$1" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        stop_app
        sleep 2
        start_app
        ;;
    status)
        status_app
        ;;
    deploy)
        create_directories
        deploy_app
        ;;
    *)
        usage
        ;;
esac