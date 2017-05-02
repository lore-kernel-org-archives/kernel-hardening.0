Date: Tue, 2 May 2017 19:06:25 +0000 (UTC)
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Message-ID: <1788778362.1495506.1493751985632@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1788778362.1495506.1493751985632.ref@mail.yahoo.com>
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Kees Cook <keescook@chromium.org>, Mathias Krause <minipli@googlemail.com>
Cc: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,


Thanks Mathias for bringing up the matter, despite the way the attempt
was bound to be received by upstream, let alone trolls...

> > Assuming there are people able and willing to judge and review the

> > code base for required changes (e.g. atomic_t -> refcount_t changes

> > or function pointer cleanups for RAP), how would those be able to

> > simply get in those changes at, say, time of rc5? -- without having

> > to argue with a horde of maintainers of the individual subsystems

> > involved?

> This is an upstream development workflow problem that is especially

> frustrating for security work since it can regularly touch lots of

> areas, but it's one that I've been working to resolve. It's actually

> on my list of things to discuss at the next Kernel Summit, since

> making these wide changes is really irritating if it's going in via

> each maintainer.

Really irritating because really time-consuming, indeed. There's a

genuine issue here. I too agree that mainline needs to grow a more
efficient, more streamlined way to integrate a number of smaller
cleanups and improvements, which _currently_ bring minor or even no

functional changes on a mainline kernel. Creating such a process would

be a major improvement.


> If you have time to criticize, you have time to write a patch.

True, and as you pointed, Mathias did.

I can't speak for others, but right now, the prospect of spending some

of my free time making the jump from

    browsing through the grsecurity patch and trying to determine which

    hunks relate to what and how they're useful

to

    actually making + testing + writing a changelog explaining to

    maintainers not necessarily caring about security why the change

    makes sense and how it changes the binary's size + submitting

    patches to mainline (with wrong credit, it's not my work in the

    first place)

and most of all

    watch a sizable subset of these patches be either dropped on the

    floor without a comment (this is not a theoretical concern, that's

    precisely what happened to most patches in Emese Revfy's large

    constification patchset years ago) or outright rejected because

    they _currently_ bring no functional change on a mainline kernel

is... unappealing.



Let's list several families of smaller cleanups and improvements made

in PaX/grsec. You (Kees, Mathias) are fully aware about them but maybe
some other readers aren't familiar with the contents of the monster
patches:
* using explicit struct members throughout the code, which is a

prerequisite for making RANDSTRUCT (probably bound for mainline at some

point, AFAIK) more broadly useful than if it's limited to a handful

of whitelisted structs. grsecurity contains hundreds of such hunks. I

think that 4 randomly chosen, simple and related samples are in

drivers/net/wan/z85230.c;


* building constant structures at compile-time (and making them const)

rather than emitting both the room for that structure in a writable

section (...) or on the stack, and the code to initialize that

structure. That's related to CONSTIFY, it yields safer and usually

smaller code+data. Over the years, overwriting needlessly writable ops

structs proved to be used multiple times in exploit PoCs for mainline

kernels, which often failed miserably on PaX/grsecurity (not just
thanks to CONSTIFY, two or three among MEMORY_UDEREF, KERNEXEC and
RANDSTRUCT foiled the PoC as well).
See the hunks for (I think)

drivers/cpufreq/sparc-us3-cpufreq.c

drivers/gpu/drm/armada/armada_drv.c

others in drivers/gpu/drm/ (constifying "*_max_ioctl(s?)" variables

initialized with ARRAY_SIZE(a constant array of structs))

drivers/media/platform/omap/omap_vout.c

drivers/memory/omap-gpmc.c

drivers/mfd/rn5t618.c

drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.*

drivers/net/wireless/ath/wil6210/pcie_bus.c

drivers/net/ethernet/amd/xgbe/* (most of the hunks in these files)

drivers/video/fbdev/aty/aty128fb.c

net/can/gw.c

include/net/sctp/checksum.h

... and hundreds of others;


* getting rid of some of the wrong casts between incompatible function

pointer types. This often does not require adding wrappers, and

sometimes even makes the code _more_ readable. These would be non-

functional changes on a mainline kernel, and therefore especially

likely to be ignored or rejected by maintainers. Again, hundreds of

such hunks, which made up the bulk of the PaX & grsecurity patches'

size increase when RAP was added. For instance, AFAICS:

drivers/gpu/drm/*/psb_intel_sdvo.c and others: returning "enum

drm_mode_status" instead of the less precise "int".

drivers/media/dvb-frontends/cx*.c and others: likewise, returning

"enum dvbfe_algo" instead of "int".


drivers/net/wireless/atmel/atmel.c

drivers/net/wireless/cisco/airo.c

drivers/net/wireless/intersil/hostap/hostap_ioctl.c

drivers/net/wireless/realtek/rtlwifi/pci.c

(+ other WiFi drivers)


arch/{arm,x86}/crypto/sha*glue.*


fs/coda/dir.c

* other samples of the untapped tidbits from PaX/grsec:

  * removing spurious "static" keywords on function-local variable

    declarations when the first thing the function does with the

    variable is to reinitialize it. See e.g. the

drivers/mfd/max8925-i2c.c

drivers/mfd/tps65910.c

    hunks, both of which were already in a grsecurity patch for 3.14

    from May 2014 laying around on my HDD.

  * annotations in e.g.

include/linux/seqlock.h 

include/linux/spinlock.h



Integrating into mainline hundreds of these smaller improvements and

cleanups from PaX/grsec, i.e. even a single-digit percentage of the

grsecurity patch's hunks, would demonstrably improve the mainline code
immediately or in the mid-term... but that integration work is harder
than it could be :(


Regards,

Lionel.
