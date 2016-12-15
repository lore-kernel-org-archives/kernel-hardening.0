Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 15 Dec 2016 22:16:23 +0100
Message-ID: <CAHmME9pCjBiZr9n9g4On2GACbDm52vt1SkDXBz4yTVzaKF0ZWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add
 cryptographically secure hashtable function
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, David Laight <David.Laight@aculab.com>, Netdev <netdev@vger.kernel.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 15, 2016 at 10:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think you can/should just use the natural alignment for "u64".
>
> For architectures that need 8-byte alignment, u64 will already be
> properly aligned. For architectures (like x86-32) that only need
> 4-byte alignment, you get it.

I should have added mention of that with my previous email. For the
parameters that are always a multiple of u64 -- namely, the key -- I
now do that in v5 of the patchset. So this is already done.
