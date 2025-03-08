{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = _: {
    packages = builtins.mapAttrs (system: pkgs: {


      image = pkgs.dockerTools.buildLayeredImage {
	name = "my-image";
	tag = "latest";
	contents = pkgs.buildEnv {
	  name = "my-env";
	  paths = [
	    pkgs.bash
	    pkgs.coreutils
	    pkgs.perl
	  ];
	};
        layeringPipeline =
            [
                ["subcomponent_out" [pkgs.perl]]
                ["over" "rest" ["pipe" [
                    ["popularity_contest"]
                    ["limit_layers" 100]
                ]]]
            ];
	config = {
	  Cmd = [ "/bin/bash" ];
	  Entrypoint = [ "/bin/bash" ];
	  WorkingDir = "/root";
	};
      };



      source = pkgs.runCommand "source" {} ''
        cp -r ${_.self} $out
      '';
    }) _.nixpkgs.legacyPackages;
    devShells = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShell {
        packages = [
          pkgs.dive
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
