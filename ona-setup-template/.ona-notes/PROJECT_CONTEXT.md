# Ona Laravel Setup Template - Project Context

## Project Overview
- **Name**: Ona Laravel Setup Template
- **Type**: Development Environment Template
- **Purpose**: Standardized Laravel + Frontend setup for Ona AI agent development
- **Created**: 2024
- **Environment**: Multi-environment (Development, Staging, Production)

## Technology Stack

### Backend
- **Framework**: Laravel 10.x
- **PHP Version**: 8.3+
- **Database**: SQLite (dev), MySQL/PostgreSQL (prod)
- **Queue System**: Laravel Horizon
- **Admin Panel**: Filament 3.x
- **Testing**: Pest Framework
- **Debugging**: Laravel Telescope

### Frontend
- **Build Tool**: Vite 4.x
- **JavaScript Framework**: Vue.js 3 (Composition API)
- **CSS Framework**: Tailwind CSS 3.x
- **Package Manager**: npm/yarn
- **Hot Reload**: Vite HMR

### Development Environment
- **Container**: Docker with Dev Containers
- **Editor**: VS Code with optimized extensions
- **PHP Extensions**: gd, zip, intl, mbstring, xml, curl, pdo, bcmath, opcache, xdebug
- **Node.js**: Version 20.x LTS

### Additional Tools
- **Code Quality**: PHP CS Fixer, PHPStan, ESLint, Prettier
- **Version Control**: Git with conventional commits
- **CI/CD**: Automated testing and deployment scripts
- **Monitoring**: Laravel Telescope, Horizon dashboard

## Architecture Patterns

### Backend Architecture
- **MVC Pattern**: Standard Laravel MVC structure
- **Service Layer**: Business logic separation
- **Repository Pattern**: Data access abstraction
- **Event-Driven**: Laravel events and listeners
- **Queue Jobs**: Background task processing

### Frontend Architecture
- **Component-Based**: Vue.js single-file components
- **Composition API**: Modern Vue.js patterns
- **Utility-First CSS**: Tailwind CSS approach
- **Module Bundling**: Vite for optimized builds

### Development Patterns
- **Test-Driven Development**: Pest testing framework
- **Conventional Commits**: Standardized commit messages
- **Feature Branches**: Git workflow with PR reviews
- **Automated Deployment**: Script-based deployments

## Key Features

### Development Environment
- **One-Command Setup**: `./setup.sh` initializes everything
- **Hot Reloading**: Instant feedback during development
- **Debugging Tools**: Xdebug, Telescope, Debugbar integration
- **Code Quality**: Automated formatting and linting
- **Testing Suite**: Comprehensive PHP and JavaScript tests

### Production Readiness
- **Optimized Builds**: Minified assets, cached configurations
- **Security**: Environment-based configurations, secure defaults
- **Performance**: OPcache, Redis caching, optimized autoloader
- **Monitoring**: Application health checks, error tracking

### Ona Integration
- **Project Context**: Structured documentation for AI understanding
- **Commit Guidelines**: Standardized development workflow
- **Code Organization**: Consistent patterns and conventions
- **Development Notes**: Contextual information for AI assistance

## Development Workflow

### Initial Setup
1. Clone or install template
2. Run `./setup.sh` for project initialization
3. Configure environment variables
4. Start development servers with `./dev`

### Daily Development
1. Pull latest changes
2. Run migrations if needed
3. Start development servers
4. Write code with hot reloading
5. Run tests before committing
6. Follow conventional commit format

### Testing Strategy
- **Unit Tests**: Individual component testing
- **Feature Tests**: End-to-end functionality
- **Browser Tests**: Frontend interaction testing
- **API Tests**: Backend endpoint validation

### Deployment Process
1. Run test suite (`./scripts/test.sh`)
2. Build for production (`./scripts/build.sh`)
3. Deploy to environment (`./scripts/deploy.sh`)
4. Verify deployment health

## File Organization

### Core Structure
```
project/
├── app/                    # Laravel application logic
│   ├── Http/Controllers/   # Request handlers
│   ├── Models/            # Eloquent models
│   ├── Services/          # Business logic
│   └── Filament/          # Admin panel resources
├── resources/             # Frontend assets
│   ├── js/               # JavaScript/Vue components
│   ├── css/              # Stylesheets
│   └── views/            # Blade templates
├── tests/                # Test suites
│   ├── Feature/          # Integration tests
│   └── Unit/             # Unit tests
└── scripts/              # Development utilities
```

### Configuration Files
- **Environment**: `.env` files for different environments
- **Build Tools**: `vite.config.js`, `tailwind.config.js`
- **PHP Tools**: `composer.json`, `phpstan.neon`
- **Container**: `.devcontainer/` for development environment

## Environment Configurations

### Development
- **Debug Mode**: Enabled for detailed error reporting
- **Database**: SQLite for simplicity
- **Cache**: File-based for development
- **Mail**: Mailhog for email testing
- **Assets**: Hot reloading with Vite

### Staging
- **Debug Mode**: Limited for testing
- **Database**: Production-like setup
- **Cache**: Redis for performance
- **Mail**: Real SMTP configuration
- **Assets**: Optimized builds

### Production
- **Debug Mode**: Disabled for security
- **Database**: Optimized production database
- **Cache**: Redis with clustering
- **Mail**: Production SMTP/SES
- **Assets**: Minified and cached

## Security Considerations

### Development Security
- **Environment Isolation**: Containerized development
- **Secret Management**: Environment-based configuration
- **Code Quality**: Automated security scanning
- **Access Control**: Role-based permissions

### Production Security
- **HTTPS Enforcement**: SSL/TLS configuration
- **Database Security**: Encrypted connections, limited access
- **Application Security**: CSRF protection, input validation
- **Infrastructure Security**: Firewall rules, access logging

## Performance Optimizations

### Backend Performance
- **OPcache**: PHP bytecode caching
- **Database**: Query optimization, indexing
- **Caching**: Redis for sessions, cache, queues
- **Queue Processing**: Background job handling

### Frontend Performance
- **Asset Optimization**: Minification, compression
- **Code Splitting**: Lazy loading, dynamic imports
- **CDN Integration**: Static asset delivery
- **Caching Strategy**: Browser and server-side caching

## Monitoring and Logging

### Application Monitoring
- **Laravel Telescope**: Development debugging
- **Laravel Horizon**: Queue monitoring
- **Error Tracking**: Centralized error logging
- **Performance Metrics**: Response time tracking

### Infrastructure Monitoring
- **Server Health**: CPU, memory, disk usage
- **Database Performance**: Query analysis, slow log
- **Network Monitoring**: Response times, uptime
- **Security Monitoring**: Access logs, intrusion detection

## Future Enhancements

### Planned Features
- **API Documentation**: Automated API docs generation
- **Advanced Testing**: Visual regression testing
- **CI/CD Pipeline**: GitHub Actions integration
- **Monitoring Dashboard**: Custom metrics visualization

### Scalability Considerations
- **Microservices**: Service decomposition strategy
- **Database Scaling**: Read replicas, sharding
- **Caching Strategy**: Multi-layer caching
- **Load Balancing**: Horizontal scaling preparation

## Ona-Specific Notes

### AI Development Patterns
- **Consistent Structure**: Predictable file organization
- **Clear Documentation**: Comprehensive context for AI
- **Standardized Workflows**: Repeatable development processes
- **Quality Assurance**: Automated testing and validation

### Integration Points
- **Code Generation**: Template-based scaffolding
- **Documentation**: Auto-generated project context
- **Testing**: AI-assisted test case generation
- **Deployment**: Automated deployment workflows

This template provides a solid foundation for Laravel development with Ona AI agent integration, ensuring consistent, high-quality, and maintainable applications.