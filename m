Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 13 Dec 2016 00:39:48 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20161213083948.GA8994@zzz>
References: <CA+55aFymjmEPNx8ZwhxtiE=nPG_5gbkzUQhdRAwTareuNcV=tA@mail.gmail.com>
 <20161212221832.10653-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212221832.10653-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable
 function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 11:18:32PM +0100, Jason A. Donenfeld wrote:
> +	for (; data != end; data += sizeof(u64)) {
> +		m = get_unaligned_le64(data);
> +		v3 ^= m;
> +		SIPROUND;
> +		SIPROUND;
> +		v0 ^= m;
> +	}
> +#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
> +	b |= le64_to_cpu(load_unaligned_zeropad(data) & bytemask_from_count(left));
> +#else

Hmm, I don't think you can really do load_unaligned_zeropad() without first
checking for 'left != 0'.  The fixup section for load_unaligned_zeropad()
assumes that rounding the pointer down to a word boundary will produce an
address from which an 'unsigned long' can be loaded.  But if 'left = 0' and we
happen to be on a page boundary with the next page unmapped, then this will not
be true and the second load will still fault.

Eric
