slides.html: slides.md
	pandoc -s -t slidy --css extra.css slides.md -o slides.html


