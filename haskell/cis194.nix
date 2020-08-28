{ mkDerivation, base, hspec, stdenv }:
mkDerivation {
  pname = "cis194";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hspec ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
