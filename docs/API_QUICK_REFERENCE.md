# SimpleServer API 快速参考

## 🚀 基础信息
- **API地址**: `http://localhost:37210/api/tasks`
- **数据格式**: JSON
- **字符编码**: UTF-8

## 📋 接口列表

### POST /sync - 批量同步任务
```bash
# 正确格式 - 数组形式
curl -X POST http://localhost:37210/api/tasks/sync \
  -H "Content-Type: application/json" \
  -d '[{"name":"任务名称","timeInMillis":1678900000000,"isDone":false}]'
```

### GET / - 获取所有任务
```bash
curl http://localhost:37210/api/tasks
```

### GET /{id} - 获取单个任务
```bash
curl http://localhost:37210/api/tasks/1
```

### POST / - 创建任务
```bash
curl -X POST http://localhost:37210/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"name":"新任务","timeInMillis":1678900000000}'
```

### PUT /{id} - 更新任务
```bash
curl -X PUT http://localhost:37210/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"更新的任务","isDone":true}'
```

### DELETE /{id} - 删除任务
```bash
curl -X DELETE http://localhost:37210/api/tasks/1
```

## ⚠️ 常见问题

### ❌ 错误示例
```json
// 错误：发送单个对象而不是数组
{
  "id": 0,
  "name": "Buy groceries",
  "timeInMillis": 1678900000000
}

// 正确：发送对象数组
[
  {
    "name": "Buy groceries",
    "timeInMillis": 1678900000000
  }
]
```

### 📝 必填字段
- `name`: 任务名称
- `timeInMillis`: 时间戳(毫秒)

### 🔄 重复模式
- `0`: 不重复
- `1`: 每日重复
- `2`: 每周重复  
- `3`: 每月重复

---
📄 完整文档请查看: [API接口文档](API_DOCUMENTATION.md)