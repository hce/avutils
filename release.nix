let
  pkgs = import <nixpkgs> ( {
  } );
  version = "0.3.0.2";
  lambda = pkgs.haskell.packages.ghc801;
in
rec {
  avwx =
    lambda.callPackage ./avwx.nix { };
}
