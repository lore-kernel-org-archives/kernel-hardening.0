Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 13 Dec 2016 00:04:27 +0100
Message-ID: <CAHmME9qk+Z8CdhTFQnTkwT8S-n56tzi77-uAV3dNigcGMQx7uQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable function
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 13, 2016 at 12:01 AM, Andi Kleen <ak@linux.intel.com> wrote:
> It would be nice if the network code could be converted to use siphash
> for the secure sequence numbers. Right now it pulls in a lot of code
> for bigger secure hashes just for that, which is a problem for tiny
> kernels.

Indeed this would be a great first candidate. There are lots of places
where MD5 (!!) is pulled in for this sort of thing, when SipHash could
be a faster and leaner replacement (and arguably more secure than
rusty MD5).
