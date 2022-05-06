.DA 2022-05-04
.TL
New Roff-based Blog System
.PP
So, it's definitely been a good while since I last wrote anything here on my
site.
Though, fear not!
I am back, after having completely re-written my site from the ground up, I am
no longer using
.F ssg5
and
.F rssg ,
but rather a new Makefile-based system I built up myself, using my own scripts
and programs to generate this whole thing;
as the old site system was just so ugly and messy that it had become essentially
unmaintainable.
I think from hereon I'll try to make more of an effort to write more articles
here in time\(embecause as it stands, I feel like I am yet to have played my
part in serving the web with actually interesting content...
Especially in our current world where the web is dominated by bloat,
bombardment of obnoxious advertisements, trillion-dollar corporations, social
media, biased news, biased searches (looking at you DuckDuckGo, for just
recently hopping on the bandwagon too), SEO spam, and just plain rubbish
content. I hope my site provides you with a breath of fresh air through the
mostly text-based content over here.
.PP
The new site generation system is fairly straight-forward.
As you'd imagine; a nice source directory with HTML files for most things, a
few `templates', and the `blog' section with it's source files.
I have general rules in the Makefile which automate most things, like updating
the stylesheet, copying over new files, and re-compiling articles when they
change, etc.
I also wrote a simple script that runs when articles are added or changed, that
generates a nice RSS feed of the blog.
However, the main new interesting thing about the blog, is that I no longer
need to write it using Markdown.
Instead, I now write these articles using a variation of the Roff `ms' macros!
(Converted my old articles to the new format, though I skipped the small useless
articles that have essentially lost all their relevance now).
This probably sounds incredibly stupid, and possibly even masochistic, but
there is I think a possibly interesting reason I chose this format of all other
formats.
The reason essentially boils down to typography.
If you've got eagle eyes or if you pay particularly close attention to the
typographic subtleties of content you read, then you may have noticed the
specific effect I aimed for here.
.PP
Specifically, I was aiming for proper
.I "sentence spacing"
in my webpage.
I developed somewhat of a habit at some point last year where I started putting
two spaces after sentences I was writing to indicate the end of sentences more
clearly (e.g. in plaintext documents); I have no idea how this habit started;
but in general I feel like after I discovered and realised it was a thing, I
found it a lot more aesthetically pleasing than the robotic
word-spacing-after-sentences that has become ever-increasingly ubiquitous in
modern times.
Perhaps it was also due to a desire to stick to a more conservative,
`traditional' way of formatting text, which had unfortunately faded in the last
few decades due to all sorts of reasons
.H https://www.tomsarazac.com/tom/opinions/space-after-periods.html see ), (
most notably of which here on the web was due to some technical limitations of
HTML.
As of course, HTML normalises all whitespace between words into uniform
spacing, the specification does not provide any
.F <sentence>
tag to use for this purpose, and there seemed to be very little concern for the
typographic implications of this at the time.
(Edit: see
.I Addendum
at the bottom of the article).
.PP
So to implement this new feature, my first idea was to just borrow the
convention used in Roff for sentence separation, and use it in Markdown.
For the sake of brevity\(emfor people who haven't used a Roff typesetting system
before (e.g. the GNU implementation,
.F groff )\(emI'll
simply state that in Roff, you are expected to start sentences on lines of
their own, to indicate to the typesetter that when a line ends with
sentence-ending punctuation such as a full-stop, question mark, or exclamation
mark, it is going to be the end of a sentence (there is a workaround for
situations where you
.I don't
want a line that ends with this kind of punctuation to be considered the end of
a sentence, by using a zero-width space escape character).
At first glance, one would assume that using this same convention for
indicating the end of a sentence should be relatively straight-forward to use
in Markdown.
And indeed, you can write a basic ``Markdown'' parser that achieves this,
finding the correct ends of sentences in
.I paragraphs
based on where the lines start and end.
However, the system would fall apart once list items are taken into
consideration; and it was the thing I stumbled upon while I myself were having
a go at writing a basic Markdown parser that did this.
In Markdown, lists items can only be defined on a single line.  However, in
Roff, a ``list item'' is actually just an indented paragraph with a bullet
point next to it, so it doesn't suffer from this problem.
.PP
I feel like the cause of this issue goes back to the roots of what Markdown
really was intended to be used for.
I had read an article not long ago on the web by Adam Hyde, where he poses the
question
.H https://www.adamhyde.net/whats-wrong-with-markdown/ "``What's wrong with Markdown?''" ,
and puts forth a few points.
He expresses his view that Markdown generally has very limited use cases, and
suggests that, ``Markdown isn't designed for creating HTML'', which is perhaps a
little exaggerated, as John Gruber, the author of Markdown, introduces it
.H https://daringfireball.net/projects/markdown/ "on his site"
(which Hyde also links) not only as ``a text-to-HTML conversion tool for web
writers'', but also notes that the structure of Markdown places a strong
emphasis on being ``publishable as-is, as plain text, without looking like it's
been marked up with tags or formatting instructions'', i.e. it should be
possible to read a Markdown document in it's
.I verbatim
form (as Hyde indeed notes, but not necessarily to the extent that he suggests).
This in turn creates a format that needs to make compromises in it's ability to
be converted to HTML, to allow for easy reading of the source content.
This, and the lack of a proper specification, are why there are so many
``variations'', of Markdown in the wild\(emit seems almost as though each
website has their own additions and exclusions to the format.
Another thing to note is that Markdown is more often converted to HTML than
it is published as-is, and hence there is more incentive to add more things that
help in the HTML conversions, but also then create a compromise
in the verbatim reading experience of the content (inline links being a notable
offender here) which then defeats one of the original purposes of the format.
This is especially problematic when ``the single biggest source of inspiration
for Markdown’s syntax is the format of plain text e-mail.''
.PP
I will note, that technically it could be possible to achieve this in Markdown,
or any markup language for that matter; and that is through some kind of
automatic sentence-detection software.
The approach here would be to write up your document as you normally would, in
Markdown or whatever, possibly generate the HTML from it to split it into
paragraphs and list items and so on, then run some kind of post-processor that
looks at the content within each tag and attempts to split them into sentences.
This is definitely possible, I've actually written some code for a project of
mine that does this, a terminal Gemini client called
.F sr71
that interprets paragraphs as an array of words and applies the spacing on it's
own; and is accurate in most cases for determining the end of sentences, via a
few rules that I defined.
(I also implemented, as an experiment, various other really nice typographic
features into
.F sr71 ,
like a Knuth-Plass approach to line breaking, which yields really nice
text-justification in the terminal, with hanging punctuation too\(emyou should
check it out if you too sometimes browse Geminispace or Gopherspace!)
The obvious problem with the approach of automated sentence detection is that
the software will inevitably make errors, as it's incredibly difficult to
program a piece of software to detect literally every possible case of where a
sentence would end.
Perhaps a solution like this is fine for reading content other people have
written, but as the author of the text content, I feel like I should have the
ability to specify where my sentences end.
.PP
Another possible method of achieving this in Markdown or other languages, that
.I does
give the writer control over the situation, would be to define some kind
of `sentence-end' escape sequence.
This would work fine to achieve the desired effect, but in my opinion I think
it'd end up really detracting from the writing experience and in the case of
Markdown, would contribute to the whole problem mentioned earlier about `adding
features to improve HTML output at the cost of readability in the source
format'.
I think it'd be more trouble than it's worth and best to just leave something
like Markdown behind, and focus on using a more versatile format.
.PP
After establishing that Markdown was unsuitable for my needs, I immediately
turned to the alternative I had considered beforehand, even before I started
writing my parser program.
Roff had always been a system that I quite enjoyed writing in; being a
traditional Unix document preparation system, it has a very nice and old-school
feel to it, and in some sense is designed to be compatible with the Unix
computing ethos, having source formats that are very easily `greppable',
and compatible with other tools on Unix-like systems.
However, while I enjoyed using Roff, I found that my uses for it had diminished
somewhat after discovering LaTeX.
Using Roff over LaTeX when LaTeX was just as easily available at my fingertips
was a bit like, in lieu of a better analogy; a sports car owner deciding to
take his wife's family sedan to a drag strip; sure it might be fun in a while,
but if you want a good performance you'd instead take the latter.
.PP
Obviously, my system isn't a `real' Roff system\(emI'm using a parser I
wrote myself, instead of an actual Roff system like
.F groff ,
which is actually a system with many more layers to it than one would think,
and my macro set isn't an `official' one; it just takes heavy inspiration from
the `ms' macros and includes my own additions to make it more usable for web
writing and excludes things that I don't have a use for just yet.
Of course, we just criticised Markdown for this very thing; not being
standardised and having loads of variations, but I think it's a lot more
acceptable with Roff, as the system is somewhat intended to be used in
this manner and you don't create any compromises that contradict the original
purposes of the format, such as plaintext readability (which doesn't at all seem
to be a goal of any Roff macro packages).
The macros that are exclusive to my macro set can easily be recreated in a
true Roff system, so it should be a reasonably trivial process to compile the
source documents to other formats such as to plaintext, PDFs, etc.
One thing I should mention in case anyone wonders, is that I actually did
somewhat consider beforehand to just compile my `.ms' source files to webpages
using
.F groff 's
provided `grohtml' driver.
The reason I didn't use it however was simply due to the reduced control I had
over the output.
Not only would it be tricky to get
.F grohtml
to place all the necessary
.F <span> 's
needed for the sentence-spacing effect I mentioned before; I also generally
just liked the fact that I could use a small program I had written myself, and
have complete control over the output it produces.
Using a true Roff system here would yield essentially no benefits that I can
think of, other than perhaps `authenticity', which isn't really of concern for
little webpages that barely anyone is even going to read in the first place!
.PP
I'll also just briefly mention the technique I used to achieve the nice sentence
spacing feature with my parser in case anybody was wondering.
I discovered the method through an article posted in 2012 on the subject;
.H https://hea-www.harvard.edu/~fine/Tech/html-sentences.html here .
It's an interesting read and outlines many different methods of achieving it,
and comparing each method to determine the best approach at the moment.
As I alluded to earlier, it involves separating sentences into
.F <span> 's
within the
.F <p>
paragraph tag, and then applying certain CSS rules to both elements.
To achieve correct spacing (and for it to work properly with text
justification), the sentence
.F <span> 's
need to have their
.F word-spacing
property set to zero, and the surrounding paragraph needs to have it's
.F word-spacing
set to the amount of space you want between sentences.
That's essentially all there is to it.
It is a bit finnicky and possibly error-prone when applying this method to raw
HTML by hand, as you would need to type out
.F "<span class=\(dqsentence\(dq>"
literally every time you need to separate a sentence which would probably be
irritating to the point where you'd probably forget what you're even writing
about.
Unless of course you're a Vim user or something and would've thought to set up
some kind of mapping so that this sort of thing is all automated.
However, with a system that takes in source files like the one I have here, it
works great and produces really nice results!
.PP
I've made my Roff-to-HTML parser available on GitHub under a GPLv3 license,
under the title
.H https://github.com/mikejzx/broff.git broff ', `
which sounded like a clever name at first, but sounds kind of stupid at the
same time.
The idea was that it was meant to be a contraction of `blog roff' as I guess
blogging is the intended purpose of it?
Maybe it could also be for `web roff', I'll let whoever happens to stumble
across it decide.
.
.NH 2
Addendum
.PP
Not long after writing this post I discovered that there exists an additional
method to achieve sentence spacing in HTML; that is to use the CSS
.F white-space
property on text to allow consecutive spaces to be preserved.
The advantage of this approach is that it's just a simple CSS rule; no
additional styling is needed and the HTML tags can be left alone.
This means that it can be used to easily achieve sentence spacing with content
converted from Markdown, or even with the
.F grohtml
web troff driver.
A disadvantage of this approach though is that you can't have precise control
over how wide the sentence space should be; you can only adjust it in terms of
the font's space character by adding more or less spaces after sentences.
Another problem I noticed is that there are no suitable values for this
property that both allow for whitespace preservation and collapse new-lines.
In other words, if you set e.g.,
.F "white-space: break-spaces"
then you will need to be mindful of any linefeed characters that you include
within your paragraph tags as they will all be interpreted as explicit line
breaks.
.PP
Despite these revelations, and some of the reasons for my new system having
become less just, I am still fairly happy with the system I'm already using as
outlined above, so I will continue to use it.
Maybe one day I might have a play around with
.F grohtml
and decide whether it's worth using or not (as it stands I think it does a bit
.I "too much"
for my needs).
