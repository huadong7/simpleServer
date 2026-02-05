# SimpleServer 项目规范文档

## 项目基本信息

### 项目名称
- **正式名称**: simpleServer
- **包名规范**: com.example.simpleserver
- **数据库名**: simpleserver
- **应用端口**: 37210

### 技术栈
- **框架**: Spring Boot 2.7.0
- **构建工具**: Maven 3.x (本地apache-maven-3.8.6)
- **数据库**: MySQL 5.7
- **ORM框架**: Spring Data JPA
- **Java版本**: Java 8
- **JSON处理**: Jackson 2.13.3

## 项目架构说明

### 整体架构图
```
┌─────────────────────────────────────────────────────────────┐
│                    SimpleServer 应用架构                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Client    │  │   Client    │  │   Client    │         │
│  │ Applications│  │  Web Browser│  │   Mobile    │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                 │
│         └────────────────┼────────────────┘                 │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │   REST API      │                        │
│                 │  Controllers    │                        │
│                 └────────┬────────┘                        │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │   Services      │                        │
│                 │  (Business Logic)│                       │
│                 └────────┬────────┘                        │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │  Repositories   │                        │
│                 │   (Data Access) │                        │
│                 └────────┬────────┘                        │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │     JPA/Hibernate│                       │
│                 │  (ORM Framework) │                       │
│                 └────────┬────────┘                        │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │    MySQL 5.7    │                        │
│                 │   (Database)    │                        │
│                 └─────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

### 代码层次结构
```
com.example.simpleserver
├── SimpleServerApplication.java    # 应用启动类
├── config/                         # 配置类
│   ├── DatabaseConfig.java         # 数据库配置
│   └── WebConfig.java             # Web配置
├── controller/                     # 控制器层
│   └── TaskController.java         # 任务管理API
├── service/                        # 业务逻辑层
│   └── TaskService.java            # 任务业务逻辑
├── repository/                     # 数据访问层
│   └── TaskRepository.java         # 任务数据访问
├── model/                          # 实体模型层
│   ├── Task.java                   # 任务实体
│   └── SyncResponse.java           # 同步响应模型
└── exception/                      # 异常处理(预留)
```

### 核心组件说明

#### 1. 控制层 (Controller)
- **TaskController**: 提供RESTful API接口
- 处理HTTP请求和响应
- 参数验证和错误处理
- 路径前缀: `/api/tasks`

#### 2. 服务层 (Service)
- **TaskService**: 实现业务逻辑
- 数据同步处理
- 任务状态管理
- 事务控制

#### 3. 数据访问层 (Repository)
- **TaskRepository**: 数据持久化操作
- 基于Spring Data JPA
- 自定义查询方法
- 软删除支持

#### 4. 实体层 (Model)
- **Task**: 任务实体类
- 映射数据库表结构
- 包含软删除字段
- Lombok注解简化代码

## 部署架构

### 构建流程
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   开发环境      │    │   构建过程      │    │   部署包        │
│                 │    │                 │    │                 │
│  src/main/java  │───▶│  Maven Compile  │───▶│  deploy/        │
│  src/main/resources│  │  Maven Package  │    │  ├── conf/      │
│                 │    │                 │    │  ├── logs/      │
│                 │    │                 │    │  └── *.jar      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 部署目录结构
```
deploy/
├── conf/                           # 配置文件目录
│   └── application.properties      # 应用配置文件
├── logs/                           # 日志目录(运行时生成)
├── simpleServer-1.0.0.jar          # 主应用程序
├── start.sh                        # Linux启动脚本
└── start.bat                       # Windows启动脚本
```

### 运行时架构
```
┌─────────────────────────────────────────────────────────────┐
│                    运行时环境                               │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   JVM       │  │   应用程序   │  │   配置文件   │         │
│  │             │  │             │  │             │         │
│  │  Heap Memory│  │  simpleServer│  │ application.│         │
│  │  Metaspace  │  │    1.0.0     │  │ properties  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│         │                │                │                 │
│         └────────────────┼────────────────┘                 │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │   数据库连接池   │                        │
│                 │   (HikariCP)    │                        │
│                 └────────┬────────┘                        │
│                          │                                  │
│                 ┌────────▼────────┐                        │
│                 │   MySQL 5.7     │                        │
│                 │   Connection    │                        │
│                 └─────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

## 数据流说明

### API请求处理流程
1. **客户端发起请求** → REST Controller
2. **参数验证** → Controller层处理
3. **业务逻辑调用** → Service层执行
4. **数据持久化** → Repository层操作
5. **数据库交互** → JPA/Hibernate处理
6. **响应返回** → JSON序列化返回客户端

### 数据同步流程
```
Client ──发送任务数据──▶ TaskController.syncTasks()
                              │
                              ▼
                       TaskService.syncTasks()
                              │
                              ▼
                    ┌─────────────────┐
                    │  批量处理逻辑    │
                    │  - 新建任务      │
                    │  - 更新任务      │
                    │  - 错误处理      │
                    └────────┬────────┘
                              │
                              ▼
                       TaskRepository
                              │
                              ▼
                         MySQL Database
```

## 配置管理体系

### 多环境配置
```
配置优先级(从高到低):
1. 环境变量 (DB_URL, DB_USERNAME, DB_PASSWORD)
2. 外部配置文件 (deploy/conf/application.properties)
3. Jar包内默认配置 (src/main/resources/application.properties)
```

### 配置文件结构
```properties
# 核心配置
server.port=37210
spring.profiles.active=prod

# 数据库配置(环境变量优先)
spring.datasource.url=${DB_URL:jdbc:mysql://localhost:3306/simpleserver}
spring.datasource.username=${DB_USERNAME:root}
spring.datasource.password=${DB_PASSWORD:}

# JPA配置
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false

# 日志配置
logging.config=classpath:logback-spring.xml
logging.file.name=logs/simpleServer.log
```

## 安全架构

### 数据安全
- **密码安全**: 数据库密码通过环境变量传递，不在配置文件中硬编码
- **传输安全**: 生产环境建议启用SSL/TLS
- **访问控制**: API接口权限控制(预留)

### 部署安全
- **文件权限**: 部署目录权限最小化
- **进程隔离**: 应用运行在专用用户下
- **日志保护**: 敏感信息不记录到日志

## 监控与运维

### 健康检查机制
```
Health Check Endpoint: GET /actuator/health
Health Check Script: deploy/health-check.sh
Monitoring Points:
├── Application Status
├── Database Connection
├── Memory Usage
└── Disk Space
```

### 日志管理
```
日志级别: INFO (生产), DEBUG (开发)
日志文件: deploy/logs/simpleServer.log
日志轮转: 按日期分割，保留30天
```

### 性能指标
- **响应时间**: API平均响应时间 < 200ms
- **并发处理**: 支持100+并发请求
- **内存使用**: JVM堆内存使用率 < 80%
- **数据库连接**: 连接池使用率监控

## 扩展性设计

### 水平扩展
- **无状态设计**: Controller层无状态，支持负载均衡
- **数据库连接池**: 可配置连接池大小适应并发需求
- **缓存机制**: 预留Redis缓存集成点

### 垂直扩展
- **JVM调优**: 可调整堆内存大小
- **线程池配置**: 可配置Tomcat线程池
- **数据库优化**: 支持读写分离架构

## 故障处理机制

### 自动恢复
```
故障检测 ──▶ 健康检查 ──▶ 自动重启 ──▶ 告警通知
    │            │            │            │
    ▼            ▼            ▼            ▼
 应用停止    状态异常    重启应用    运维介入
```

### 错误处理
- **全局异常处理**: 统一错误响应格式
- **事务回滚**: 数据库操作失败自动回滚
- **熔断机制**: 数据库连接失败时的降级处理

## 版本演进规划

### 当前版本 (v1.0.0)
- ✅ 基础CRUD操作
- ✅ 任务同步功能
- ✅ 软删除机制
- ✅ 多环境配置
- ✅ 安全部署架构

### 未来规划
```
v1.1.0: 性能优化和监控增强
├── 添加Actuator监控端点
├── 实现缓存机制
└── 完善日志分析

v1.2.0: 安全增强
├── JWT认证授权
├── API限流控制
└── 审计日志记录

v2.0.0: 微服务架构
├── 服务拆分
├── 消息队列集成
└── 容器化部署
```

## 参考文档

- [README.md](../README.md) - 项目说明和快速开始
- [DEPLOY_CENTOS_HOME.md](../DEPLOY_CENTOS_HOME.md) - CentOS部署指南
- [DEPLOY_PACKAGE_HOME.md](../DEPLOY_PACKAGE_HOME.md) - 部署包说明
- [PROJECT_STRUCTURE.md](../PROJECT_STRUCTURE.md) - 项目结构详细说明