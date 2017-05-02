MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1788778362.1495506.1493751985632@mail.yahoo.com>
References: <1788778362.1495506.1493751985632.ref@mail.yahoo.com> <1788778362.1495506.1493751985632@mail.yahoo.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 May 2017 15:35:36 -0700
Message-ID: <CAGXu5jK8EyUVmNutzTnQJB9tiQ0kTH9_xi2R=9D5uoZPyj7TEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: Mathias Krause <minipli@googlemail.com>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 2, 2017 at 12:06 PM, Lionel Debroux <lionel_debroux@yahoo.fr> wrote:
> Hi,
>
>
> Thanks Mathias for bringing up the matter, despite the way the attempt
> was bound to be received by upstream, let alone trolls...
>
>> > Assuming there are people able and willing to judge and review the
>> > code base for required changes (e.g. atomic_t -> refcount_t changes
>> > or function pointer cleanups for RAP), how would those be able to
>> > simply get in those changes at, say, time of rc5? -- without having
>> > to argue with a horde of maintainers of the individual subsystems
>> > involved?
>> This is an upstream development workflow problem that is especially
>
>> frustrating for security work since it can regularly touch lots of
>> areas, but it's one that I've been working to resolve. It's actually
>> on my list of things to discuss at the next Kernel Summit, since
>> making these wide changes is really irritating if it's going in via
>> each maintainer.
>
> Really irritating because really time-consuming, indeed. There's a
> genuine issue here. I too agree that mainline needs to grow a more
> efficient, more streamlined way to integrate a number of smaller
> cleanups and improvements, which _currently_ bring minor or even no
> functional changes on a mainline kernel. Creating such a process would
> be a major improvement.

Yup, and being able to show the cases for this is what I'm hoping to
do at Kernel Summit. I currently think that for minor things, having a
process to notify maintainers (seeking their Ack), but committing the
changes if there is no NAK would be the best approach. This is how
similar large changes happen now (see the uaccess conversion, for
example), but it requires such a tree be maintained by someone that
Linus will trust to pull from. I'm hoping to be that person, but I'll
need to demonstrate the need with a few examples, and build that trust
by doing it safely for a while. I've already started this a little bit
with my KSPP tree that is pulled for -next. From this tree I've been
carrying hardened usercopy changes (which touched lots of
architectures initially), gcc plugin changes (which touch lots of
files for annotations), and lately the CONFIG_DEBUG_RODATA renaming.
The trick is finding the right balance and making sure maintainers
have a chance to see things. The massive refcount_t conversion, for
example, while really time-consuming has resulted in a lot of
excellent discussion, identified many places where things were
refcounting incorrectly, etc. In those cases, the "via maintainers"
approach continues to make sense, even if painful.

>> If you have time to criticize, you have time to write a patch.
>
> True, and as you pointed, Mathias did.
>
> I can't speak for others, but right now, the prospect of spending some
> of my free time making the jump from
> browsing through the grsecurity patch and trying to determine which
> hunks relate to what and how they're useful to
> actually making + testing + writing a changelog explaining to
> maintainers not necessarily caring about security why the change

If it helps, the other people on this mailing list care very much
about security, so you're not alone in the effort of convincing
maintainers of things they might not understand. With that said, that
is fundamentally the cost of protecting the users of Linux. Linux is
successful because of the specialization and diversity of its
maintainers. In the same way not everyone can be a security expert,
not everyone can be a USB expert, or a filesystem expert.

> makes sense and how it changes the binary's size + submitting
> patches to mainline (with wrong credit, it's not my work in the
> first place) and most of all
> watch a sizable subset of these patches be either dropped on the
> floor without a comment (this is not a theoretical concern, that's

And this flaw in the upstream culture is why I started KSPP: there IS
a group of upstream developers that care about security, and we needed
a single umbrella to stand under to help each other with developing
and landing important defenses. Sometimes there is silence or
incredulity for a patch, but that is part of what I hope KSPP will
help shield contributors from.

> precisely what happened to most patches in Emese Revfy's large
> constification patchset years ago) or outright rejected because

Yup, that was a shame. And it's that past cultural problem I want KSPP
to help fix. And I think it's had some success there. Take the tty
hardening patch being recently discussed. It hasn't landed yet, sure,
but it wasn't ignored. Ways to improve it were found, etc. This is a
big shift, IMO. Maybe I'm seeing it wrong, but I think the culture has
moved.

> they _currently_ bring no functional change on a mainline kernel
> is... unappealing.

Agreed. At the end of the day, no matter how the upstream culture
improves, it is time consuming and frequently frustrating work to
upstream things. That's why I don't think less of anyone who doesn't
contribute. But when someone can spend the time criticizing things
without trying to actually fix it... that's pretty disappointing. A
lot of people see upstreaming just as developing code, but there's a
lot more to helping fix the culture. Chime in on threads to help
explain stuff, test code, etc. This is a community, and building it
constructively takes time and effort.

> Let's list several families of smaller cleanups and improvements made
> in PaX/grsec. You (Kees, Mathias) are fully aware about them but maybe
> some other readers aren't familiar with the contents of the monster
> patches:
> * using explicit struct members throughout the code, which is a
> prerequisite for making RANDSTRUCT (probably bound for mainline at some
> point, AFAIK) more broadly useful than if it's limited to a handful
> of whitelisted structs. grsecurity contains hundreds of such hunks. I
> think that 4 randomly chosen, simple and related samples are in
>
> drivers/net/wan/z85230.c;

Yup. And getting those into upstream isn't hard at all. Most
maintainers trivially take those patches, as you can see:

$ git log --oneline | grep -i 'use designated initializers' | wc -l
30

As for z85230.c itself, that appears not to get covered by an x86,
arm, or arm64 allyesconfig nor allmodconfig, since I didn't trip over
it when porting randstruct:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugin/randstruct-next-20170418

And that's what I mean about incremental improvements. I hope to land
the core of rand struct soon, and as others find things that need the
designated initializers, they'll get fixed. And then we can move on to
the discussions about how to deal with unnamed structs in task_struct
(a gcc 4.6+ feature) for controlling what/where randomization is
possible, etc, etc. Without forward progress, there is NO progress.

And by the way, while porting randstruct, I landed
-Werror=designated-init and adjusted the plugin to emit that
annotation so mistakes could be found at build time:
https://lkml.org/lkml/2017/3/21/604

And then offered the improvements to grsecurity, which was met with silence:
http://www.openwall.com/lists/kernel-hardening/2017/02/01/9

> * building constant structures at compile-time (and making them const)
> rather than emitting both the room for that structure in a writable
> section (...) or on the stack, and the code to initialize that
> structure. That's related to CONSTIFY, it yields safer and usually
> smaller code+data. Over the years, overwriting needlessly writable ops
> structs proved to be used multiple times in exploit PoCs for mainline
> kernels, which often failed miserably on PaX/grsecurity (not just
> thanks to CONSTIFY, two or three among MEMORY_UDEREF, KERNEXEC and
> RANDSTRUCT foiled the PoC as well).
> See the hunks for (I think)
>
> drivers/cpufreq/sparc-us3-cpufreq.c
> drivers/gpu/drm/armada/armada_drv.c
> others in drivers/gpu/drm/ (constifying "*_max_ioctl(s?)" variables
> initialized with ARRAY_SIZE(a constant array of structs))
> drivers/media/platform/omap/omap_vout.c
> drivers/memory/omap-gpmc.c
> drivers/mfd/rn5t618.c
> drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.*
> drivers/net/wireless/ath/wil6210/pcie_bus.c
> drivers/net/ethernet/amd/xgbe/* (most of the hunks in these files)
> drivers/video/fbdev/aty/aty128fb.c
> net/can/gw.c
> include/net/sctp/checksum.h
> ... and hundreds of others;

Yup, this is a major area of kernel attack surface reduction. I
kick-started upstream work on this with the introduction of
__ro_after_init which could cover a subset of these changes, and it's
being used more and more. Some coccinelle work went into further
constification (and checkpatch work) of ops structures, and with the
port of __read_only and the constify plugin:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/write-rarely
upstream is getting closer to having even more of this coverage. In
the meantime, these are all excellent individual patches to send
upstream. Here's a less trivial one I ported from grsecurity, again,
taking by the maintainer immediately:
https://patchwork.kernel.org/patch/9570905/

> * getting rid of some of the wrong casts between incompatible function
> pointer types. This often does not require adding wrappers, and
> sometimes even makes the code _more_ readable. These would be non-
> functional changes on a mainline kernel, and therefore especially
> likely to be ignored or rejected by maintainers. Again, hundreds of
> such hunks, which made up the bulk of the PaX & grsecurity patches'
> size increase when RAP was added. For instance, AFAICS:
>
> drivers/gpu/drm/*/psb_intel_sdvo.c and others: returning "enum
> drm_mode_status" instead of the less precise "int".
>
> drivers/media/dvb-frontends/cx*.c and others: likewise, returning
> "enum dvbfe_algo" instead of "int".
>
> drivers/net/wireless/atmel/atmel.c
> drivers/net/wireless/cisco/airo.c
> drivers/net/wireless/intersil/hostap/hostap_ioctl.c
> drivers/net/wireless/realtek/rtlwifi/pci.c
> (+ other WiFi drivers)
> arch/{arm,x86}/crypto/sha*glue.*
> fs/coda/dir.c

The function pointer type fixes are a huge clean-up and would have
appeared "unjustified" to maintainers. (For a sense of scale, just
look at the delta between the v4.4 grsecurity patch and the v4.5
patch. The bulk of the changes there were for RAP function pointer
type fixes.) However that's a matter of describing why it's a useful
change, and this is kind of thing the KSPP tree would be perfect for
carrying. No one has spent the time on these patches yet, since RAP is
pretty far down on the TODO list, especially given that it's
x86_64-only. But that doesn't mean the fixes wouldn't be welcome.

> * other samples of the untapped tidbits from PaX/grsec:
>
>   * removing spurious "static" keywords on function-local variable
>     declarations when the first thing the function does with the
>     variable is to reinitialize it. See e.g. the
>
> drivers/mfd/max8925-i2c.c
> drivers/mfd/tps65910.c
>
>     hunks, both of which were already in a grsecurity patch for 3.14
>     from May 2014 laying around on my HDD.

This sounds like a great coccinelle rule to generate and fix these
everywhere in the kernel.

>   * annotations in e.g.
>
> include/linux/seqlock.h
> include/linux/spinlock.h

It'd be great to find which testing tool noticed these being missing
and see if there are others. Again, please upstream them.

> Integrating into mainline hundreds of these smaller improvements and
> cleanups from PaX/grsec, i.e. even a single-digit percentage of the
> grsecurity patch's hunks, would demonstrably improve the mainline code
> immediately or in the mid-term... but that integration work is harder
> than it could be :(

And that is what KSPP is here to help with. We'll help new
contributors get this work done.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
