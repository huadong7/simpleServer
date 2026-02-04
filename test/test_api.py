import requests
import json

# 测试错误的请求格式（单个对象）
wrong_payload = {
    "id": 0,
    "name": "Buy groceries",
    "timeInMillis": 1678900000000,
    "isDone": False,
    "repeatMode": 0
}

# 测试正确的请求格式（数组）
correct_payload = [
    {
        "name": "Buy groceries",
        "timeInMillis": 1678900000000,
        "isDone": False,
        "repeatMode": 0
    }
]

url = "http://localhost:37210/api/tasks/sync"

print("=== 测试错误格式 ===")
try:
    response = requests.post(url, json=wrong_payload)
    print(f"状态码: {response.status_code}")
    print(f"响应: {response.text}")
except Exception as e:
    print(f"请求失败: {e}")

print("\n=== 测试正确格式 ===")
try:
    response = requests.post(url, json=correct_payload)
    print(f"状态码: {response.status_code}")
    print(f"响应: {response.text}")
except Exception as e:
    print(f"请求失败: {e}")