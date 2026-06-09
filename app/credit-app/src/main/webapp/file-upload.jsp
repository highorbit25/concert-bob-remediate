<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Upload - Credit App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .vulnerability-warning {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 8px;
            padding: 20px;
            margin: 20px;
        }
        
        .vulnerability-warning h3 {
            color: #856404;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        
        .vulnerability-warning p {
            color: #856404;
            line-height: 1.8;
            margin-bottom: 10px;
        }
        
        .vulnerability-warning code {
            background: #fff;
            padding: 2px 8px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            color: #dc3545;
        }
        
        .content {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input[type="text"],
        .form-group textarea,
        .form-group input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.3s;
        }
        
        .btn:hover {
            opacity: 0.9;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            margin-left: 10px;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .exploit-info {
            background: #f8d7da;
            border: 2px solid #dc3545;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }
        
        .exploit-info h4 {
            color: #721c24;
            margin-bottom: 15px;
        }
        
        .exploit-info pre {
            background: #fff;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-size: 0.85em;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚠️ File Upload (VULNERABLE)</h1>
            <p>CVE-2017-5638 Exploitation Point</p>
        </div>
        
        <div class="vulnerability-warning">
            <h3>🔴 Critical Vulnerability: CVE-2017-5638</h3>
            <p>
                This file upload endpoint is <strong>vulnerable to Remote Code Execution (RCE)</strong> 
                through malicious Content-Type headers. The vulnerability exists in Apache Struts 2.3.31's 
                Jakarta Multipart parser.
            </p>
            <p>
                <strong>Attack Vector:</strong> Inject OGNL expressions in the Content-Type header to execute 
                arbitrary commands on the server.
            </p>
            <p>
                <strong>CVSS Score:</strong> <code>10.0 (Critical)</code>
            </p>
        </div>
        
        <div class="content">
            <h2 style="margin-bottom: 20px;">Upload Dispute Documentation</h2>
            
            <s:form action="upload" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="disputeId">Dispute ID:</label>
                    <s:textfield name="disputeId" id="disputeId" placeholder="e.g., DISP-001" />
                </div>
                
                <div class="form-group">
                    <label for="description">Description:</label>
                    <s:textarea name="description" id="description" placeholder="Describe the document you're uploading..." />
                </div>
                
                <div class="form-group">
                    <label for="upload">Select File:</label>
                    <s:file name="upload" id="upload" accept=".pdf,.jpg,.jpeg,.png,.doc,.docx" />
                    <small style="color: #666; display: block; margin-top: 5px;">
                        Accepted formats: PDF, JPG, PNG, DOC, DOCX (Max 10MB)
                    </small>
                </div>
                
                <div style="margin-top: 30px;">
                    <s:submit value="Upload File" cssClass="btn" />
                    <a href="index.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </s:form>
            
            <div class="exploit-info">
                <h4>🔓 Exploitation Instructions</h4>
                <p style="color: #721c24; margin-bottom: 15px;">
                    To test this vulnerability, use the <strong>struts-pwn</strong> tool:
                </p>
                <pre>python struts-pwn.py --url http://localhost:8080/credit-app/upload.action --check</pre>
                <p style="color: #721c24; margin-top: 15px;">
                    Execute commands:
                </p>
                <pre>python struts-pwn.py --url http://localhost:8080/credit-app/upload.action -c "whoami"</pre>
            </div>
            
            <a href="index.jsp" class="back-link">← Back to Home</a>
        </div>
    </div>
</body>
</html>