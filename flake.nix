{
  description = "Reusable Zig devshell component";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # The composable core. Takes `pkgs`, returns the pieces `mkShell` wants.
    # Callers pass *their own* pkgs so there's only one nixpkgs instance.
    lib.zigShell = pkgs: {
      packages = with pkgs; [ zig zigscient ];
      shellHook = ''
        export ZIG_BUILD_ERROR_STYLE=minimal
        export ZIG_BUILD_MULTILINE_ERRORS=newline
      '';
    };

    # Convenience: also usable standalone with `nix develop`.
    devShells.${system}.default = pkgs.mkShell (self.lib.zigShell pkgs);
  };
}
