Date: Tue, 6 Jun 2017 13:03:19 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170606170319.5eva2yoxxeru5p74@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
 <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 02:34:43PM +0200, Jason A. Donenfeld wrote:
> 
> Yes, I agree whole-heartedly.  A lot of people have proposals for
> fixing the direct idea of entropy gathering, but for whatever reason,
> Ted hasn't merged stuff. I think Stephan (CCd) rewrote big critical
> sections of the RNG, called LRNG, and published a big paper for peer
> review and did a lot of cool engineering, but for some reason this
> hasn't been integrated. I look forward to movement on this front in
> the future, if it ever happens. Would be great.

So it's not clear what you mean by Stephan's work.  It can be
separated into multiple pieces; one is simply using a mechanism which
can be directly mapped to NIST's DRBG framework.  I don't believe this
actually adds any real security per se, but it can make it easier to
get certification for people who care about getting FIPS
certification.  Since I've seen a lot of snake oil and massive waste
of taxpayer and industry dollars by FIPS certification firms, it's not
a thing I particularly find particularly compelling.

The second bit is "Jitter Entropy".  The problem I have with that is
there isn't any convincing explanation about why it can't be predicted
to some degree of accuracy with someone who understands what's going
on with Intel's cache architecture.  (And this isn't just me, I've
talked to people who work at Intel and they are at best skeptical of
the whole idea.)

To be honest, there is a certain amount of this which is true with
harvesting interrupt timestamps, since for at least some interrupts
(in the worst case, the timer interrupt, especially on SOC's where all
of the clocks are generated from a single master oscillator) at least
some of the unpredictability is due to fact that the attacker needs to
understand what's going on with cache hits and misses, and that in
turn is impacted by compiler code generation, yadda, yadda, yadda.

The main thing then with trying to get entropy from sampling from the
environment is to have a mixing function that you trust, and that you
capture enough environmental data which hopefully is not available to
the attacker.  So for example, radio strength measurements from the
WiFi data is not necessarily secret, but hopefully the information of
whether the cell phone is on your desk, or in your knapsack, either on
the desk, or under the desk, etc., is not available the analyst
sitting in Fort Meade (or Beijing, if you trust the NSA but not the
Ministry of State Security :-).

The judgement call is when you've gathered enough environmental data
(whether it is from CPU timing and cache misses if you are using
Jitter Entropy), or interupt timing, etc., is when you have enough
unpredictable data that it will be sufficient to protect you against
the attacker.  We try to make some guesses of when we've gathered a
"bit" of entropy, but it's important to be humble here.  We don't have
a theoretical framework for *any* of this, so the way we gather
metrics is really not all that scientific.

We also need to be careful not to fall into the trap of wishful
thinking.  Yes, if we can say that the CRNG is fully initialized
before the init scripts are started, or even very early in the
initcall, then we can say yay!  Problem solved!!  But just because
someone *claims* that JitterEntropy will solve the problem, doesn't
necessarily mean it really does.  I'm not accusing Stephan of trying
to deliberately sell snake oil; just that at least some poeople have
looked at it dubiously, and I would at least prefer to gather a lot
more environmental noise, and be more conservative before saying that
we're sure the CRNG is fully initialized.


The other approach is to find a way to have initialized "seed" entropy
which we can count on at every boot.  The problem is that this is very
much dependent on how the bootloader works.  It's easy to say "store
it in the kernel", but where the kernel is stored varies greatly from
architecture to architecture.  In some cases, the kernel can stored in
ROM, where it can't be modified at all.

It might be possible, for example, to store a cryptographic key in a
UEFI boot-services variable, where the key becomes inaccessible after
the boot-time services terminate.  But you also need either a reliable
time-of-day clock, or a reliable counter which is incremented each
time the system that boots, and which can't be messed with by an
attacker, or trivially reset by a clueless user/sysadmin.

Or maybe we can have a script that is run at shutdown and boot-up that
stashes 32 bytes of entropy in a reserved space accessible to GRUB,
and which GRUB then passes to the kernel using an extension to the
Linux/x86 Boot Protocol.  (See Documentation/x86/boot.txt)


Quite frankly, I think this is actually a more useful and fruitful
path than either the whack-a-mole audit of all of the calls to
get_random_bytes() or adding a blocking variant to get_random_bytes()
(since in my opinion this becomes yet another version of whack-a-mole,
since each change to use the blocking variant requires an audit of how
the randomness is used, or where the function is called).

The reality though is that Linux is a volunteer effort, and so all a
maintainer can control is (a) is personal time, (b) whatever resources
his company may have entrusted him with, (c) trying to pursuade others
in the development community to do things (for which this e-mail is an
example :-), and ultimately, (d) the maintainer can say NO to a patch.
I try as much as possible to do (c), but the reality is that
/dev/random is sexiest thing, and to be honest, I suspect that there
are many more sources of vulnerability which are easier for an
attacker than attacking the random number generator.  So it may in
fact be _rational_ for people who are working on hardening the kernel
to focus on other areas.  That being said, we should be trying to
improve things on all fronts, not just the sexy ones.

> Ted about this, I proposed instead a more global approach of
> introducing an rng_init() to complement things like late_init() and
> device_init() and such. The idea here would be two-fold:
> 
> - Modules that are built in would only be loaded as a callback to the
> initialization of the RNG. An API for that already exists.
> - Modules that are external would simply block userspace in
> request_module until the RNG is initialized. This patch series adds
> that kind of API.
> 
> If I understood correctly, Ted was worried that this might introduce
> some headaches with module load ordering.

My concern is while it might work on one architecture, it would break
on another architecture.  And even on one architecture, it might be
that it works on bare metal hardware, but on in a virtual environment,
there aren't enough interrupts for us to fully initialize the CRNG.
So it might be that Fedora with its kernel config file work fine in one area, but
it mysteriously fails if you install Fedora in a VM --- and worse,
maybe it works in Cloud Platform A, but not Cloud Platform B.  (And
then the rumor mongers will come out and claim that the failure on one
Cloud Platform is due to the fact that some set of enigneers work for
one company versus another...  not that we've seen any kind of rants
like that on the kernel-hardening mailing list!  :-)

I think this is a soluble problem, but it may be rather tricky.  For
example, it may be that for a certain class of init calls, even though
they are in subsystems that are compiled into the kernel, those init
calls perhaps could be deferred so they are running in parallel with
the init scripts.  (Or maybe we could just require that certain kernel
modules can *only* be compiled as modules if they use rng_init ---
although that may get annoying for those of us who like being able to
build custom configured monolithic kernels.  So I'd prefer the first
possibility if at all possible.)

Cheers,

					- Ted
