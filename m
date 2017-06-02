MIME-Version: 1.0
In-Reply-To: <20170602190734.6zll7zc5hr66oacl@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 3 Jun 2017 01:58:25 +0200
Message-ID: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: Theodore Ts'o <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ted,

Based on the tone of your last email, before I respond to your
individual points, I think it's worth noting that the intent of this
thread is to get a sampling of opinions of the issue of
get_random_bytes, so that I can write a patch that fixes this issue
(or a series of issues) using some strategy that we agree is a good
one. I've already implemented prototypes of a few different ideas, so
that I can discuss them competently here (a personal thing, I tend to
learn best by "doing"), and so with list feedback, I'll know in which
direction I should go for refinement eventually leading to a [PATCH]
submission. In case it wasn't evident from my last patch series for
drivers/char/random.c, despite not being corporately backed, I really
have a fun time working on this part of the kernel in my freetime.
With that said...

On Fri, Jun 2, 2017 at 9:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> It's not _my_ API, it's *our* API
> much don't break backwards compatibility,
> broken, and they complain, and you tell them to suck it,
> If you are using the word *you*, and speaking as an outside to the
> community, they you can kvetch all you like.  But you're an outsider,
> take your complaints seriously.

As I wrote earlier, if you want to bike-shed the technical aspects and
political aspects of fixing /dev/urandom, we can do that in another
thread. It's obviously a complex topic worthy of discussion, and I'd
like that discussion to be technically worthy of the issues at hand,
some of which you've raised here. So please, start a new topic for
that, and I'll happily follow up, all with the intent of writing a
patch series and running compatibility tests and whatnot; as I said
before, I like working on this stuff. However, the focus of this
thread is get_random_bytes, so please try to stay focused, lest this
get derailed.

So, you wrote:

> And if your answer is just, "blah blah di blah blah", don't be
> surprised if others respond to you in exactly the same way.
> Specifically, by saying to you (in your words), "I don't care".

I really don't care about bikeshedding this with you here, now, in
this thread. I care about solving the get_random_bytes situation.

>> While we're on the topic of that, you might consider adding a simple
>> synchronous interface.
>
> There's that word "you" again....

Yea, whatever, Ted. Can I rephrase? "As the maintainer of
drivers/char/random.c, you might consider adding a synchronous
interface so that the consumers of the file you maintain can benefit
from it; alternatively, and perhaps easier for you, express your
support for such an idea, and I'll gladly write the patch." Better? I
ask you for the benefit of the doubt that this is what I had in mind
when I wrote "you" -- that I'm seeking approval of the idea before
moving my code past prototype stage. You're the boss, so whether I
write the patch or you write the patch or someone else writes the
patch, it really _is_ you whose consideration matters the most.

> This is open source --- want to send patches?  It sounds like it's a
> workable, good idea.

Awesome, happy you like it. Yes, absolutely, I'll start cleaning
things up and will send a series.

Do you have any opinions on the issue of what the most flexible API
would be? There are a lot of varieties of wait_event. The default one
is uninterruptable, but as Stephan and Herbert saw when they were
working on this was that it could be dangerous in certain
circumstances not to allow interruption. So probably we'd want an
interruptable variety. But then maybe we want to support the other
wait_event_* modes too, like killable, timeout, hrtimeout, io, and so
on. There's a huge list. These are all implemented as macros in
wait.h, and I don't really want to have a different get_random_bytes_*
function that corresponds to _each_ of these wait_event_* functions,
since that'd be overwhelming. So I was thinking maybe a simple flag
and a timeout param could work:

int get_random_bytes_seeded(u8 *buf, size_t len, bool
is_interruptable, unsigned long timeout);

If timeout=3D=3D0, the timeout is infinite. If in_interruptible is true,
we use wait_event_interruptible_*, otherwise we use wait_event_*, and
the ret value is the usual return value from wait_event_*.

Does that seem like a good simplification that will cover most use
cases? We could of course add exceeding complexity and choice, but I
was thinking this would cover most use cases, at least to begin.

What do you think?

> ...or that I disagree with your prior point.  I think you're being
> lazy, and trying to make it someone else's problem and standing on the
> side lines and complaining, as opposed to trying to help solve the
> problem.

Um, no, what an offensive insinuation. I'm trying to solve the
problem. I'd like your honest feedback, since your maintainer, before
I start fixing this.

> No, of course we can't audit all of the code, but it's probably a good
> idea to take a random sample, and to analyze them, so we can get a
> sense of what the issues are.

That's fair. In that case, please don't take my sample of 4 as a good
one. I'll put some time into doing a more extensive analysis.

> And then maybe we can find a way to
> quickly find a class of users that can be easily fixed by using
> prandom_u32() (for example).

Yea, the easy cases like this might be easy to just extensively audit
for (it's the more subtle ones I'm concerned about). I'm sure there
will be some drivers where I'm unsure, in which case I'll leave it as
is, but for others I can see.

There are ~180 call sites to examine.

> Or maybe we can then help figure out what percentage of the callsites
> can be fixed with a synchronous interface, and fix some number of them
> just to demonstrate that the synchronous interface does work well.

I was planning on doing this to at least a couple callsites in my
upcoming patch series that adds the synchronous interface. It seems
like the right way to see if the API is good or not.

> It depends on where it's being used.  If it's part of module load,
> especially if it's one that's done automatically, having something
> that blocks forever might not be all that useful.  Especially if it
> blocks device drivers from being albe to be initialized enough to
> actually supply entropy to the whole system.

Right. In my initial email I proposed a distinction:

- External module loading is usually in a different process context,
so multiple modules can be attempted to be loaded at the same time. In
this case, it is probably safe to block in request_module.
- Built-in modules are loaded =C2=B1 linearly, from init/main.c, so these
really can't block each other. For this, I was thinking of introducing
an rnginit section, to add to the list of things like lateinit. The
rnginit drivers would be loaded _after_ the RNG has initialized, so
that they don't get blocked.

This solution would be instead of introducing that synchronous API
mentioned above. I generally like it better, since it means fewer
error prone changes, and it kind of fixes the problem in a more
systemic way.

The point you raise against it is that there might be issues where a
driver needs randomness to start, yet that driver contributes, perhaps
solely, to randomness. However, I don't think this is an inherent
problem with this solution. I think, rather, that in cases like this,
it's the driver itself that needs to be fixed, so as not to have this
catch-22. So, indeed, we'd have to hunt down any of these cases.

>> What would you think of just removing the #ifdef completely?
>
> I think making it a Kconfig option which defaults to true is the
> better approach.  At the very least let's make sure that on a range of
> "standard x86 developer machines", we're not spamming dmesg.  If we
> are, simply turning it on and standing on principle, "we're the
> cryptographers and we get to decide what is right and holy", and if
> lots of people start complaining about how it makes their machine
> usuable, that's exactly the same kind of arrogance which caused kernel
> developers to become incensed by systemd developers when they spammed
> dmesg and made kernel developers' systems unusuable.  Would you be
> upset if systemd developers did it unto you?  Then maybe you shouldn't
> do it unto others....

Again, I wasn't thinking about this in such an extreme polarized
fashion like how you present it here. I was just thinking that since
it's a bug when the pool is read from while unseeded -- either they
should be using prandom or should be deferring the call, as we
discussed -- that it'd just be easiest to always print, so we can
always see when this bug occurs. I wasn't thinking that this would
result in "arrogant log spam" or something. But anyway, if you prefer
it to be a Kconfig option, that's no problem with me, and I'll roll a
patch for that and submit it here.

Regards,
Jason
