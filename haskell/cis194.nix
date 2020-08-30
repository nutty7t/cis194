{ mkDerivation, base, hspec, safe, stdenv, string-qq }:
mkDerivation {
  pname = "cis194";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hspec safe string-qq ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
