#!/bin/sh

#
# Generates the site RSS feed
#

BASE="https://mikejzx.github.io"

echo "updating RSS feed"

# Create the sorted article list
article_files=$(find src/blog -name '*.ms')
articles_sorted=$(
    for i in $article_files; do
        epoch=$(grep -Po '\.DA \K.*' "$i")
        epoch=$(date -d "$epoch" +"%s")
        dstfile=$(echo "$i" | \
            sed -e 's|\.ms$|\.html|' -e "s|^src|$PREFIX|")
        title=$(awk 'f{print;f=0} /\.TL/{f=1}' "$i")
        echo "$epoch $dstfile $title"
    done
)
articles_sorted=$(echo "$articles_sorted" | sort -nr)

# Generate RSS items
rss_content=$(echo "$articles_sorted" | while read -r i; do
    echo "<item>"

    # Insert title
    title=$(echo "$i" | cut -f3- -d' ')
    echo "<title>$title</title>"

    # Insert URIs
    uri=$(echo "$i" | awk '{print $2}' | sed -e "s|^$PREFIX\/||")
    echo "<guid>$BASE/$uri</guid>"
    echo "<link>$BASE/$uri</link>"

    # Insert published date
    rssdate=$(date \
        '+%a, %d %b %Y %H:%M:%S %z' \
        -d "@$(echo $i | awk '{print $1}')")
    echo "<pubDate>$rssdate</pubDate>"

    # Insert content
    htmlfile=$(echo "$i" | awk '{print $2}')
    html=$(tr "\n" "|" < "$htmlfile" | \
        grep -o '<article>.*</article>' | \
        sed 's/\(<article>\|<\/article>\)//g;s/|/\n/g')
    #html=$(cat "$htmlfile" | tr -d "\t")
    #html=$(awk '/^<article>/{p=1;next} p&&/^<\/article>/{p=0};p' "$htmlfile")
    echo "<description><![CDATA[$html]]></description>"

    echo "</item>"
done | sed -e ':a;N;$!ba;s/\n/\\n/g' -e 's#\&#\\&#g')

cp src/rss.xml $PREFIX/rss.xml
sed -i -e "s|<!-- rss_update_pos -->|$rss_content|" \
    -e 's#\ class="sentspc"##g' \
    -e 's#<span class="sntc">\([^<]*\)</span>#\1#g' \
    $PREFIX/rss.xml
echo "RSS feed updated, $(echo "$articles_sorted" | wc -l) articles"
