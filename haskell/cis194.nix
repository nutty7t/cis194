{ mkDerivation, base, hspec, safe, stdenv }:
mkDerivation {
  pname = "cis194";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hspec safe ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
