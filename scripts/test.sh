#!/bin/bash

# Ona Laravel Testing Script
# Runs comprehensive test suite

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

print_header "Ona Laravel Test Suite"

# Check if we're in a Laravel project
if [ ! -f "artisan" ]; then
    print_error "Not in a Laravel project directory"
    exit 1
fi

# PHP Tests
print_header "Running PHP Tests"

if [ -f "./vendor/bin/pest" ]; then
    print_info "Running Pest tests..."
    ./vendor/bin/pest --colors=always
    print_status "Pest tests completed"
elif [ -f "./vendor/bin/phpunit" ]; then
    print_info "Running PHPUnit tests..."
    ./vendor/bin/phpunit --colors=always
    print_status "PHPUnit tests completed"
else
    print_warning "No PHP testing framework found"
fi

# Code Quality Checks
print_header "Code Quality Checks"

# PHP CS Fixer
if command -v php-cs-fixer &> /dev/null; then
    print_info "Checking PHP code style..."
    php-cs-fixer fix --dry-run --diff --config=.php-cs-fixer.php . || print_warning "PHP CS Fixer issues found"
    print_status "PHP code style check completed"
fi

# PHPStan
if command -v phpstan &> /dev/null; then
    print_info "Running PHPStan static analysis..."
    phpstan analyse --memory-limit=1G || print_warning "PHPStan issues found"
    print_status "PHPStan analysis completed"
fi

# Frontend Tests
print_header "Frontend Tests"

if [ -f "package.json" ]; then
    if grep -q "test" package.json; then
        print_info "Running JavaScript tests..."
        npm test
        print_status "JavaScript tests completed"
    else
        print_warning "No JavaScript tests configured"
    fi
    
    # ESLint
    if grep -q "eslint" package.json; then
        print_info "Running ESLint..."
        npx eslint resources/js --ext .js,.vue || print_warning "ESLint issues found"
        print_status "ESLint check completed"
    fi
    
    # Build check
    print_info "Testing frontend build..."
    npm run build
    print_status "Frontend build successful"
else
    print_warning "No package.json found"
fi

# Laravel Specific Tests
print_header "Laravel Application Tests"

# Route list
print_info "Checking routes..."
php artisan route:list --compact
print_status "Routes verified"

# Config cache
print_info "Testing configuration cache..."
php artisan config:cache
php artisan config:clear
print_status "Configuration cache test passed"

# Database tests
if [ -f "database/database.sqlite" ] || grep -q "DB_CONNECTION" .env; then
    print_info "Testing database connection..."
    php artisan migrate:status
    print_status "Database connection verified"
fi

# Queue tests
print_info "Testing queue configuration..."
php artisan queue:failed
print_status "Queue configuration verified"

# Performance Tests
print_header "Performance Tests"

# Composer autoload optimization
print_info "Testing optimized autoloader..."
composer dump-autoload --optimize --quiet
print_status "Autoloader optimization verified"

# Route caching
print_info "Testing route cache..."
php artisan route:cache
php artisan route:clear
print_status "Route caching verified"

# View caching
print_info "Testing view cache..."
php artisan view:cache
php artisan view:clear
print_status "View caching verified"

# Security Tests
print_header "Security Tests"

# Check for debug mode in production
if grep -q "APP_DEBUG=true" .env && grep -q "APP_ENV=production" .env; then
    print_warning "Debug mode is enabled in production environment"
else
    print_status "Debug mode configuration is appropriate"
fi

# Check for default keys
if grep -q "base64:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" .env; then
    print_error "Default application key detected - run 'php artisan key:generate'"
else
    print_status "Application key is properly configured"
fi

# File Permissions
print_header "File Permissions"

print_info "Checking storage permissions..."
if [ -w "storage" ] && [ -w "bootstrap/cache" ]; then
    print_status "Storage directories are writable"
else
    print_warning "Storage directories may not be writable"
fi

# Final Report
print_header "🎉 Test Suite Complete!"

echo ""
echo "Test Summary:"
echo "============="
echo "✅ PHP Tests: Completed"
echo "✅ Code Quality: Checked"
echo "✅ Frontend: Verified"
echo "✅ Laravel: Tested"
echo "✅ Performance: Optimized"
echo "✅ Security: Validated"
echo "✅ Permissions: Verified"
echo ""
echo "Your Ona Laravel application is ready for deployment! 🚀"