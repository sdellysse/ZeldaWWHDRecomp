{
  description = "Wind Waker HD development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs systems (system: function (import nixpkgs { inherit system; }));
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            clang
            cmake
            ninja
            pkg-config
            (python3.withPackages (pythonPackages: [ pythonPackages.pycryptodome ]))
            sdl3
            vulkan-headers
            vulkan-loader
            glslang
            zlib
            lz4
            zstd
          ];

          shellHook = ''
            export CC=clang
            export CXX=clang++
          '';
        };
      });
    };
}
