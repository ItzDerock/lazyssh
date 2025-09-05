{
  description = "lazyssh - A terminal-based SSH manager inspired by lazydocker and k9s";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages = rec {
            lazyssh = pkgs.buildGoModule {
              pname = "lazyssh";
              version = "0.2.0";
              src = ./.;
              vendorHash = "sha256-/RgjcAy2H9sWMWDA3QxMkT4LkzxvZqOZzKeR9u9bsH0=";

              postInstall = ''
                mv $out/bin/cmd $out/bin/lazyssh
              '';
            };

            default = lazyssh;
          };

          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                go
                gotools
                gnumake
              ];
            };
          };
        }
    );
}
