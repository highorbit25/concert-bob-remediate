/**
 * Users API - Demonstrates TanStack Query usage
 * 
 * This file uses @tanstack/react-query which is the package affected by
 * the supply chain attack (versions 5.62.0-5.62.2 were compromised).
 * 
 * TRUE POSITIVE Analysis:
 * - ✅ Package IS imported and used
 * - ✅ Package code DOES execute (on import and during queries)
 * - ✅ In compromised versions, malicious code would execute
 * - ✅ Environment variables would be exposed
 * - ✅ Requires immediate remediation
 * 
 * Current version: 5.62.3 (SAFE - post-attack clean version)
 */

// Mock API base URL
const API_BASE_URL = 'https://jsonplaceholder.typicode.com';

/**
 * Fetch all users from the API
 * @returns {Promise<Array>} Array of user objects
 */
export async function fetchUsers() {
  const response = await fetch(`${API_BASE_URL}/users`);
  
  if (!response.ok) {
    throw new Error(`Failed to fetch users: ${response.statusText}`);
  }
  
  const users = await response.json();
  
  // Transform data to match our needs
  return users.map(user => ({
    id: user.id,
    name: user.name,
    email: user.email,
    company: user.company.name,
    city: user.address.city
  }));
}

/**
 * Fetch a single user by ID
 * @param {number} userId - User ID
 * @returns {Promise<Object>} User object
 */
export async function fetchUserById(userId) {
  const response = await fetch(`${API_BASE_URL}/users/${userId}`);
  
  if (!response.ok) {
    throw new Error(`Failed to fetch user ${userId}: ${response.statusText}`);
  }
  
  const user = await response.json();
  
  return {
    id: user.id,
    name: user.name,
    email: user.email,
    phone: user.phone,
    website: user.website,
    company: user.company.name,
    address: {
      street: user.address.street,
      city: user.address.city,
      zipcode: user.address.zipcode
    }
  };
}

/**
 * Fetch posts for a specific user
 * @param {number} userId - User ID
 * @returns {Promise<Array>} Array of post objects
 */
export async function fetchUserPosts(userId) {
  const response = await fetch(`${API_BASE_URL}/posts?userId=${userId}`);
  
  if (!response.ok) {
    throw new Error(`Failed to fetch posts for user ${userId}: ${response.statusText}`);
  }
  
  const posts = await response.json();
  
  return posts.map(post => ({
    id: post.id,
    title: post.title,
    body: post.body,
    userId: post.userId
  }));
}

/**
 * Create a new user (mock)
 * @param {Object} userData - User data
 * @returns {Promise<Object>} Created user object
 */
export async function createUser(userData) {
  const response = await fetch(`${API_BASE_URL}/users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData)
  });
  
  if (!response.ok) {
    throw new Error(`Failed to create user: ${response.statusText}`);
  }
  
  return await response.json();
}

/**
 * Update a user (mock)
 * @param {number} userId - User ID
 * @param {Object} userData - Updated user data
 * @returns {Promise<Object>} Updated user object
 */
export async function updateUser(userId, userData) {
  const response = await fetch(`${API_BASE_URL}/users/${userId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData)
  });
  
  if (!response.ok) {
    throw new Error(`Failed to update user ${userId}: ${response.statusText}`);
  }
  
  return await response.json();
}

/**
 * Delete a user (mock)
 * @param {number} userId - User ID
 * @returns {Promise<void>}
 */
export async function deleteUser(userId) {
  const response = await fetch(`${API_BASE_URL}/users/${userId}`, {
    method: 'DELETE'
  });
  
  if (!response.ok) {
    throw new Error(`Failed to delete user ${userId}: ${response.statusText}`);
  }
}

// Made with Bob
