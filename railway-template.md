# Railway Deployment Options

## Option 1: Use Official Dify Railway Template (Recommended)
Click this link to deploy:
https://railway.app/new/template/dify

This will automatically:
- Create PostgreSQL database
- Create Redis instance
- Deploy Dify API and Web services
- Configure all environment variables

## Option 2: Manual Deployment

Since Railway doesn't support Docker Compose, you need to:

1. **Create a New Project in Railway**
2. **Add PostgreSQL Database**
   - Click "New" → "Database" → "PostgreSQL"
3. **Add Redis Database**
   - Click "New" → "Database" → "Redis"
4. **Deploy API Service**
   - Click "New" → "GitHub Repo"
   - Select `enablerdao/enabler-dify`
   - Set root directory to `/api`
5. **Deploy Web Service**
   - Click "New" → "GitHub Repo"
   - Select `enablerdao/enabler-dify`
   - Set root directory to `/web`

## Option 3: Use Alternative Platforms

For easier deployment with Docker Compose support:
- **Render.com**: https://render.com
- **DigitalOcean App Platform**: https://www.digitalocean.com/products/app-platform
- **Google Cloud Run**: https://cloud.google.com/run

## Environment Variables for Railway

```env
# Required
SECRET_KEY=${{secret}}
INIT_PASSWORD=your-admin-password

# Database (auto-configured by Railway)
DATABASE_URL=${{POSTGRES.DATABASE_URL}}
REDIS_URL=${{REDIS.REDIS_URL}}

# Optional API Keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```