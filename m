Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 10 Jan 2017 18:03:07 +0100
Message-ID: <CAHmME9pyO9yQ2aBM3CJYFBEyg8-J3whrGEkciJBNnvUNf34Wag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] [RFC] Use of SipHash and HalfSipHash for Hashtables and PRF
To: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

In this case, by "RFC" I actually mean "request for commits". No
comments, please. :)

David Miller's net-next tree now has my SipHash patchset, which adds
SipHash to the kernel for all sorts of interesting uses. The first two
uses include syncookies and secure sequence numbers. Future uses
include hashtable lookup functions and other types of short MAC uses.
This message is an invitation to start switching certain interfaces
over to SipHash, if the use improves either performance or security,
or perhaps both.

So, what's the deal?

SipHash takes two inputs:
- A randomly generated 16-byte longterm secret key, generated via
get_random_bytes or get_random_once.
- Some variable length input.
SipHash then spits out:
- A 64-bit psuedo-random number.

Documentation and usage examples are in this document:
https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/plain/Docum=
entation/siphash.txt

If you have a hashtable that takes input from sources outside the
kernel, consider using SipHash. If you're generating deterministic
random bytes based on some key, consider using SipHash. If you're just
curious, consider using SipHash. I merely say "consider" using it,
because there are many cases in which SipHash will _not_ make sense,
so the result of such consideration will be a clear "no thanks". But
perhaps in other cases will indeed be useful, so your consideration
may very well be worthwhile. If you have any questions about it, don't
hesitate to inquire, and if you're at all uncertain about whether or
not your patch using it is correct, put me in the CC and I'll give my
2=C2=A2.

Jason
