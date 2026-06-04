import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import UserList from './components/UserList';
import Weather from './components/Weather';
import './App.css';

/**
 * Main App Component
 * 
 * This app demonstrates the Concert + Bob vulnerability remediation workflow
 * with two scenarios:
 * 
 * 1. TRUE POSITIVE: TanStack Query supply chain attack
 *    - @tanstack/react-query@5.62.1 was compromised (Dec 2024)
 *    - Malicious code exfiltrated environment variables
 *    - Current version: 5.62.3 (SAFE)
 *    - Bob will detect this as TRUE POSITIVE and create PR to upgrade
 * 
 * 2. FALSE POSITIVE: axios SSRF vulnerability
 *    - axios@1.5.1 has CVE-2023-45857 (SSRF)
 *    - BUT we only use it with hardcoded URLs
 *    - User input safely passed as query parameters
 *    - Bob will detect this as FALSE POSITIVE (intelligent analysis)
 */

// Create a QueryClient instance
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      cacheTime: 1000 * 60 * 10, // 10 minutes
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <div className="app">
        <header className="app-header">
          <h1>🔒 Concert + Bob Remediation Demo</h1>
          <p className="subtitle">
            Demonstrating intelligent vulnerability remediation with supply chain attack detection
          </p>
        </header>

        <main className="app-main">
          <section className="demo-section">
            <div className="section-header">
              <h2>✅ TRUE POSITIVE: TanStack Query</h2>
              <span className="badge badge-critical">Supply Chain Attack</span>
            </div>
            <p className="section-description">
              This component uses <code>@tanstack/react-query@5.62.3</code> (safe version).
              The workflow simulates detecting the compromised version 5.62.1 and upgrading to 5.62.3.
            </p>
            <UserList />
          </section>

          <section className="demo-section">
            <div className="section-header">
              <h2>❌ FALSE POSITIVE: axios SSRF</h2>
              <span className="badge badge-medium">CVE-2023-45857</span>
            </div>
            <p className="section-description">
              This component uses <code>axios@1.5.1</code> which has a SSRF vulnerability.
              However, Bob's intelligent analysis detects this as a FALSE POSITIVE because
              we only use hardcoded URLs with user input safely passed as query parameters.
            </p>
            <Weather />
          </section>

          <section className="info-section">
            <h3>📋 Workflow Overview</h3>
            <ol className="workflow-steps">
              <li>
                <strong>Detection:</strong> Concert scans SBOM and detects vulnerable packages
              </li>
              <li>
                <strong>Analysis:</strong> Bob Shell analyzes code to determine true vs false positives
              </li>
              <li>
                <strong>True Positive:</strong> Bob creates PR with package upgrades
              </li>
              <li>
                <strong>False Positive:</strong> Bob comments on issue with detailed analysis
              </li>
              <li>
                <strong>Approval:</strong> DevOps engineer reviews and approves
              </li>
              <li>
                <strong>Testing:</strong> Automated tests run with safe package versions
              </li>
              <li>
                <strong>Remediation:</strong> Bob fixes any failing tests
              </li>
              <li>
                <strong>Merge:</strong> Software lead reviews and merges to production
              </li>
            </ol>
          </section>
        </main>

        <footer className="app-footer">
          <p>
            <strong>Note:</strong> This is a demonstration application. The TanStack supply chain
            attack occurred in December 2024. This demo uses safe versions (5.62.3+) and simulates
            the remediation workflow.
          </p>
        </footer>
      </div>

      {/* React Query DevTools - only in development */}
      <ReactQueryDevtools initialIsOpen={false} position="bottom-right" />
    </QueryClientProvider>
  );
}

export default App;

// Made with Bob
