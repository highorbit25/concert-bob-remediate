<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Equifax Credit Services</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
        
        .error-box {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 4px;
        }
        
        .error-box h2 {
            color: #721c24;
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .error-box p {
            color: #721c24;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .error-details h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .error-details p {
            color: #333;
            font-size: 14px;
            line-height: 1.6;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }
        
        .help-section {
            margin-bottom: 30px;
        }
        
        .help-section h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .help-section ul {
            list-style: none;
            padding: 0;
        }
        
        .help-section li {
            padding: 10px 0;
            padding-left: 30px;
            position: relative;
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .help-section li:before {
            content: "→";
            position: absolute;
            left: 0;
            color: #667eea;
            font-weight: bold;
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
            margin-bottom: 10px;
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
        
        .contact-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-top: 30px;
            border-radius: 4px;
        }
        
        .contact-box p {
            color: #0d47a1;
            font-size: 13px;
            line-height: 1.6;
        }
        
        .contact-box a {
            color: #0d47a1;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">⚠️</div>
            <h1>Oops! Something Went Wrong</h1>
            <p>We encountered an error processing your request</p>
        </div>
        
        <div class="content">
            <div class="error-box">
                <h2>Error Occurred</h2>
                <p>We're sorry, but we encountered an unexpected error while processing your request. Our team has been notified and is working to resolve the issue.</p>
            </div>
            
            <s:if test="hasActionErrors()">
                <div class="error-details">
                    <h3>Error Details</h3>
                    <s:iterator value="actionErrors">
                        <p><s:property /></p>
                    </s:iterator>
                </div>
            </s:if>
            
            <s:if test="exception != null">
                <div class="error-details">
                    <h3>Technical Details</h3>
                    <p><s:property value="exception.message" default="An unexpected error occurred" /></p>
                </div>
            </s:if>
            
            <div class="help-section">
                <h3>What You Can Do</h3>
                <ul>
                    <li>Try refreshing the page and submitting your request again</li>
                    <li>Check that all required fields are filled out correctly</li>
                    <li>Clear your browser cache and cookies, then try again</li>
                    <li>If the problem persists, please contact our support team</li>
                </ul>
            </div>
            
            <div class="contact-box">
                <p><strong>📞 Need Help?</strong><br>
                If you continue to experience issues, please contact our support team:<br>
                Phone: <a href="tel:1-800-685-1111">1-800-685-1111</a><br>
                Email: <a href="mailto:support@equifax-demo.com">support@equifax-demo.com</a><br>
                Hours: Monday-Friday, 8:00 AM - 8:00 PM ET</p>
            </div>
            
            <div class="actions">
                <a href="javascript:history.back()" class="btn">Go Back</a>
                <a href="index.jsp" class="btn btn-secondary">Return to Home</a>
                <a href="credit-check.jsp" class="btn btn-secondary">Try Credit Check</a>
            </div>
        </div>
    </div>
</body>
</html>