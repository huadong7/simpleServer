# SimpleServer 部署包清单 (/home/simpleServer目录)

## 部署文件列表

### 必须文件
1. `simpleServer-1.0.0.jar` - 主应用程序文件 (约41MB)
2. `application.properties` - 应用配置文件
3. `start-simpleServer.sh` - 应用启动管理脚本

### 可选文件
4. `DEPLOY_CENTOS_HOME.md` - 详细部署说明文档
5. `health-check.sh` - 健康检查脚本 (需单独创建)

## 部署目录结构

```
/home/simpleServer/
├── simpleServer-1.0.0.jar          # 应用程序jar包
├── application.properties          # 应用配置文件
├── start-simpleServer.sh          # 启动管理脚本
├── application.log                # 应用运行日志 (自动生成)
├── startup.log                    # 应用启动日志 (自动生成)
└── application.pid                # 应用进程ID文件 (自动生成)
```

## 部署步骤

### 1. 服务器准备
```bash
# 创建目录并设置权限
sudo mkdir -p /home/simpleServer
sudo chown $USER:$USER /home/simpleServer
```

### 2. 上传文件
```bash
# 上传必需文件到服务器
scp target/simpleServer-1.0.0.jar user@server:/home/simpleServer/
scp application-prod.properties user@server:/home/simpleServer/application.properties
scp start-simpleServer.sh user@server:/home/simpleServer/
```

### 3. 设置权限
```bash
cd /home/simpleServer
chmod +x start-simpleServer.sh
```

### 4. 配置应用
编辑 `/home/simpleServer/application.properties`：
- 修改数据库连接信息
- 调整端口和其他配置参数

### 5. 启动应用
```bash
cd /home/simpleServer
./start-simpleServer.sh start
```

## 管理命令

```bash
cd /home/simpleServer

# 应用控制
./start-simpleServer.sh start    # 启动应用
./start-simpleServer.sh stop     # 停止应用
./start-simpleServer.sh restart  # 重启应用
./start-simpleServer.sh status   # 查看状态

# 监控检查
./start-simpleServer.sh health   # 健康检查
./start-simpleServer.sh logs     # 查看日志
```

## 重要配置说明

### 数据库配置
在 `application.properties` 中必须正确配置：
```properties
spring.datasource.url=jdbc:mysql://数据库主机:3306/simpleserver
spring.datasource.username=数据库用户名
spring.datasource.password=数据库密码
```

### 端口配置
默认端口：37210
可通过修改 `application.properties` 中的 `server.port` 参数调整

### 日志配置
- 应用日志：`/home/simpleServer/application.log`
- 启动日志：`/home/simpleServer/startup.log`
- 日志级别可在 `application.properties` 中调整

## 注意事项

1. 确保服务器已安装Java 8或更高版本
2. 确保MySQL数据库已创建并可访问
3. 根据实际网络环境开放相应端口
4. 生产环境建议配置系统服务和监控脚本
5. 定期备份配置文件和数据库

## 故障排除

如遇问题，请查看：
1. 启动日志：`/home/simpleServer/startup.log`
2. 应用日志：`/home/simpleServer/application.log`
3. 使用 `./start-simpleServer.sh status` 查看应用状态