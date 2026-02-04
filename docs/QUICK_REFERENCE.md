# SimpleServer 快速参考卡片

## 🚀 快速命令

### 本地开发
```bash
# 构建项目
mvn clean package -DskipTests

# 启动应用
mvn spring-boot:run

# 生成部署包
build-deploy-package.bat
```

### 服务器部署
```bash
# 上传部署包
scp -r deploy/* user@server:/home/simpleServer/

# 服务器操作
cd /home/simpleServer
chmod +x start-simpleServer.sh health-check.sh
./start-simpleServer.sh start
```

## 📁 关键目录

```
开发目录: C:\pro\yt\simpleServer\
部署目录: /home/simpleServer/ (服务器)
构建输出: target/
部署包: deploy/
```

## ⚙️ 核心配置

### 应用端口: 37210
### 数据库: simpleserver
### 包名: com.example.simpleserver

## 🛠️ 管理脚本

### 应用控制
- `start-simpleServer.sh start` - 启动
- `start-simpleServer.sh stop` - 停止
- `start-simpleServer.sh restart` - 重启
- `start-simpleServer.sh status` - 状态

### 监控检查
- `start-simpleServer.sh health` - 健康检查
- `start-simpleServer.sh logs` - 查看日志

## 🐛 常见问题

### 端口占用
```bash
netstat -ano | findstr :37210
taskkill /PID <pid> /F
```

### 数据库连接
检查:
- MySQL服务状态
- 数据库用户权限
- 连接配置信息

### 启动失败
查看:
- `startup.log` 启动日志
- `application.log` 应用日志
- 端口是否被占用

## 📋 部署清单

- [ ] 上传deploy目录全部文件
- [ ] 设置脚本执行权限
- [ ] 修改数据库连接配置
- [ ] 启动应用并验证
- [ ] 配置健康检查定时任务

---
📌 详细规范请参考: PROJECT_SPECIFICATION.md