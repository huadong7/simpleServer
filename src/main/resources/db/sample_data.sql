-- 插入测试数据
USE simpleserver;

-- 清空现有数据（可选）
-- TRUNCATE TABLE tasks;

-- 插入测试任务数据
INSERT INTO tasks (name, timeInMillis, isMonthly, remindCount, isDone, remarks, imagePaths, maxRetries, retryIntervalHours, repeatMode, created_at, updated_at) VALUES
('购买 groceries', 1707033600000, FALSE, 2, FALSE, '记得买牛奶和面包', '["/images/grocery1.jpg", "/images/grocery2.jpg"]', 3, 1, 0, NOW(), NOW()),
('完成项目报告', 1707120000000, FALSE, 1, FALSE, '季度总结报告', '["/documents/report.docx"]', 2, 2, 0, NOW(), NOW()),
('健身锻炼', 1707206400000, FALSE, 0, TRUE, '今天的训练已完成', '[]', 3, 1, 1, NOW(), NOW()),
('约会晚餐', 1707292800000, FALSE, 3, FALSE, '和朋友在意大利餐厅见面', '["/images/restaurant.jpg"]', 3, 1, 0, NOW(), NOW()),
('学习新技术', 1707379200000, FALSE, 1, FALSE, '研究Spring Boot微服务架构', '["/docs/spring-boot.pdf", "/code/examples.zip"]', 5, 1, 2, NOW(), NOW()),
('月度账单支付', 1707465600000, TRUE, 0, FALSE, '水电费和网费', '[]', 1, 24, 3, NOW(), NOW()),
('家庭聚会准备', 1707552000000, FALSE, 2, FALSE, '准备食材和装饰', '["/images/party-supplies.jpg"]', 3, 1, 0, NOW(), NOW()),
('车辆保养', 1707638400000, FALSE, 1, FALSE, '更换机油和检查轮胎', '["/images/car-service.jpg"]', 2, 3, 0, NOW(), NOW());

-- 验证数据插入
SELECT COUNT(*) as total_tasks FROM tasks;
SELECT * FROM tasks ORDER BY updated_at DESC LIMIT 5;