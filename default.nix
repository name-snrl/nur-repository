{ pkgs ? import <nixpkgs> {} }:

with pkgs;

rec {
  modules = import ./modules;

  overlays = import ./overlays;

  cascadia-code-nerdfont = runCommand "cascadia-code-nerdfont" {} ''
    mkdir -p "$out/share/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${cascadia-code} -regex "$font_regexp" \
      -exec ${nerd-font-patcher}/bin/nerd-font-patcher -c '{}' "$out/share/fonts" \;
  ''

  exo2 = callPackage ./pkgs/exo2 {};

  exo2-nerdfont = runCommand "exo2-nerdfont" {} ''
    mkdir -p "$out/share/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${exo2} -regex "$font_regexp" \
      -exec ${nerd-font-patcher}/bin/nerd-font-patcher -c '{}' "$out/share/fonts" \;
  ''

  gtk-layer-background = callPackage ./pkgs/gtk-layer-background {};

  # Qt 5.15 is not default on mac, tdesktop requires 5.15 (and kotatogram subsequently)
  kotatogram-desktop = libsForQt515.callPackage ./pkgs/kotatogram-desktop {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreFoundation CoreServices CoreText CoreGraphics
      CoreMedia OpenGL AudioUnit ApplicationServices Foundation AGL Security SystemConfiguration
      Carbon AudioToolbox VideoToolbox VideoDecodeAcceleration AVFoundation CoreAudio CoreVideo
      CoreMediaIO QuartzCore AppKit CoreWLAN WebKit IOKit GSS MediaPlayer IOSurface Metal MetalKit;

    # C++20 is required, darwin has Clang 7 by default, aarch64 has gcc 9 by default
    stdenv = if stdenv.isDarwin
      then llvmPackages_12.libcxxStdenv
      else if stdenv.isAarch64 then gcc10Stdenv else stdenv;

    # tdesktop has random crashes when jemalloc is built with gcc.
    # Apparently, it triggers some bug due to usage of gcc's builtin
    # functions like __builtin_ffsl by jemalloc when it's built with gcc.
    jemalloc = (jemalloc.override { stdenv = llvmPackages.stdenv; }).overrideAttrs(_: {
      doCheck = false;
    });

    abseil-cpp = abseil-cpp_202111;
  };

  mir = callPackage ./pkgs/mir {};

  mirco = callPackage ./pkgs/mirco {
    inherit mir;
  };

  silver = callPackage ./pkgs/silver {};

  virtualboxWithExtpack = virtualbox.override {
    enableHardening = true;
    extensionPack = virtualboxExtpack;
  };

  #wlcs = callPackage ./pkgs/wlcs {};
}
