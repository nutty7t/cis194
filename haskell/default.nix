let
  pkgs = import <nixpkgs> {};
  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

  pinnedNixpkgs = import src {};

in
  pinnedNixpkgs.haskellPackages.callPackage ./cis194.nix {}
