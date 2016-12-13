Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161213083948.GA8994@zzz>
References: <CA+55aFymjmEPNx8ZwhxtiE=nPG_5gbkzUQhdRAwTareuNcV=tA@mail.gmail.com>
 <20161212221832.10653-1-Jason@zx2c4.com> <20161213083948.GA8994@zzz>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 13 Dec 2016 23:43:06 +0100
Message-ID: <CAHmME9rViJoDbJ_30ocqHEFESjeLMZOerjbnXmhQ4P32pbXRFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable function
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Tue, Dec 13, 2016 at 9:39 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hmm, I don't think you can really do load_unaligned_zeropad() without first
> checking for 'left != 0'.  The fixup section for load_unaligned_zeropad()
> assumes that rounding the pointer down to a word boundary will produce an
> address from which an 'unsigned long' can be loaded.  But if 'left = 0' and we
> happen to be on a page boundary with the next page unmapped, then this will not
> be true and the second load will still fault.

Excellent point. I haven't been able to trigger this in my
experiments, but it doesn't look like there's much to prevent this
from happening. I'll submit a v4 with this as fixed, since there
hasn't been any other code quality issues.

Jason
