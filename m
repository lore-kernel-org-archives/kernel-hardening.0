Date: Wed, 7 Jun 2017 17:27:37 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170607212737.t54x4a6ym4wqxzmw@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
 <20170606221910.GB9057@khazad-dum.debian.net>
 <1691714.1h4IbvMDSf@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1691714.1h4IbvMDSf@tauon.chronox.de>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 07, 2017 at 07:00:17AM +0200, Stephan Müller wrote:
> > On that same idea, one could add an early_initramfs handler for entropy
> > data.
> 
> Any data that comes from outside during the boot process, be it some NVRAM 
> location, the /var/lib...seed file for /dev/random or other approaches are 
> viewed by a number of folks to have zero bits of entropy.

The Open BSD folks would disagree with you.  They've designed their
whole system around saving entropy at shutdown, reading it as early as
possible by the bootloader, and then as soon as possible after the
reboot, to overwrite and reinitialize the entropy seed stored on disk
so that on a reboot after a crash.  They consider this good enough to
assume that their CRNG is *always* strongly initialized.

I'll let you have that discussion/argument with Theo de Raadt, though.
Be warned that he has opinions about security that are almost
certainly as strong (and held with the same level of certainty) as a
certain Brad Spengler...

						- Ted
