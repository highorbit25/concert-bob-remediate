package com.creditapp.demo.actions;

import org.apache.struts2.ActionSupport;
import org.apache.struts2.ActionContext;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * VULNERABLE: File upload action susceptible to CVE-2017-5638
 * 
 * This action processes file uploads for dispute documentation.
 * The vulnerability exists in Apache Struts 2.3.31's Jakarta Multipart parser's
 * handling of Content-Type headers, allowing OGNL (Object-Graph Navigation Language) 
 * injection that leads to Remote Code Execution (RCE).
 * 
 * CVE-2017-5638 Details:
 * - CVSS Score: 10.0 (Critical)
 * - Attack Vector: Malicious Content-Type header in HTTP POST requests
 * - Impact: Complete system compromise, arbitrary code execution
 * - Exploited in: 2017 Equifax data breach (147 million records compromised)
 * 
 * The vulnerability is triggered BEFORE this execute() method runs, during
 * the multipart request parsing phase. Attackers can inject OGNL expressions
 * in the Content-Type header that are evaluated on the server.
 * 
 * Example malicious Content-Type header:
 * Content-Type: %{(#_='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS)...}
 * 
 * Remediation:
 * - Upgrade to Apache Struts 2.3.32, 2.5.10.1, or later
 * - Implement WAF rules to block OGNL patterns in headers
 * - Monitor for exploitation attempts in logs
 */
public class FileUploadAction extends ActionSupport {
    private static final long serialVersionUID = 1L;
    
    // File upload fields (Struts convention)
    private File upload;
    private String uploadContentType;
    private String uploadFileName;
    
    // Additional fields
    private String disputeId;
    private String description;
    
    /**
     * Execute method for file upload
     * 
     * NOTE: The vulnerability occurs BEFORE this method is called,
     * during the Content-Type header parsing phase.
     */
    @Override
    public String execute() {
        try {
            // Vulnerable: Struts 2.3.31 processes Content-Type header
            // before this code executes, allowing RCE via OGNL injection
            
            if (upload == null) {
                addActionError("No file selected for upload");
                return INPUT;
            }
            
            // Validate file (this code is never reached during exploit)
            if (uploadFileName == null || uploadFileName.trim().isEmpty()) {
                addActionError("Invalid file name");
                return INPUT;
            }
            
            // Create upload directory if it doesn't exist
            String uploadPath = ActionContext.getContext().getServletContext()
                .getRealPath("/") + "uploads/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save the uploaded file
            File destFile = new File(uploadDir, uploadFileName);
            copyFile(upload, destFile);
            
            // Success message
            addActionMessage("File uploaded successfully: " + uploadFileName);
            addActionMessage("Dispute ID: " + disputeId);
            
            return SUCCESS;
            
        } catch (Exception e) {
            addActionError("Upload failed: " + e.getMessage());
            return ERROR;
        }
    }
    
    /**
     * Copy uploaded file to destination
     */
    private void copyFile(File source, File dest) throws IOException {
        try (FileInputStream in = new FileInputStream(source);
             FileOutputStream out = new FileOutputStream(dest)) {
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        }
    }
    
    // Getters and Setters
    
    public File getUpload() {
        return upload;
    }
    
    public void setUpload(File upload) {
        this.upload = upload;
    }
    
    public String getUploadContentType() {
        return uploadContentType;
    }
    
    public void setUploadContentType(String uploadContentType) {
        this.uploadContentType = uploadContentType;
    }
    
    public String getUploadFileName() {
        return uploadFileName;
    }
    
    public void setUploadFileName(String uploadFileName) {
        this.uploadFileName = uploadFileName;
    }
    
    public String getDisputeId() {
        return disputeId;
    }
    
    public void setDisputeId(String disputeId) {
        this.disputeId = disputeId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
}

// Made with Bob
