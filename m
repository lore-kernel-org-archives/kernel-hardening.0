Date: Tue, 6 Jun 2017 19:14:42 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170606231442.i4t5qs4z5q6wlbj7@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
 <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
 <20170606221910.GB9057@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606221910.GB9057@khazad-dum.debian.net>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:19:10PM -0300, Henrique de Moraes Holschuh wrote:
> On that same idea, one could add an early_initramfs handler for entropy
> data.
> 
> One could also ensure the kernel command line is used to feed some
> entropy for the CRNG init (for all I know, this is already being done),
> and add a do-nothing parameter (that gets sanitized away after use) that
> can be used to add entropy to that command line.  Something like
> random.someentropy=<bootloader-supplied random stuff goes here>.  This
> might be more generic than the x86 boot protocol reserved space...
> 
> On the better bootloaders, an initramfs segment can be loaded
> independently (and you can have as many as required), which makes an
> early_initramfs a more palatable vector to inject large amounts of
> entropy into the next boot than, say, modifying the kernel image
> directly at every boot/shutdown to stash entropy in there somewhere.
> 
> These are all easy to implement, I just don't know how *useful* they
> would really be.

+1

The kernel side for all of these are relatively easy.  The hard part
is to do an end-to-end solution.  Which means the changes to the
bootloader, the initramfs tools, etc.

As I recall one issue with doing things in the initramfs scripts is
that for certain uses of randomness (such as the stack canary), it's
hard to change the valid canary after it's been used for a userspace
process, since you might have to support more than one valid canary
value until all of the proceses using the original (not necessarily
cryptographically initialized) stack canary has exited.  So while the
upside is that it might not require any kernel changes to inject the
randomness into the non-blocking pool via one of the initramfs
scripts, from an overall simplicity for the kernel users, it's nice if
we can initialize the CRNG as early possible --- in the ideal world,
even before KASLR has been initialized, which means ****really****
early in the boot process.

That's the advantage of doing it as part of the Linux/x86 boot
protocol, since it's super simple to get at the entropy seed.  It
doesn't require parsing the kernel command-line.  The tradeoff is that
it is x86 specific, and the ARM, ppcle folks, etc. would have to
implement their own way of injecting entropy super-early into the boot
process.

One advantage of doing this somewhat harder thing is that **all** of
the issues around re-architecting a new rng_init initcall level, and
dealing with module load order, etc., disappear if we can figure out a
way to initialize the entropy pre-KASLR.  Yes, it's harder; but it
solves all of the issues at one fell swoop.

					- Ted
