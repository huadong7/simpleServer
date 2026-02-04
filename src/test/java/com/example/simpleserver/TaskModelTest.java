package com.example.simpleserver.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TaskModelTest {
    
    @Test
    public void testTaskCreation() {
        Task task = new Task();
        task.setName("测试任务");
        task.setTimeInMillis(System.currentTimeMillis());
        task.setIsDone(false);
        task.setRemarks("这是一个测试任务");
        
        assertEquals("测试任务", task.getName());
        assertNotNull(task.getTimeInMillis());
        assertFalse(task.getIsDone());
        assertEquals("这是一个测试任务", task.getRemarks());
    }
    
    @Test
    public void testTaskIdSetter() {
        Task task = new Task();
        task.setId(1L);
        assertEquals(Long.valueOf(1L), task.getId());
    }
    
    @Test
    public void testSyncResponse() {
        SyncResponse response = new SyncResponse(true, "同步成功", 5);
        assertTrue(response.isSuccess());
        assertEquals("同步成功", response.getMessage());
        assertEquals(5, response.getCount());
    }
}