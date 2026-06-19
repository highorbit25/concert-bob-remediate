<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Credit Report - Equifax Credit Services</title>
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
        
        .score-section {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            margin-bottom: 30px;
            color: white;
        }
        
        .score-value {
            font-size: 72px;
            font-weight: bold;
            margin: 20px 0;
        }
        
        .score-label {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .score-range {
            font-size: 14px;
            margin-top: 10px;
            opacity: 0.8;
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
        }
        
        .detail-value {
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-good {
            background: #d4edda;
            color: #155724;
        }
        
        .status-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-danger {
            background: #f8d7da;
            color: #721c24;
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
        
        .disclaimer {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-top: 30px;
            border-radius: 4px;
        }
        
        .disclaimer p {
            font-size: 12px;
            color: #856404;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Credit Report</h1>
            <p>Generated on <s:property value="reportDate" default="June 9, 2026" /></p>
        </div>
        
        <div class="content">
            <div class="score-section">
                <div class="score-label">Your Credit Score</div>
                <div class="score-value"><s:property value="creditScore" default="720" /></div>
                <div class="score-range">Range: 300 - 850</div>
                <div class="score-range">
                    <s:if test="creditScore >= 740">
                        <span class="status-badge status-good">Excellent</span>
                    </s:if>
                    <s:elseif test="creditScore >= 670">
                        <span class="status-badge status-good">Good</span>
                    </s:elseif>
                    <s:elseif test="creditScore >= 580">
                        <span class="status-badge status-warning">Fair</span>
                    </s:elseif>
                    <s:else>
                        <span class="status-badge status-danger">Poor</span>
                    </s:else>
                </div>
            </div>
            
            <div class="info-grid">
                <div class="info-card">
                    <h3>Total Accounts</h3>
                    <p><s:property value="totalAccounts" default="12" /></p>
                </div>
                <div class="info-card">
                    <h3>Open Accounts</h3>
                    <p><s:property value="openAccounts" default="8" /></p>
                </div>
                <div class="info-card">
                    <h3>Credit Utilization</h3>
                    <p><s:property value="creditUtilization" default="28%" /></p>
                </div>
                <div class="info-card">
                    <h3>Payment History</h3>
                    <p><s:property value="paymentHistory" default="98%" /></p>
                </div>
            </div>
            
            <div class="section">
                <h2>Personal Information</h2>
                <div class="detail-row">
                    <span class="detail-label">Full Name</span>
                    <span class="detail-value"><s:property value="fullName" default="John Doe" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Social Security Number</span>
                    <span class="detail-value"><s:property value="ssn" default="***-**-6789" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Date of Birth</span>
                    <span class="detail-value"><s:property value="dateOfBirth" default="01/15/1985" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Current Address</span>
                    <span class="detail-value"><s:property value="address" default="123 Main St, Atlanta, GA 30303" /></span>
                </div>
            </div>
            
            <div class="section">
                <h2>Credit Summary</h2>
                <div class="detail-row">
                    <span class="detail-label">Total Credit Limit</span>
                    <span class="detail-value">$<s:property value="totalCreditLimit" default="45,000" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Balance</span>
                    <span class="detail-value">$<s:property value="totalBalance" default="12,600" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Available Credit</span>
                    <span class="detail-value">$<s:property value="availableCredit" default="32,400" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Oldest Account</span>
                    <span class="detail-value"><s:property value="oldestAccount" default="12 years" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Recent Inquiries</span>
                    <span class="detail-value"><s:property value="recentInquiries" default="2" /></span>
                </div>
            </div>
            
            <div class="section">
                <h2>Account Status</h2>
                <div class="detail-row">
                    <span class="detail-label">Accounts in Good Standing</span>
                    <span class="detail-value">
                        <s:property value="goodStandingAccounts" default="11" />
                        <span class="status-badge status-good">Good</span>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Late Payments (Last 12 months)</span>
                    <span class="detail-value">
                        <s:property value="latePayments" default="1" />
                        <s:if test="latePayments == 0">
                            <span class="status-badge status-good">None</span>
                        </s:if>
                        <s:elseif test="latePayments <= 2">
                            <span class="status-badge status-warning">Minor</span>
                        </s:elseif>
                        <s:else>
                            <span class="status-badge status-danger">Concern</span>
                        </s:else>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Collections</span>
                    <span class="detail-value">
                        <s:property value="collections" default="0" />
                        <span class="status-badge status-good">None</span>
                    </span>
                </div>
            </div>
            
            <div class="disclaimer">
                <p><strong>⚠️ Important Notice:</strong> This credit report is for demonstration purposes only and does not represent actual credit data. In a real scenario, this information would be pulled from Equifax, Experian, and TransUnion credit bureaus. Always protect your personal information and review your credit reports regularly for accuracy.</p>
            </div>
            
            <div class="actions">
                <a href="credit-check.jsp" class="btn">Run Another Check</a>
                <a href="dispute.jsp" class="btn btn-secondary">File a Dispute</a>
                <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>