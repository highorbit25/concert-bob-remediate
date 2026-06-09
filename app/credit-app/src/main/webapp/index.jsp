<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Credit App - CVE-2017-5638 Demo</title>
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
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .warning {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 20px;
            border-radius: 5px;
        }
        
        .warning h3 {
            color: #856404;
            margin-bottom: 10px;
        }
        
        .warning p {
            color: #856404;
            line-height: 1.6;
        }
        
        .content {
            padding: 30px;
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .feature-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 2px solid #e9ecef;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .feature-card.vulnerable {
            border-color: #dc3545;
            background: #fff5f5;
        }
        
        .feature-card h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        
        .feature-card p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: opacity 0.3s;
            font-weight: 600;
        }
        
        .btn:hover {
            opacity: 0.9;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }
        
        .vulnerability-badge {
            display: inline-block;
            background: #dc3545;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🏦 Credit Reporting Application</h1>
            <p>CVE-2017-5638 Demonstration</p>
        </div>
        
        <div class="warning">
            <h3>⚠️ Security Warning - Demonstration Only</h3>
            <p>
                This application is <strong>intentionally vulnerable</strong> to CVE-2017-5638, 
                a critical Remote Code Execution vulnerability in Apache Struts 2.3.31. 
                This is the same vulnerability exploited in the 2017 Equifax data breach that 
                affected 147 million consumers.
            </p>
            <p style="margin-top: 10px;">
                <strong>DO NOT deploy this application in production!</strong> 
                This is for educational and demonstration purposes only.
            </p>
        </div>
        
        <div class="content">
            <h2 style="margin-bottom: 20px;">Application Features</h2>
            
            <div class="features">
                <div class="feature-card">
                    <h3>📊 Credit Check</h3>
                    <p>Request and view credit reports with scores, payment history, and account details.</p>
                    <a href="credit-check.jsp" class="btn">Check Credit</a>
                </div>
                
                <div class="feature-card">
                    <h3>👤 Consumer Data</h3>
                    <p>View and manage consumer information including personal and financial data.</p>
                    <a href="consumer-data.jsp" class="btn">View Data</a>
                </div>
                
                <div class="feature-card">
                    <h3>📝 Dispute Management</h3>
                    <p>File and track credit report disputes with supporting documentation.</p>
                    <a href="dispute.jsp" class="btn">File Dispute</a>
                </div>
                
                <div class="feature-card vulnerable">
                    <span class="vulnerability-badge">VULNERABLE</span>
                    <h3>📎 File Upload</h3>
                    <p>Upload dispute documentation. <strong>Vulnerable to CVE-2017-5638 RCE</strong></p>
                    <a href="file-upload.jsp" class="btn btn-danger">Upload File</a>
                </div>
            </div>
            
            <div style="margin-top: 40px; padding: 20px; background: #e7f3ff; border-radius: 8px; border-left: 4px solid #0066cc;">
                <h3 style="color: #0066cc; margin-bottom: 15px;">🔍 About CVE-2017-5638</h3>
                <ul style="color: #333; line-height: 2; margin-left: 20px;">
                    <li><strong>CVSS Score:</strong> 10.0 (Critical)</li>
                    <li><strong>Vulnerability Type:</strong> Remote Code Execution (RCE)</li>
                    <li><strong>Attack Vector:</strong> Malicious Content-Type header in HTTP requests</li>
                    <li><strong>Affected Versions:</strong> Apache Struts 2.3.5 - 2.3.31, 2.5 - 2.5.10</li>
                    <li><strong>Fixed Versions:</strong> 2.3.32, 2.5.10.1+</li>
                    <li><strong>Real-World Impact:</strong> 2017 Equifax breach (147M records)</li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>Credit App Demo | Apache Struts 2.3.31 (Vulnerable) | For Educational Purposes Only</p>
            <p style="margin-top: 10px; font-size: 0.9em;">
                Test exploitation with: <code>struts-pwn</code> tool
            </p>
        </div>
    </div>
</body>
</html>