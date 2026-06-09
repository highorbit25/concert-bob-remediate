<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File a Dispute - Equifax Credit Services</title>
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
        
        input[type="text"],
        select,
        textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        select {
            cursor: pointer;
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
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 4px;
        }
        
        .info-box h3 {
            color: #1565c0;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .info-box p {
            color: #0d47a1;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .info-box ul {
            margin-top: 10px;
            margin-left: 20px;
            color: #0d47a1;
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
        
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📝 File a Dispute</h1>
            <p>Challenge inaccurate information on your credit report</p>
        </div>
        
        <div class="content">
            <div class="info-box">
                <h3>ℹ️ Your Rights Under FCRA</h3>
                <p>Under the Fair Credit Reporting Act (FCRA), you have the right to dispute inaccurate or incomplete information on your credit report. Common reasons for disputes include:</p>
                <ul>
                    <li>Incorrect personal information</li>
                    <li>Accounts that don't belong to you</li>
                    <li>Incorrect account status or balance</li>
                    <li>Duplicate accounts</li>
                    <li>Outdated negative information</li>
                </ul>
            </div>
            
            <s:form action="dispute" method="post">
                <div class="form-group">
                    <label for="consumerName">Full Name <span class="required">*</span></label>
                    <s:textfield 
                        name="consumerName" 
                        id="consumerName" 
                        placeholder="Enter your full legal name"
                        required="true"
                    />
                </div>
                
                <div class="form-group">
                    <label for="ssn">Social Security Number <span class="required">*</span></label>
                    <s:textfield 
                        name="ssn" 
                        id="ssn" 
                        placeholder="XXX-XX-XXXX"
                        maxlength="11"
                        required="true"
                    />
                    <div class="help-text">Required for identity verification</div>
                </div>
                
                <div class="form-group">
                    <label for="disputeType">Type of Dispute <span class="required">*</span></label>
                    <s:select 
                        name="disputeType" 
                        id="disputeType"
                        list="#{
                            'personal_info':'Incorrect Personal Information',
                            'account_not_mine':'Account Does Not Belong to Me',
                            'incorrect_balance':'Incorrect Account Balance',
                            'incorrect_status':'Incorrect Account Status',
                            'duplicate':'Duplicate Account',
                            'outdated':'Outdated Negative Information',
                            'other':'Other'
                        }"
                        required="true"
                    />
                </div>
                
                <div class="form-group">
                    <label for="accountNumber">Account Number (if applicable)</label>
                    <s:textfield 
                        name="accountNumber" 
                        id="accountNumber" 
                        placeholder="Enter the account number in question"
                    />
                    <div class="help-text">Leave blank if disputing personal information</div>
                </div>
                
                <div class="form-group">
                    <label for="description">Detailed Description <span class="required">*</span></label>
                    <s:textarea 
                        name="description" 
                        id="description" 
                        placeholder="Please provide a detailed explanation of the inaccuracy and why you believe it is incorrect. Include any relevant dates, amounts, or other details."
                        required="true"
                    />
                    <div class="help-text">Be as specific as possible to help us investigate your dispute</div>
                </div>
                
                <div class="form-group">
                    <label for="contactEmail">Email Address <span class="required">*</span></label>
                    <s:textfield 
                        name="contactEmail" 
                        id="contactEmail" 
                        placeholder="your.email@example.com"
                        required="true"
                    />
                    <div class="help-text">We'll send updates about your dispute to this email</div>
                </div>
                
                <s:submit value="Submit Dispute" cssClass="btn" />
            </s:form>
            
            <a href="index.jsp" class="back-link">← Back to Home</a>
        </div>
    </div>
</body>
</html>