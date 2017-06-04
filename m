MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170603113007.GA1544@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 4 Jun 2017 00:16:43 -0700
Message-ID: <CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

(Hilariously, this email was detected as spam and never hit my inbox.
Dug it out now...)

On Sat, Jun 3, 2017 at 4:30 AM, Brad Spengler <spender@grsecurity.net> wrote:
> http://www.openwall.com/lists/kernel-hardening/2017/06/03/11
>
> Guys, this is your *last warning*.  This stops *now* or I'm sending lawyers
> after you and the companies paying you to plagiarize our work and violate
> our *registered* copyright (which for the record entitles us to punitive
> damages which now are very easily provable).  It's time to get serious
> about attribution -- what you are doing is completely unacceptable.  I'm
> already in contact with lawyers to prepare for the next time this happens.
> If any of this plagiarized and misattributed code actually made it into
> the Linux kernel, you'd all be in a world of pain.

There have been a few cases of grsecurity's copyright notice going
missing from things it shouldn't have, and it got corrected. People
make mistakes, especially those that are new to upstream Linux kernel
work. You've pointed the mistakes out before, and I've asked that
people contact you when there is question about how to do attribution:
http://www.openwall.com/lists/kernel-hardening/2016/05/20/6

Perhaps a more prominent FAQ entry is needed on the KSPP Wiki?

> https://lwn.net/SubscriberLink/724319/830a4de15663b8dd/
> over a dozen mentions of various forms of "Cook's implementation"

Let's see, the paragraph in the article that talks about the proposal
credits PaX/grsecurity. Clicking through to my proposed series shows
the first paragraph crediting PaX/grsecurity. You seem to be arguing
semantics, rather than credit?

> that was blindly copy+pasted from PaX (as evidenced by its bugs and
> complete misunderstanding of how the original PaX code works since
> it didn't copy+paste all the parts it needed).  And of course Kees
> is nowhere to be found to correct the misattribution of the work because
> it benefits him and his perceived security ability.  There's a word for
> that: charlatan.

Look, you need to stop this kind of personal attack. I'm not going to
suddenly give up on improving Linux kernel security because you're
calling me names. Making Linux more secure isn't all about you, and
your tired rants about how things should be done "better" are hollow.

As for thinking all misattribution is somehow singularly on me to fix
is ridiculous. I can't read everything the instant it is published,
nor can I reply to it all. This email is the first I even knew about
this LWN article being published. And as I already said, it's not
misattributed. You're just willfully misreading it.

Make up your mind about how you want grsecurity attributed and maybe
people will actually do it "right". But you don't seem to actually
want that, since you appear to just want to discourage anything that
even looks like grsecurity from going upstream. If you think you're
amply credited, you get mad that it's TOO MUCH credit because the
resulting code is different from grsecurity and it's giving you a bad
name somehow. If you think you're under credited, you go on these
kinds of rants calling everyone a plagiarist.

> Or how about this one:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2f48641cfc83c3e1fdc81204382e05edf182691a
> First three copied directly from grsecurity, presumably you submitted
> some patch series to a mailing list where only the 0/N cover mail mentioned
> grsecurity, and now there's no mention whatsoever of where the changes

Let's look at that, shall we?

$ git log --oneline | grep "Use designated"
243dd05d39aa mtk-vcodec: Use designated initializers
3ddd396f6b57 drm/amd/powerplay: Use designated initializers
2a9d6d26e2b7 drm/amdgpu: Use designated initializers
234041dfe5ca sgi-xp: Use designated initializers
33006cdf9c03 ovl: Use designated initializers
efacae6d4c09 scsi: qedi: qedf: Use designated initializers
82fe0d2b44e0 af_unix: Use designated initializers
8291798dcf05 TOMOYO: Use designated initializers
ffc7dc8d838c x86/floppy: Use designated initializers

The last 5 here all say:

    Prepare to mark sensitive kernel structures for randomization by making
    sure they're using designated initializers. These were identified during
    allyesconfig builds of x86, arm, and arm64, with most initializer fixes
    extracted from grsecurity.

The sgi-xp changes were completely different from grsecurity, and the
other 3 you're specifically mentioning here were fixed by me in code
that was newer than the most current grsecurity patch I was working
from at the time and/or I wasn't even bothering to look at the
grsecurity patch because they're all trivial fixes. The remaining
changes were ERR_CAST() fixes that weren't fixed in grsecurity at all,
and threw warnings during randstruct builds.

> came from in the first place.  You guys are seriously playing with fire,
> and it seems like an intentional act of revenge for being cut off from
> our work (lest I remind you of the legal and financial consequences of
> willful copyright infringement).

I do not understand why you think there is a conspiracy against you. I
have no time to try to figure out how to take "revenge", and even if I
did, I'm not upset about being "cut off" from your work. As I
mentioned already, making Linux more secure isn't all about
grsecurity. Just ask arm64 system builders how useful grsecurity was
for them.

> This is exactly how your plagiarism works.  This is exactly why you
> no longer have access to our work -- do you not get how incredibly
> infuriating this is?

I really think you need to take a step back and look at what has gone
into upstream. All the gcc plugins from grsecurity have changelog
credit, Kconfig credit, and copyright. The hardened usercopy code has
changelog credit and copyright (and when PaX Team got upset that I
rewrote the Kconfig text, I detailed why the original Kconfig was
inaccurate for upstream, etc). I have repeatedly demonstrated what I
feel to be comprehensive credit-giving and copyright carrying for
things coming out of grsecurity.

You've been upset in the past about seemingly NIHed code like
VMAP_STACK or ARM's use of Domains, but those were implemented without
those authors reading grsecurity, IIUC. In fact, you've regularly
harassed them because you think their implementations are bad. That
can hardly be considered uncredited derivative work.

So, given that grsecurity is amply credited, what is it you're infuriated about?

> This is your last warning.  This is not a new problem and it needs to
> end completely, or I will make sure it ends.

You appear to be trying to bully people into not contributing to the
upstream effort to make Linux more secure. Please stop.

I have bent over backwards to credit grsecurity as best as I can see
how, and you're still going on rants. If you want people to credit
grsecurity in some specific way, then please detail the method they
should follow. If you don't have a specific way you want to be
credited, I must conclude that you're just trying to be an
obstructionist.

-Kees

-- 
Kees Cook
Pixel Security
