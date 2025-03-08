{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = _: {
    packages = builtins.mapAttrs (system: pkgs: {

      image = import ./image.nix {inherit pkgs;};

      source = pkgs.runCommand "source" {} ''
        cp -r ${_.self} $out
      '';
    }) _.nixpkgs.legacyPackages;
    devShells = builtins.mapAttrs (system: pkgs: {
      default = import ./shell.nix {inherit pkgs;};
    }) _.nixpkgs.legacyPackages;
  };
}
