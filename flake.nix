{
  description = "Interactively view git branches before you checkout";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    npmlock2nix.url = "github:nix-community/npmlock2nix";
    npmlock2nix.flake = false;
  };

  outputs = { self, nixpkgs, npmlock2nix }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (self: super: {
          npmlock2nix = pkgs.callPackage npmlock2nix {};
        })
      ];
    };

    cio-shell = pkgs.npmlock2nix.v2.shell {
      src = ./.;
      nodejs = pkgs.nodejs_latest;
      node_modules_mode = "symlink";
    };
  in
  {
    devShells.${system}.default = cio-shell;
  };
}
