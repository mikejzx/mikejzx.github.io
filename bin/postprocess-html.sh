#!/bin/sh

#
# HTML post-processing script.
#
# All we do here is evaluate some specific expressions, like $$(ROOT)$$ so that
# we can view the pages offline or online as needed.
#

is_final="$2"

echo "post-processing $1 ..."

MATCH_ROOT='\$\$(ROOT)\$\$'
MATCH_NAVBAR='\$\$(NAVBAR)\$\$'
MATCH_HEADER='\$\$(HEADER)\$\$'
MATCH_FOOTER='\$\$(FOOTER)\$\$'
MATCH_ARTICLE_LIST='\$\$(ARTICLE_LIST)\$\$'
MATCH_ARTICLE_TITLE='\$\$(ARTICLE_TITLE)\$\$'

src_navbar="$(cat src/templates/_navbar.html | sed ':a;N;$!ba;s/\n/\\n/g')"
src_header="$(cat src/templates/_header.html | sed ':a;N;$!ba;s/\n/\\n/g')"
src_footer="$(cat src/templates/_footer.html | sed ':a;N;$!ba;s/\n/\\n/g')"

# Macros
sed -i -e "s|$MATCH_NAVBAR|$src_navbar|" "$1" \
    -e "s|$MATCH_HEADER|$src_header|" "$1" \
    -e "s|$MATCH_FOOTER|$src_footer|" "$1"

# Article list handling
if grep -Eq '\$\$\(ARTICLE_LIST\)\$\$' "$1"; then
    # Create the article list
    article_files=$(find src/blog -name '*.ms')

    articles_sorted=$(
        for i in $article_files; do
            epoch=$(grep -Po '\.DA \K.*' "$i")
            epoch=$(date -d "$epoch" +"%s")
            dstfile=$(echo "$i" | \
                sed -e 's|\.ms$|\.html|' \
                    -e 's|src/blog/|\$\$(ROOT)\$\$/blog/|')
            title=$(awk 'f{print;f=0} /\.TL/{f=1}' "$i" | sed -e 's#\&#\\&amp;#g')
            echo "$epoch $dstfile $title"
        done
    )
    articles_sorted=$(echo "$articles_sorted" | sort -nr)

    article_list=$(
        echo "$articles_sorted" | while read -r i; do
            date=$(date -d "@$(echo "$i" | awk '{print $1}')" +"%Y-%m-%d")
            link=$(echo "$i" | awk '{print $2}')
            title=$(echo "$i" | cut -f3- -d' ')
            if [ -z "$title" ]; then
                title="(untitled entry)"
            fi
            echo "\t\t\t\t<li>$date \&mdash; <a href='$link'>$title</a></li>"
        done
    )
    article_list_final=$(echo "$article_list" | sed -e ':a;N;$!ba;s/\n/\\n/g')

    sed -i -e "s|$MATCH_ARTICLE_LIST|$article_list_final|" "$1"
fi

# Apply root prefix
if [ "$is_final" = 0 ]; then
    sed -i -e "s#$MATCH_ROOT#file://$(pwd)#g" "$1"
else
    sed -i -e "s#$MATCH_ROOT##g" "$1"
fi
