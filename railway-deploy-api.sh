#!/bin/bash

# Railway API deployment script
TOKEN="81740f45-d599-43f5-9a9d-8c548239fc12"
API_URL="https://api.railway.app/v1"

# Create a new project
echo "Creating Railway project..."
PROJECT_RESPONSE=$(curl -s -X POST "$API_URL/projects" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "enabler-dify",
    "description": "Dify deployment for EnablerDAO",
    "isPublic": false
  }')

echo "Project creation response: $PROJECT_RESPONSE"

# Extract project ID
PROJECT_ID=$(echo $PROJECT_RESPONSE | grep -o '"id":"[^"]*' | grep -o '[^"]*$' | head -1)
echo "Project ID: $PROJECT_ID"

if [ -z "$PROJECT_ID" ]; then
  echo "Failed to create project. Response: $PROJECT_RESPONSE"
  exit 1
fi

# Create services
echo "Creating services..."

# Create PostgreSQL service
curl -s -X POST "$API_URL/projects/$PROJECT_ID/services" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "postgres",
    "source": {
      "image": "postgres:15-alpine"
    }
  }'

# Create Redis service
curl -s -X POST "$API_URL/projects/$PROJECT_ID/services" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "redis",
    "source": {
      "image": "redis:7-alpine"
    }
  }'

# Create main app service
curl -s -X POST "$API_URL/projects/$PROJECT_ID/services" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "dify",
    "source": {
      "repo": "https://github.com/enablerdao/enabler-dify"
    }
  }'

echo "Services created!"
echo "Visit https://railway.app/project/$PROJECT_ID to view your project"