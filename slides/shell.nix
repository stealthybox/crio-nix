{pkgs}:
pkgs.mkShell {
   packages = [
     pkgs.dive
     pkgs.gnumake
     pkgs.pandoc
     pkgs.ran
   ];
}
