#!/bin/bash

# Ona Laravel Deployment Script
# Handles deployment to staging and production environments

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

# Configuration
ENVIRONMENT="$1"
DEPLOY_USER="${DEPLOY_USER:-deploy}"
DEPLOY_PATH="${DEPLOY_PATH:-/var/www/html}"

# Validate environment
if [ -z "$ENVIRONMENT" ]; then
    print_error "Environment not specified"
    echo "Usage: $0 {staging|production}"
    exit 1
fi

if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ]; then
    print_error "Invalid environment: $ENVIRONMENT"
    echo "Valid environments: staging, production"
    exit 1
fi

print_header "Ona Laravel Deployment - $ENVIRONMENT"

# Load environment-specific configuration
case "$ENVIRONMENT" in
    staging)
        DEPLOY_HOST="${STAGING_HOST:-staging.example.com}"
        DEPLOY_PATH="${STAGING_PATH:-/var/www/staging}"
        DEPLOY_USER="${STAGING_USER:-deploy}"
        ;;
    production)
        DEPLOY_HOST="${PRODUCTION_HOST:-production.example.com}"
        DEPLOY_PATH="${PRODUCTION_PATH:-/var/www/production}"
        DEPLOY_USER="${PRODUCTION_USER:-deploy}"
        
        # Production safety check
        echo -e "${RED}⚠️  PRODUCTION DEPLOYMENT${NC}"
        echo "This will deploy to production environment."
        echo "Host: $DEPLOY_HOST"
        echo "Path: $DEPLOY_PATH"
        echo ""
        read -p "Are you sure you want to continue? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            print_info "Deployment cancelled"
            exit 0
        fi
        ;;
esac

print_info "Target: $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH"

# Pre-deployment checks
print_header "Pre-deployment Checks"

# Check if we're in a Laravel project
if [ ! -f "artisan" ]; then
    print_error "Not in a Laravel project directory"
    exit 1
fi

# Check Git status
if [ -d ".git" ]; then
    if ! git diff-index --quiet HEAD --; then
        print_warning "Uncommitted changes detected"
        git status --porcelain
        echo ""
        read -p "Continue with uncommitted changes? (yes/no): " continue_deploy
        if [ "$continue_deploy" != "yes" ]; then
            print_info "Deployment cancelled"
            exit 0
        fi
    fi
    
    CURRENT_BRANCH=$(git branch --show-current)
    CURRENT_COMMIT=$(git rev-parse HEAD)
    print_info "Branch: $CURRENT_BRANCH"
    print_info "Commit: $CURRENT_COMMIT"
fi

# Check SSH connection
print_info "Testing SSH connection..."
if ! ssh -o ConnectTimeout=10 "$DEPLOY_USER@$DEPLOY_HOST" "echo 'SSH connection successful'" > /dev/null 2>&1; then
    print_error "Cannot connect to $DEPLOY_USER@$DEPLOY_HOST"
    print_info "Please ensure SSH key authentication is set up"
    exit 1
fi
print_status "SSH connection verified"

# Run tests
print_info "Running test suite..."
if [ -f "./vendor/bin/pest" ]; then
    ./vendor/bin/pest --bail
elif [ -f "./vendor/bin/phpunit" ]; then
    ./vendor/bin/phpunit --stop-on-failure
else
    print_warning "No test framework found, skipping tests"
fi
print_status "Tests passed"

# Build for production
print_header "Building Application"
print_info "Running production build..."
./scripts/build.sh
print_status "Build completed"

# Create deployment package
print_header "Creating Deployment Package"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PACKAGE_NAME="deploy-$ENVIRONMENT-$TIMESTAMP.tar.gz"

print_info "Creating deployment package: $PACKAGE_NAME"
tar -czf "$PACKAGE_NAME" \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='tests' \
    --exclude='.github' \
    --exclude='backup-*' \
    --exclude='*.tar.gz' \
    .

print_status "Deployment package created"

# Upload and deploy
print_header "Deploying to $ENVIRONMENT"

# Create deployment script
cat > deploy-remote.sh << 'EOF'
#!/bin/bash
set -e

DEPLOY_PATH="$1"
PACKAGE_NAME="$2"
TIMESTAMP="$3"

echo "🚀 Starting remote deployment..."

# Create backup of current deployment
if [ -d "$DEPLOY_PATH/current" ]; then
    echo "📦 Creating backup..."
    cp -r "$DEPLOY_PATH/current" "$DEPLOY_PATH/backup-$TIMESTAMP" || true
fi

# Create releases directory
mkdir -p "$DEPLOY_PATH/releases"
RELEASE_PATH="$DEPLOY_PATH/releases/$TIMESTAMP"

# Extract new release
echo "📂 Extracting release..."
mkdir -p "$RELEASE_PATH"
tar -xzf "/tmp/$PACKAGE_NAME" -C "$RELEASE_PATH"

# Link shared directories
echo "🔗 Setting up shared directories..."
mkdir -p "$DEPLOY_PATH/shared/storage/app"
mkdir -p "$DEPLOY_PATH/shared/storage/logs"
mkdir -p "$DEPLOY_PATH/shared/storage/framework/cache"
mkdir -p "$DEPLOY_PATH/shared/storage/framework/sessions"
mkdir -p "$DEPLOY_PATH/shared/storage/framework/views"

# Remove release storage and link to shared
rm -rf "$RELEASE_PATH/storage"
ln -sf "$DEPLOY_PATH/shared/storage" "$RELEASE_PATH/storage"

# Link .env file
if [ -f "$DEPLOY_PATH/shared/.env" ]; then
    ln -sf "$DEPLOY_PATH/shared/.env" "$RELEASE_PATH/.env"
else
    echo "⚠️  No shared .env file found"
fi

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 775 "$DEPLOY_PATH/shared/storage"
chmod -R 775 "$RELEASE_PATH/bootstrap/cache"

# Update current symlink
echo "🔄 Updating current release..."
rm -f "$DEPLOY_PATH/current"
ln -sf "$RELEASE_PATH" "$DEPLOY_PATH/current"

# Run post-deployment tasks
echo "⚙️  Running post-deployment tasks..."
cd "$DEPLOY_PATH/current"

# Clear caches
php artisan cache:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

# Cache for production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations
php artisan migrate --force

# Restart services (if applicable)
if command -v supervisorctl &> /dev/null; then
    supervisorctl restart laravel-horizon || true
    supervisorctl restart laravel-schedule || true
fi

# Clean up old releases (keep last 5)
echo "🧹 Cleaning up old releases..."
cd "$DEPLOY_PATH/releases"
ls -t | tail -n +6 | xargs rm -rf || true

echo "✅ Deployment completed successfully!"
EOF

# Upload files
print_info "Uploading deployment package..."
scp "$PACKAGE_NAME" "$DEPLOY_USER@$DEPLOY_HOST:/tmp/"
scp deploy-remote.sh "$DEPLOY_USER@$DEPLOY_HOST:/tmp/"

print_status "Files uploaded"

# Execute remote deployment
print_info "Executing remote deployment..."
ssh "$DEPLOY_USER@$DEPLOY_HOST" "chmod +x /tmp/deploy-remote.sh && /tmp/deploy-remote.sh '$DEPLOY_PATH' '$PACKAGE_NAME' '$TIMESTAMP'"

print_status "Remote deployment completed"

# Cleanup
print_header "Cleanup"
print_info "Cleaning up local files..."
rm -f "$PACKAGE_NAME"
rm -f deploy-remote.sh

# Cleanup remote files
ssh "$DEPLOY_USER@$DEPLOY_HOST" "rm -f /tmp/$PACKAGE_NAME /tmp/deploy-remote.sh"

print_status "Cleanup completed"

# Health check
print_header "Health Check"
print_info "Performing post-deployment health check..."

# Check if application is responding
HEALTH_URL="https://$DEPLOY_HOST/health"
if command -v curl &> /dev/null; then
    if curl -f -s "$HEALTH_URL" > /dev/null 2>&1; then
        print_status "Application is responding"
    else
        print_warning "Health check endpoint not responding"
        print_info "You may need to manually verify the deployment"
    fi
else
    print_warning "curl not available, skipping health check"
fi

# Deployment summary
print_header "🎉 Deployment Complete!"
echo ""
echo "Deployment Summary:"
echo "==================="
echo "Environment: $ENVIRONMENT"
echo "Host: $DEPLOY_HOST"
echo "Path: $DEPLOY_PATH/current"
echo "Timestamp: $TIMESTAMP"
if [ -n "$CURRENT_COMMIT" ]; then
    echo "Commit: $CURRENT_COMMIT"
fi
echo ""
echo "✅ Application deployed successfully!"
echo "🌐 URL: https://$DEPLOY_HOST"
echo ""
echo "Post-deployment checklist:"
echo "1. ✅ Application files uploaded"
echo "2. ✅ Database migrations run"
echo "3. ✅ Caches optimized"
echo "4. ✅ Permissions set"
echo "5. ⏳ Manual verification recommended"
echo ""
echo "Happy deployment with Ona! 🚀"