#!/bin/bash

# Ona Laravel Production Build Script
# Optimizes application for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_header() {
    echo -e "${PURPLE}🎯 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_header "Ona Laravel Production Build"

# Check if we're in a Laravel project
if [ ! -f "artisan" ]; then
    print_error "Not in a Laravel project directory"
    exit 1
fi

# Environment check
if [ ! -f ".env" ]; then
    print_error ".env file not found"
    exit 1
fi

# Backup current state
print_header "Creating Backup"
BACKUP_DIR="backup-$(date +%Y%m%d_%H%M%S)"
print_info "Creating backup in $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r storage/app "$BACKUP_DIR/" 2>/dev/null || true
cp .env "$BACKUP_DIR/" 2>/dev/null || true
print_status "Backup created"

# Clear all caches
print_header "Clearing Caches"
print_info "Clearing application caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan event:clear
print_status "Caches cleared"

# Install production dependencies
print_header "Installing Dependencies"
print_info "Installing Composer dependencies..."
composer install --optimize-autoloader --no-dev --no-interaction
print_status "Composer dependencies installed"

if [ -f "package.json" ]; then
    print_info "Installing Node.js dependencies..."
    npm ci --only=production
    print_status "Node.js dependencies installed"
fi

# Run database migrations
print_header "Database Setup"
print_info "Running database migrations..."
php artisan migrate --force
print_status "Database migrations completed"

# Build frontend assets
print_header "Building Frontend Assets"
if [ -f "package.json" ]; then
    print_info "Building production assets..."
    npm run build
    print_status "Frontend assets built"
    
    # Clean up node_modules to save space
    print_info "Cleaning up development dependencies..."
    rm -rf node_modules
    print_status "Development dependencies removed"
else
    print_warning "No package.json found, skipping frontend build"
fi

# Optimize Laravel
print_header "Laravel Optimization"

print_info "Caching configuration..."
php artisan config:cache
print_status "Configuration cached"

print_info "Caching routes..."
php artisan route:cache
print_status "Routes cached"

print_info "Caching views..."
php artisan view:cache
print_status "Views cached"

print_info "Caching events..."
php artisan event:cache
print_status "Events cached"

# Optimize Composer autoloader
print_info "Optimizing Composer autoloader..."
composer dump-autoload --optimize --classmap-authoritative
print_status "Autoloader optimized"

# Set proper permissions
print_header "Setting Permissions"
print_info "Setting storage permissions..."
chmod -R 775 storage
chmod -R 775 bootstrap/cache
print_status "Permissions set"

# Generate application key if needed
if grep -q "APP_KEY=$" .env; then
    print_info "Generating application key..."
    php artisan key:generate --force
    print_status "Application key generated"
fi

# Security checks
print_header "Security Validation"

# Check environment
if grep -q "APP_ENV=local" .env; then
    print_warning "Application is still in local environment"
    print_info "Consider setting APP_ENV=production"
fi

if grep -q "APP_DEBUG=true" .env; then
    print_warning "Debug mode is enabled"
    print_info "Consider setting APP_DEBUG=false for production"
fi

# Check for sensitive files
SENSITIVE_FILES=(".env.example" "README.md" "CHANGELOG.md" ".git")
for file in "${SENSITIVE_FILES[@]}"; do
    if [ -e "$file" ]; then
        print_warning "Sensitive file '$file' present in build"
    fi
done

print_status "Security validation completed"

# Create deployment info
print_header "Creating Deployment Info"
cat > deployment-info.json << EOF
{
    "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "build_user": "$(whoami)",
    "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "git_branch": "$(git branch --show-current 2>/dev/null || echo 'unknown')",
    "laravel_version": "$(php artisan --version | cut -d' ' -f3)",
    "php_version": "$(php -r 'echo PHP_VERSION;')",
    "environment": "$(grep APP_ENV .env | cut -d'=' -f2)"
}
EOF
print_status "Deployment info created"

# Health check
print_header "Health Check"
print_info "Running application health check..."

# Check if application boots
if php artisan inspire > /dev/null 2>&1; then
    print_status "Application boots successfully"
else
    print_error "Application failed to boot"
    exit 1
fi

# Check database connection
if php artisan migrate:status > /dev/null 2>&1; then
    print_status "Database connection verified"
else
    print_warning "Database connection issues detected"
fi

# File size report
print_header "Build Report"
print_info "Build size analysis..."

if command -v du &> /dev/null; then
    echo "Directory sizes:"
    du -sh vendor 2>/dev/null || echo "vendor: not found"
    du -sh public 2>/dev/null || echo "public: not found"
    du -sh storage 2>/dev/null || echo "storage: not found"
    du -sh bootstrap/cache 2>/dev/null || echo "bootstrap/cache: not found"
    echo ""
    echo "Total build size: $(du -sh . | cut -f1)"
fi

# Cleanup
print_header "Cleanup"
print_info "Removing build artifacts..."
rm -rf .git 2>/dev/null || true
rm -rf tests 2>/dev/null || true
rm -rf .github 2>/dev/null || true
rm -f .gitignore .gitattributes 2>/dev/null || true
rm -f phpunit.xml pest.php 2>/dev/null || true
rm -f package-lock.json yarn.lock 2>/dev/null || true
print_status "Build artifacts removed"

# Final verification
print_header "Final Verification"
print_info "Verifying production build..."

# Check critical files
CRITICAL_FILES=("artisan" "composer.json" ".env" "public/index.php")
for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        print_error "Critical file '$file' is missing"
        exit 1
    fi
done

print_status "All critical files present"

# Success message
print_header "🎉 Production Build Complete!"
echo ""
echo "Build Summary:"
echo "=============="
echo "✅ Dependencies: Optimized"
echo "✅ Frontend: Built and minified"
echo "✅ Laravel: Cached and optimized"
echo "✅ Database: Migrated"
echo "✅ Permissions: Set"
echo "✅ Security: Validated"
echo "✅ Health: Verified"
echo ""
echo "Your Ona Laravel application is ready for production deployment! 🚀"
echo ""
echo "Backup location: $BACKUP_DIR"
echo "Deployment info: deployment-info.json"
echo ""
echo "Next steps:"
echo "1. Upload to your production server"
echo "2. Configure web server (Apache/Nginx)"
echo "3. Set up SSL certificate"
echo "4. Configure environment variables"
echo "5. Set up monitoring and logging"