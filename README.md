# Parse Server on Apple Silicon in Docker
This repo allows macOS users running Apple Silicon to start a Parse Server + MongoDB that supports [debugging CloudCode](#debugging-cloudcode).  I built this because I wanted to isolate Parse & Mongo in a container.  I published it because I found that getting this container running on Apple Silicon was somewhat non-trivial due to issues with mongo's aarch64 support.

I'm building on [Back4App](~~https://www.back4app.com/~~) so I followed their [local environment guide](~~https://www.back4app.com/docs/local-development/parse-server-local~~) and their [YouTube Guide](~~https://www.youtube.com/watch?v=Zy8k-B6FLzY~~).  

**WARNING** - This container has no security and is meant for local development only. Do not expose this container outside your local machine.

## Features
- Parse Server with Logs (see /logs)
- Parse Dashboard
- Parse CloudCode w/Debugging & Hot Reload in VSCode

## Requirements
- macOS on Apple Silicon
- Docker

## Getting Started
After cloning the repo, update your Parse client application's call to `Parse.initialize` to use the following parameters:
- applicationId: APPLICATION_ID
- clientKey: CLIENT_KEY
- javascriptKey: JAVASCRIPT_KEY
- masterKey: MASTER_KEY
- serverUrl: http://localhost:1337/parse

Next, update the volume path in `docker-compose.yml` to point to your app's CloudCode folder.  For example, let's assume your CloudCode is at `~/parse/cloud`.
```
# Change this line...
- ./cloud:/app/cloud:ro

# To this...
- ~/parse/cloud:/app/cloud:ro
```

Now you can build the container and verify it's working.
``` bash
# Build and start container
docker compose up --build --force-recreate

# Call CloudCode function to ensure it's working
curl -X POST http://localhost:1337/parse/functions/hello \
  -H "X-Parse-Application-Id: APPLICATION_ID" \
  -H "X-Parse-Client-Key: CLIENT_KEY" \
  -H "Content-Type: application/json" \
  -d '{}'
```

You can now use the container with your Parse application.  If you make changes to the container you can restart it with these commands.
``` bash
# Restart container
docker compose down
docker compose up --build --force-recreate
```

You're now up and running and can see your data running in the [Parse Dashboard](~~http://localhost:4040/~~) and can [debug](#debugging-cloudcode) your CloudCode. If you want to open a bash shell in the Parse server, here's your command.
``` bash
docker compose exec parse bash
```
## Debugging CloudCode
This repo supports debugging in VS Code via the `.vscode/launch.json`.  After starting your container, follow these steps to debug your CloudCode. 
1. Open this project in VS Code.
1. Open a CloudCode file (e.g. `cloud/functions.js`).
1. Set a breakpoint.
1. Run -> Start Debugging
1. Call the CloudCode function, e.g. in a shell, use curl as shown above.
1. View verbose debug logs of `parse-server` in Docker app.

## To Do
1. Support hot reloading of CloudCode - not sure this works yet.
