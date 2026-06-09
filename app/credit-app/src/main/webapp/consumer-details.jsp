<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consumer Details - Equifax Credit Services</title>
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
        
        .consumer-id-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .section {
            margin-bottom: 30px;
        }
        
        .section h2 {
            font-size: 20px;
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
            flex: 0 0 40%;
        }
        
        .detail-value {
            color: #333;
            font-weight: 600;
            font-size: 14px;
            text-align: right;
            flex: 1;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .info-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-card p {
            font-size: 20px;
            color: #333;
            font-weight: 600;
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
            font-size: 12px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👤 Consumer Details</h1>
            <p>Comprehensive consumer information</p>
        </div>
        
        <div class="content">
            <div class="consumer-id-badge">
                Consumer ID: <s:property value="consumer.id" default="1" />
            </div>
            
            <div class="info-grid">
                <div class="info-card">
                    <h3>Credit Score</h3>
                    <p><s:property value="consumer.creditScore" default="720" /></p>
                </div>
                <div class="info-card">
                    <h3>Account Status</h3>
                    <p><s:property value="consumer.accountStatus" default="Active" /></p>
                </div>
                <div class="info-card">
                    <h3>Risk Level</h3>
                    <p><s:property value="consumer.riskLevel" default="Low" /></p>
                </div>
            </div>
            
            <div class="section">
                <h2>Personal Information</h2>
                <div class="detail-row">
                    <span class="detail-label">Full Name</span>
                    <span class="detail-value"><s:property value="consumer.firstName" default="John" /> <s:property value="consumer.lastName" default="Doe" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Social Security Number</span>
                    <span class="detail-value"><s:property value="consumer.ssn" default="***-**-6789" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Date of Birth</span>
                    <span class="detail-value"><s:property value="consumer.dateOfBirth" default="01/15/1985" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email Address</span>
                    <span class="detail-value"><s:property value="consumer.email" default="john.doe@email.com" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone Number</span>
                    <span class="detail-value"><s:property value="consumer.phone" default="(555) 123-4567" /></span>
                </div>
            </div>
            
            <div class="section">
                <h2>Address Information</h2>
                <div class="detail-row">
                    <span class="detail-label">Current Address</span>
                    <span class="detail-value"><s:property value="consumer.address" default="123 Main St" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">City, State</span>
                    <span class="detail-value"><s:property value="consumer.city" default="Atlanta" />, <s:property value="consumer.state" default="GA" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">ZIP Code</span>
                    <span class="detail-value"><s:property value="consumer.zipCode" default="30303" /></span>
                </div>
            </div>
            
            <div class="section">
                <h2>Employment Information</h2>
                <div class="detail-row">
                    <span class="detail-label">Employer</span>
                    <span class="detail-value"><s:property value="consumer.employer" default="Tech Corp" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Annual Income</span>
                    <span class="detail-value">$<s:property value="consumer.annualIncome" default="75,000" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Employment Status</span>
                    <span class="detail-value"><s:property value="consumer.employmentStatus" default="Full-time" /></span>
                </div>
            </div>
            
            <div class="section">
                <h2>Credit Summary</h2>
                <div class="detail-row">
                    <span class="detail-label">Total Credit Limit</span>
                    <span class="detail-value">$<s:property value="consumer.totalCreditLimit" default="45,000" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Balance</span>
                    <span class="detail-value">$<s:property value="consumer.totalBalance" default="12,600" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Credit Utilization</span>
                    <span class="detail-value"><s:property value="consumer.creditUtilization" default="28%" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Payment History</span>
                    <span class="detail-value"><s:property value="consumer.paymentHistory" default="98%" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Open Accounts</span>
                    <span class="detail-value"><s:property value="consumer.openAccounts" default="8" /></span>
                </div>
            </div>
            
            <div class="warning-box">
                <p><strong>⚠️ Confidential Information:</strong> This consumer data is confidential and protected under federal law. Unauthorized disclosure or misuse may result in civil and criminal penalties. This is demonstration data only.</p>
            </div>
            
            <div class="actions">
                <a href="credit-check.jsp" class="btn">Run Credit Check</a>
                <a href="consumer-data.jsp" class="btn btn-secondary">Lookup Another Consumer</a>
                <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>