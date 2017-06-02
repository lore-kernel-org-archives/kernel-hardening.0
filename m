Date: Fri, 2 Jun 2017 15:07:34 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170602190734.6zll7zc5hr66oacl@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org>
 <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is
 complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 02, 2017 at 07:44:04PM +0200, Jason A. Donenfeld wrote:
> On Fri, Jun 2, 2017 at 7:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > I tried making /dev/urandom block.
> > So if you're a security focused individual who is kvetching
> > And if we're breaking
> 
> Yes yes, bla bla, predictable response. I don't care. Your API is
> still broken. Excuses excuses. Yes, somebody needs to do the work in
> the end, maybe that person can be me, maybe you, maybe somebody else.

It's not _my_ API, it's *our* API --- that is the Linux kernel
community's.  And part of the rules of this community is that we very
much don't break backwards compatibility, unless there is a really
good reason, where Linus gets to decide if it's a really good reason.
So if you care a lot about this issue, then you need to do the work to
make the change, and part of it is showing, to a high degree of
certainty, that it won't break backwards compatibility.

Because if you don't, and you flout community norms, and users get
broken, and they complain, and you tell them to suck it, then Linus
will pull out is patented clue stick, and tell you that you have in
fact flouted community norms, correct you publically, and then revert
your change.

If you are using the word *you*, and speaking as an outside to the
community, they you can kvetch all you like.  But you're an outsider,
and don't have to listen to you.  But if you want to make a positive
difference here, and you're passionate about it --- this is you would
need to do.  That being said, we're all volunteers, so if you don't
want to bother, that's fine.  But then don't be surprised if we don't
take your complaints seriously.

> While we're on the topic of that, you might consider adding a simple
> synchronous interface.

There's that word "you" again....

> I realize that the get_blocking_random_bytes
> attempt was aborted as soon as it began, because of issues of
> cancelability, but you could just expose the usual array of wait,
> wait_interruptable, wait_killable, etc, or just make that wait object
> and condition non-static so others can use it as needed. Having to
> wrap the current asynchronous API like this kludge is kind of a
> downer:

This is open source --- want to send patches?  It sounds like it's a
workable, good idea.

> No, what it means is that the particularities of individual examples I
> picked at random don't matter. Are we really going to take the time to
> audit each and every callsite to see "do they need actually random
> data? can this be called pre-userspace?" I mentioned this in my
> initial email. As I said there, I think analyzing all the cases one by
> one is fragile, and more will pop up, and that's not really the right
> way to approach this. And furthermore, as alluded to above, even
> fixing clearly-broken places means using that hard-to-use asynchronous
> API, which adds even more potentially buggy TCB to these drivers and
> all the rest. Not a good strategy.
> 
> Seeing as you took the time to actually respond to the
> _particularities_ of each individual random example I picked could
> indicate that you've missed this point prior.

...or that I disagree with your prior point.  I think you're being
lazy, and trying to make it someone else's problem and standing on the
side lines and complaining, as opposed to trying to help solve the
problem.

No, of course we can't audit all of the code, but it's probably a good
idea to take a random sample, and to analyze them, so we can get a
sense of what the issues are.  And then maybe we can find a way to
quickly find a class of users that can be easily fixed by using
prandom_u32() (for example).

Or maybe we can then help figure out what percentage of the callsites
can be fixed with a synchronous interface, and fix some number of them
just to demonstrate that the synchronous interface does work well.

> Right, it was him and Stephan (CCd). They initially started by adding
> get_blocking_random_bytes, but then replaced this with the
> asynchronous one, because they realized it could block forever. As I
> said above, though, I still think a blocking API would be useful,
> perhaps just with more granularity for the way in which it blocks.

It depends on where it's being used.  If it's part of module load,
especially if it's one that's done automatically, having something
that blocks forever might not be all that useful.  Especially if it
blocks device drivers from being albe to be initialized enough to
actually supply entropy to the whole system.

Or maybe (in the case of stack canaries), the answer is we should
start with crappy random numbers, but then once the random number
generator has been initialized, we can use the callback to get
cryptographically secure random number generators, and then we need to
figure out how to phase out use of the old crappy random numbers and
substitute in the exclusive use of the good random numbers.  Because
saying that we'll just simply not allow any processes to start until
we have good random numbers, which means we can't load the kernel
modules, and we're running on an architecture which doesn't have
RDRAND or even a high-resolution clock, may mean that we're in a world
of hurt.

And simply saying *your* system is buggy, or *your* system is
fundamentally broken, isn't particularly helpful.  Yes, *we* have Linux
routers using MIPS processors which don't have much in the way of
entropy gathering facilities or true random number generation.  Simply
bricking them so we can say, "yay, our system is no longer buggy", is
not acceptable.  So the question is whether you're going to help make
things incrementally better, or just sit on the sidelines and kvetch.

And if your answer is just, "blah blah di blah blah", don't be
surprised if others respond to you in exactly the same way.
Specifically, by saying to you (in your words), "I don't care". 

> > Adding a patch to make DEBUG_RANDOM_BOOT a Kconfig option also is a
> > really good first step, for someone who wants to take this on as a
> > project.
> 
> What would you think of just removing the #ifdef completely?

I think making it a Kconfig option which defaults to true is the
better approach.  At the very least let's make sure that on a range of
"standard x86 developer machines", we're not spamming dmesg.  If we
are, simply turning it on and standing on principle, "we're the
cryptographers and we get to decide what is right and holy", and if
lots of people start complaining about how it makes their machine
usuable, that's exactly the same kind of arrogance which caused kernel
developers to become incensed by systemd developers when they spammed
dmesg and made kernel developers' systems unusuable.  Would you be
upset if systemd developers did it unto you?  Then maybe you shouldn't
do it unto others....

						- Ted
