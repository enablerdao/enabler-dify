# Railway Deployment Guide for Enabler-Dify

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/deploy?template=https://github.com/enablerdao/enabler-dify)

## Quick Deploy via Railway Dashboard

1. **Go to Railway Dashboard**
   - Visit: https://railway.app/new

2. **Deploy from GitHub**
   - Click "Deploy from GitHub repo"
   - Select: `enablerdao/enabler-dify`
   - Railway will automatically detect the configuration files

3. **Environment Variables (Auto-configured)**
   The following are already set in the railway.toml:
   - `SECRET_KEY` - Auto-generated
   - `INIT_PASSWORD` - Set to: enabler-dify-2024
   - Database and Redis configurations

4. **Additional API Keys (Optional)**
   Add these in Railway dashboard > Variables:
   - `OPENAI_API_KEY` - Your OpenAI API key
   - `ANTHROPIC_API_KEY` - Your Anthropic Claude API key
   - `AZURE_OPENAI_API_KEY` - Azure OpenAI key
   - Other LLM provider keys as needed

5. **Access Your Instance**
   - Railway will provide a URL like: `https://enabler-dify.up.railway.app`
   - First access: Complete the setup wizard
   - Default admin password: `enabler-dify-2024`

## Manual Deployment with CLI

If you have Railway CLI access:

```bash
# Clone the repository
git clone https://github.com/enablerdao/enabler-dify.git
cd enabler-dify

# Set your Railway token
export RAILWAY_TOKEN=your-token-here

# Deploy
railway up
```

## Files Included

- `railway.json` - Service configuration
- `railway.toml` - Build and deployment settings
- `.railway/template.json` - Environment variable templates
- `.github/workflows/railway-deploy.yml` - GitHub Actions automation

## Support

For issues or questions:
- Check Railway logs in the dashboard
- Review Dify documentation: https://docs.dify.ai
- Open an issue: https://github.com/enablerdao/enabler-dify/issues