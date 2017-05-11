Message-ID: <1494520259.1168.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 11 May 2017 12:30:59 -0400
In-Reply-To: <5913BD53.14417.3F7C9BC9@pageexec.freemail.hu>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
	, <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
	, <CAGXu5j+nB-0B9UNWV_u+xdWtmLnUQewfGXi2Kd=KjSLrcQu=NQ@mail.gmail.com>
	 <5913BD53.14417.3F7C9BC9@pageexec.freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: PaX Team <pageexec@freemail.hu>, Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>
Cc: Daniel Cegielka <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

KSPP is going to change without public patches. There was a substantial
community built around PaX and grsecurity. Hardened Gentoo, Alpine and
Arch Linux all had/have official support integration and a significant
number of users. Other people used it on their own. Few of those users
are going to have access now so the best we have is upstream work (KSPP)
and maintaining stuff downstream if it hasn't landed yet or is blocked
by politics, etc. People aren't going to accept only having a 4.9 LTS
with the last public patch. New hardware support is already chipping
away at the usefulness of that.

I agree with a lot of what you're saying, but that doesn't really matter
anymore. I care about code, not politics and historical grievances. I
think PaX / grsecurity has almost always been on the right side of these
feuds but that changed when people trying to improve security upstream
by landing changes from PaX / grsecurity or even just new code became
the enemy. People get banned from the community (IRC) for even stating
that they want to help improve upstream security.

I was quite happy with the grsecurity patches so I lacked the motivation
to make upstream contributions. I only tried to push things in the right
direction on the mailing lists, which ended up getting me banned from a
community that I put a lot of time/effort into. Other than the few with
access to the commercial patches, the community either has the choice of
staying loyal to you and having nothing or using and contributing to the
remaining public efforts.

In terms of funding contracting out work isn't how companies like Google
do things. They hire people and do everything in-house, even if that
means losing on lots of talented people not willing to do things their
way. CII / OTF are the exception to the rule and then your funding would
be subject to politics and could vanish at any time even if you succeed
in getting it from them initially. They didn't single out grsecurity for
this treatment, it's how they do things in general. We were encouraged
to apply for OTF funding for CopperheadOS by people who supposedly had
influence there and were rejected based on astoundingly stupid reasons
after wasting time on it. AOSP is primarily permissively licensed, so we
moved away from FOSS licensing -> non-commercial usage licensing for
everything but the kernel due to getting nothing back from it while
companies were taking and not giving back. Unfortunately, you don't have
that option. I've always tried (and mostly failed) to get changes
upstream into AOSP though. I'm not worried about running out of features
to implement and it makes it easier to maintain since that stuff doesn't
need to keep being ported forward, although there's a lot more time
pressure to port than there is for Linux due to how it's released.

The VMAP_STACK feature is upstream, so while reinventing KSTACKOVERFLOW
was silly and rediscovering the same bugs even more so, that time ended
up being wasted and the temporary stability hit was accepted. It's too
late now and the upstream feature is going to be perfectly good. KASLR
is a weak mitigation, but people decided to spend their time on that and
it exists so I don't see the point in not getting the marginal utility
it offers rather than disabling it or marginally useful checks in the
USERCOPY code via CONFIG_BROKEN_SECURITY, where you're taking something
away from your users essentially out of spite. I also don't understand
the point of maintaining stuff like KSTACKOVERFLOW and a bunch of other
features once the upstream solution works fine. Why keep a separate ASLR
implementation with a legacy random number generation scheme vs. a few
small changes to the upstream one, etc?

https://github.com/thestinger/linux-hardened now exists because I am
quite aware of the limitations of upstream work and I don't plan on
waiting years to have features like RAP and page table protection.
Still, it's only maintainable for us if we actually split everything up
and document it which is half of the way to upstreaming everything. It
makes sense to try to land as much as possible upstream for free code
review / testing and a reduction of the maintenance burden. The goal
isn't to upstream as much as possible, but rather than the means to an
end which is getting back what we already had available via the work you
published. If you can't tolerate people doing stuff like this, you're
going to end up considering a lot of your old community as enemies... I
don't see what else we are supposed to do. There's no way for the PaX /
grsecurity commercial model to work for regular users.
