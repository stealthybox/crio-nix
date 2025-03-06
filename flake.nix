{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  outputs = _: {
    packages = builtins.mapAttrs (system: pkgs: {
      source = pkgs.runCommand "source" {} ''
        cp -r ${_.self} $out
      '';
    }) _.nixpkgs.legacyPackages;
    devShells = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.gnumake
          pkgs.pandoc
          pkgs.ran
        ];
        shellHook = ''
        '';
      };
    }) _.nixpkgs.legacyPackages;
  };
}
