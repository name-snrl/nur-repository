name: "Cachix"
on:
  pull_request:
  push:
jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2.4.0
    - uses: cachix/install-nix-action@v16
      with:
        nix_path: nixpkgs=channel:nixos-unstable
    - uses: cachix/cachix-action@v10
      with:
        name: ilya-fedin
        authToken: '${{ secrets.CACHIX_AUTH_TOKEN }}'
    - run: nix-build
