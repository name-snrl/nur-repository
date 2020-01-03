{ pkgs ? import <nixpkgs> {} }:

with pkgs;

rec {
  modules = import ./modules;

  cmake_3_16 = callPackage ./pkgs/cmake {};

  kotatogram-desktop = qt5.callPackage ./pkgs/kotatogram-desktop {
    inherit libtgvoip rlottie-tdesktop;
  };

  libtgvoip = callPackage ./pkgs/libtgvoip {};

  rlottie-tdesktop = callPackage ./pkgs/rlottie-tdesktop {};

  silver = callPackage ./pkgs/silver {};
}
