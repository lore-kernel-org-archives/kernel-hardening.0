MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 02 May 2017 13:11:54 +0200
From: David Gens <david.gens@cs.tu-darmstadt.de>
In-Reply-To: <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
Message-ID: <8708035924881b2aceb280d9a6bdd14e@cs.tu-darmstadt.de>
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-05-02 00:01, Mathias Krause wrote:
> On 27 April 2017 at 00:04, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Apr 26, 2017 at 2:05 PM, Daniel Cegiełka
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
> 
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
> 
> *sigh*
> 
> I think the intention of the KSPP is good -- making vanilla Linux more
> secure. But the way it does its work harms overall Linux security. It
> does hurt mine, that's for sure! I know the value of grsecurity and
> PaX in particular and know how easy it still is to exploit a vanilla
> Linux. Features like KERNEXEC and RAP make it almost impossible for an
> attacker to abuse a memory corruption bug in the kernel. Many unnamed
> features -- unnamed because not under an #ifdef -- make exploiting
> use-after-free bugs much less interesting or reduce the race window
> for TOCTTOU bugs involving user copy operations. None of this can be
> found in vanilla Linux. Probably never will...

So tell me how exactly a PaX-hardened kernel with a memory-corruption 
bug
prevents an adversary from modifying critical data, such as the page 
tables
in a data-only attack? IMHO the "PaX mitigates Memory-corruption" 
argument
is wishful thinking, and now that PaX is gone users cannot fool 
themselves
any longer into thinking "My System is Secure". That awareness is 
actually
good no?


> So, here's my list of questions for the KSPP:
> 1/ When will I be able to switch to a vanilla Linux kernel that is
> equivalently hardened as a grsecurity/PaX kernel used to be?
> 2/ Who will maintain this code and how?
> 3/ Who ensures the coverage and quality won't suffer for each new
> kernel release?
> 
> Judging from the planed EOL for the v4.9 LTS kernel -- the last one a
> grsecurity patch was publicly available for --, there are less than
> two years to finish the work for item 1 to ensure a secure and smooth
> transition from grsecurity to upstream Linux. Will the KSPP be able to
> achieve this?... I have my doubts.
> 
> Even if so, item 3 will be a hard problem to solve as the Linux kernel
> development model does not support such a tree-wide review point in
> the release cycle. Assuming there are people able and willing to judge
> and review the code base for required changes (e.g. atomic_t ->
> refcount_t changes or function pointer cleanups for RAP), how would
> those be able to simply get in those changes at, say, time of rc5? --
> without having to argue with a horde of maintainers of the individual
> subsystems involved?
> 
> Quite a lot of questions. The external patch solved them all by not
> having to deal with upstream Linux development and not having the code
> available until it's ready. But now it's gone and no adequate
> replacement is on the horizon. What will KSPP do about it? I had a
> reasonably secure kernel, now it's gone. :(
> 
> 
> Regards,
> Mathias

Best,
David
