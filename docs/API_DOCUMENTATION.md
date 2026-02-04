# SimpleServer API 接口文档

## 概述
SimpleServer 是一个基于Spring Boot的任务管理RESTful API服务，提供任务的增删改查和同步功能。

## 基础信息
- **API地址**: `http://localhost:37210`
- **基础路径**: `/api/tasks`
- **数据格式**: JSON
- **字符编码**: UTF-8

## 状态码说明
| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 204 | 删除成功 |
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 数据模型

### Task 任务对象
```json
{
  "id": 1,
  "name": "任务名称",
  "timeInMillis": 1640995200000,
  "isMonthly": false,
  "remindCount": 0,
  "isDone": false,
  "remarks": "备注信息",
  "imagePaths": "[\"path1\", \"path2\"]",
  "maxRetries": 3,
  "retryIntervalHours": 1,
  "repeatMode": 0,
  "createdAt": "2022-01-01 00:00:00",
  "updatedAt": "2022-01-01 00:00:00"
}
```

#### 字段说明
| 字段名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Long | 否 | 任务ID，创建时由系统生成 |
| name | String | 是 | 任务名称 |
| timeInMillis | Long | 是 | 任务时间戳(毫秒) |
| isMonthly | Boolean | 否 | 是否每月重复(已废弃) |
| remindCount | Integer | 否 | 提醒次数，默认0 |
| isDone | Boolean | 否 | 是否完成，默认false |
| remarks | String | 否 | 备注信息 |
| imagePaths | String | 否 | 图片路径数组(JSON格式) |
| maxRetries | Integer | 否 | 最大重试次数，默认3 |
| retryIntervalHours | Integer | 否 | 重试间隔小时数，默认1 |
| repeatMode | Integer | 否 | 重复模式: 0-不重复, 1-每日, 2-每周, 3-每月 |
| createdAt | String | 否 | 创建时间 |
| updatedAt | String | 否 | 更新时间 |

### SyncResponse 同步响应对象
```json
{
  "success": true,
  "message": "任务同步成功",
  "count": 5
}
```

#### 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| success | Boolean | 同步是否成功 |
| message | String | 响应消息 |
| count | Integer | 同步成功的任务数量 |

## API接口详情

### 1. 同步任务
**接口地址**: `POST /api/tasks/sync`

**功能说明**: 批量同步任务，支持创建和更新

**请求参数**:
```json
[
  {
    "id": 1,
    "name": "购买 groceries",
    "timeInMillis": 1678900000000,
    "isDone": false,
    "repeatMode": 0,
    "remarks": "记得买牛奶和面包"
  }
]
```

**注意事项**:
- 请求体必须是数组格式
- 如果包含id且数据库中存在该id，则更新任务
- 如果不包含id或id不存在，则创建新任务
- timeInMillis为必填字段

**成功响应**:
```json
{
  "success": true,
  "message": "任务同步成功",
  "count": 1
}
```

**错误响应**:
```json
{
  "success": false,
  "message": "任务列表不能为空",
  "count": 0
}
```

### 2. 获取所有任务
**接口地址**: `GET /api/tasks`

**功能说明**: 获取所有任务，按更新时间倒序排列

**请求参数**: 无

**成功响应**:
```json
[
  {
    "id": 1,
    "name": "购买 groceries",
    "timeInMillis": 1678900000000,
    "isDone": false,
    "repeatMode": 0,
    "createdAt": "2022-01-01 00:00:00",
    "updatedAt": "2022-01-01 00:00:00"
  }
]
```

### 3. 获取单个任务
**接口地址**: `GET /api/tasks/{id}`

**功能说明**: 根据ID获取特定任务

**请求参数**: 
- Path参数: `id` (Long) - 任务ID

**成功响应**:
```json
{
  "id": 1,
  "name": "购买 groceries",
  "timeInMillis": 1678900000000,
  "isDone": false,
  "repeatMode": 0,
  "createdAt": "2022-01-01 00:00:00",
  "updatedAt": "2022-01-01 00:00:00"
}
```

**错误响应**:
- 404 Not Found: 任务不存在

### 4. 创建任务
**接口地址**: `POST /api/tasks`

**功能说明**: 创建新任务

**请求参数**:
```json
{
  "name": "新任务",
  "timeInMillis": 1678900000000,
  "isDone": false,
  "repeatMode": 0,
  "remarks": "任务备注"
}
```

**成功响应**: HTTP 201 Created
```json
{
  "id": 2,
  "name": "新任务",
  "timeInMillis": 1678900000000,
  "isDone": false,
  "repeatMode": 0,
  "remarks": "任务备注",
  "createdAt": "2022-01-01 00:00:00",
  "updatedAt": "2022-01-01 00:00:00"
}
```

### 5. 更新任务
**接口地址**: `PUT /api/tasks/{id}`

**功能说明**: 更新指定ID的任务

**请求参数**: 
- Path参数: `id` (Long) - 任务ID
- Body参数: Task对象

**成功响应**:
```json
{
  "id": 1,
  "name": "更新后的任务名称",
  "timeInMillis": 1678900000000,
  "isDone": true,
  "repeatMode": 0,
  "updatedAt": "2022-01-01 00:00:00"
}
```

**错误响应**:
- 404 Not Found: 任务不存在

### 6. 删除任务
**接口地址**: `DELETE /api/tasks/{id}`

**功能说明**: 删除指定ID的任务

**请求参数**: 
- Path参数: `id` (Long) - 任务ID

**成功响应**: HTTP 204 No Content

**错误响应**:
- 404 Not Found: 任务不存在

## 使用示例

### Python 示例
```python
import requests
import json

# 基础URL
BASE_URL = "http://localhost:37210/api/tasks"

# 1. 同步任务
def sync_tasks(tasks):
    response = requests.post(f"{BASE_URL}/sync", json=tasks)
    return response.json()

# 2. 获取所有任务
def get_all_tasks():
    response = requests.get(BASE_URL)
    return response.json()

# 3. 创建任务
def create_task(task):
    response = requests.post(BASE_URL, json=task)
    return response.json()

# 使用示例
tasks_to_sync = [
    {
        "name": "购买 groceries",
        "timeInMillis": 1678900000000,
        "isDone": False,
        "repeatMode": 0
    }
]

result = sync_tasks(tasks_to_sync)
print(result)
```

### JavaScript 示例
```javascript
const BASE_URL = 'http://localhost:37210/api/tasks';

// 1. 同步任务
async function syncTasks(tasks) {
    const response = await fetch(`${BASE_URL}/sync`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(tasks)
    });
    return response.json();
}

// 2. 获取所有任务
async function getAllTasks() {
    const response = await fetch(BASE_URL);
    return response.json();
}

// 使用示例
const tasks = [
    {
        name: "购买 groceries",
        timeInMillis: 1678900000000,
        isDone: false,
        repeatMode: 0
    }
];

syncTasks(tasks).then(result => console.log(result));
```

### curl 示例
```bash
# 同步任务
curl -X POST http://localhost:37210/api/tasks/sync \
  -H "Content-Type: application/json" \
  -d '[{"name":"购买 groceries","timeInMillis":1678900000000,"isDone":false,"repeatMode":0}]'

# 获取所有任务
curl http://localhost:37210/api/tasks

# 创建任务
curl -X POST http://localhost:37210/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"name":"新任务","timeInMillis":1678900000000,"isDone":false}'
```

## 错误处理

### 常见错误及解决方案

1. **400 Bad Request**
   - 原因: 请求参数格式错误
   - 解决: 检查JSON格式和必填字段

2. **404 Not Found**
   - 原因: 请求的资源不存在
   - 解决: 检查任务ID是否正确

3. **500 Internal Server Error**
   - 原因: 服务器内部错误
   - 解决: 查看服务器日志，联系管理员

## 版本信息
- **API版本**: v1.0
- **文档版本**: 1.0
- **最后更新**: 2026-02-03