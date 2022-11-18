.DA 2022-08-28
.TL
Controller Mappings for Gran Turismo 1-4 Emulation
.PP
I've always been a fan of the Gran\~Turismo series of games, and in the last
year or two have been playing around with running these games in an emulator on
PC.
The classic PS1 games run flawlessly in the DuckStation emulator, and the
PS2-era games work well in the PCSX2 emulator.
In general, you are able to play the games just as if you were playing on a
real console (although sometimes playing on the real thing just makes these
games feel that extra bit more nostalgic).
.PP
Playing games like this in an emulator has certain advantages.
The resolution of the games can be adjusted (if you're into that sort of thing;
I personally prefer emulating at the native resolution), you are able to create
virtual memory cards, and manage your saves in bizarre ways (not to mention the
ability to create save states that you can return to in the game).
.PP
One advantage of playing in an emulator, that would be incredibly difficult if
using real console hardware, is the ability to remap the controller's buttons
and axes to essentially whatever you desire.
This is especially very useful for these old racing games like Gran\~Turismo,
particularly in relation to having
.B analog
accelerator brake inputs, which will be one of the main focuses of this article.
.
.NH 2
The Goal
.PP
The goal here is to remap the controller in such a way that will allow for easy
modulation of the accelerator and brake inputs in the game.
Generally, racing games that came out from the PS3-era onwards would usually
use the left and right analog trigger buttons (L2 and R2) for the brake and
accelerator respectively, as this is a fairly modest scheme and is very easy to
use (and it quite familiar to most people, having been used in popular games
such as Grand\~Theft\~Auto IV and V).
Many players of Gran\~Turismo\~5 and 6 on the PS3 would map their controllers
in this way, and I believe that later games like GT\~Sport and Gran\~Turismo\~7
use these mappings by default.
.PP
Traditionally, the only way an analog throttle/brake could've been achieved in
the PS1 games (other than using a wheel with pedals, etc.), was to adjust the
in-game controller mapping settings to use one of the analog sticks (e.g. the
up-down axis of the right stick) to be mapped to the accelerator and brake.
The game is playable in this way, and there are people who have played the game
like this for years and never looked back.
The DualShock\~2 controllers that were used on the PS2 were interesting in that
most buttons on it were pressure-sensitive; this meant that the standard Cross
for accelerate, and Square for brake, worked reasonably well as the player
was able to at least modulate the pressure they put on these buttons.
.PP
However, the DualShock\~2's pressure-sensitive face buttons turned out to be
not much more than a mere quirk, as we would never see this feature again in
later controllers like the DualShock\~3 and Xbox gamepads.
Since these later gamepads like the DualShock\~3 (that I use) don't have
pressure-sensitive buttons, using them to play the PS2 Gran\~Turismo games
in an emulator means that you face the same dilemma as that of the early PS1
games\(emif you wish to modulate the accelerator and brake, your only option is
to map the analog sticks.
One nice feature of the DualShock\~3 PS3 controllers (and I believe Xbox 360
gamepads) is that their trigger buttons are in fact analog and use their own
axis.
The problem here of course, is that DualShock\~2 controllers didn't have this
axis, and therefore the games (and emulators) cannot take advantage of it.
.PP
Thankfully, there is a workaround to this to allow us to use this extra axis
for the accelerator and brake inputs in the old Gran\~Turismo games.
The technique that will be used here will be to map the accelerator and brake
to the analog sticks using the in-game input mapper, and then on top of this,
apply our own custom mappings to the controller itself, through the use of
external tools.
To get an idea of this more clearly; imagine that in the game, we map the
accelerator and brake to the Y-axis of the right analog stick.
That is, the accelerator is pressed as the right analog stick is pushed upward,
and the brake is pressed as the right-analog stick is pushed downward.
By applying our own mappings externally, we can ``hack'' this using a mapping,
so that the left analog trigger of the controller is used to control
(virtually) how much the analog stick is pushed down (for brake), and the right
trigger is mapped to control how much the stick is pushed up (for accelerator).
By doing this we are able to use the left/right analog triggers (L2 and R2) of
the controller to comfortably modulate the brake and accelerator inputs of the
PS1 and PS2 games.
.
.NH 2
Achieving the External Mappings
.PP
This article is catered towards Linux users because of the totally non-existent
documentation of how this can be achieved easily and intuitively on these
operating systems.
.PP
Presumably most people who find this article will be Windows users perhaps
wondering how they can achieve these sorts of mappings.
If you are on Windows, the process of achieving this  is actually rather
straight-forward; all that you will need is some sort of external controller
mapping utility.
One that I have used in the past for DualShock\~3 that works perfectly is
BetterDS3, however, this tool requires that you have the MotionInJoy
DualShock\~3 drivers installed (which is generally considered to be a very bad
idea due to MotionInJoy's malicious software; installing the drivers
`manually', which is what I did, is generally considered the safest approach).
If you using a DualShock\~4 or 5, or an Xbox gamepad, you will need to do some
research of your own (as I don't own any of these controllers) to find good
Windows drivers for your controller and a mapping utility.
.PP
Over on Linux, SDL is very widely-used as an input backend, and one that both
the PCSX2 and DuckStation emulators can use (you should ensure that the
backends in the emulators are indeed configured so, and not to something else
like `evdev', or else our mappings will not take effect).
DualShock controller support is also available directly in the Linux kernel.
If you too are a Gentoo user then you will need to
.H https://wiki.gentoo.org/wiki/Sony_DualShock "build your kernel with the DualShock drivers included" "."
Other distributions (Debian, Arch Linux, etc.) will almost always ship their
kernels with this built in already for you.
.
We will take advantage of SDL's controller mapping ability, which, while it is
somewhat difficult to understand at first (and frankly quite scary to look at),
it does get the job done.
The mappings I will show will be for DualShock\~3 controllers.
If you are not using a DualShock\~3 controller, you will need to find a base
mapping for your controller to work off of, which you can find in the
.H https://github.com/gabomdq/SDL_GameControllerDB "SDL GameControllerDB list"
online.
You can also find a default mapping for your controller by using one of the
mapping tools linked on that page; which should be able to generate one for
you.
Once you have a mapping for your controller, you should be able to apply the
techniques described here to create your own mappings.
.
.NH 2
How SDL Controller Mapping Strings Work
.PP
Windows users who already have their controller mapping method worked out can
skip this part.
Linux users who don't happen to be using the exact same DualShock\~3 controller
as me will have to read on to understand how to map their own controller.
.PP
An SDL controller mapping string appears like follows:
.
.DS
030000004c0500006802000011810000,PS3 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:a5,rightx:a3,righty:a4,start:b9,x:b3,y:b2,
.DE
.LP
This is the base mapping that I use for my DualShock\~3 controller, and that I
work from to remap things to what I need.
The first section (the controller's GUID), and the ``PS3 Controller'' part can
be ignored for now.
The most important thing here is the comma-separated list of `key:value' pairs,
which define how the controller is mapped.
The important thing to understand is that the `key' in these pairs refers to
the abstract button/axis input on the gamepad that will be sent to the game
(with abstract names such as `leftx', `righty', which refer to the left stick
X-axis and right stick Y-axis respectively).
The `value' part (the
.F a0 ,
.F b1 ,
.F b8 ,
etc.) are the identifiers of each
button/axis on the controller, as identified by the kernel driver.
.NH 3
Applying the Mapping
.PP
In order to actually apply a controller mapping to our emulator; we should
first ensure that the emulator is in fact using SDL as the input backend.
PCSX2 seems to use SDL by default.
In DuckStation we can check by going to the `General Settings' and ensuring
that the `Controller Backend' is set to SDL.
.PP
Next, we should ensure that the emulator is not trying to do any unusual
mapping of it's own.
This is because we don't want the emulator mess up any of our
manually-specified mappings.
This is only an issue for DuckStation, as PCSX2 doesn't really allow you to
modify the mappings.
The reader might be asking why we wouldn't just use the emulator's own mapping
options to achieve what we want; but at least in the case of DuckStation, the
functionality of mapping the positive/negative sides of a controller axis is
completely missing; therefore we need to resort to manually mapping with SDL.
.PP
Once we've ensured that the emulator is not trying to remap anything, we need
to start the emulator with the
.F "SDL_GAMECONTROLLERCONFIG"
environment variable set to the mapping string.
For example, to start PCSX2 with a custom SDL mapping, something along the
lines of the following commands should be used:
.DS
SDL_GAMECONTROLLERCONFIG="<mapping string>" pcsx2
# Or alternatively:
export SDL_GAMECONTROLLERCONFIG="<mapping string>" && pcsx2
.DE
.LP
PCSX2 should now be started with the custom mapping in
.F "<mapping string>"
loaded.
You may wish to write some simple shell scripts that allow you to easily launch
your emulated games with these controller mappings automatically applied.
.PP
If you provide your base mapping in the
.F "<mapping string>"
part of that command, then you should be able to play games as normal.
To test that the mappings are being applied, you can use a mapping string like
the following, where every button and axis is unbound; you should not be able
to provide any input to the game.
You may need to replace the GUID and `PS3 Controller' part with that of your
own controller:
.DS
030000004c0500006802000011810000,PS3 Controller,a:,b:,back:,dpdown:,dpleft:,dpright:,dpup:,guide:,leftshoulder:,leftstick:,lefttrigger:,leftx:,lefty:,rightshoulder:,rightstick:,righttrigger:,rightx:,righty:,start:,x:,y:,
.DE
.LP
.
.NH 3
An Example Mapping
.PP
The important thing to note is what buttons and axes we actually want to map.
Consider the example used earlier of mapping the right stick (which should in
the game be set to control the accelerator and brake) to the left/right trigger
buttons.
The abstract `key' we want to change, is the `righty' one (pronounced `Right
Y', not `Righty'!).
As an example, if we modify the above mapping so that the `righty' is not
mapped to any axis, like this:
.DS
righty:
.DE
.LP
then we will be unable to accelerate or brake in the game (if the
accelerator and brake is mapped to the right Y axis).
This is the simplest mapping possible.
.PP
Now, let's say that we want to map our left and right triggers (L2/R2) to the
`righty' axis.
Readers who ate their Weet-Bix for breakfast this morning may have already
noticed that the left and right triggers have two different identifiers
.F a2 "" (
and
.F a5 ),
indicating that they are in fact treated as two different axes:
.DS
lefttrigger:a2,righttrigger:a5,
.DE
.LP
For months I would think that this was the fatal flaw in the mapping syntax
that would make achieving the goal mapping essentially impossible.
The difficult question here is of course, how can we map the single `righty'
analog axis to both the
.F a2
and
.F a5
trigger axes at the same time?
Thankfully, I recently turned out to be wrong when I, at last, stumbled upon
the following GitHub issue:
.H https://github.com/libsdl-org/SDL/issues/1166 #1166 .
This issue includes quotes from the SDL mailing list, which properly describe
and document an extended syntax of the SDL mapping strings (at the bottom of
the linked page).
This documentation was incredibly difficult to find, but using it we are able
to finally map the individual positive/negative halves of the analog stick to
the left and right triggers the way we want, using this extended syntax:
.DS
-righty:a2,+righty:a5
.DE
.LP
where
.F a2
is the identifier of the left-side trigger axis on the controller
(in this case a DualShock\~3), and
.F a5
is the right-side trigger axis.
This isn't the full string though, as for this to work, we must also unmap the
left and right trigger buttons themselves (or else SDL will confused because
the
.F a2
and
.F a5
identifiers cannot appear in multiple places at once):
.DS
lefttrigger:,righttrigger:,-righty:a2,+righty:a5
.DE
.LP
Of course, this means that whatever the left/right trigger buttons are mapped
to in the game, will become unusable (which isn't really a problem for most
cases).
If you for whatever reason have a need for what the left/right trigger buttons
are originally mapped to; your only option is to map them to something else on
the controller.
.PP
This sort of format for the mapping strings will be used for our mappings for
each of the games, and Gran\~Turismo 1, 2, and 4 will each have very similar
mappings.
There is a better mapping for Gran\~Turismo\~3 that we can create because of
it's more versatile in-game mapping system that the other games don't have.
.PP
The following sections will describe the mappings that can be used for each of
the games.
Please also remember that for each of the mappings shown, the left trigger and
right trigger axes are identified as
.F a2
and
.F a5
respectively, which may or may not be the same for your controller.
It is good to become familiar with what identifiers correspond to what on your
controller to make producing your own mappings easier.
.
.\" GT1/2
.NH 2
Gran\~Turismo\~1 & 2
.PP
Both the first and second installments of Gran\~Turismo use the same input
mapping system in the game.
The following images show how the controller should be configured inside of
both Gran\~Turismo\~1 and 2 in their options menus:
.
.IM $$(ROOT)$$/files/img/gt_mapping_1.jpg "Gran Turismo 1 in-game mapping"
.
.IM $$(ROOT)$$/files/img/gt_mapping_2.jpg "Gran Turismo 2 in-game mapping"
.
.PP
The next thing to do is formulate a mapping that considers the fact that our
right stick now is acting as the accelerator and brake input.
The mapping should map the left trigger to the downward direction (+Y) of the
right analog stick (for brake), and map the right trigger to the upward
direction (-Y) of the stick (for accelerator).
.PP
The modified parts of my SDL mapping is the following, where
.F a2
and
.F a5
are the identifiers of the L2 and R2 axes respectively:
.DS
lefttrigger:,righttrigger:,-righty:a5,+righty:a2,
.DE
.LP
And the final full mapping for Gran\~Turismo\~1 & 2 for my controller:
.DS
030000004c0500006802000011810000,PS3 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:,rightx:a3,-righty:a5,+righty:a2,start:b9,x:b3,y:b2,
.DE
.LP
.
.
.\" GT4
.NH 2
Gran\~Turismo\~4
.PP
Gran\~Turismo\~4 can be mapped just as easily as 1 and 2.
The only different thing here is that the game only allows us to use the left
stick for acceleration and brake, rather than the right like we used in the
other games.
The following screenshot shows the in-game mapping that should be used:
.
.IM $$(ROOT)$$/files/img/gt_mapping_4.jpg "Gran Turismo 4 in-game mapping"
.
Now, we need to map the left trigger to the downward direction (+Y) of the left
analog stick (for brake), and the right trigger to the upward direction
(-Y) of the same analog stick (for accelerator).
.PP
The modified parts of my SDL mapping are the following:
.DS
lefttrigger:,+lefty:a2,-lefty:a5,righttrigger:,
.DE
.LP
And the final mapping for Gran\~Turismo\~4:
.DS
030000004c0500006802000011810000,PS3 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:,leftx:a0,+lefty:a2,-lefty:a5,rightshoulder:b5,rightstick:b12,righttrigger:,rightx:a3,righty:a4,start:b9,x:b3,y:b2,
.DE
.LP
.
.
.\" GT3
.NH 2
Gran\~Turismo\~3: A-Spec
.PP
Gran\~Turismo\~3 allows us more flexibility with the controller mappings; as it
allows us to actually map the accelerator and brake inputs to totally seperate
analog sticks and axes.
We can take advantage of this, and create a mapping that allows us to press the
brake and accelerator simultaneously (unlike in the other games, where the
accelerator and brake are locked to the same axis).
.PP
The in-game mapping that I use is shown below:
.
.IM $$(ROOT)$$/files/img/gt_mapping_3.jpg "Gran Turismo 3 in-game mapping"
.
.LP
To map the controller correctly, as this configuration would be
hilariously uncomfortable to play with without a custom mapping, we need to map
the left trigger to the downward (+Y) direction of the right stick for braking
input, and map the right trigger to the rightward direction (+X) of the right
stick for accelerator input.
.PP
The modified parts of my SDL mapping are as follows:
.DS
lefttrigger:,righttrigger:,+rightx:a5,+righty:a2,
.DE
.
.LP
The final mapping I use for Gran\~Turismo\~3: A-Spec, is:
.DS
030000004c0500006802000011810000,PS3 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:,+rightx:a5,+righty:a2,start:b9,x:b3,y:b2,
.DE
.LP
.
.NH 2
Potential Issues
.PP
Because of these crazy mappings, it's possible that some parts of the games
would be unusable while these mappings are applied.
For example, the Data Logger in Gran\~Turismo\~3 allows you to use the right
stick to move around; which isn't really possible because of the wacky
controller mapping that is applied.
I assume that the other games would have other things that would be unusable
with these mappings.
If you wish to access these unusable sections of the games, the obvious way to
do it is to just set the controller to use a normal mapping (e.g. via
the
.F SDL_GAMECONTROLLERCONFIG
environment variable).
