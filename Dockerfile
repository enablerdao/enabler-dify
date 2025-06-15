# Multi-stage build for Dify on Railway
FROM ubuntu:22.04 AS base

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    curl \
    python3 \
    python3-pip \
    postgresql-client \
    redis-tools \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install PM2 globally
RUN npm install -g pm2

# Create app directory
WORKDIR /app

# Copy configuration files
COPY docker/nginx/nginx.conf.template /etc/nginx/nginx.conf.template
COPY docker/nginx/proxy.conf.template /etc/nginx/proxy.conf.template

# Create supervisord configuration
RUN mkdir -p /etc/supervisor/conf.d
COPY <<EOF /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid

[program:nginx]
command=nginx -g 'daemon off;'
autostart=true
autorestart=true
stdout_logfile=/var/log/nginx/access.log
stderr_logfile=/var/log/nginx/error.log

[program:api]
command=cd /app/api && python -m gunicorn --timeout 360 --workers 1 --worker-class gevent --worker-connections 10 --bind 0.0.0.0:5001 app:app
environment=MODE="api"
autostart=true
autorestart=true
stdout_logfile=/var/log/api.log
stderr_logfile=/var/log/api_error.log

[program:worker]
command=cd /app/api && celery -A app.celery worker --loglevel=info --concurrency=1
environment=MODE="worker"
autostart=true
autorestart=true
stdout_logfile=/var/log/worker.log
stderr_logfile=/var/log/worker_error.log

[program:web]
command=cd /app/web && pm2-runtime start --no-daemon ./pm2.json
autostart=true
autorestart=true
stdout_logfile=/var/log/web.log
stderr_logfile=/var/log/web_error.log
EOF

# Copy API application
FROM langgenius/dify-api:1.4.2 AS api-stage
FROM langgenius/dify-web:1.4.2 AS web-stage

# Final stage
FROM base

# Copy API files
COPY --from=api-stage /app /app/api

# Copy Web files  
COPY --from=web-stage /app /app/web

# Create required directories
RUN mkdir -p /var/log/supervisor /var/log/nginx /app/storage

# Configure nginx
RUN envsubst '$NGINX_PORT $NGINX_SERVER_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]