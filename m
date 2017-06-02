MIME-Version: 1.0
In-Reply-To: <20170602172616.47qcxav6adq52nmk@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 2 Jun 2017 19:44:04 +0200
Message-ID: <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 7:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I tried making /dev/urandom block.
> So if you're a security focused individual who is kvetching
> And if we're breaking

Yes yes, bla bla, predictable response. I don't care. Your API is
still broken. Excuses excuses. Yes, somebody needs to do the work in
the end, maybe that person can be me, maybe you, maybe somebody else.
Regardless, we can take this to a different thread if you'd like to
bikeshed about that particular point for another five millennia. But
that isn't the main topic of this thread, so I'm not going to get
sucked into that blackhole.

> the time, we hadn't yet created the asynchronous interfaces that allow
> kernel code to do the right thing, even if it was massively
> inconvenient.

While we're on the topic of that, you might consider adding a simple
synchronous interface. I realize that the get_blocking_random_bytes
attempt was aborted as soon as it began, because of issues of
cancelability, but you could just expose the usual array of wait,
wait_interruptable, wait_killable, etc, or just make that wait object
and condition non-static so others can use it as needed. Having to
wrap the current asynchronous API like this kludge is kind of a
downer:

https://git.zx2c4.com/WireGuard/diff/src/config.c?id=c77145a8248dfc49e307eae7d7edd5fdca8d5559

> At this point, I think we should be completely open to making it be a
> config option, and if it looks like for common configs we're not
> spamming dmesg, we could even it make it be the default.  We just also
> need to give driver writers some easy-to-understand receipes to fix
> their drivers to do the right thing.  If we do that first, it's much
> more likely they will actually fix their kernel code, instead of just
> turning the warning off.

That's a good point. In my initial email I looked down on the
whack-a-mole approach, because nobody is ever going to analyze all of
those cases. But... if dmesgs are going wild for some people, we'll
have upset users doing the hard work for us. So maybe it's worthwhile
to turn that warning on by default.


> This is basically the exponential backoff which used in ethernet
> networks, and the *real* answer is that they should be using
> prandom_u32().
> I think in practice most IBM customers will be safe because they tend

No, what it means is that the particularities of individual examples I
picked at random don't matter. Are we really going to take the time to
audit each and every callsite to see "do they need actually random
data? can this be called pre-userspace?" I mentioned this in my
initial email. As I said there, I think analyzing all the cases one by
one is fragile, and more will pop up, and that's not really the right
way to approach this. And furthermore, as alluded to above, even
fixing clearly-broken places means using that hard-to-use asynchronous
API, which adds even more potentially buggy TCB to these drivers and
all the rest. Not a good strategy.

Seeing as you took the time to actually respond to the
_particularities_ of each individual random example I picked could
indicate that you've missed this point prior.

>> And so on and so on and so on. If you grep the source as I did, you'll
>> find there's no shortage of head-scratchers. "Hmmm," you ask yourself,
>> "could this be called before userspace has ensured that /dev/urandom
>> is seeded? do we actually _need_ good randomness here, or does it not
>> matter?" I guess you could try to reason about each and every one of
>> them -- you might even have those same questions about the silly
>> examples I pasted above -- but that one-by-one methodology seems
>> excessively fragile and arduous.
>
> This is a fair point.

Glad we're on the same page about that.


> That developer was Herbert Xu, and he added it about two years ago.
> See commit 205a525c3342.

Right, it was him and Stephan (CCd). They initially started by adding
get_blocking_random_bytes, but then replaced this with the
asynchronous one, because they realized it could block forever. As I
said above, though, I still think a blocking API would be useful,
perhaps just with more granularity for the way in which it blocks.

> So the problem with doing this by default, for all modules, is that on
> those platforms which don't have good hardware support for seeding the
> non-blocking pool quickly, if we defer all modules, we will also be
> deferring the means by which we get the entropy needed to seed the
> non-blocking pool.  So for example, if you have a bunch of networking
> drivers that are using get_random_bytes() for exponential backoff,
> when they *should* be using prandom_u32(), if we don't fix *that* bug,
> simply deferring the module load will also defer the entropy input
> from the networking interrupts from the networking card.

"We shouldn't fix legitimate cryptographic bugs, because the rest of
our codebase is too buggy to support anything reasonable."
Sounds like it'd be worthwhile to begin fixing things in this fashion, then.

> So while I agree that auditing all calls to get_random_bytes() is
> fragile from a security robustness perspective, and I certainly agree
> that it is onerous, some amount of it is still going to have to be
> done.

In fixing those bugs where it's clearly not necessary, I guess you're
right then.

>  And for things like the S390 PRNG (which is supposed to be
> generating cryptorgaphically secure random numbers), probably we
> should just fix it to use the add_random_ready_callback() interface
> since even if in practice most users will be safe, we shouldn't be
> depending on it.

Please don't think of this example as THE instance where it matters. I
seriously just opened a few files from my grep at random. That this
one wound up being a particularly relevant one is just chance. Other
dragons lurk below, beware.

> Adding a patch to make DEBUG_RANDOM_BOOT a Kconfig option also is a
> really good first step, for someone who wants to take this on as a
> project.

What would you think of just removing the #ifdef completely?

Regards,
Jason
