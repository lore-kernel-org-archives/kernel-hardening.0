Date: Fri, 2 Jun 2017 13:26:16 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170602172616.47qcxav6adq52nmk@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is
 complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 02, 2017 at 04:59:56PM +0200, Jason A. Donenfeld wrote:
> /dev/urandom will return bad randomness before its seeded, rather than
> blocking, and despite years and years of discussion and bike shedding,
> this behavior hasn't changed, and the vast majority of cryptographers
> and security experts remain displeased. It _should_ block until its
> been seeded for the first time, just like the new getrandom() syscall,
> and this important bug fix (which is not a real api break) should be
> backported to all stable kernels. (Userspace doesn't even have a
> reliable way of determining whether or not it's been seeded!) Yes,
> yes, you have arguments for why you're keeping this pathological, but
> you're still wrong, and this api is still a bug. Forcing userspace
> architectures to work around your bug, as your arguments usually go,
> is disquieting.

I tried making /dev/urandom block.  The zero day kernel testing within
a few hours told us that Ubuntu LTS at the time and OpenWrt would fail
to boot.  And when Python made a change to call getrandom(2) with the
default blocking semantic instead of using /dev/urandom, some
distributions using systemd stopped booting.

So if you're a security focused individual who is kvetching that we're
asking to force userspace to change to fix "a bug", you need to
understand that making the change you're suggesting will *also*
require making changes to userspace.  And if you want to go try to
convince Linus Torvalds that it's OK to make a backwards-incompatible
changes that break Ubuntu LTS and OpenWRT by causing them to fail to
boot --- be my guest.

And if we're breaking distributions from them booting when their use
of /dev/urandom is not security critical, I suspect Linus is not going
to be impressed that you are breaking those users for no beneft.  (For
example, Python's use of getrandom(2) was to prevent denial of service
attacks when Python is used as a fast-CGI web server script, and it
was utterly pointless from security perspective to block when the
python script was creating on-demand systemd unit files, where the DOS
threat was completely irrelevant.)

> As the printk implies, it's possible for get_random_bytes() to be
> called before it's seeded. Why was that helpful printk put behind an
> ifdef? I suspect because people would see the lines in their dmesg and
> write emails like this one to the list.

The #ifdef and the printk was there from the very beginning.

commit 392a546dc8368d1745f9891ef3f8f7c380de8650
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Nov 3 18:24:08 2013 -0500

    random: add debugging code to detect early use of get_random_bytes()

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

It was four years ago, so I don't remember the exact circumstances,
but if I recall the issue was not wanting to spam the dmesg.  Also, at
the time, we hadn't yet created the asynchronous interfaces that allow
kernel code to do the right thing, even if it was massively
inconvenient.

At this point, I think we should be completely open to making it be a
config option, and if it looks like for common configs we're not
spamming dmesg, we could even it make it be the default.  We just also
need to give driver writers some easy-to-understand receipes to fix
their drivers to do the right thing.  If we do that first, it's much
more likely they will actually fix their kernel code, instead of just
turning the warning off.

> drivers/net/ieee802154/at86rf230.c:
> static int at86rf230_probe(struct spi_device *spi)
> {
> ...
>         get_random_bytes(csma_seed, ARRAY_SIZE(csma_seed));
> 
> No clue what this driver is for or if it actually needs good
> randomness, but using get_random_bytes in a hardware probe function
> can happen prior to userspace's ability to seed.

What, you mean as a computer scientist you didn't immediately
understand that csma doesn't refer to CSMA/CD --- or "Carrier-sense
multiple access with collision avoidance"?  For shame!  :-)

This is basically the exponential backoff which used in ethernet
networks, and the *real* answer is that they should be using
prandom_u32().

> arch/s390/crypto/prng.c seems to call get_random_bytes on module load,
> which can happen pre-userspace, for seeding some kind of RNG of its
> own.

It appears to be accessing a hardware cryptographic processor
function, and seems to do its own entropy gathering relying on stack
garbage as well as using get_random_bytes().  By default it is defined
as a module, so I suspect in most situations it's called
post-userspace, but agreed that it is not guaranteed to be the case.
I think in practice most IBM customers will be safe because they tend
to use distro kernels that will almost certainly be building it as a
module, but your point is well taken.

> And so on and so on and so on. If you grep the source as I did, you'll
> find there's no shortage of head-scratchers. "Hmmm," you ask yourself,
> "could this be called before userspace has ensured that /dev/urandom
> is seeded? do we actually _need_ good randomness here, or does it not
> matter?" I guess you could try to reason about each and every one of
> them -- you might even have those same questions about the silly
> examples I pasted above -- but that one-by-one methodology seems
> excessively fragile and arduous.

This is a fair point.

> There must have been a developer who thought about this at least once
> before, because random.c does have a callback notifier mechanism for
> drivers to learn when they can safely call get_random_bytes --
> add_random_ready_callback. However, it's only used by ONE driver --
> the drbg in crypto/. It's pretty clunky to use, and there's no
> reasonable to way replace every single usage of get_random_bytes with
> complicated callback infrastructure.

That developer was Herbert Xu, and he added it about two years ago.
See commit 205a525c3342.

> There might be some hope, however. Recent kernels now have a very fast
> urandom seeding, which moves the seed-ready-point to be much early
> during boot. This is still not early enough to just "do nothing", but
> early enough that there's room for a good solution:
> 
> For builtin modules, we defer all __init calls to after seeding of
> drivers that use get_random_bytes. That is to say, rather than using
> add_random_ready_callback one by one in an ad-hoc fashion with every
> call site that needs good randomness, we just defer loading those
> entire modules until an add_random_ready_callback callback. We might
> need to explicitly opt-in to this -- by introducing an
> `after_urandom_init(..)`, for example, to replace module_init in these
> cases -- or perhaps there's a way to automatically detect and defer.
> For external modules, it's much easier; we simply have
> request_module() block until after seeding is complete. This function
> is already a blocking one, so that's not an issue. And it'd ensure
> that things like virtual network drivers that are dynamically loaded
> and use get_random_bytes, such as vxlan or wireguard, simply block on
> `ip link add ...`, which would be the desired behavior.

So the problem with doing this by default, for all modules, is that on
those platforms which don't have good hardware support for seeding the
non-blocking pool quickly, if we defer all modules, we will also be
deferring the means by which we get the entropy needed to seed the
non-blocking pool.  So for example, if you have a bunch of networking
drivers that are using get_random_bytes() for exponential backoff,
when they *should* be using prandom_u32(), if we don't fix *that* bug,
simply deferring the module load will also defer the entropy input
from the networking interrupts from the networking card.

So while I agree that auditing all calls to get_random_bytes() is
fragile from a security robustness perspective, and I certainly agree
that it is onerous, some amount of it is still going to have to be
done.  And for things like the S390 PRNG (which is supposed to be
generating cryptorgaphically secure random numbers), probably we
should just fix it to use the add_random_ready_callback() interface
since even if in practice most users will be safe, we shouldn't be
depending on it.

Adding a patch to make DEBUG_RANDOM_BOOT a Kconfig option also is a
really good first step, for someone who wants to take this on as a
project.

Cheers,

					- Ted
					
