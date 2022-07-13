# Whether the current build is final copy for server (set it via envvar)
IS_FINAL?=0

PREFIX=.

# HTML source and outputs
SRC_HTML=$(shell find -L src -name '*.html' | sed '/\/templates\//d')
OUT_HTML=$(patsubst src/%,$(PREFIX)/%,$(SRC_HTML))

# CSS source and output directory (and other files)
OUT_CSS=$(PREFIX)/css
OUT_FILES=$(PREFIX)/files

# Blog
SRC_BLOG=$(shell find -L src/blog -name '*.ms')
OUT_BLOG=$(patsubst src/%.ms,$(PREFIX)/%.html,$(SRC_BLOG))

# RSS feed
RSS=$(PREFIX)/rss.xml

.PHONY: all clean

# Directories we need under the dest directory
SRC_DIRS=$(shell find -L src -type d | sed '/\/templates/d;/\/css/d;/\/files/d;/\/blog_wip/d')
DIRS=$(patsubst src/%,$(PREFIX)/%,$(SRC_DIRS))

all: dirs $(OUT_HTML) $(OUT_CSS) $(OUT_FILES) $(OUT_BLOG) $(RSS)

dirs: $(DIRS)

# Generate blog HTML from roff
$(PREFIX)/blog/%.html: src/blog/%.ms
	PREFIX=$(PREFIX) bin/blog-gen.sh $< $@
	PREFIX=$(PREFIX) bin/postprocess-html.sh $@ $(IS_FINAL)

# Post-process pages that are in HTML
$(PREFIX)/%.html: src/%.html
	cp $< $@
	PREFIX=$(PREFIX) bin/postprocess-html.sh $@ $(IS_FINAL)

# Update blog index separately so we can set the title
$(PREFIX)/blog/index.html: src/blog/index.html
	cp $< $@
	PREFIX=$(PREFIX) bin/postprocess-html.sh $@ $(IS_FINAL)
	sed -i -e 's#\$$\$$(ARTICLE_TITLE)\$$\$$#Mike\&rsquo;s blog#' $@

# Link CSS
$(OUT_CSS):
	ln -s ./src/css $(OUT_CSS)

# Link files
$(OUT_FILES):
	ln -s ./src/files $(OUT_FILES)

# RSS feed, updates when blog articles update
$(RSS): $(OUT_BLOG) src/rss.xml
	PREFIX=$(PREFIX) bin/rss-gen.sh

$(DIRS):
	mkdir -p $(DIRS)

clean:
	rm -rf $(PREFIX)/blog/**/*.html $(PREFIX)/blog/*.html $(PREFIX)/*.html $(OUT_CSS) $(OUT_FILES) $(OUT_BLOG)
