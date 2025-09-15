# Commit Guidelines for Ona Laravel Development

## Conventional Commits Format

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

### Primary Types
- **feat**: A new feature for the user
- **fix**: A bug fix for the user
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries

### Additional Types
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **revert**: Reverts a previous commit
- **security**: Security improvements or fixes

## Scopes

Use scopes to indicate the area of the codebase affected:

### Backend Scopes
- **auth**: Authentication and authorization
- **api**: API endpoints and controllers
- **model**: Eloquent models and database
- **service**: Business logic services
- **queue**: Queue jobs and processing
- **mail**: Email functionality
- **config**: Configuration changes

### Frontend Scopes
- **ui**: User interface components
- **vue**: Vue.js components and logic
- **css**: Styling and CSS changes
- **js**: JavaScript functionality
- **build**: Build tools and configuration

### Infrastructure Scopes
- **docker**: Container configuration
- **deploy**: Deployment scripts and configuration
- **env**: Environment configuration
- **deps**: Dependency updates

## Examples

### Feature Commits
```
feat(auth): add two-factor authentication

Implement TOTP-based 2FA using Google Authenticator.
Includes user settings page and backup codes.

Closes #123
```

```
feat(ui): add dark mode toggle

Add system preference detection and manual toggle.
Persists user preference in localStorage.
```

### Bug Fix Commits
```
fix(api): resolve user registration validation error

Fix email validation regex to properly handle plus signs
in email addresses.

Fixes #456
```

```
fix(vue): correct reactive data binding in user profile

Ensure profile form updates reflect immediately in the UI
without requiring page refresh.
```

### Documentation Commits
```
docs: update API documentation for user endpoints

Add examples for all user management endpoints.
Include authentication requirements and response formats.
```

```
docs(setup): add troubleshooting section to README

Include common issues and solutions for development
environment setup.
```

### Refactoring Commits
```
refactor(service): simplify user notification logic

Extract notification methods into dedicated service class.
Improve testability and reduce controller complexity.
```

```
refactor(vue): convert Options API to Composition API

Modernize Vue components to use Composition API.
Improves type safety and code organization.
```

### Performance Commits
```
perf(query): optimize user dashboard data loading

Add eager loading for relationships and implement
query result caching. Reduces page load time by 60%.
```

```
perf(build): enable tree shaking for JavaScript bundle

Configure Vite to eliminate unused code.
Reduces bundle size by 25%.
```

### Test Commits
```
test(auth): add comprehensive login flow tests

Include tests for successful login, failed attempts,
rate limiting, and password reset functionality.
```

```
test(api): add integration tests for user endpoints

Cover CRUD operations, validation, and authorization
for all user management endpoints.
```

### Chore Commits
```
chore(deps): update Laravel to version 10.32

Update framework and related packages.
No breaking changes required.
```

```
chore(build): configure ESLint for Vue 3

Add Vue 3 specific rules and TypeScript support.
Fix existing linting issues.
```

## Breaking Changes

For breaking changes, add `!` after the type/scope and include `BREAKING CHANGE:` in the footer:

```
feat(api)!: change user endpoint response format

BREAKING CHANGE: User API now returns nested user object
instead of flat structure. Update client applications accordingly.

Before: { "id": 1, "name": "John", "email": "john@example.com" }
After: { "user": { "id": 1, "name": "John", "email": "john@example.com" } }
```

## Co-authoring with Ona

Always include Ona as co-author when AI assistance was used:

```
feat(auth): implement OAuth2 integration

Add support for Google and GitHub OAuth providers.
Includes user account linking and profile synchronization.

Co-authored-by: Ona <no-reply@ona.com>
```

## Multi-line Commit Messages

For complex changes, use the body to explain what and why:

```
feat(queue): add job retry mechanism with exponential backoff

Implement configurable retry logic for failed jobs:
- Exponential backoff with jitter
- Maximum retry attempts per job type
- Dead letter queue for permanently failed jobs
- Monitoring dashboard integration

This improves system reliability and reduces manual intervention
for transient failures.

Closes #789
Co-authored-by: Ona <no-reply@ona.com>
```

## Commit Message Rules

### Do's
- ✅ Use imperative mood ("add" not "added" or "adds")
- ✅ Keep the subject line under 50 characters
- ✅ Capitalize the subject line
- ✅ Don't end the subject line with a period
- ✅ Use the body to explain what and why vs. how
- ✅ Separate subject from body with a blank line
- ✅ Wrap the body at 72 characters
- ✅ Reference issues and pull requests when applicable

### Don'ts
- ❌ Don't use vague descriptions ("fix stuff", "update things")
- ❌ Don't include file names in the subject line
- ❌ Don't use past tense ("fixed", "added")
- ❌ Don't exceed character limits
- ❌ Don't commit without testing
- ❌ Don't mix unrelated changes in one commit

## Commit Frequency

### When to Commit
- After completing a logical unit of work
- Before switching branches or contexts
- After fixing a bug or adding a feature
- Before major refactoring
- At the end of each development session

### Atomic Commits
Each commit should represent a single logical change:
- ✅ One feature per commit
- ✅ One bug fix per commit
- ✅ Related changes grouped together
- ❌ Multiple unrelated changes in one commit

## Pre-commit Checklist

Before committing, ensure:
- [ ] Code compiles without errors
- [ ] Tests pass locally
- [ ] Code follows project style guidelines
- [ ] No debugging code or console.log statements
- [ ] Environment files are not included
- [ ] Commit message follows conventions
- [ ] Changes are properly scoped and atomic

## Git Hooks

The template includes pre-commit hooks that:
- Run PHP syntax checks
- Execute test suite
- Validate commit message format
- Check for debugging statements
- Ensure code formatting compliance

## Examples by Feature Type

### Authentication Features
```
feat(auth): add password strength validation
feat(auth): implement remember me functionality
fix(auth): resolve session timeout issues
test(auth): add password reset flow tests
```

### API Development
```
feat(api): add user profile endpoints
feat(api): implement API rate limiting
fix(api): correct JSON response formatting
docs(api): update OpenAPI specification
```

### Frontend Development
```
feat(ui): add responsive navigation menu
feat(vue): implement real-time notifications
fix(css): resolve mobile layout issues
perf(js): optimize component rendering
```

### Database Changes
```
feat(model): add user preferences table
fix(migration): correct foreign key constraints
perf(query): optimize dashboard queries
refactor(model): simplify user relationships
```

### DevOps and Deployment
```
feat(docker): add multi-stage build configuration
fix(deploy): resolve production environment issues
chore(ci): update GitHub Actions workflow
docs(deploy): add deployment troubleshooting guide
```

## Revert Commits

When reverting commits, use this format:
```
revert: feat(auth): add two-factor authentication

This reverts commit 1234567890abcdef.

Reason: Discovered security vulnerability in TOTP implementation.
Will re-implement after security review.
```

## Release Commits

For release commits:
```
chore(release): bump version to 1.2.0

- Add user dashboard improvements
- Fix authentication edge cases
- Update dependencies
- Improve performance by 15%

Co-authored-by: Ona <no-reply@ona.com>
```

Following these guidelines ensures consistent, readable, and meaningful commit history that helps both human developers and AI agents understand the project evolution and make informed decisions about future changes.