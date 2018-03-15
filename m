From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] crypto: ctr: avoid VLA use
Date: Thu, 15 Mar 2018 11:55:21 +0000
Message-ID: <913c28c268ca49f19f2407afc110deef@AcuMS.aculab.com>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
 <20180314183157.GA183724@gmail.com>
In-Reply-To: <20180314183157.GA183724@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: 'Eric Biggers' <ebiggers3@gmail.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Eric Biggers
> Sent: 14 March 2018 18:32
...
> Also, I recall there being a long discussion a while back about how
> __aligned(16) doesn't work on local variables because the kernel's stack =
pointer
> isn't guaranteed to maintain the alignment assumed by the compiler (see c=
ommit
> b8fbe71f7535)...

ISTR that gcc arbitrarily decided that the x86 stack (for 32 bit) would be
kept aligned to more than 4 bytes (16??) - probably so that xmm registers
could be written to stack locations.
This was a massive ABI change that they didn't tell anyone about!
While gcc compiled code maintained the alignment a lot of asm code didn't.
I don't know about Linux, but NetBSD didn't even align user stacks.

There is a gcc option to not assume that the stack is 'appropriately aligne=
d',
but ISTR that it generates rather more code that one might have wished.

If the compiler does align the stack, it does so by generating a double
stack frame - not pretty at all.

	David
