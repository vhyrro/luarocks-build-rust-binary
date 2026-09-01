{
  description = "devShell for the luarocks-build-rust-binary build backend";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    pre-commit-hooks,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./nix/overlay.nix {inherit self;})
          ];
        };

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            stylua.enable = true;
            luacheck.enable = true;
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "luarocks-build-rust-binary devShell";
          shellHook = ''
            ${pre-commit-check.shellHook}
          '';
          buildInputs = with pre-commit-hooks.packages.${system};
            [
              alejandra
              stylua
              luacheck
            ]
            ++ (with pkgs; [
              (lua5_1.withPackages (ps: with ps; [luarocks luarocks-build-rust-binary]))
              cargo
            ]);
        };

        legacyPackages.fixtures = {
          inherit
            (pkgs.lua51Packages)
            vimcats
            ;
        };

        checks = {
          inherit
            pre-commit-check
            ;
          inherit
            (pkgs.lua51Packages)
            vimcats
            ;
        };
      };
    };
}
