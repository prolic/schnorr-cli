{
  description = "CLI tools for using schnorr signatures";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  };

  outputs = inputs:
    let
      makeNixpkgs = system:
        let projectOverlay = final: prev: {
          project = final.haskell-nix.project' {
            src = ./.;
            compiler-nix-name = "ghc8107";

            shell.tools = {
              cabal = { };
              ghcid = { };
            };
          };
        };

        in
        import inputs.nixpkgs {
          inherit system;
          inherit (inputs.haskell-nix) config;
          overlays = [ inputs.haskell-nix.overlay projectOverlay ];
        };

      flake = inputs.flake-utils.lib.eachDefaultSystem (system:
        (makeNixpkgs system).project.flake { });
    in
    inputs.nixpkgs.lib.attrsets.recursiveUpdate flake {
      # Must cross-compile from x86_64-linux only
      packages.x86_64-linux.default =
        (makeNixpkgs "x86_64-linux").pkgsCross.musl64.project.hsPkgs.schnorr-cli.components.exes.schnorr;
    };
}
