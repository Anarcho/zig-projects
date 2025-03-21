{
  description = "Anarchos Zig 0.14.0 Flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zig-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    zig-overlay,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      zig-ver = "0.14.0";
      zigPkg = zig-overlay.packages.${system}.${zig-ver};
    in {
      devShells.default = pkgs.mkShell {
        name = "zig-dev";
        buildInputs = [
          zigPkg # Zig 0.14.0 from zig-overlay
          pkgs.zls # ZLS from nixpkgs-unstable
          pkgs.lldb
        ];
      };
    });
}
