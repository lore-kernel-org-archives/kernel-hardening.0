Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAHmME9qk+Z8CdhTFQnTkwT8S-n56tzi77-uAV3dNigcGMQx7uQ@mail.gmail.com>
References: <CAHmME9qk+Z8CdhTFQnTkwT8S-n56tzi77-uAV3dNigcGMQx7uQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Dec 2016 11:25:45 -0800
Message-ID: <CA+55aFyBsU_sxUuuNBMFUQonWOtfoW9AMk=vn=KLTKrkXVv+MA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andi Kleen <ak@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 3:04 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Indeed this would be a great first candidate. There are lots of places
> where MD5 (!!) is pulled in for this sort of thing, when SipHash could
> be a faster and leaner replacement (and arguably more secure than
> rusty MD5).

Yeah,. the TCP sequence number md5_transform() cases are likely the
best example of something where siphash might be good. That tends to
be really just a couple words of data (the address and port info) plus
the net_secret[] hash. I think they currently simply just fill in the
fixed-sized 64-byte md5-round area.

I wonder it's worth it to have a special spihash version that does
that same "fixed 64-byte area" thing.

But please talk to the netwotrking people. Maybe that's the proper way
to get this merged?

            Linus
