copy: _episodes/02-tradeoffs.md _episodes/03-bash.md _episodes/05-nosql.md 
_episodes/02-tradeoffs.md: DE2DSD/DSD1/README.md
	cp $< $@
_episodes/03-bash.md: ceudsd/seminar/Linux/README.md
	cp $< $@
_episodes/05-nosql.md: DE2DSD/DSD2-3-4/README.md
	cp $< $@
_episodes/08-knime.md: ceudsd/seminar/Knime/README.md
	cp $< $@
