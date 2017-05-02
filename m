MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com> <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 1 May 2017 17:54:24 -0700
Message-ID: <CAGXu5j+nB-0B9UNWV_u+xdWtmLnUQewfGXi2Kd=KjSLrcQu=NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>
Cc: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 1, 2017 at 3:01 PM, Mathias Krause <minipli@googlemail.com> wro=
te:
> On 27 April 2017 at 00:04, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Apr 26, 2017 at 2:05 PM, Daniel Cegie=C5=82ka
>> <daniel.cegielka@gmail.com> wrote:
>>> https://grsecurity.net/passing_the_baton_faq.php
>>
>> Yeah, I'm sad to see them go. PaX Team was just last night helping
>> with some details of PAX_REFCOUNT as it could appear in the upstream
>> refcount_t API. I hope they'll still help out from time to time.
>>
>> It does underscore the critical need to upstream stuff, though. Forks
>> of projects might disappear at any time. :(
>
> Now, since grsecurity and PaX went private, quite a few users
> (including me) are left in the dark and are, to say the least,
> slightly pissed. But not everybody seems to be barking at the right
> tree. So I've a few comments and questions for the KSPP.

First, let me adjust language here a bit to make things more clear.
Talking about KSPP is like talking about net-dev: it is upstream, not
a separate fork. It has a focus, like net-dev, but it is upstream. So
there is no difference semantically between talking about KSPP and
upstream. Additionally, while PaX Team, grsecurity, and ephox's work
were technically separate development efforts (for example, just look
at how PAX_USERCOPY differed between PaX and grsecurity), most people
used the combination, which I'll just call grsecurity here. Both
definitions will be helpful below...

> I think the main reason for Brad and PaX Team to make their work
> private is the increased amount of work KSSP has put on them without
> providing any valuable work in return. They just don't want to be

First, to think they didn't get valuable work in return from upstream
is missing the forest for the trees. With every release of upstream,
grsecurity would get tens of thousands of commits. If there wasn't
benefit in these changes, grsecurity would never forward port to the
latest upstream. The fact that it is a notable event that grsecurity
has ceased updating their public patches is because people using
grsecurity suddenly aren't getting the upstream changes, in addition
to them not getting new grsecurity features. It is a totally false
equivalency to say "upstream has [created work for|used code from]
grsecurity without giving anything valuable in return". I'll come back
to this later.

Second, when HARDENED_USERCOPY was landing, I specifically asked
grsecurity about the best way to make the upstreaming efforts easiest
to deal with for them, since I knew there might be some work with
their forward porting, and I didn't want to create undue work for
them. They ignored me. I asked again a while later and was continued
to be met with silence. Looking at the results in grsecurity, though,
it's clear that they chose to integrate with upstream instead of
maintaining a forked implementation. For example, the core
PAX_USERCOPY logic lived in fs/exec.c. When I upstreamed it, I moved
it to a place that made more sense in mm/usercopy.c. When grsecurity
forward ported, they could have trivially left HARDENED_USERCOPY
disabled, and kept PAX_USERCOPY using fs/exec.c, but they didn't.
Since grsecurity has talked in the past about how their
implementations are frequently arranged to make their forward porting
easier, I think this is strong evidence that using upstream's
implementation (with whatever further changes they wanted) was easier
than keeping their own fork. This is further supported by grsecurity
being paid by CII to upstream the gcc plugin infrastructure, where
they used almost entirely the same paths, Kconfigs, and Makefile
changes. So, given that grsecurity did not communicate at all about
wanting forward porting made easier and that they've reused gcc
plugins, hardened usercopy, etc, I think it's an entirely false claim
that upstream is creating more work that normal forward porting. In
some places, it even appears to be easier.

Finally, even if you can somehow disregard the thousands of upstream
changes benefiting grsecurity, and just want to look at the areas
touched while upstreaming things from grsecurity, they have benefited
from the upstreaming review by upstream finding bugs in various
grsecurity features (some of which haven't even landed in upstream
yet: Arnd Bergmann alone found tons of issues with the initify plugin
and grsecurity fixed them). Hardened usercopy found bugs in
grsecurity's slab implementation, gained strncpy_from_user() coverage,
and triggered a massive consolidation of per-arch uaccess fixes which
have found numerous upstream bugs that will now be fixed in grsecurity
too. The current refcount_t work based on PAX_REFCOUNT uncovered a
crash bug in grsecurity's implementation as well as a corner case in
bounds checking. Upstreaming grsecurity features brings a huge amount
of testing to bear on the code, which, like all the other things in
upstream, grsecurity directly benefits from. And to top all of this
off, while upstreaming the latent_entropy plugin, I noticed a English
typo that was present in all the grsecurity gcc plugins, and when I
sent them a trivial spelling fix patch for all their plugins (rather
than just letting it stand and making work for them to catch it during
forward porting and fix it everywhere else), they publicly mocked the
patch (which they applied). So, no, unless you count fixing newly
discovered bugs in their code, I again summarily reject the notion
that upstreaming grsecurity features creates "more work for grsecurity
without value in return".

> forced to maintain and fix-up the variants of grsecurity/PaX features
> KSPP lands upstream. And no, the work of KSPP does not make their life
> easier, in fact, it makes it harder. Harder for two reasons: First,
> the code does not end up verbatim, it's always changed, taken out of
> context and "enhanced". Second is the loose of control over the code.
> But let me elaborate those two a little further.

See above. In many cases, they chose integration over maintaining a
fork. In others, the two features coexist (for example, to various
levels of needless redundancy, see arch/arm/mm/init.c's KERNEXEC
overlap with RODATA).

> The first point directly forces them to think through the upstream
> incarnation of a feature, how it differs from their original one and,
> for those parts, how to fix them up to work properly to fit their
> needs, to fit their security requirements. Those changes generate a
> lot of conflicts with their version of the code which takes time to
> fiddle out. As happened for __ro_after_init, MEMORY_SANITIZE,
> USERCOPY,... which only went in in reduced and modified form,
> generating needless work on their side -- from their point of view.

One of the costs of forking a project is dealing with forward porting.
This problem is faced by all kinds of organizations (usually with
small engineering teams), where some set of features is desired on top
of Linux, and there are three choices for handling it, in ascending
order of difficulty:

- pick a kernel version, fork, develop features, use, abandon, repeat
(see most IoT vendors)

- pick a kernel version, fork, develop features, use, forward port to
next kernel version, repeat (see most phone vendors)

- develop features, upstream, use whatever future kernel desired (see
most CPU vendors and distros)

Upstreaming can be extremely time consuming. Grsecurity made it clear
from long ago that they had no intention of upstreaming things because
they wanted to use their time differently. This is entirely their
choice, and one that, frankly, the vast majority of Linux forks make.
But it means accepting the literally unending work of forward porting.
That said, when I asked grsecurity if there I was any way they would
accept payment to upstream things, they did briefly agree and
upstreamed the gcc plugin infrastructure. So they were willing to
upstream if paid, yet ultimately decided to stop, and to continue to
forward port their patches. But now they made their work private,
which, I should point out, doesn't change the amount of work for them,
except maybe no longer getting bug reports from their users.

To your specific examples, __ro_after_init is literally a one-line
change: they just make in __read_only. This was some of my first
attempts to make their forward porting work easy while upstream slowly
incorporated features. The work around PAX_MEMORY_SANITIZE made the
slab debug paths faster for everyone. I already talked about usercopy.
So, neither of us can speak for grsecurity, but I reject your belief
that upstream has somehow created needless work for them.

Which brings me to a question I haven't seen anyone ask yet: why does
grsecurity exist? If it was created to showcase strong security
mechanisms to benefit Linux users, then why fight upstreaming? Why
appear to abandon their users as soon as some of their work starts
entering upstream? The number of users protected by these features has
gone up by orders of magnitude, benefiting all Linux users, not just
grsecurity's users. One could take the position that grsecurity
desires to be differentiated from upstream so that they can point at
how more protected grsecurity users are over upstream users, but as
the gap shrinks, it will become harder to see the benefits. But that
would seem to be still a long way down the road, given how time
consuming upstreaming security features can be (regardless of whether
they come from grsecurity or not). So if they just want to be better
than upstream without caring about how many users are protected, then
it's not hard to imagine grsecurity taking their patches private. I
don't know that this is the actual rationale, but it really doesn't
look to me like they want to protect as many Linux users as possible.
And if protecting users isn't their goal, what is?

> The second point, the loose of control over the code, is even worse.
> Not getting any more conflicts when porting the grsecurity/PaX patch
> to a new kernel release makes changes to code that used to live in
> grsecurity/PaX probably go unnoticed. And, as it seem to be the case,
> upstream developers are not always familiar with all the gory details
> and might introduce weaknesses and bugs. This not only makes upstream
> Linux less secure, it makes grsecurity and PaX less secure, too.

You're speaking entirely in theoreticals, but I understand what you're
trying to say. All forward porting runs this risk. Kernel internals
change in ways that threaten even unchanged grsecurity features. To
bring this down to earth, I would ask "how does grsecurity perform
testing?" I can point to the many ways how upstream performs testing,
including LKDTM for several of the security-sensitive features. As
seen in the PAX_REFCOUNT porting work, the 4.9 grsecurity patch was
clearly never actually tested since _any_ exercise of the PAX_REFCOUNT
protection would Oops the kernel. I'm not saying they don't have
tests, nor am I saying they didn't just make a one-time mistake, but I
can point you directly to how upstream tests, how upstream developers
find bugs in grsecurity features, and how things can improve once
upstreamed (again, for example, the massive uaccess consolidation). As
to familiarity with code, this is part of upstreaming. Upstreaming
isn't just throwing a patch at the wall and running away: it needs to
have an understandable and compelling changelog, it needs to clearly
implemented and easy to maintain, etc. This differs greatly from
grsecurity changes which were rarely commented, had nearly unusable
changelogs, but only needed to be understood by a couple people. What
would happen to grsecurity if one of their developers decided to give
up on technology and go live in the woods? I would argue that features
in upstream are significantly more resilient to bad things happening,
but, we're now back where we started: a hard to prove opinion.

> So I can understand why they've done this. Still, with the loose of
> the public availability of the patch, Linux security has suffered a
> lot. Not only is upstream far far away to reach a level that is
> available today in grsecurity and PaX, no, it also won't benefit from
> new developments any more. What a great achievement! :(

Yeah, I'm quite disappointed too. When grsecurity talked at the first
Linux Security Summit in 2010, they detailed a "ten year todo list"
for upstream, itemizing all the features grsecurity had that upstream
needed. Over the years I took them at their word that they wanted to
see upstream improved but that they didn't have time to be bothered
with upstreaming. And even finding money for upstreaming didn't really
help things. And now that the needle has finally moved, and things are
starting to actually land upstream, they go private. I thought they
wanted to protect Linux users but not at the cost of upstreaming
(which, again, I can certainly understand: it can be very hard). But
now they've gone private. To me, that says I misunderstood their
intentions from the very start.

I'm glad to see that folks from the Hardened Gentoo project have
started organizing to upstream grsecurity features too. I'm excited to
find more people willing to risk their sanity and bring stuff
upstream: https://wiki.gentoo.org/wiki/Hardened/Hardened_Kernel_Project

> *sigh*
>
> I think the intention of the KSPP is good -- making vanilla Linux more
> secure. But the way it does its work harms overall Linux security. It
> does hurt mine, that's for sure! I know the value of grsecurity and

I think I have thoroughly disproved this position. Something that I
think is hard to see for people not involved in day-to-day upstream
work is how very different the development workflows are between
upstream and grsecurity. Upstream is normally evolutionary, doing
things in easy to digest pieces, where as grsecurity could just land
massive changes between releases. This makes it look like upstreaming
is just landing tiny bits of features, instead of looking at the long
view over time. Look at how __ro_after_init (while, yes, not being
anywhere close to __read_only) has been slowly gaining ground in
upstream. Look at how maybe one gcc plugin appears every couple of
releases, or how usercopy continues to expand coverage.

> PaX in particular and know how easy it still is to exploit a vanilla
> Linux. Features like KERNEXEC and RAP make it almost impossible for an
> attacker to abuse a memory corruption bug in the kernel. Many unnamed
> features -- unnamed because not under an #ifdef -- make exploiting
> use-after-free bugs much less interesting or reduce the race window
> for TOCTTOU bugs involving user copy operations. None of this can be
> found in vanilla Linux. Probably never will...

These are all complaints to be made to grsecurity. They are the ones
who provides those features originally, did not upstream them, and
then took them away. As far as never finding them in upstream, I would
remind you that grsecurity, while very impressive, is not the single
source for all Linux kernel security improvements. For example, ARM
created the PAN emulation code, HP is working on XPFO, etc. How much
further along would upstream be with security features if you yourself
had started sending patches like I've asked you repeatedly over the
years? I wasn't being glib; I was being genuine. If you have time to
criticize, you have time to write a patch. That said, I shouldn't give
you too hard a time: you have 5 times the number of commits in the
kernel than grsecurity has.

> So, here's my list of questions for the KSPP:
> 1/ When will I be able to switch to a vanilla Linux kernel that is
> equivalently hardened as a grsecurity/PaX kernel used to be?

How could anyone answer that question? I can't see the future. And
besides, it's not like grsecurity was providing comprehensive
protections. If you're using arm64, you might feel like you're already
in a better position with upstream (got PAN emu, got hardened
usercopy, still no RAP). If you're on x86_64, you might feel like
you've very far (no SMAP emu, no RAP). Upstream's goal is protecting
as many people as possible.

> 2/ Who will maintain this code and how?
> 3/ Who ensures the coverage and quality won't suffer for each new
> kernel release?

The upstream development community, just like everything else. I
answered both of these already above.

> Judging from the planed EOL for the v4.9 LTS kernel -- the last one a
> grsecurity patch was publicly available for --, there are less than
> two years to finish the work for item 1 to ensure a secure and smooth
> transition from grsecurity to upstream Linux. Will the KSPP be able to
> achieve this?... I have my doubts.

Again, it depends on your perspective. And if you have doubts, then be
part of the solution. What would you need to do to achieve your goal?

> Even if so, item 3 will be a hard problem to solve as the Linux kernel
> development model does not support such a tree-wide review point in
> the release cycle. Assuming there are people able and willing to judge
> and review the code base for required changes (e.g. atomic_t ->
> refcount_t changes or function pointer cleanups for RAP), how would
> those be able to simply get in those changes at, say, time of rc5? --
> without having to argue with a horde of maintainers of the individual
> subsystems involved?

This is an upstream development workflow problem that is especially
frustrating for security work since it can regularly touch lots of
areas, but it's one that I've been working to resolve. It's actually
on my list of things to discuss at the next Kernel Summit, since
making these wide changes is really irritating if it's going in via
each maintainer. This doesn't have to be the case, but that's how I've
been doing it lately since I can work on those pieces while waiting
for reviews on other things. And in the case of refcount_t, the
arduous work has provided some important discussions and reviews of
existing refcounting in the kernel, so I can't say this workflow is
entirely without merit.

> Quite a lot of questions. The external patch solved them all by not
> having to deal with upstream Linux development and not having the code
> available until it's ready. But now it's gone and no adequate
> replacement is on the horizon. What will KSPP do about it? I had a
> reasonably secure kernel, now it's gone. :(

Upstream was never in the business of providing the grsecurity patch,
so you'll need to ask them why they abandoned their users. Upstream's
work is unchanged. We'll still continue to work to bring security
features into the kernel, and we'll continue to welcome new
contributors.

-Kees

--=20
Kees Cook
Pixel Security
