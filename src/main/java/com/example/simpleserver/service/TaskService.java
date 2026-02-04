package com.example.simpleserver.service;

import com.example.simpleserver.model.Task;
import com.example.simpleserver.repository.TaskRepository;
import com.example.simpleserver.model.SyncResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    @Autowired
    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    @Transactional
    public SyncResponse syncTasks(List<Task> clientTasks) {
        List<Task> savedTasks = new ArrayList<>();
        int successCount = 0;
        
        for (Task task : clientTasks) {
            try {
                Task existingTask = null;
                if (task.getId() != null && task.getId() > 0) {
                    existingTask = taskRepository.findById(task.getId()).orElse(null);
                }
                
                if (existingTask == null) {
                    // 新建任务
                    task.setId(null); // 让数据库生成新ID
                    task.setCreatedAt(new Date());
                    task.setUpdatedAt(new Date());
                    savedTasks.add(taskRepository.save(task));
                    successCount++;
                } else {
                    // 更新任务
                    existingTask.setName(task.getName());
                    existingTask.setTimeInMillis(task.getTimeInMillis());
                    existingTask.setIsMonthly(task.getIsMonthly());
                    existingTask.setRemindCount(task.getRemindCount());
                    existingTask.setIsDone(task.getIsDone());
                    existingTask.setRemarks(task.getRemarks());
                    existingTask.setImagePaths(task.getImagePaths());
                    existingTask.setMaxRetries(task.getMaxRetries());
                    existingTask.setRetryIntervalHours(task.getRetryIntervalHours());
                    existingTask.setRepeatMode(task.getRepeatMode());
                    existingTask.setUpdatedAt(new Date());
                    
                    savedTasks.add(taskRepository.save(existingTask));
                    successCount++;
                }
            } catch (Exception e) {
                // 记录单个任务同步失败，但继续处理其他任务
                System.err.println("同步任务失败: " + task.getName() + ", 错误: " + e.getMessage());
            }
        }
        
        String message = successCount == clientTasks.size() ? 
            "任务同步成功" : 
            String.format("部分任务同步成功 (%d/%d)", successCount, clientTasks.size());
            
        return new SyncResponse(true, message, successCount);
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAllByOrderByUpdatedAtDesc();
    }
    
    public Task getTaskById(Long id) {
        return taskRepository.findById(id).orElse(null);
    }
    
    public Task saveTask(Task task) {
        if (task.getId() == null) {
            task.setCreatedAt(new Date());
        }
        task.setUpdatedAt(new Date());
        return taskRepository.save(task);
    }
    
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }
}