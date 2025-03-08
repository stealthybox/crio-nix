{ pkgs }:
with pkgs;
dockerTools.buildLayeredImage {
  name = "my-image";
  tag = "latest";
  contents = buildEnv {
    name = "my-env";
    paths = [
      bash
      coreutils
      perl
    ];
  };
  layeringPipeline = [
    [ "subcomponent_out" [ perl ] ]
    [ "over" "rest"
      [ "pipe" [ [ "popularity_contest" ] [ "limit_layers" 100 ] ]
    ]]];

  config = {
    Entrypoint = [ "/bin/bash" ];
    WorkingDir = "/root";
  };
}
