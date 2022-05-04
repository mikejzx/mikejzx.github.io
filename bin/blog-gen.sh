#!/bin/sh

# Generate blog post HTML from source roff document
# * Arg 1: source roff file
# * Arg 2: output HTML file

roff="$1"
html="$2"

HEADER=src/templates/_header.html
FOOTER=src/templates/_footer.html
TITLE_EXTRA=" \&ndash; Mike\&rsquo;s Blog"

ROFF_TO_HTML=broff

# Write the header
cat "$HEADER" > "$html"

# Set the title in the header
title=$(awk 'f{print;f=0} /\.TL/{f=1}' "$roff" | sed -e 's#\&#\\&amp;#g')
sed -i -e 's#\$\$(ARTICLE_TITLE)\$\$#'"$title$TITLE_EXTRA"'#' "$html"

# Convert the Markdown to HTML
"$ROFF_TO_HTML" "$roff" >> "$html"

# Write the footer
cat "$FOOTER" >> "$html"
