{
  description = "Dev shell for alfonsoalba.com (Jekyll)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f (import nixpkgs {
            inherit system;
            # Allow only this specific unfree package
            config.allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
          }));
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # Tools you run interactively
          packages = with pkgs; [
            claude-code
            gh
            git
            git-lfs
            openspec
          ];

          # Tools used while building gems
          nativeBuildInputs = with pkgs; [
            ruby_3_4 # ships with bundler
            pkg-config # lets gems find the C libraries below
          ];

          # C libraries the gems compile against
          buildInputs = with pkgs; [
            libffi
            openssl
            zlib
            imagemagick
            vips
            glib
          ];
          # ruby-vips loads libvips at runtime via dlopen, which on NixOS
          # only works if the library directory is on LD_LIBRARY_PATH.
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [ vips glib ]);

          # Keep gems inside the project instead of the read-only Nix store.
          shellHook = ''
            export GEM_HOME="$PWD/.gems"
            export PATH="$GEM_HOME/bin:$PATH"
          '';
        };
      });
    };
}
