# Parse Server on Apple Silicon in Docker
This repo allow macOS users running Apple Silicon to start a Parse Server + mongodb that supports debugging CloudCode.  I built this because I wanted to isolate Parse & Mongo in a container.  I published it because I found that getting a single Docker container with mongo, Node & Parse running on Apple Silicon was somewhat non-trivial due to issues with mongo's aarch64 support.

I'm building on [Back4App](https://www.back4app.com/) so I followed their [local environment guide](https://www.back4app.com/docs/local-development/parse-server-local) and their [YouTube Guide](https://www.youtube.com/watch?v=Zy8k-B6FLzY).  

**WARNING** - This container has no security and is meant for local development only. Do not expose this container the greater world.

## Features
- Parser Server with Logs (see /logs)
- Parse Dashboard
- Parse Cloud Code w/Debugging & Hot Reload in VSCode

## Requirements
- macOS on Apple Silicon
- Docker installed

## Getting Started
After cloning the repo, start the container and test that it's working.
``` bash
# Build and start container
docker compose up --build --force-recreate

# Call cloud code function to ensure it's working
curl -X POST http://localhost:1337/parse/functions/hello \
  -H "X-Parse-Application-Id: APPLICATION_ID" \
  -H "X-Parse-Client-Key: CLIENT_KEY" \
  -H "Content-Type: application/json" \
  -d '{}'
```
Update your application's call to `Parse:initializeWithConfiguration` to use the following parameters:
- applicationId: APPLICATION_ID
- clientKey: CLIENT_KEY
- serverUrl: http://localhost:1337/parse

If your application uses CloudCode update the volume path in `docker-compose.yml` so that it points to your app's cloud code folder, then restart the container.

``` bash
# Restart container
docker-compose down
docker compose up --build --force-recreate
```

You're now up and running and can see your data running in the [Parse Dashboard](http://localhost:4040/).

If you want to open a bash shell in the parse server here's your command.

``` bash
docker compose exec parse bash
```

## Debugging Cloud Code
This repo supports Debugging in VS Code via the `.vscode/launch.json`.  After starting your container follow these steps to debug your cloud code.
1. Open this project in VS Code
1. Open a cloud code file (e.g. `cloud/functions.js`)
1. Set a breakpoint in the function.
1. Run -> Start Debugging
1. Call the cloud code function, e.g. in a shell, use curl as shown above.
