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

## Nix

### [Install nix](https://nixos.org/download.html)

### Setting up the binary cache

IMPORTANT: you must do this or you will build several copies of GHC!

You need to add the following sections to /etc/nix/nix.conf or, if you are a trusted user, ~/.config/nix/nix.conf.

substituters = https://cache.nixos.org https://cache.iog.io https://digitallyinduced.cachix.org https://static-haskell-nix.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= digitallyinduced.cachix.org-1:y+wQvrnxQ+PdEsCt91rmvv39qRCYzEgGQaldK26hCKE= static-haskell-nix.cachix.org-1:Q17HawmAwaM1/BfIxaEDKAxwTOyRVhPG5Ji9K3+FvUU=
experimental-features = nix-command flakes

### Build

```bash
nix build
```

### Wait...

The first build takes a while, even with binary cache activated. Afterwards it's super quick, as it only recompiles packages that have a newer hash. Take a break, do something else and come back later. The binary cache is really important, a full build without cache might easily take 10 hours or more.
