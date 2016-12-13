Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20161213083948.GA8994@zzz>
References: <CA+55aFymjmEPNx8ZwhxtiE=nPG_5gbkzUQhdRAwTareuNcV=tA@mail.gmail.com>
 <20161212221832.10653-1-Jason@zx2c4.com> <20161213083948.GA8994@zzz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Dec 2016 11:26:44 -0800
Message-ID: <CA+55aFyOD4EhD1v7JNTHxvGSqMi7UKgybWH+PZE1KjXeZTT8BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable function
To: Eric Biggers <ebiggers3@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 13, 2016 at 12:39 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
>
> Hmm, I don't think you can really do load_unaligned_zeropad() without first
> checking for 'left != 0'.

Right you are. If the allocation is at the end of a page, the 0-size
case would be entirely outside the page and there's no fixup.

Of course, that never happens in normal code, but DEBUG_PAGE_ALLOC can
trigger it.

              Linus
