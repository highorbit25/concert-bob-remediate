import os
import sqlite3
from flask import Flask, request, render_template_string, jsonify, session
import pickle
import subprocess

app = Flask(__name__)

# VULNERABILITY 1: Hardcoded secret key (Configuration Vulnerability)
app.secret_key = 'super-secret-key-12345'

# VULNERABILITY 2: Hardcoded database credentials (Configuration Vulnerability)
DB_USER = 'admin'
DB_PASSWORD = 'password123'
DB_HOST = 'localhost'

# Initialize database
def init_db():
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            role TEXT NOT NULL
        )
    ''')
    cursor.execute("INSERT OR IGNORE INTO users VALUES (1, 'admin', 'admin@example.com', 'admin')")
    cursor.execute("INSERT OR IGNORE INTO users VALUES (2, 'user', 'user@example.com', 'user')")
    conn.commit()
    conn.close()

@app.route('/')
def index():
    # VULNERABILITY 3: Using deprecated Flask attribute (Breaking change in Flask 2.0+)
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return 'This was an AJAX request'
    return '''
        <h1>Vulnerable Flask App</h1>
        <ul>
            <li><a href="/search?q=test">Search Users</a></li>
            <li><a href="/user/1">View User Profile</a></li>
            <li><a href="/greet?name=John">Greet User</a></li>
            <li><a href="/execute?cmd=ls">Execute Command</a></li>
            <li><a href="/load">Load Data</a></li>
        </ul>
    '''

@app.route('/search')
def search():
    # VULNERABILITY 4: SQL Injection (Code Vulnerability)
    query = request.args.get('q', '')
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # Vulnerable: Direct string concatenation in SQL query
    sql = f"SELECT * FROM users WHERE username LIKE '%{query}%'"
    cursor.execute(sql)
    results = cursor.fetchall()
    conn.close()
    
    return jsonify(results)

@app.route('/user/<user_id>')
def user_profile(user_id):
    # VULNERABILITY 5: SQL Injection via path parameter (Code Vulnerability)
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # Vulnerable: Direct string formatting in SQL query
    cursor.execute("SELECT * FROM users WHERE id = " + user_id)
    user = cursor.fetchone()
    conn.close()
    
    if user:
        return jsonify({
            'id': user[0],
            'username': user[1],
            'email': user[2],
            'role': user[3]
        })
    return jsonify({'error': 'User not found'}), 404

@app.route('/greet')
def greet():
    # VULNERABILITY 6: Cross-Site Scripting (XSS) (Code Vulnerability)
    name = request.args.get('name', 'Guest')
    
    # Vulnerable: Rendering user input without escaping
    template = f'''
        <html>
            <body>
                <h1>Hello, {name}!</h1>
                <p>Welcome to our vulnerable app.</p>
            </body>
        </html>
    '''
    return render_template_string(template)

@app.route('/execute')
def execute_command():
    # VULNERABILITY 7: Command Injection (Code Vulnerability)
    cmd = request.args.get('cmd', 'echo hello')
    
    # Vulnerable: Direct shell execution with user input
    result = subprocess.check_output(cmd, shell=True, text=True)
    return f'<pre>{result}</pre>'

@app.route('/file')
def read_file():
    # VULNERABILITY 8: Path Traversal (Code Vulnerability)
    filename = request.args.get('name', 'default.txt')
    
    # Vulnerable: No path validation
    filepath = os.path.join('/var/data/', filename)
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        return f'<pre>{content}</pre>'
    except Exception as e:
        return f'Error: {str(e)}'

@app.route('/load', methods=['POST'])
def load_data():
    # VULNERABILITY 9: Insecure Deserialization (Code Vulnerability)
    data = request.data
    
    # Vulnerable: Unpickling untrusted data
    try:
        obj = pickle.loads(data)
        return jsonify({'loaded': str(obj)})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/load', methods=['GET'])
def load_form():
    return '''
        <form method="POST" action="/load">
            <textarea name="data" placeholder="Pickled data"></textarea>
            <button type="submit">Load</button>
        </form>
    '''

@app.route('/api/data')
def api_data():
    # VULNERABILITY 10: Missing CORS restrictions (Configuration Vulnerability)
    # No CORS headers set, allowing any origin
    return jsonify({'sensitive': 'data', 'api_key': 'sk-1234567890'})

@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    
    # VULNERABILITY 11: Weak session management
    # Using default Flask session without secure settings
    session['user'] = username
    session['authenticated'] = True
    
    return jsonify({'status': 'logged in'})

@app.route('/admin')
def admin():
    # VULNERABILITY 12: Insufficient authorization check
    if session.get('authenticated'):
        # No role-based access control
        return jsonify({'admin_data': 'sensitive information'})
    return jsonify({'error': 'Not authenticated'}), 401

if __name__ == '__main__':
    init_db()
    # VULNERABILITY 13: Debug mode enabled in production (Configuration Vulnerability)
    # VULNERABILITY 14: Binding to all interfaces (0.0.0.0) (Configuration Vulnerability)
    app.run(host='0.0.0.0', port=5001, debug=True)

# Made with Bob
