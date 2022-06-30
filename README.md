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

setup cache:

nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use static-haskell-nix

Variations:

a)

nix-env -iA nixpkgs.haskell.compiler.ghc8107

NIX_PATH=nixpkgs=nixpkgs nix-build --no-link
-- or
$(nix-build --no-link -A fullBuildScript)

b)
nix-env -iA nixpkgs.niv                                                                                                     :(
niv init
nix build -A schnorr
(nach 2 std: schnorr not found)
-- or
nix-env -iA nixpkgs.secp256k1
nix build
(neuester versuch, ghc 8.10.7 set)


ergebnis:
src/Crypto/Schnorr.hs:13:5: error:
parse error on input ‘-- * Messages’
|
13 |     -- * Messages
|     ^^^^^^^^^^^^^

error: builder for '/nix/store/hzi1w73m2l2hisgz81ngj2m2ajx1pacq-secp256k1-schnorr-lib-secp256k1-schnorr-0.0.1-haddock.drv' failed with exit code 1
error: 1 dependencies of derivation '/nix/store/lskqp5sb50h0167i5100jjrfdsn8yrj8-ghc-shell-for-schnorr-cli-config.drv' failed to build
error: 1 dependencies of derivation '/nix/store/q180m18bk037wibs6fh6pssa25ip4aci-ghc-shell-for-schnorr-cli-ghc-8.10.7-env.drv' failed to build
error: 1 dependencies of derivation '/nix/store/pcq8kfp9y43k318hbz0a94qay19jqg4g-ghc-shell-for-schnorr-cli.drv' failed to build
nix-build  2618,20s user 615,61s system 159% cpu 33:50,40 tota


ok jetzt nachdem ich kommentate in secp256k1-schnorr (haskell-code) gefixt habe
läuft ein neuer "nix-build" weiter an der stelle.


erfolg, aber wo ist die binary?

next try:

stack build