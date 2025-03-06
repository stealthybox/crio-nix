slides.html: slides.md
	pandoc --standalone -t slidy --css extra.css slides.md -o slides.html

slides-alond.html: slides.md
	pandoc --standalone --embed-resources -t slidy --css extra.css slides.md -o slides.html

demo0:
	NIX_STORE=/opt/store nix shell --store /home/tom/flox/labs/opt/opt-store ~/nixpkgs#hello
