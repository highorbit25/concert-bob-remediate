import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import UserList from '../components/UserList';
import * as usersApi from '../api/users';

/**
 * UserList Component Tests
 *
 * Tests the TRUE POSITIVE scenario component that uses @tanstack/react-query
 * which was affected by the supply chain attack (versions 5.62.0-5.62.2).
 *
 * These tests verify:
 * - Component renders correctly with TanStack Query
 * - Loading states are displayed
 * - Error handling works properly
 * - Data fetching and display functions correctly
 * - Refetch functionality works
 *
 * IMPORTANT: package.json references vulnerable version 5.62.1 (withdrawn from npm)
 * - Cannot be installed via npm (versions 5.62.0-5.62.2 are withdrawn)
 * - Tests will only run AFTER Bob creates PR with safe version (5.62.3+)
 * - This demonstrates the workflow: detect vulnerable version → Bob remediates → tests pass
 * - The GitHub Actions workflow ensures npm install only runs after remediation PR
 */

// Mock the users API
vi.mock('../api/users');

// Helper function to create a fresh QueryClient for each test
function createTestQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: {
        retry: false, // Disable retries for tests
        cacheTime: 0, // Disable caching for tests
      },
    },
  });
}

// Helper function to render component with QueryClient
function renderWithQueryClient(component) {
  const queryClient = createTestQueryClient();
  return render(
    <QueryClientProvider client={queryClient}>
      {component}
    </QueryClientProvider>
  );
}

// Mock user data
const mockUsers = [
  {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    company: 'Acme Corp',
    city: 'New York'
  },
  {
    id: 2,
    name: 'Jane Smith',
    email: 'jane@example.com',
    company: 'Tech Inc',
    city: 'San Francisco'
  },
  {
    id: 3,
    name: 'Bob Johnson',
    email: 'bob@example.com',
    company: 'Dev Co',
    city: 'London'
  }
];

describe('UserList Component', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('Loading State', () => {
    it('should display loading spinner while fetching users', () => {
      // Mock API to return a promise that never resolves (simulates loading)
      usersApi.fetchUsers.mockImplementation(() => new Promise(() => {}));

      renderWithQueryClient(<UserList />);

      // Check for loading indicators
      expect(screen.getByText('Loading users...')).toBeInTheDocument();
      expect(screen.getByRole('status', { hidden: true })).toBeInTheDocument(); // spinner div
    });

    it('should have correct loading state structure', () => {
      usersApi.fetchUsers.mockImplementation(() => new Promise(() => {}));

      const { container } = renderWithQueryClient(<UserList />);

      // Check for loading container structure
      const loadingDiv = container.querySelector('.loading');
      expect(loadingDiv).toBeInTheDocument();
      expect(loadingDiv.querySelector('.spinner')).toBeInTheDocument();
    });
  });

  describe('Success State', () => {
    it('should display users when data is successfully fetched', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      // Wait for users to be displayed
      await waitFor(() => {
        expect(screen.getByText('John Doe')).toBeInTheDocument();
      });

      // Verify all users are displayed
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.getByText('john@example.com')).toBeInTheDocument();
      expect(screen.getByText('🏢 Acme Corp')).toBeInTheDocument();
      expect(screen.getByText('📍 New York')).toBeInTheDocument();

      expect(screen.getByText('Jane Smith')).toBeInTheDocument();
      expect(screen.getByText('jane@example.com')).toBeInTheDocument();
      expect(screen.getByText('🏢 Tech Inc')).toBeInTheDocument();
      expect(screen.getByText('📍 San Francisco')).toBeInTheDocument();

      expect(screen.getByText('Bob Johnson')).toBeInTheDocument();
      expect(screen.getByText('bob@example.com')).toBeInTheDocument();
      expect(screen.getByText('🏢 Dev Co')).toBeInTheDocument();
      expect(screen.getByText('📍 London')).toBeInTheDocument();
    });

    it('should display user avatars with first letter of name', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('J')).toBeInTheDocument(); // John Doe
      });

      // Check for avatar letters
      const avatars = screen.getAllByText(/^[JB]$/); // J for John/Jane, B for Bob
      expect(avatars.length).toBeGreaterThanOrEqual(3);
    });

    it('should display header and footer information', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('👥 User Directory')).toBeInTheDocument();
      });

      expect(screen.getByText('👥 User Directory')).toBeInTheDocument();
      expect(screen.getByText(/This component uses TanStack Query/)).toBeInTheDocument();
      expect(screen.getByText(/5.62.0-5.62.2/)).toBeInTheDocument();
    });

    it('should display refresh button', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('🔄 Refresh')).toBeInTheDocument();
      });

      const refreshButton = screen.getByText('🔄 Refresh');
      expect(refreshButton).toBeInTheDocument();
      expect(refreshButton.tagName).toBe('BUTTON');
    });

    it('should handle empty user list', async () => {
      usersApi.fetchUsers.mockResolvedValue([]);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('No users found')).toBeInTheDocument();
      });
    });
  });

  describe('Error State', () => {
    it('should display error message when fetch fails', async () => {
      const errorMessage = 'Failed to fetch users: Network error';
      usersApi.fetchUsers.mockRejectedValue(new Error(errorMessage));

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('❌ Error loading users')).toBeInTheDocument();
      });

      expect(screen.getByText(errorMessage)).toBeInTheDocument();
    });

    it('should display try again button on error', async () => {
      usersApi.fetchUsers.mockRejectedValue(new Error('Network error'));

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('Try Again')).toBeInTheDocument();
      });

      const tryAgainButton = screen.getByText('Try Again');
      expect(tryAgainButton).toBeInTheDocument();
      expect(tryAgainButton.tagName).toBe('BUTTON');
    });

    it('should have correct error state structure', async () => {
      usersApi.fetchUsers.mockRejectedValue(new Error('Test error'));

      const { container } = renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(container.querySelector('.error')).toBeInTheDocument();
      });

      const errorDiv = container.querySelector('.error');
      expect(errorDiv).toBeInTheDocument();
      expect(errorDiv.querySelector('h3')).toHaveTextContent('❌ Error loading users');
    });
  });

  describe('Refetch Functionality', () => {
    it('should refetch users when refresh button is clicked', async () => {
      const user = userEvent.setup();
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      // Wait for initial load
      await waitFor(() => {
        expect(screen.getByText('John Doe')).toBeInTheDocument();
      });

      // Click refresh button
      const refreshButton = screen.getByText('🔄 Refresh');
      await user.click(refreshButton);

      // Verify fetchUsers was called again
      await waitFor(() => {
        expect(usersApi.fetchUsers).toHaveBeenCalledTimes(2);
      });
    });

    it('should refetch users when try again button is clicked after error', async () => {
      const user = userEvent.setup();
      
      // First call fails
      usersApi.fetchUsers.mockRejectedValueOnce(new Error('Network error'));
      // Second call succeeds
      usersApi.fetchUsers.mockResolvedValueOnce(mockUsers);

      renderWithQueryClient(<UserList />);

      // Wait for error state
      await waitFor(() => {
        expect(screen.getByText('Try Again')).toBeInTheDocument();
      });

      // Click try again button
      const tryAgainButton = screen.getByText('Try Again');
      await user.click(tryAgainButton);

      // Wait for successful load
      await waitFor(() => {
        expect(screen.getByText('John Doe')).toBeInTheDocument();
      });

      expect(usersApi.fetchUsers).toHaveBeenCalledTimes(2);
    });
  });

  describe('TanStack Query Integration', () => {
    it('should use TanStack Query for data fetching', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      // Verify that the component uses TanStack Query by checking
      // that it properly handles loading and success states
      await waitFor(() => {
        expect(screen.getByText('John Doe')).toBeInTheDocument();
      });

      // Verify API was called
      expect(usersApi.fetchUsers).toHaveBeenCalledTimes(1);
    });

    it('should display note about TanStack Query vulnerability', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText(/This component uses TanStack Query/)).toBeInTheDocument();
      });

      // Check for vulnerability information
      const noteText = screen.getByText(/compromised in versions 5.62.0-5.62.2/);
      expect(noteText).toBeInTheDocument();
    });
  });

  describe('Component Structure', () => {
    it('should have correct CSS classes', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      const { container } = renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(container.querySelector('.user-list')).toBeInTheDocument();
      });

      expect(container.querySelector('.user-list')).toBeInTheDocument();
      expect(container.querySelector('.user-list-header')).toBeInTheDocument();
      expect(container.querySelector('.user-grid')).toBeInTheDocument();
      expect(container.querySelector('.user-list-footer')).toBeInTheDocument();
    });

    it('should render user cards with correct structure', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      const { container } = renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(container.querySelectorAll('.user-card').length).toBe(3);
      });

      const userCards = container.querySelectorAll('.user-card');
      expect(userCards.length).toBe(3);

      // Check first user card structure
      const firstCard = userCards[0];
      expect(firstCard.querySelector('.user-avatar')).toBeInTheDocument();
      expect(firstCard.querySelector('.user-info')).toBeInTheDocument();
      expect(firstCard.querySelector('.user-name')).toBeInTheDocument();
      expect(firstCard.querySelector('.user-email')).toBeInTheDocument();
      expect(firstCard.querySelector('.user-company')).toBeInTheDocument();
      expect(firstCard.querySelector('.user-city')).toBeInTheDocument();
    });
  });

  describe('Accessibility', () => {
    it('should have accessible button elements', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(screen.getByText('🔄 Refresh')).toBeInTheDocument();
      });

      const refreshButton = screen.getByText('🔄 Refresh');
      expect(refreshButton).toHaveAttribute('class');
      expect(refreshButton.tagName).toBe('BUTTON');
    });

    it('should have semantic HTML structure', async () => {
      usersApi.fetchUsers.mockResolvedValue(mockUsers);

      const { container } = renderWithQueryClient(<UserList />);

      await waitFor(() => {
        expect(container.querySelector('h3')).toBeInTheDocument();
      });

      // Check for semantic elements
      expect(container.querySelector('h3')).toBeInTheDocument();
      expect(container.querySelector('h4')).toBeInTheDocument();
      expect(container.querySelectorAll('p').length).toBeGreaterThan(0);
    });
  });
});

// Made with Bob