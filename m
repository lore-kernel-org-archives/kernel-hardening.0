Date: Wed, 7 Jun 2017 18:26:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170607172627.GB8330@leverpostej>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
 <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
 <20170606221910.GB9057@khazad-dum.debian.net>
 <1496854825.10825.24.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496854825.10825.24.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Daniel Micay <danielmicay@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 07, 2017 at 01:00:25PM -0400, Daniel Micay wrote:
> > On the better bootloaders, an initramfs segment can be loaded
> > independently (and you can have as many as required), which makes an
> > early_initramfs a more palatable vector to inject large amounts of
> > entropy into the next boot than, say, modifying the kernel image
> > directly at every boot/shutdown to stash entropy in there somewhere.

[...]
 
> I didn't really understand the device tree approach and mentioned a
> few times before. Passing via the kernel cmdline is a lot simpler than
> modifying the device tree in-memory and persistent modification isn't
> an option unless verified boot is missing anyway.

I might be missing something here, but the command line is inside of the
device tree, at /chosen/bootargs, so modifying the kernel command line
*is* modifying the device tree in-memory.

For arm64, we have a /chosen/kaslr-seed property that we hope
FW/bootloaders fill in, and similar could be done for some initial
entropy, provided appropriate HW/FW support.

Thanks,
Mark.
