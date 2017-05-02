References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <67901812-66ad-a383-fa2b-afc59a21bc8c@schaufler-ca.com>
Date: Mon, 1 May 2017 17:44:53 -0700
MIME-Version: 1.0
In-Reply-To: <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>
Cc: =?UTF-8?Q?Daniel_Cegie=c5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 5/1/2017 3:01 PM, Mathias Krause wrote:
> On 27 April 2017 at 00:04, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Apr 26, 2017 at 2:05 PM, Daniel Cegiełka
>> <daniel.cegielka@gmail.com> wrote:
>>> https://grsecurity.net/passing_the_baton_faq.php
>> Yeah, I'm sad to see them go. PaX Team was just last night helping
>> with some details of PAX_REFCOUNT as it could appear in the upstream
>> refcount_t API. I hope they'll still help out from time to time.
>>
>> It does underscore the critical need to upstream stuff, though. Forks
>> of projects might disappear at any time. :(
> Now, since grsecurity and PaX went private, quite a few users
> (including me) are left in the dark and are, to say the least,
> slightly pissed. But not everybody seems to be barking at the right
> tree. So I've a few comments and questions for the KSPP.
>
> I think the main reason for Brad and PaX Team to make their work
> private is the increased amount of work KSSP has put on them without
> providing any valuable work in return. They just don't want to be
> forced to maintain and fix-up the variants of grsecurity/PaX features
> KSPP lands upstream. And no, the work of KSPP does not make their life
> easier, in fact, it makes it harder. Harder for two reasons: First,
> the code does not end up verbatim, it's always changed, taken out of
> context and "enhanced". Second is the loose of control over the code.
> But let me elaborate those two a little further.

I can't speak for Brad and the PaX team, and I certainly
can't claim to understand their motivation for abandoning
the community they had built. I can say that maintaining a
fork of the kernel for any purpose is a lot of work, and
keeping a patch set as large and complex as grsecurity up
to date is no mean feat. This would be true whether KSPP
were active or not. As anyone who does kernel development
outside of an isolated area can tell you, there's always
someone messing up everything.

There's good reason that code hasn't often been taken from
grsecurity verbatim. Not the least of these is that teasing
a particular "feature" out of the public patches is not easy.
Another is that maintainers of other aspects of the system
often dislike the affect the grsecurity code has on the
aspect near and dear to their hearts, and won't accept the
"value of security" argument. KSPP is committed to upstream.
KSPP has to make the trade-offs grsecurity was never motivated
to.

> The first point directly forces them to think through the upstream
> incarnation of a feature, how it differs from their original one and,
> for those parts, how to fix them up to work properly to fit their
> needs, to fit their security requirements. Those changes generate a
> lot of conflicts with their version of the code which takes time to
> fiddle out. As happened for __ro_after_init, MEMORY_SANITIZE,
> USERCOPY,... which only went in in reduced and modified form,
> generating needless work on their side -- from their point of view.
>
> The second point, the loose of control over the code, is even worse.
> Not getting any more conflicts when porting the grsecurity/PaX patch
> to a new kernel release makes changes to code that used to live in
> grsecurity/PaX probably go unnoticed. And, as it seem to be the case,
> upstream developers are not always familiar with all the gory details
> and might introduce weaknesses and bugs. This not only makes upstream
> Linux less secure, it makes grsecurity and PaX less secure, too.
>
> So I can understand why they've done this. Still, with the loose of
> the public availability of the patch, Linux security has suffered a
> lot. Not only is upstream far far away to reach a level that is
> available today in grsecurity and PaX, no, it also won't benefit from
> new developments any more. What a great achievement! :(

You are confusing "Linux security" with "grsecurity (tm) security".
grsecurity is a commercial product. Brad Spender has made it very
clear that this is how he wants it viewed (Brad, feel free to correct
me) and that is his call. Linux is a community project. As such, Linux
has never before had the facilities KSPP is putting in now. Similar
features have been available in a commercial fork, and thanks to the
terms of the GPLv2, we have access to that code.

> *sigh*
>
> I think the intention of the KSPP is good -- making vanilla Linux more
> secure. But the way it does its work harms overall Linux security.

No. Again, you are confusing a commercial product based on Linux
with Linux.

>  It
> does hurt mine, that's for sure! I know the value of grsecurity and
> PaX in particular and know how easy it still is to exploit a vanilla
> Linux. Features like KERNEXEC and RAP make it almost impossible for an
> attacker to abuse a memory corruption bug in the kernel. Many unnamed
> features -- unnamed because not under an #ifdef -- make exploiting
> use-after-free bugs much less interesting or reduce the race window
> for TOCTTOU bugs involving user copy operations. None of this can be
> found in vanilla Linux. Probably never will...

Patches welcome!

> So, here's my list of questions for the KSPP:
> 1/ When will I be able to switch to a vanilla Linux kernel that is
> equivalently hardened as a grsecurity/PaX kernel used to be?

Can't answer that. I spent months trying to unravel USERCOPY
from the rest of the patch and can safely say that there's so
much going on in grsecurity that I would never believe someone
who told me they could identify all the features.

> 2/ Who will maintain this code and how?

Most often the authors of code will maintain it, but we've
already seen cases where architecture specialists have begun
treating KSPP code as their own. How? The usual community
spirit of keeping things working.

> 3/ Who ensures the coverage and quality won't suffer for each new
> kernel release?

Do you understand how community works?

>
> Judging from the planed EOL for the v4.9 LTS kernel -- the last one a
> grsecurity patch was publicly available for --, there are less than
> two years to finish the work for item 1 to ensure a secure and smooth
> transition from grsecurity to upstream Linux. Will the KSPP be able to
> achieve this?... I have my doubts.

Grsecurity was a fork, and part of the reason for that is that
parts of what is in it where not acceptable to other members of
the community. Support of what is in a fork when the fork goes
away is one reason not to rely on forks. 

> Even if so, item 3 will be a hard problem to solve as the Linux kernel
> development model does not support such a tree-wide review point in
> the release cycle. Assuming there are people able and willing to judge
> and review the code base for required changes (e.g. atomic_t ->
> refcount_t changes or function pointer cleanups for RAP), how would
> those be able to simply get in those changes at, say, time of rc5? --
> without having to argue with a horde of maintainers of the individual
> subsystems involved?

You *always* have to argue with a horde of maintainers!
That's what we do! Drop in the refcount_t change without
getting buy-in from Al and David? I think not.

> Quite a lot of questions. The external patch solved them all by not
> having to deal with upstream Linux development and not having the code
> available until it's ready. But now it's gone and no adequate
> replacement is on the horizon. What will KSPP do about it? I had a
> reasonably secure kernel, now it's gone. :(

Pay Mr. Spender.
Contribute patches to KSPP.

>
>
> Regards,
> Mathias
>
