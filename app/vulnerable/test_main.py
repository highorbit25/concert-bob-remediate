import unittest
import os
import sqlite3
from main import app, init_db

class VulnerableAppTestCase(unittest.TestCase):
    """Test suite for the vulnerable Flask application"""
    
    @classmethod
    def setUpClass(cls):
        """Set up test database once for all tests"""
        # Use test database
        if os.path.exists('users.db'):
            os.remove('users.db')
        init_db()
    
    def setUp(self):
        """Set up test client before each test"""
        self.app = app
        self.app.config['TESTING'] = True
        self.client = self.app.test_client()
    
    def tearDown(self):
        """Clean up after each test"""
        pass
    
    @classmethod
    def tearDownClass(cls):
        """Clean up test database after all tests"""
        if os.path.exists('users.db'):
            os.remove('users.db')
    
    # Test 1: Index page loads correctly
    def test_index_page(self):
        """Test that the index page loads successfully"""
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Vulnerable Flask App', response.data)
    
    # Test 2: AJAX detection
    def test_ajax_detection(self):
        """Test AJAX request detection"""
        response = self.client.get('/', headers={'X-Requested-With': 'XMLHttpRequest'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'AJAX request', response.data)
    
    # Test 3: Search functionality works
    def test_search_users(self):
        """Test user search functionality"""
        response = self.client.get('/search?q=admin')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIsInstance(data, list)
        self.assertTrue(len(data) > 0)
    
    # Test 4: Search with empty query
    def test_search_empty_query(self):
        """Test search with empty query returns all users"""
        response = self.client.get('/search?q=')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIsInstance(data, list)
    
    # Test 5: User profile retrieval
    def test_user_profile_valid(self):
        """Test retrieving a valid user profile"""
        response = self.client.get('/user/1')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIn('username', data)
        self.assertEqual(data['username'], 'admin')
    
    # Test 6: User profile with invalid ID
    def test_user_profile_invalid(self):
        """Test retrieving a non-existent user profile"""
        response = self.client.get('/user/999')
        self.assertEqual(response.status_code, 404)
        data = response.get_json()
        self.assertIn('error', data)
    
    # Test 7: Greet endpoint with name
    def test_greet_with_name(self):
        """Test greeting endpoint with a name parameter"""
        response = self.client.get('/greet?name=John')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Hello, John!', response.data)
    
    # Test 8: Greet endpoint without name
    def test_greet_without_name(self):
        """Test greeting endpoint without name parameter"""
        response = self.client.get('/greet')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Hello, Guest!', response.data)
    
    # Test 9: Command execution endpoint
    def test_execute_command(self):
        """Test command execution endpoint"""
        response = self.client.get('/execute?cmd=echo test')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'test', response.data)
    
    # Test 10: File reading endpoint
    def test_read_file_not_found(self):
        """Test file reading with non-existent file"""
        response = self.client.get('/file?name=nonexistent.txt')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Error', response.data)
    
    # Test 11: Load data form (GET)
    def test_load_form(self):
        """Test that the load data form is displayed"""
        response = self.client.get('/load')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<form', response.data)
    
    # Test 12: API data endpoint
    def test_api_data(self):
        """Test API data endpoint returns JSON"""
        response = self.client.get('/api/data')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIn('sensitive', data)
        self.assertIn('api_key', data)
    
    # Test 13: Login functionality
    def test_login(self):
        """Test login endpoint"""
        response = self.client.post('/login', data={
            'username': 'testuser',
            'password': 'testpass'
        })
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertEqual(data['status'], 'logged in')
    
    # Test 14: Admin access without authentication
    def test_admin_without_auth(self):
        """Test admin endpoint without authentication"""
        response = self.client.get('/admin')
        self.assertEqual(response.status_code, 401)
        data = response.get_json()
        self.assertIn('error', data)
    
    # Test 15: Admin access with authentication
    def test_admin_with_auth(self):
        """Test admin endpoint with authentication"""
        with self.client.session_transaction() as sess:
            sess['authenticated'] = True
            sess['user'] = 'testuser'
        
        response = self.client.get('/admin')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIn('admin_data', data)
    
    # Test 16: Database initialization
    def test_database_initialized(self):
        """Test that database is properly initialized with default users"""
        conn = sqlite3.connect('users.db')
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM users")
        count = cursor.fetchone()[0]
        conn.close()
        self.assertGreaterEqual(count, 2)
    
    # Test 17: Search with special characters
    def test_search_special_characters(self):
        """Test search with special characters"""
        response = self.client.get('/search?q=test%20user')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertIsInstance(data, list)
    
    # Test 18: Multiple concurrent requests
    def test_concurrent_requests(self):
        """Test that multiple requests can be handled"""
        responses = []
        for i in range(5):
            response = self.client.get('/search?q=admin')
            responses.append(response)
        
        for response in responses:
            self.assertEqual(response.status_code, 200)
    
    # Test 19: Session persistence
    def test_session_persistence(self):
        """Test that session data persists across requests"""
        with self.client as c:
            c.post('/login', data={'username': 'testuser', 'password': 'testpass'})
            response = c.get('/admin')
            self.assertEqual(response.status_code, 200)
    
    # Test 20: Content type headers
    def test_content_type_json(self):
        """Test that JSON endpoints return correct content type"""
        response = self.client.get('/api/data')
        self.assertEqual(response.content_type, 'application/json')

class DatabaseTestCase(unittest.TestCase):
    """Test suite for database operations"""
    
    def setUp(self):
        """Set up test database before each test"""
        if os.path.exists('test_users.db'):
            os.remove('test_users.db')
    
    def tearDown(self):
        """Clean up test database after each test"""
        if os.path.exists('test_users.db'):
            os.remove('test_users.db')
    
    def test_database_creation(self):
        """Test that database is created successfully"""
        conn = sqlite3.connect('test_users.db')
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE users (
                id INTEGER PRIMARY KEY,
                username TEXT NOT NULL,
                email TEXT NOT NULL,
                role TEXT NOT NULL
            )
        ''')
        conn.commit()
        
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
        result = cursor.fetchone()
        conn.close()
        
        self.assertIsNotNone(result)
        self.assertEqual(result[0], 'users')
    
    def test_user_insertion(self):
        """Test that users can be inserted into database"""
        conn = sqlite3.connect('test_users.db')
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE users (
                id INTEGER PRIMARY KEY,
                username TEXT NOT NULL,
                email TEXT NOT NULL,
                role TEXT NOT NULL
            )
        ''')
        cursor.execute("INSERT INTO users VALUES (1, 'testuser', 'test@example.com', 'user')")
        conn.commit()
        
        cursor.execute("SELECT * FROM users WHERE id = 1")
        user = cursor.fetchone()
        conn.close()
        
        self.assertIsNotNone(user)
        self.assertEqual(user[1], 'testuser')

if __name__ == '__main__':
    unittest.main()

# Made with Bob
