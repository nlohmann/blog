all:
	@echo "update"
	@echo "upload"

#update: tagebuch update_site originals quotes tidy_html minify_css

update: update_site originals tidy_html minify_css

# Update Tagebuch from Pad
tagebuch:
	head -n 11 source/tagebuch.md > tmp.md
	curl https://niels.piratenpad.de/ep/pad/export/ro.BRzE5G5k9v12Iz/latest?format=txt >> tmp.md
	mv tmp.md source/tagebuch.md

originals:
	-for SOURCEFILE in `ls -1 source/_posts/*.md`; do cp -v $$SOURCEFILE www/`echo $$SOURCEFILE | sed 's/source\/_posts\///' | sed 's/-//;s/-//;s/-/\//'`; done

update_site:
	@cd source ; jekyll build
	@rm -fr www
	@cp -Rp source/_site www

# seems not to work too well
quotes:
	-for HTMLFILE in `find www/* | grep .html`; do gsed -i 's/\&ldquo;/\&bdquo;/g;s/\&rdquo;/\&ldquo;/g' $$HTMLFILE; done

tidy_html:
	-for HTMLFILE in `find www/* | grep .html`; do  echo "Processing $$HTMLFILE"; tools/tidy-html5/bin/tidy -indent -wrap 0 -modify -quiet --drop-empty-elements false $$HTMLFILE; done
	@echo

minify_css:
	-for CSSFILE in `find www/assets/themes/tldr/* | grep .css`; do echo "Processing $$CSSFILE"; java -jar tools/yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar $$CSSFILE > $$CSSFILE~; mv $$CSSFILE~ $$CSSFILE; done

# see http://nb.nathanamy.org/2012/04/rsyncing-jekyll/
upload:
	rm -fr www/build www/serve
	rsync --compress --recursive --checksum --delete --itemize-changes -e ssh www/ root@nitpickertool.com:/projects/blog.nlohmann.me/www

serve:
	@cd source ; jekyll serve --watch

clean:
	rm -fr www/* source/_site
