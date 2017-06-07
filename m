Date: Wed, 7 Jun 2017 18:37:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170607173749.GC8330@leverpostej>
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
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 01:03:19PM -0400, Theodore Ts'o wrote:
> The other approach is to find a way to have initialized "seed" entropy
> which we can count on at every boot.  The problem is that this is very
> much dependent on how the bootloader works.  It's easy to say "store
> it in the kernel", but where the kernel is stored varies greatly from
> architecture to architecture.  In some cases, the kernel can stored in
> ROM, where it can't be modified at all.
> 
> It might be possible, for example, to store a cryptographic key in a
> UEFI boot-services variable, where the key becomes inaccessible after
> the boot-time services terminate.  But you also need either a reliable
> time-of-day clock, or a reliable counter which is incremented each
> time the system that boots, and which can't be messed with by an
> attacker, or trivially reset by a clueless user/sysadmin.

FWIW, EFI has an (optional) EFI_RNG_PROTOCOL, that we currently use to
seed the kernel's entropy pool. The EFI stub creates a config table with
the entropy, which the kernel reads.

This is re-seeded prior to kexec() to avoid the entropy being recycled.

See commits:

636259880a7e7d34 ("efi: Add support for seeding the RNG from a UEFI config table")
568bc4e87033d232 (" efi/arm*/libstub: Invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table")

Unfortunately, I beleive that support for the protocol is currently rare
in practice.

Thanks,
Mark.
