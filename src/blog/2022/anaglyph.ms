.DA 2022-07-13
.TL
3D Anaglyph Pro for Unity Now Available
.
.PP
.H https://assetstore.unity.com/packages/slug/222754 "Get 3D Anaglyph Pro on the Unity Asset Store!"
.IM $$(ROOT)$$/files/img/anaglyph0.webp "3D Anaglyph Pro"
.PP
.H https://assetstore.unity.com/packages/slug/222754 "3D Anaglyph Pro"
is a Unity asset that allows you to render high-quality 3D
anaglyphs in real-time.
I recently released this asset, after re-writing my
.H https://www.youtube.com/watch?v=4PcuNIqLdTw "old anaglyph effect"
from scratch, focusing on making something that is more usable by people and
produces more accurate anaglyphs.
See a test video of the effect in action
.H https://www.youtube.com/watch?v=LYmQpSpUJp8 here !
.
.PP
The new effect is a lot more customisable than the old one.
The eye separation width and convergence distance are now fully-adjustable, and
the effect internally uses a 3x6 matrix for determining output colours,
allowing for
.H https://www.site.uottawa.ca/~edubois/anaglyph/ "Dubois anaglyphs"
to be generated, and for maximum control over the output image.
A number of preset schemes are provided, making common schemes
(red/cyan, Dubois red/cyan, monochrome, etc.) easily-accessible to the user.
The effect by default uses a Dubois matrix for LCD screens, proposed by
Z. Zhang and D. M\[u1D9C]Allister
.H https://web.archive.org/web/20070206033630/http://research.csc.ncsu.edu:80/stereographics/ei06.pdf here .
The stereoscopic image pairs are now generated in a much more accurate fashion,
by making use of custom projection matrices, unlike the old method which
used two very basic offsetted cameras.
This means that the effect looks more realistic, as if you're really in the
scene!
Applying the effect is also incredibly simple, and is shown
.H https://www.youtube.com/watch?v=fQaAiNZ8Iro here .
.PP
3D Anaglyph Pro also supports using post-processing effects, in a clunky, but
functional way.
The way this is achieved is by allowing the user to manually specify a second
camera to use for the rendering of the second stereo image.
This gives the user full control over the effects on the second camera,
allowing them to apply any post-processing effects they like to it, which will
usually consist of those on the main camera.
Setting up the effect in this way is demonstrated in
.H https://www.youtube.com/watch?v=E_0ju-mX1hg "this guide on YouTube" .
.PP
Unfortunately the effect does come with a performance cost.
Having to render the scene twice in full (and apply post-processing effects
twice) means that the cost of rendering is twofold, and for complex scenes on
older or low-end hardware the effect may be too demanding.
Additionally, there are bugs in Unity that can sometimes prevent the effect
from operating at maximum efficiency, most notably in relation to occlusion
culling.
Unity has been known for years to not calculate culling matrices correctly with
oblique projection matrices
.H https://forum.unity.com/threads/occlusion-matrices-computed-incorrectly-by-unity.450827/ "see this forum thread" ), (
and despite
.H https://issuetracker.unity3d.com/issues/setting-the-cameras-culling-matrix-breaks-culling-for-oblique-matrices "many issues"
being opened in the Issue Tracker on the matter, these bugs still exist in the
engine today.
As a result, occlusion culling sometimes needs to be disabled when using the
anaglyph effect, to avoid artifacts caused by the improperly-calculated
culling matrix (i.e. objects popping in and out of view constantly).
However, this is usually only a problem in complex scenes, and when using large
eye separation widths.
