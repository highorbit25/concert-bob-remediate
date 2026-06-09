<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Successful - Equifax Credit Services</title>
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
            max-width: 600px;
            margin: 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header .icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 16px;
            opacity: 0.95;
        }
        
        .content {
            padding: 40px;
        }
        
        .success-box {
            background: #d4edda;
            border-left: 4px solid #28a745;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 4px;
        }
        
        .success-box h2 {
            color: #155724;
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .success-box p {
            color: #155724;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .file-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .file-info h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: #666;
            font-size: 14px;
        }
        
        .detail-value {
            color: #333;
            font-weight: 600;
            font-size: 14px;
            text-align: right;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-right: 10px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
            text-align: center;
        }
        
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-top: 30px;
            border-radius: 4px;
        }
        
        .info-box p {
            color: #0d47a1;
            font-size: 13px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">✅</div>
            <h1>File Uploaded Successfully</h1>
            <p>Your document has been received</p>
        </div>
        
        <div class="content">
            <div class="success-box">
                <h2>Upload Complete</h2>
                <p>Your file has been successfully uploaded and will be processed by our team. You'll receive a confirmation email once the document has been reviewed.</p>
            </div>
            
            <div class="file-info">
                <h3>📄 File Details</h3>
                <div class="detail-row">
                    <span class="detail-label">File Name</span>
                    <span class="detail-value"><s:property value="fileName" default="document.pdf" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">File Size</span>
                    <span class="detail-value"><s:property value="fileSize" default="2.5 MB" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Upload Date</span>
                    <span class="detail-value"><s:property value="uploadDate" default="June 9, 2026" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Upload Time</span>
                    <span class="detail-value"><s:property value="uploadTime" default="4:28 PM" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status</span>
                    <span class="detail-value">Processing</span>
                </div>
            </div>
            
            <div class="info-box">
                <p><strong>ℹ️ What's Next:</strong> Our team will review your uploaded document within 1-2 business days. If we need any additional information, we'll contact you via email. Thank you for your patience.</p>
            </div>
            
            <div class="actions">
                <a href="file-upload.jsp" class="btn">Upload Another File</a>
                <a href="dispute.jsp" class="btn btn-secondary">File a Dispute</a>
                <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>