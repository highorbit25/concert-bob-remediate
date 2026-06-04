import { useQuery } from '@tanstack/react-query';
import { fetchUsers } from '../api/users';
import './UserList.css';

/**
 * UserList Component - Demonstrates TanStack Query usage
 * 
 * This component uses @tanstack/react-query which was affected by the
 * supply chain attack in December 2024 (versions 5.62.0-5.62.2).
 * 
 * TRUE POSITIVE Analysis:
 * - ✅ Package IS imported: import { useQuery } from '@tanstack/react-query'
 * - ✅ Package IS actively used: useQuery hook called
 * - ✅ Package code DOES execute on component render
 * - ✅ In compromised versions, malicious code would execute
 * - ✅ Environment variables would be exposed to attacker
 * - ✅ Requires immediate remediation
 * 
 * Current version: 5.62.3 (SAFE - post-attack clean version)
 */

function UserList() {
  // Using TanStack Query to fetch users
  // This demonstrates active usage of the package
  const {
    data: users,
    isLoading,
    isError,
    error,
    refetch
  } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });

  if (isLoading) {
    return (
      <div className="user-list">
        <div className="loading">
          <div className="spinner"></div>
          <p>Loading users...</p>
        </div>
      </div>
    );
  }

  if (isError) {
    return (
      <div className="user-list">
        <div className="error">
          <h3>❌ Error loading users</h3>
          <p>{error.message}</p>
          <button onClick={() => refetch()} className="btn btn-primary">
            Try Again
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="user-list">
      <div className="user-list-header">
        <h3>👥 User Directory</h3>
        <button onClick={() => refetch()} className="btn btn-secondary">
          🔄 Refresh
        </button>
      </div>

      <div className="user-grid">
        {users && users.length > 0 ? (
          users.map((user) => (
            <div key={user.id} className="user-card">
              <div className="user-avatar">
                {user.name.charAt(0).toUpperCase()}
              </div>
              <div className="user-info">
                <h4 className="user-name">{user.name}</h4>
                <p className="user-email">{user.email}</p>
                <p className="user-company">🏢 {user.company}</p>
                <p className="user-city">📍 {user.city}</p>
              </div>
            </div>
          ))
        ) : (
          <p className="no-users">No users found</p>
        )}
      </div>

      <div className="user-list-footer">
        <p className="info-text">
          <strong>Note:</strong> This component uses TanStack Query for data fetching.
          The package was compromised in versions 5.62.0-5.62.2 but is now safe (5.62.3+).
        </p>
      </div>
    </div>
  );
}

export default UserList;

// Made with Bob
