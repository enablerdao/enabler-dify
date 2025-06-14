#!/bin/bash

echo "Setting up Railway CLI with provided token..."

# Create Railway config directory
mkdir -p ~/.config/railway

# Try different config file locations
cat > ~/.config/railway/config.json << EOF
{
  "token": "81740f45-d599-43f5-9a9d-8c548239fc12",
  "user": {
    "id": "enablerdao",
    "email": "enabler@dao.com"
  }
}
EOF

# Also try the legacy location
mkdir -p ~/.railway
cat > ~/.railway/config.json << EOF
{
  "token": "81740f45-d599-43f5-9a9d-8c548239fc12",
  "user": {
    "id": "enablerdao",
    "email": "enabler@dao.com"
  }
}
EOF

# Set environment variable
export RAILWAY_TOKEN="81740f45-d599-43f5-9a9d-8c548239fc12"

echo "Attempting to use Railway CLI..."
railway projects