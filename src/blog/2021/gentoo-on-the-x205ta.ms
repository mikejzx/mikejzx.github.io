.DA 2021-01-14
.TL
Gentoo on the X205TA
.PP
I've had an ASUS X205TA for a few years now, and installed Lubuntu on it
initially, as it was practically unusable with Windows\~10 after installing a
few programs.
Lubuntu was great and all for me while I was just starting to use to Linux more
often, and it worked fine for doing schoolwork.
Just recently I felt like it was time to do a clean install of something on
there.
I was initially thinking of going with Arch, but I figured I'd get a bit
adventurous and try something different (already running Arch on two other
machines).
I thought, ``Maybe I should try out Gentoo!''
This was my first time installing Gentoo\(emit was also probably the most
painful Linux install I've ever put myself through!
(not because of Gentoo, but because of the device hardware).
.
.PP
If you've done any searching online for guides or helpers on installing Gentoo
specifically on this laptop, you've probably realised already that there's
almost no information whatsoever.
You can find info for other distros which doesn't all apply since there's so
much manual work required in a Gentoo installation.
There's one article by
.H https://blanktar.jp/blog/2015/02/gentoo-into-eeebook "some Japanese guy"
which when translated has some useful stuff in it.
The guy was close to getting it to work on his X205TA, but ran into the same
issues that I did; kernel panics while booting, and an unusable keyboard when
it actually did boot.
After hours of tweaking with the kernel configuration, I managed to get the
system to run real nicely.
I still haven't run into any issues, freezes or anything, which is great!
.
.PP
I thought I'd write this little guide to help any of the other people pulling
their hair out trying to install Gentoo on this system.
This is not a ``full installation'' per se, but rather a set of
.B "extra/notable steps"
that need to be taken on this device.
I'd recommend having this guide on the side as you follow the official guide.
.
.PP
Let me just warn you now\(emcompilation of large packages on this device will
usually take quite a while.
If I were you I'd definitely try avoiding installing any massive desktop
environments, and instead take a minimal approach, with a standalone window
manager, etc.
.
.PP
Oh, and a little disclaimer: do this at your own risk.
I'm not at fault if you screw up your laptop!
.
.NH 2
Getting started
.
.PP
If you've installed Linux on an X205TA before, you're probably already aware
that the device has a 64-bit CPU, and must have an exclusively 32-bit
bootloader (if you didn't know that before you're probably wondering why this
is the case; the reason is actually because ASUS are a pack of idiots).
Gentoo's Live 64-bit CD ISO already comes with a 32-bit bootloader on it, so
you're able to just burn it to a USB stick, plug it in, and boot right into the
live environment.
.
.PP
Wi-fi should work out of the box.
Hop into
.F wpa_supplicant
and get yourself connected. If for whatever reason you cannot connect, try run
.F "modprobe brcmfmac"
to manually load the Wi-fi module.
.
.NH 2
Partitioning
.
.PP
The X205TA uses an eMMC as it's storage device (basically an SD card).
Linux identifies it as
.F /dev/mmcblkX
and its partitions as
.F /dev/mmcblkpXpX .
.PP
I partitioned my drives as below using
.F parted :
.
.DS
NAME          SIZE   MOUNTPOINT
mmcblk1
  mmcblk1p1   130M   /boot/EFI
  mmcblk1p2    29G   /
.DE
.
.PP
Since this is a UEFI system, we need to create an ESP (EFI System Partition),
which is
.F mmcblk1p1
in my case.
Make sure you also
.B "set the ESP to be bootable!"
It should have both the 'boot' and 'esp' flags when you run the print command in
.F parted .
.
.PP
If your
.F lsblk
output includes a bunch of other block devices, like
.F mmcblk1boot0
or something, just ignore them.
I didn't use these at all and had no idea where they came from honestly.
You might be able to delete them if you want (though I'm not sure if it'll
cause problems).
.
.PP
You can optionally create a separate
.F /boot
partition if you want.
I decided not to do this just to keep shit simple.
.
.PP
.B Note :
the X205TA only has 2 GiB of RAM onboard.
.B "You will need some kind of swap space on the system"
to compile some of the larger packages or else you will run out of RAM and
portage will abort the compilation process (happened to me twice while
compiling GCC).
You can create a swap partition if you like.
I personally created a 2 GiB swapfile, however you can use as much as you like.
.
.PP
As for filesystems.
The ESP must also be formatted as a FAT filesystem, so:
.
.DS
mkfs.fat -F 32 /dev/mmcblk1p1
.DE
.
.PP
You can of course use EXT4 for your root partition.
.PP
Make sure that you mount all the partitions and
.F swapon
your swap space when you chroot into the system (use the method provided in the
install guide).
If you're partitioning the same way as me, make sure you use the same mount
points I specified above.
.
.NH 2
Setting up the make.conf
.
.PP
You should be able to get away with using
.F MAKEOPTS="-j3"
for building most of the packages on the system (be careful when compiling
large packages like GCC though.
If you have too many jobs then you will end up writing a lot to swap instead of
RAM which will make compilation very slow).
.
.PP
Other things you will want to put in your make.conf:
.
.DS
# 'synaptics' is for touchpad support
INPUT_DEVICES="libinput synaptics"

# X205TA has Intel graphics onboard
VIDEO_CARDS="intel i965"
.DE
.
.PP
You can also add the following CPU flags to it, I generated these using
.F cpuid2cpuflags .
If you want to be absolutely certain that these are correct for your hardware,
emerge
.F cpuid2cpuflags
and run it yourself.
.
.DS
CPU_FLAGS_X86="aes mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_2 ssse3"
.DE
.
.PP
Finally, and this is probably one of the most important settings; like I
mentioned earlier, the X205TA has an exclusively 32-bit bootloader.
Make sure you put this in your make.conf if you want your machine to boot:
.
.DS
GRUB_PLATFORMS="efi-32"
.DE
.
.NH 2
Kernel configuration
.
.PP
Okay.
This is another important part; it's also where it gets pretty messy.
There are a bunch of kernel options that must be included in order for your
system to function properly. These should be all the important ones.
If you think anything is missing, feel free to contact me and I'll correct it.
I've also probably included more options than necessary here\(emI don't really
have the time to test every option individually, so I just went with whatever
worked.
If you think any of the options are completely unnecessary, just let me know
and I'll remove it from here.
.
.PP
If you don't want to configure your kernel yourself (or if you can't get your
system to work properly), you can try
.H $$(ROOT)$$/files/x205ta-kernel.config.gz "using my config instead"
(no sound support), given that you are also running something around kernel
5.4.80.
.
.NH 3
eMMC support
.
.PP
Make sure you've got all of these in your config, or else you will get kernel
panics at boot time.
.
.DS
Device Drivers
  MMC/SD/SDIO card support
    <*> MMC block device driver
    <*> Secure Digital Host Controller Interface support
    <*>   SDHCI support on PCI bus
    [*]     Ricoh MMC Controller Disabler
    <*>   SDHCI support for ACPI enumerated SDHCI controllers
    <*>   SDHCI platform and OF driver helper
    <*> MMC/SD driver for Ricoh Bay1Controllers
.DE
.
.NH 3
Pin Controller
.
.DS
Device Drivers
  Pin controllers
    [*] Intel Baytrail GPIO pin control
    [*] Intel Cherryview/Braswell pinctrl and GPIO driver
.DE
.
.NH 3
Wi-fi
.
.PP
Thanks to the Japanese guy I mentioned earlier for mentioning these options.
However we also need to include the WLAN driver so we can enable the
.F wlan0
interface.
(Note that these are in addition to the other base options that you'd normally
use for networking).
.
.DS
Device Drivers
  Wireless LAN
    [*] Broadcom devices
    <M>   Broadcom 43xx wireless support (mac80211 stack)
    [*]   Broadcom 43xx SDIO device support
    <M>   Broadcom FullMAC WLAN driver
    [*]   SDIO bus interface support for FullMAC driver

Networking Support
  <M> cfg80211 - wireless configuration API
  [*]   enable powersave by default
  [*]   cfg80211 wireless extensions compatibility
  <M> Generic IEEE 802.11 Networking Stack (mac80211)
  [*] Export mac80211 internals in DebugFS
.DE
.
.NH 3
Input
.
.PP
The following need to be built into the kernel to get the keyboard working.
Thanks to
.H https://ubuntuforums.org/showthread.php?t=2254322&p=13733677#post13733677 "harryharryharry over at Ubuntu forums"
for mentioning the I2C stuff (and for all of his contributions to getting Linux
working on this laptop!)
.
.DS
Device Drivers
  HID support
    I2C HID support
      <*> HID over I2C transport layer
  I2C support
    I2C Hardware Bus Support
      <*> Synopsys DesignWare Platform
      [*]   Synopsys DesignWare Slave
      <*> Synopsys DesignWare PCI
      [*] Intel Baytrail I2C semaphore support

  Input device support
    <M> Mouse interface
    <M> Event interface
    [*] Keyboards
    <M>   (basically all keyboards)
    [*] Mice
    <M>   ELAN I2C Touchpad support
    [*]     Enable I2C support
    [*]     Enable SMbus support
    <*>   Synaptics I2C Touchpad support
.DE
.
.NH 3
Graphics
.
.DS
Device Drivers
  Graphics support
    <*> Intel 8xx/9xx/G3x/G4x/HD Graphics
    [*] Enable capturing GPU state following a hang.
    [*]   Compress GPU error state
    [*] Always enable userptr support
.DE
.
.NH 3
Sound
.
.PP
I'm adding this section after the original post date (currently 2020-01-22).
I haven't tried getting sound working on the 5.4 kernel, as I'm now running the
latest stable 5.10.9 kernel.
You can try reproduce the settings below on an older kernel, I don't know if
it'll work though.
.PP
These should be all the options you need to get the sound working decently.
There will be just a slight hiss in the headphone output but I'm sure you can
live with that.
Oh, and you will also need to manually switch the output from Headphones to
Speakers and vice-versa, using e.g. pavucontrol.
You could probably set up some kind of output-toggle binding to speed up that
process.
.
.DS
Device Drivers
  <*> Sound card support
    <*> ALSA
      [*] PCI sound devices
      <M> HR-timer backend support
          HD-Audio
          <M> HD Audio PCI
          [*] Build hwdep interface for HD-audio driver
          [*] Support initialization patch loading for HD-audio
          <M> Build Realtek HD-audio codec support
          <M> Build Analog devices HD-audio codec support
      (4096) Pre-allocated buffer size for HD-audio driver
      <*> ALSA for SoC audio support
        [*] Intel ASoC SST drivers
        <*>   ACPI HiFi2 (Baytrail, Cherrytrail) Platforms
        -*- Intel Machine Drivers
          <M> (everything)
        [*] Sound Open Firmware Support
          <*> SOF ACPI enumeration support.
          [*] SOF support for Intel audio DSPs
        <M> ASoC Simple sound card support
.DE
.
.PP
I have no idea if the microphone will work with these options.
I don't really care since I don't use the microphone.
.PP
And from here all the other kernel options (USB support, etc) should be pretty
generic and obvious.
.
.NH 3
Kernel patches
.
.PP
If you want to squeeze as much performance as possible out of your X205TA, you
can apply the
.H http://ck.kolivas.org/patches "linux-ck performance patches"
to your kernel.
I'm running this personally and it seems to just make the system feel a bit
snappier overall.
.
.NH 2
GRUB installation
.
.PP
To install GRUB we have to run these two commands.
Make sure you
.B "do not"
include a partition number in the
.F grub-install
command (e.g.\&
.B "don't use"
.F mmcblk1pX )
or else your laptop won't boot (at least in my testing).
As long as the
.F /boot/EFI
directory exists (and you've formatted partitions the same as me), the below
commands will install the bootloader just fine.
.
.DS
grub-install --target=i386-efi /dev/mmcblk1
grub-mkconfig -o /boot/grub/grub.cfg
.DE
.
.PP
Your bootloader should now appear in
.F /boot/EFI/EFI/gentoo .
It probably looks weird with the two EFI directories, but it seems to work
perfectly like this.
.PP
I also created an initramfs.
I'd say you should probably install one of these too on your machine:
.
.DS
genkernel --install --kernel-config=/usr/src/linux/.config initramfs
.DE
.
.NH 2
Finishing up
.PP
And that's about it!
If all went well\(emyou followed the official install Gentoo instructions and
applied the stuff from this guide, you should hopefully be able to unmount
everything, reboot, and boot into a fresh Gentoo installation on your X205TA!
You're on your own from here to decide how the rest of your system will be laid
out.
.PP
If you have any questions, comments, or problems with the information here,
please feel free to e-mail me via the address on my
.H https://mikejzx.github.io "homepage" .
.PP
Have fun waiting for all your packages to compile ;)
