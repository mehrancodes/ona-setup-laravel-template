# Ona Laravel + Frontend Development Environment
FROM mcr.microsoft.com/devcontainers/php:1-8.3-bullseye

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_NO_INTERACTION=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic utilities
    curl \
    wget \
    unzip \
    git \
    vim \
    nano \
    htop \
    tree \
    jq \
    # Build tools
    build-essential \
    software-properties-common \
    # PHP extensions dependencies
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    # Database clients
    mysql-client \
    postgresql-client \
    sqlite3 \
    # Redis
    redis-tools \
    # Image processing
    imagemagick \
    libmagickwand-dev \
    # Other utilities
    supervisor \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        zip \
        intl \
        mbstring \
        xml \
        curl \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        bcmath \
        opcache \
        exif \
        pcntl \
        sockets

# Install Redis PHP extension
RUN pecl install redis && docker-php-ext-enable redis

# Install ImageMagick PHP extension
RUN pecl install imagick && docker-php-ext-enable imagick

# Install Xdebug for development
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Configure PHP
COPY .devcontainer/php.ini /usr/local/etc/php/conf.d/99-custom.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install global npm packages
RUN npm install -g \
    yarn \
    pnpm \
    @vue/cli \
    @angular/cli \
    create-react-app \
    vite \
    typescript \
    ts-node \
    eslint \
    prettier \
    nodemon \
    pm2

# Install global Composer packages
RUN composer global require \
    laravel/installer \
    laravel/valet \
    friendsofphp/php-cs-fixer \
    phpstan/phpstan \
    squizlabs/php_codesniffer \
    phpmd/phpmd

# Add Composer global bin to PATH
ENV PATH="${PATH}:/home/vscode/.composer/vendor/bin:/root/.composer/vendor/bin"

# Create vscode user if it doesn't exist
RUN if ! id -u vscode > /dev/null 2>&1; then \
        groupadd --gid 1000 vscode \
        && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode; \
    fi

# Set up directories with proper permissions
RUN mkdir -p /workspaces \
    && chown -R vscode:vscode /workspaces \
    && mkdir -p /home/vscode/.composer \
    && chown -R vscode:vscode /home/vscode/.composer

# Install additional development tools
RUN apt-get update && apt-get install -y \
    # Git tools
    git-flow \
    # Shell tools
    zsh \
    fish \
    # Network tools
    netcat \
    telnet \
    # Process tools
    procps \
    psmisc \
    # Archive tools
    zip \
    unzip \
    tar \
    gzip \
    # Text processing
    sed \
    awk \
    grep \
    # System monitoring
    iotop \
    iftop \
    && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh for better shell experience (optional)
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# Configure Git (will be overridden by user)
RUN git config --global init.defaultBranch main \
    && git config --global pull.rebase false \
    && git config --global core.autocrlf input

# Set up supervisor for background services
COPY .devcontainer/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create log directories
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/laravel \
    && chown -R vscode:vscode /var/log/laravel

# Set up cron for scheduled tasks
RUN mkdir -p /var/spool/cron/crontabs \
    && chown -R vscode:vscode /var/spool/cron/crontabs

# Install mailhog for email testing
RUN wget -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 \
    && chmod +x /usr/local/bin/mailhog

# Set working directory
WORKDIR /workspaces

# Switch to vscode user
USER vscode

# Set up shell environment for vscode user
RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc \
    && echo 'alias art="php artisan"' >> ~/.bashrc \
    && echo 'alias tinker="php artisan tinker"' >> ~/.bashrc \
    && echo 'alias serve="php artisan serve --host=0.0.0.0"' >> ~/.bashrc \
    && echo 'alias migrate="php artisan migrate"' >> ~/.bashrc \
    && echo 'alias fresh="php artisan migrate:fresh --seed"' >> ~/.bashrc \
    && echo 'alias test="php artisan test"' >> ~/.bashrc \
    && echo 'alias pest="./vendor/bin/pest"' >> ~/.bashrc

# Install Laravel installer and other tools for vscode user
RUN composer global require laravel/installer \
    && composer global require laravel/valet \
    && composer global require friendsofphp/php-cs-fixer \
    && composer global require phpstan/phpstan

# Create common directories
RUN mkdir -p ~/.config \
    && mkdir -p ~/.local/bin \
    && mkdir -p ~/.cache

# Set up Git hooks directory
RUN mkdir -p ~/.git-templates/hooks

# Expose ports
EXPOSE 8000 3000 5173 8025

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Default command
CMD ["/bin/bash"]