# Schnorr-CLI

CLI tools for using schnorr signatures.

## Usage
```bash
Schnorr-CLI

Usage: schnorr [--version] [--help] COMMAND
Generate keys, sign & verify schnorr messages

Available options:
--version                Show version
--help                   Show this help text

Available commands:
gen                      Generate a new keypair
pub                      Calculate the xonly pub key from given keypair
sign                     Sign with schnorr signature
verify                   Verify a schnorr signature
```

## Binaries

[Linux amd64](https://drive.google.com/file/d/1tce4oNqHikBUpRoTnjPWXGjXpnvrdqZt)
(SHA256 7c52c5920e988419c515637561682d6bcc5ac5239b8975c45117e28917625b25)

## Secp256k1 Dependency

```bash
-- optional
sudo apt remove sudo apt remove libsecp256k1-0 libsecp256k1-dev

git clone https://github.com/bitcoin-core/secp256k1
cd secp256k1
./autogen.sh
./configure --enable-module-schnorrsig --enable-module-extrakeys --enable-module-ecdh --enable-experimental
make
make install
```
