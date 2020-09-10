let
  pkgs = import <nixpkgs> {};
  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

  pinned = import src {};
  app = pinned.haskellPackages.callPackage ./cis194.nix {};
  lib = pinned.haskell.lib;

in
  # I copied this from https://stackoverflow.com/a/54280625.
  # I want to make a `shell.nix` file that combines the haskell build
  # environment with some development tools.
  lib.overrideCabal app (old: { buildTools = [ pinned.cabal-install pinned.cabal2nix ] ++ (old.buildTools or []); })
