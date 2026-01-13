#!/bin/bash
set -e

echo "Starting Parse Server..."
node --inspect=0.0.0.0:9229 \
  $(which parse-server) \
  --appId APPLICATION_ID \
  --clientKey CLIENT_KEY \
  --javascriptKey JAVASCRIPT_KEY \
  --masterKey MASTER_KEY \
  --allowClientClassCreation true \
  --databaseURI mongodb://mongo:27017/test \
  --cloud /app/cloud/main.js \
  --masterKeyIps "0.0.0.0/0,::0" \
  --verbose &

echo "Starting Parse Dashboard..."
parse-dashboard \
  --dev \
  --allowInsecureHTTP \
  --appId APPLICATION_ID \
  --masterKey MASTER_KEY \
  --serverURL "http://localhost:1337/parse" \
  --appName MY_APP &

wait
