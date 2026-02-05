package com.example.simpleserver.controller;

import com.example.simpleserver.model.SyncResponse;
import com.example.simpleserver.model.Task;
import com.example.simpleserver.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin(origins = "*")
public class TaskController {

    private final TaskService taskService;

    @Autowired
    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    /**
     * 同步任务接口
     * POST /api/tasks/sync
     */
    @PostMapping("/sync")
    public ResponseEntity<?> syncTasks(@RequestBody List<Task> tasks) {
        try {
            System.out.println("收到同步请求，任务数量: " + (tasks != null ? tasks.size() : 0));
            
            if (tasks == null || tasks.isEmpty()) {
                System.out.println("任务列表为空");
                return ResponseEntity.badRequest()
                    .body(new SyncResponse(false, "任务列表不能为空", 0));
            }
            
            System.out.println("开始同步任务...");
            SyncResponse response = taskService.syncTasks(tasks);
            System.out.println("同步完成: " + response.getMessage());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("同步任务异常: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new SyncResponse(false, "同步失败：" + e.getMessage(), 0));
        }
    }

    /**
     * 获取所有任务接口
     * GET /api/tasks
     */
    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        try {
            List<Task> tasks = taskService.getAllTasks();
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * 根据ID获取单个任务
     * GET /api/tasks/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskById(@PathVariable Long id) {
        try {
            Task task = taskService.getTaskById(id);
            if (task != null) {
                return ResponseEntity.ok(task);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * 创建新任务
     * POST /api/tasks
     */
    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody Task task) {
        try {
            Task savedTask = taskService.saveTask(task);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedTask);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * 更新任务
     * PUT /api/tasks/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @RequestBody Task task) {
        try {
            Task existingTask = taskService.getTaskById(id);
            if (existingTask == null) {
                return ResponseEntity.notFound().build();
            }
            
            task.setId(id); // 确保ID一致
            Task updatedTask = taskService.saveTask(task);
            return ResponseEntity.ok(updatedTask);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * 删除任务
     * DELETE /api/tasks/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        try {
            Task existingTask = taskService.getTaskById(id);
            if (existingTask == null) {
                return ResponseEntity.notFound().build();
            }
            
            taskService.deleteTask(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * 恢复已删除的任务
     */
    @PutMapping("/{id}/restore")
    public ResponseEntity<?> restoreTask(@PathVariable Long id) {
        try {
            boolean restored = taskService.restoreTask(id);
            if (restored) {
                return ResponseEntity.ok().body("{\"message\": \"任务恢复成功\"}");
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("{\"error\": \"恢复任务失败: " + e.getMessage() + "\"}");
        }
    }
}