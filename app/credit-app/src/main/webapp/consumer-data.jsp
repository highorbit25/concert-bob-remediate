<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consumer Data Lookup - Equifax Credit Services</title>
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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .content {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .info-box {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 4px;
        }
        
        .info-box h3 {
            color: #333;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .info-box p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .info-box ul {
            margin-top: 10px;
            margin-left: 20px;
            color: #666;
            font-size: 14px;
        }
        
        .info-box li {
            margin-bottom: 5px;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .warning-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 4px;
        }
        
        .warning-box p {
            color: #856404;
            font-size: 13px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👤 Consumer Data Lookup</h1>
            <p>Access consumer credit information</p>
        </div>
        
        <div class="content">
            <div class="warning-box">
                <p><strong>⚠️ Authorized Access Only:</strong> This system is for authorized personnel only. Unauthorized access or misuse of consumer data is a violation of federal law and may result in criminal prosecution.</p>
            </div>
            
            <div class="info-box">
                <h3>📋 Available Information</h3>
                <p>Retrieve comprehensive consumer data including:</p>
                <ul>
                    <li>Personal identification information</li>
                    <li>Contact details and addresses</li>
                    <li>Employment history</li>
                    <li>Credit account summary</li>
                    <li>Public records and inquiries</li>
                </ul>
            </div>
            
            <form action="consumer-data.action" method="post">
                <div class="form-group">
                    <label for="consumerId">Consumer ID</label>
                    <input type="text" name="consumerId" id="consumerId" placeholder="Enter Consumer ID (1-147)" required />
                    <div class="help-text">Enter a numeric consumer ID from our database (1-147)</div>
                </div>
                
                <button type="submit" class="btn">Retrieve Consumer Data</button>
            </form>
            
            <a href="index.jsp" class="back-link">← Back to Home</a>
        </div>
    </div>
</body>
</html>