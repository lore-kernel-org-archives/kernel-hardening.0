Date: Tue, 6 Jun 2017 19:19:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Message-ID: <20170606221910.GB9057@khazad-dum.debian.net>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
 <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606170319.5eva2yoxxeru5p74@thunk.org>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 06 Jun 2017, Theodore Ts'o wrote:
> It might be possible, for example, to store a cryptographic key in a
> UEFI boot-services variable, where the key becomes inaccessible after
> the boot-time services terminate.  But you also need either a reliable
> time-of-day clock, or a reliable counter which is incremented each
> time the system that boots, and which can't be messed with by an
> attacker, or trivially reset by a clueless user/sysadmin.
> 
> Or maybe we can have a script that is run at shutdown and boot-up that
> stashes 32 bytes of entropy in a reserved space accessible to GRUB,
> and which GRUB then passes to the kernel using an extension to the
> Linux/x86 Boot Protocol.  (See Documentation/x86/boot.txt)

On that same idea, one could add an early_initramfs handler for entropy
data.

One could also ensure the kernel command line is used to feed some
entropy for the CRNG init (for all I know, this is already being done),
and add a do-nothing parameter (that gets sanitized away after use) that
can be used to add entropy to that command line.  Something like
random.someentropy=<bootloader-supplied random stuff goes here>.  This
might be more generic than the x86 boot protocol reserved space...

On the better bootloaders, an initramfs segment can be loaded
independently (and you can have as many as required), which makes an
early_initramfs a more palatable vector to inject large amounts of
entropy into the next boot than, say, modifying the kernel image
directly at every boot/shutdown to stash entropy in there somewhere.

These are all easy to implement, I just don't know how *useful* they
would really be.

-- 
  Henrique Holschuh
