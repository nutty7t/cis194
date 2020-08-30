{ pkgs ? import <nixpkgs> {} }:

let
  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "7ff5a12af5750f94d0480059dba0ba6b82c6c452";
    sha256 = "0af25dqhs13ii4mx9jjkx2pww4ddbs741vb5gfc5ckxb084d69fq";
  }) {};

in
  pkgs.mkShell {
    buildInputs = easyPS.buildInputs ++ [ pkgs.nodejs ];
  }
