# Deploying Dify on Railway

The Railway deployment failed because Railway doesn't support Docker-in-Docker operations. Here are the correct ways to deploy Dify on Railway:

## Option 1: Use Railway Template (Recommended)

1. Use the official Dify Railway template:
   ```
   https://railway.app/new/template/dify
   ```

2. Click "Deploy on Railway" and it will automatically provision:
   - PostgreSQL database
   - Redis instance  
   - Dify API service
   - Dify Web service
   - Nginx proxy

## Option 2: Manual Deployment with Separate Services

1. Create a new Railway project

2. Add PostgreSQL database:
   - Click "New" → "Database" → "PostgreSQL"
   - Note the connection details

3. Add Redis:
   - Click "New" → "Database" → "Redis"
   - Note the connection details

4. Deploy API service:
   ```yaml
   # railway.toml for API
   [build]
   builder = "dockerfile"
   dockerfilePath = "api/Dockerfile"

   [deploy]
   startCommand = "gunicorn --timeout 360 --workers 1 --worker-class gevent --bind 0.0.0.0:$PORT app:app"
   port = 5001
   healthcheckPath = "/health"
   
   [variables]
   MODE = "api"
   ```

5. Deploy Web service:
   ```yaml
   # railway.toml for Web
   [build]
   builder = "dockerfile"
   dockerfilePath = "web/Dockerfile"

   [deploy]
   startCommand = "npm run start"
   port = 3000
   healthcheckPath = "/"
   ```

## Option 3: Use Docker Compose Plugin

Railway has experimental Docker Compose support:

1. Install Railway CLI
2. Run: `railway up --docker-compose`

## Environment Variables Required

For any deployment method, set these variables in Railway:

```env
# Security
SECRET_KEY=<generate-a-secure-key>
INIT_PASSWORD=<admin-password>

# URLs (Railway will provide RAILWAY_PUBLIC_DOMAIN)
CONSOLE_API_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
CONSOLE_WEB_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
SERVICE_API_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
APP_API_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
APP_WEB_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}

# Database (Railway provides these)
DB_USERNAME=${{PGUSER}}
DB_PASSWORD=${{PGPASSWORD}}
DB_HOST=${{PGHOST}}
DB_PORT=${{PGPORT}}
DB_DATABASE=${{PGDATABASE}}

# Redis (Railway provides these)
REDIS_HOST=${{REDISHOST}}
REDIS_PORT=${{REDISPORT}}
REDIS_USERNAME=${{REDISUSER}}
REDIS_PASSWORD=${{REDISPASSWORD}}
REDIS_USE_SSL=true
CELERY_BROKER_URL=redis://${{REDISUSER}}:${{REDISPASSWORD}}@${{REDISHOST}}:${{REDISPORT}}/1?ssl_cert_reqs=CERT_REQUIRED

# Storage
STORAGE_TYPE=local
STORAGE_LOCAL_PATH=/app/storage

# Vector Database (optional, defaults to embedded)
VECTOR_STORE=weaviate
WEAVIATE_ENDPOINT=http://weaviate:8080
```

## Fixing "Unexposed Service" Error

The error occurs because:
1. No PORT environment variable is set
2. The service doesn't expose any ports
3. Railway can't detect which port to proxy

To fix:
1. Set PORT environment variable
2. Ensure your service binds to 0.0.0.0:$PORT
3. Add port configuration in railway.toml

## Alternative: Deploy on Other Platforms

If Railway deployment continues to fail, consider:

1. **Render.com** - Better Docker support
2. **Fly.io** - Full Docker Compose support  
3. **DigitalOcean App Platform** - Easy container deployment
4. **Google Cloud Run** - Serverless containers
5. **AWS ECS/Fargate** - Enterprise deployment

## Quick Fix for Current Deployment

To fix your current deployment:

1. Delete the existing Railway deployment
2. Use the official Dify Railway template: https://railway.app/template/dify
3. Or deploy services separately as shown above

The key issue is that Railway doesn't support running docker-compose inside containers, so you need to deploy each service (API, Web, Worker) as separate Railway services.