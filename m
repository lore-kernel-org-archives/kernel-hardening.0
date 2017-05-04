MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
 <1493683745.2530.2.camel@redhat.com> <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
 <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com> <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 3 May 2017 22:45:19 -0700
Message-ID: <CAGXu5jKpRafmuNaGMEn_N9jrvt2zkysB0TXOWs6pfCsDhYgkeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Shawn <citypw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Mathias Krause <minipli@googlemail.com>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 2, 2017 at 9:50 PM, Shawn <citypw@gmail.com> wrote:
> The fragmentation of Android eco-system may be inevitable. The whole
> chains is too long from ASOP/BSP/Vendors and it affect the security
> fix being delivered to the end user. According to my own statistic
> from my customers, there will be more than 7 millions of Android phone
> will be using some features of PaX/Grsec this year. I've been pushing
> those "simplified" mitigation from PaX/Grsecurity to some vendors.
> That's why I have to find out what exploitable bugs is possible to
> turned to be "massive" exp and which one is being massive used
> already. To me, it's obviously my problem solved by PaX/Grsecurity. I
> can't wait for Google's hepl to solve the problem. I shared what I
> found about "massive" exp with you and other Google folksl at last
> linux security summit. I really appreciate you guys helped some
> patches goes into AOSP. But it's just a starting point. Maybe in
> Google's point of view, everybody should buy the new phone( btw, I
> really love Pixel XL). But I have responsible to taking care of old
> devices.

My concerns aren't limited to just phones, since the pattern of "stick
with one kernel version" is endemic in the industry. Even distros are
mostly guilty of this, though their production cycle time is much
shorter. I'm glad to have people like you working on this, especially
in places where it's traditionally not gotten a lot of attention!

> Yeah, I know the history. Intel/ARM never credited PaX/Grsecurity
> about the contribution of KERNEXEC/UDEREF, which is the origins of
> hardware implementation, e.g: SMEP/SMAP in x86, PXN/PAN in
> armv7/arm64. I don't blame Spender/PaX team;-) I thank to ARM
> maintainers who did those mitigation for arm64. But I thank more to
> PaX/Grsecurity who created it from nothing.

Yeah, no doubt. The stuff PaX and grsecurity invented was amazing! And
I credit them as helping me see that killing individual bugs isn't
sufficient for security defense work.

> btw: I share the same view with Mathias Krause and other ppl who
> really concern the real sense of security. I like KSPP in the 1st
> place. But now I lost PaX/Grsecurity test patch. Who should I blame? I
> think we made our point very clear here:
>
> https://hardenedlinux.github.io/announcement/2017/04/29/hardenedlinux-statement2.html

Well, there's exactly one group that decided to pull the patches. If
you want to assign blame, I think it's clear it falls squarely on
their shoulders.

To the first point at your URL, there's a lot of inaccuracies. KSPP is
an upstream group; CII funds individuals (not the whole of KSPP) that
make independent proposals. In fact, the very first CII funded person
was ephox from grsecurity. So ... if CII funding contributors to
upstream was the problem, then grsecurity created their own problem?
That makes no sense.

As for "hardly accomplished anything compared to grsecurity" that's a
pretty unfair comparison to make. Upstream has been really focusing on
this for maybe 2 years at best now? And grsecurity has been doing it
for over a decade? And besides, "upstream doesn't have all of
grsecurity upstreamed" isn't a reason to blame upstream for grsecurity
going private.

How can you say "introduced more bugs"? I'd be happy to fix them, if
you see them. And as I talked about in my reply to Mathias, of course
things look incomplete in upstream: they're being developed like
everything else in upstream: incrementally. It is not possible to just
fork-lift everything from grsecurity into upstream. It's just not how
upstream development works.

To this notion that there is some kind of conspiracy by LF to snub
grsecurity is just flat out silly. LF isn't upstream (though, sure,
they support a lot of the work). Upstream developers can't control
what or how LF says things (and few of us have time to deal with
that). If you look at things in upstream that came from grsecurity,
you'll see plenty of credit given. That sure seems like upstream
"revealing the truth to the public". Look at the copyright notices in
the gcc plugins, in mm/usercopy.c, and the notes in the Kconfigs, and
the commit messages. Look at my own blog posts covering the features,
look at the KSPP wiki page. The vast majority of things attributable
to grsecurity, do, in fact, give credit. So upstream certainly isn't
"blatantly stealing credit from grsecurity", so why would LF? And if
this single PR statement from LF is still seen as a sudden marketing
war against grsecurity, then I would ask "How is making the patches
private the solution?" Grsecurity has spent over a decade mocking and
berating upstream (just look at LWN), so how does a single article
from LF suddenly undo all their work to differentiate themselves? This
whole line of reasoning is convoluted, and frankly, has absolutely
nothing to do with upstream's efforts to protect Linux users.

It'd be nice if I could convince you otherwise (see my reply to
Mathias), but upstream hasn't "created more work" for grsecurity. And
even if you still believe that, making their patches private doesn't
reduce the amount of work they have to do. It just forces people to
pay them.

You later speak of philosophy, so let me ask you: if they've forced
their users to pay for access because their features were being
upstreamed, then they do not want these protections available to
everyone, they want them available only to those who would pay for
them. To me, though, it still can't be this simplistic. They've mostly
rejected spending free time to upstream things, they've mostly
rejected being paid to upstream things, and their efforts to be paid
to just work on grsecurity in the open (see the CII thread from a
while back) haven't worked, or are insufficient in some way. What is
it that grsecurity wants?

It looks very much like they want to stay a fork and be paid for it. I
certainly can't blame them for this; upstreaming is hard and as
Mathias says, they lose a certain level of control over the results.
Fundamentally, it's their time; they can do whatever they want with
it. And looking to be paid for your time is of course perfectly
sensible. But if this desire to stay a fork is true, then their
primary goal is NOT protecting as many people as possible, it's
protecting a subset of people as perfectly as they can. Again, this is
fine. Upstream and grsecurity can coexist in this state (since again,
upstreaming doesn't increase their work), and this was the state for
over a decade. But suddenly grsecurity went private.

So it would appear that grsecurity couldn't make enough money with
their patches staying public, so they've made them private. If that's
true, then it means that everyone who was using grsecurity but wasn't
a sponsor of grsecurity's work holds some level of responsibility for
grsecurity's decision.

It could be argued that upstream is "using grsecurity but wasn't a
sponsor", but this would be missing an important point: upstream's
contribution to grsecurity is Linux itself, which has giant value.
(And for my part personally, I did everything I could to pay
grsecurity, and succeeded a couple times over the years.) With this we
have come back around to looking at the GPL, which you mentioned. This
is specifically what the GPL was created to protect against. Why
hasn't grsecurity paid money to the tens of thousands of contributors
to the Linux kernel? Because they don't have to, and that is part of
the understanding about using the GPL for a project: everyone
contributes what they can, and everyone benefits. And if there are
forks, people can use each other's work so no one is risking being in
a situation where someone is unfairly benefiting from someone else's
work.

You had invoked RMS, so, here we are. It looks like grsecurity has
gone private because upstream started exercising the princples of the
GPL to expand how many upstream users would benefit from grsecurity's
work in the same way grsecurity's users benefited from upstream's
work. In answer to "who should I blame?" I'd say this is squarely on
grsecurity, not anyone else. They've chosen to benefit from upstream's
future work without making their future work available to upstream.

But maybe this is all wrong. Neither of us can speak for grsecurity,
nor know their motivations. I've always tried to avoid these kinds of
discussions for that very reason, and to stay focused on the technical
work. I can only truly speak for myself. I was faced with a seemingly
simple problem: Linux users need to be protected, the vast majority of
Linux users run upstream-derived kernels, but many of the best
defenses lived in grsecurity. What I'd learned from working at an
industry group (OSDL, the pre-LF), working at a distro (Canonical on
Ubuntu), and now working on devices and services (Google), is that
engineering teams in most places won't risk basing their work on a
fork of upstream, whether it be support concerns, cost concerns,
complexity concerns, or whatever. At the end of the day, it was clear
that the only path forward was to focus upstream on the same defense
principles grsecurity espoused, and to then start porting or creating
these kinds of defenses in upstream. (Which is the very thing
grsecurity told upstream to do at the first Linux Security Summit in
2010!) Doing this work was very time consuming, so I tried to collect
interested people together to work under a single umbrella to help
change the upstream culture, examine flaws, port or invent defenses,
test, document, etc.

So, in the end, I can't speak to grsecurity's true motivations, but I
can speak to mine, and what I'd like upstream to be doing: protecting
as many Linux users as completely as possible. What's possible in
upstream differs from what was possible in grsecurity, so no one
should expect the same things between the two. Comparing the two
projects is fraught with error, and blaming anyone other than
grsecurity for going private is ridiculous.

> Agree! I'm afraid I can't help much on upstream because that's not my
> customer want in short-term. S0rry, my idealist side never fit in
> KSPP.

Sure, understood. I'm delighted you've spent time getting kernel
hardening stuff landed in AOSP, though; for vendors that can be
convinced to care about backporting these things, it's great to have a
place to point to for them to get your work! And it's fine not to
contribute to upstream, since luckily there will be some people who
can. Upstream will continue to work on security defenses, but at the
very least, it'd be nice if people would be constructive in their
criticisms. We've gone over a decade with grsecurity's frequently
toxic rhetoric only alienating people instead of productively working
together to reach what should be the common goal of security work:
defending users.

-Kees

-- 
Kees Cook
Pixel Security
