<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dispute Submitted - Equifax Credit Services</title>
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
            max-width: 700px;
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
        
        .reference-box {
            background: #f8f9fa;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .reference-box h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .reference-number {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            font-family: 'Courier New', monospace;
            letter-spacing: 2px;
        }
        
        .info-section {
            margin-bottom: 30px;
        }
        
        .info-section h3 {
            font-size: 18px;
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
        
        .timeline {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .timeline h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .timeline-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            padding-left: 30px;
            position: relative;
        }
        
        .timeline-item:before {
            content: "●";
            position: absolute;
            left: 0;
            color: #667eea;
            font-size: 20px;
        }
        
        .timeline-item:last-child {
            margin-bottom: 0;
        }
        
        .timeline-content {
            flex: 1;
        }
        
        .timeline-title {
            font-weight: 600;
            color: #333;
            font-size: 14px;
            margin-bottom: 3px;
        }
        
        .timeline-desc {
            color: #666;
            font-size: 13px;
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
        
        .note {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-top: 30px;
            border-radius: 4px;
        }
        
        .note p {
            color: #856404;
            font-size: 13px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">✅</div>
            <h1>Dispute Successfully Submitted</h1>
            <p>We've received your dispute and will begin investigating</p>
        </div>
        
        <div class="content">
            <div class="success-box">
                <h2>Thank You for Contacting Us</h2>
                <p>Your dispute has been successfully submitted to our investigation team. We take all disputes seriously and will thoroughly review the information you provided.</p>
            </div>
            
            <div class="reference-box">
                <h3>Your Reference Number</h3>
                <div class="reference-number"><s:property value="disputeId" default="DSP-2026-001234" /></div>
                <p style="margin-top: 10px; color: #666; font-size: 13px;">Please save this number for your records</p>
            </div>
            
            <div class="info-section">
                <h3>Dispute Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Submitted Date</span>
                    <span class="detail-value"><s:property value="submittedDate" default="June 9, 2026" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Consumer Name</span>
                    <span class="detail-value"><s:property value="consumerName" default="John Doe" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Dispute Type</span>
                    <span class="detail-value"><s:property value="disputeType" default="Incorrect Account Balance" /></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status</span>
                    <span class="detail-value">Under Investigation</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Contact Email</span>
                    <span class="detail-value"><s:property value="contactEmail" default="john.doe@email.com" /></span>
                </div>
            </div>
            
            <div class="timeline">
                <h3>📅 What Happens Next</h3>
                <div class="timeline-item">
                    <div class="timeline-content">
                        <div class="timeline-title">Day 1-3: Initial Review</div>
                        <div class="timeline-desc">We'll review your dispute and verify your identity</div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-content">
                        <div class="timeline-title">Day 4-15: Investigation</div>
                        <div class="timeline-desc">We'll contact the creditor and investigate the disputed information</div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-content">
                        <div class="timeline-title">Day 16-30: Resolution</div>
                        <div class="timeline-desc">We'll send you the investigation results and updated credit report</div>
                    </div>
                </div>
            </div>
            
            <div class="note">
                <p><strong>📧 Email Confirmation:</strong> A confirmation email has been sent to <strong><s:property value="contactEmail" default="your email address" /></strong> with your dispute details and reference number. Please check your spam folder if you don't see it within a few minutes.</p>
            </div>
            
            <div class="note" style="margin-top: 15px;">
                <p><strong>⏱️ Investigation Timeline:</strong> Under the Fair Credit Reporting Act (FCRA), we have 30 days to investigate your dispute. You'll receive updates via email throughout the process.</p>
            </div>
            
            <div class="actions">
                <a href="dispute.jsp" class="btn">File Another Dispute</a>
                <a href="credit-check.jsp" class="btn btn-secondary">Run Credit Check</a>
                <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>