#!/bin/bash

# Railway deployment script for enabler-dify
export RAILWAY_TOKEN=81740f45-d599-43f5-9a9d-8c548239fc12

echo "Deploying to Railway..."

# Initialize Railway project
railway link

# Set environment variables
railway variables set SECRET_KEY=$(openssl rand -base64 42)
railway variables set INIT_PASSWORD=enabler-dify-2024
railway variables set CONSOLE_API_URL=\${{RAILWAY_PUBLIC_DOMAIN}}
railway variables set APP_WEB_URL=\${{RAILWAY_PUBLIC_DOMAIN}}
railway variables set SERVICE_API_URL=\${{RAILWAY_PUBLIC_DOMAIN}}
railway variables set FILES_URL=\${{RAILWAY_PUBLIC_DOMAIN}}

# Database configuration
railway variables set DB_USERNAME=postgres
railway variables set DB_PASSWORD=$(openssl rand -base64 32)
railway variables set DB_HOST=postgres.railway.internal
railway variables set DB_PORT=5432
railway variables set DB_DATABASE=dify

# Redis configuration
railway variables set REDIS_HOST=redis.railway.internal
railway variables set REDIS_PORT=6379
railway variables set REDIS_PASSWORD=$(openssl rand -base64 32)
railway variables set REDIS_USE_SSL=false

# Deploy
railway up

echo "Deployment initiated!"
echo "Check your Railway dashboard for deployment status"