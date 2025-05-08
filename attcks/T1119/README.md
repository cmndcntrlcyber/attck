# T1119: Automated Collection

## Data Collection Components

This directory contains two complementary components for data collection:

1. **cf-collect** - Cloudflare Worker for traffic redirection
2. **collect.js** - Express-based collection server

Both components work together to implement the data collection infrastructure for the T1119 technique demonstration, but can also be used independently.

## Component 1: cf-collect Cloudflare Worker

The Cloudflare Worker acts as a traffic redirector that forwards all incoming requests to `https://attck-deploy.net/attcks/T1119/collect`.

### Purpose

The worker serves as a middle layer that can:
- Log and forward incoming traffic
- Preserve request metadata and payloads
- Maintain the original request methods, headers, and body content
- Create an additional layer of obfuscation for collection activities

### Deployment

To deploy this worker to Cloudflare:

1. Install Wrangler CLI: `npm install -g wrangler`
2. Authenticate: `wrangler login`
3. Test locally: `wrangler dev`
4. Deploy: `wrangler publish`

### Configuration

The worker is configured using the `wrangler.toml` file, which specifies:
- Worker name and main script
- Routes and triggers
- Environment variables

### Technical Details

The worker:
1. Captures all incoming requests
2. Preserves the original HTTP method
3. Maintains all headers from the original request 
4. Forwards the body content (if present)
5. Returns the response from the collection endpoint

## Component 2: collect.js Express Server

This is a Node.js Express server that receives and processes data sent to the collection endpoint.

### Purpose

The Express server provides:
- Direct data collection capabilities
- Detailed logging of all received data
- CORS support for cross-origin requests
- Request metadata capture (IP, user agent, etc.)
- Persistent storage of exfiltrated data

### Deployment

To run the collection server:

1. Install dependencies: `npm install`
2. Start the server: `npm start`
3. For development with auto-reload: `npm run dev`

### Technical Details

The server:
1. Listens for POST requests on `/attcks/T1119/collect`
2. Extracts incoming data and metadata
3. Logs all information to date-stamped files
4. Provides a minimal response to avoid detection
5. Offers a health check endpoint at `/attcks/T1119/health`

## Directory Structure

```
/T1119/
├── cf-collect.js      # Cloudflare Worker code
├── collect.js         # Express collection server
├── package.json       # Node.js dependencies
├── wrangler.toml      # Cloudflare Worker configuration
├── logs/              # Collection logs directory (created automatically)
│   ├── access.log     # HTTP access logs
│   └── data_*.json    # Collected data logs (date-stamped)
└── README.md          # This documentation
```

## Prerequisites and Environment Setup

### System Requirements

#### For the Cloudflare Worker (cf-collect.js)
- [Node.js](https://nodejs.org/) (v14.x or later)
- [npm](https://www.npmjs.com/) (v6.x or later)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/) (v2.x or later)
- A Cloudflare account with Workers enabled

#### For the Collection Server (collect.js)
- [Node.js](https://nodejs.org/) (v14.x or later)
- [npm](https://www.npmjs.com/) (v6.x or later)
- 50MB+ of disk space for logs (depending on collection volume)
- Network access on the configured port (default: 3000)

### Environment Setup

#### Setting Up the Cloudflare Worker

1. Install the Wrangler CLI:
   ```bash
   npm install -g wrangler
   ```

2. Authenticate with your Cloudflare account:
   ```bash
   wrangler login
   ```

3. Configure your `wrangler.toml` file with:
   - Your Cloudflare account ID
   - Appropriate zone settings
   - Custom routes if needed

4. For local development, use:
   ```bash
   wrangler dev cf-collect.js
   ```

#### Setting Up the Collection Server

1. Install dependencies:
   ```bash
   cd /path/to/T1119
   npm install
   ```

2. Create a `.env` file (optional) to override default settings:
   ```
   PORT=3000
   LOG_DIRECTORY=./logs
   ENABLE_CONSOLE_LOGGING=true
   ```

3. Start the server:
   ```bash
   node collect.js
   # Or with nodemon for development
   npx nodemon collect.js
   ```

### Configuration Options

#### Cloudflare Worker Configuration

The `wrangler.toml` file supports the following key configuration options:

- `name`: The name of your worker (default: "cf-collect")
- `main`: The main JavaScript file (default: "cf-collect.js")
- `compatibility_date`: Workers compatibility date
- `routes`: Array of routes that trigger the worker
- `vars`: Environment variables accessible to the worker

Example custom configuration:
```toml
[vars]
COLLECTION_ENDPOINT = "https://custom-domain.com/collect"
LOG_LEVEL = "debug"
```

#### Collection Server Configuration

The Express server can be configured via environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Port to listen on | 3000 |
| `LOG_DIRECTORY` | Directory for logs | ./logs |
| `ENABLE_CONSOLE_LOGGING` | Toggle console logging | true |
| `MAX_REQUEST_SIZE` | Maximum allowed request size | 10mb |
| `ALLOWED_ORIGINS` | CORS allowed origins | * |

You can set these variables in your environment or use a `.env` file.

### Testing the Setup

After setting up both components, you can test them using the included script:

```bash
# Make the script executable if needed
chmod +x test-collect.sh

# Run the test script
./test-collect.sh
```

This will send various test payloads to your collection endpoint.

## Security Considerations

These components demonstrate collection techniques used in the T1119 MITRE ATT&CK framework. In a production environment, additional security measures should be implemented such as:

- TLS/HTTPS for all communications
- Authentication for API endpoints
- Rate limiting to prevent abuse
- Input validation and sanitization
- Secure storage of collected data
- Regular log rotation and encryption
- Network-level protections and firewalls
