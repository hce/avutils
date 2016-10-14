{ mkDerivation, attoparsec, base, HTTP, lens, optparse-applicative
, parsers, pretty-show, stdenv, text
}:
mkDerivation {
  pname = "avwx";
  version = "0.3.0.2";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ attoparsec base HTTP lens parsers text ];
  executableHaskellDepends = [
    base optparse-applicative pretty-show text
  ];
  testHaskellDepends = [ attoparsec base lens pretty-show text ];
  homepage = "https://www.hcesperer.org/posts/2016-09-20-avwx.html";
  description = "Parse aviation weather reports";
  license = stdenv.lib.licenses.mit;
}
