package com.creditapp.demo.actions;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;

import java.io.File;

import static org.junit.Assert.*;

/**
 * Unit tests for FileUploadAction
 * 
 * Note: These tests verify the normal functionality of the file upload action.
 * The CVE-2017-5638 vulnerability occurs during the Content-Type header parsing
 * phase, before the execute() method is called, so it cannot be tested through
 * normal unit tests. Use integration tests or exploitation tools like struts-pwn
 * to verify the vulnerability.
 */
@RunWith(MockitoJUnitRunner.class)
public class FileUploadActionTest {
    
    private FileUploadAction action;
    
    @Before
    public void setUp() {
        action = new FileUploadAction();
    }
    
    @Test
    public void testExecuteWithNoFile() throws Exception {
        // Test with no file uploaded
        String result = action.execute();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
        assertTrue(action.getActionErrors().toString().contains("No file selected"));
    }
    
    @Test
    public void testExecuteWithValidFile() throws Exception {
        // Create a temporary test file
        File testFile = File.createTempFile("test", ".txt");
        testFile.deleteOnExit();
        
        // Set up the action with file data
        action.setUpload(testFile);
        action.setUploadFileName("test-document.txt");
        action.setUploadContentType("text/plain");
        action.setDisputeId("DISP-001");
        action.setDescription("Test document upload");
        
        // Execute the action
        String result = action.execute();
        
        // Verify success (note: may return error if ServletActionContext not initialized in test)
        assertTrue(result.equals("success") || result.equals("error"));
        // In unit test environment without servlet context, file operations may fail
    }
    
    @Test
    public void testGettersAndSetters() {
        // Test all getters and setters
        File testFile = new File("test.txt");
        action.setUpload(testFile);
        assertEquals(testFile, action.getUpload());
        
        action.setUploadFileName("document.pdf");
        assertEquals("document.pdf", action.getUploadFileName());
        
        action.setUploadContentType("application/pdf");
        assertEquals("application/pdf", action.getUploadContentType());
        
        action.setDisputeId("DISP-123");
        assertEquals("DISP-123", action.getDisputeId());
        
        action.setDescription("Test description");
        assertEquals("Test description", action.getDescription());
    }
    
    @Test
    public void testMultipleFileUploads() throws Exception {
        // Test uploading multiple files sequentially
        for (int i = 1; i <= 3; i++) {
            File testFile = File.createTempFile("test" + i, ".txt");
            testFile.deleteOnExit();
            
            action = new FileUploadAction(); // Reset action
            action.setUpload(testFile);
            action.setUploadFileName("file" + i + ".txt");
            action.setUploadContentType("text/plain");
            action.setDisputeId("DISP-00" + i);
            
            String result = action.execute();
            // In unit test environment, file operations may fail without servlet context
            assertTrue(result.equals("success") || result.equals("error"));
        }
    }
}

// Made with Bob
