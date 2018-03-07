MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJaVPPjqtpOLapk8ABT93zaUoaKR-i7Ga6LVSK2OiX_tQ@mail.gmail.com>
References: <CAGXu5jJaVPPjqtpOLapk8ABT93zaUoaKR-i7Ga6LVSK2OiX_tQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Mar 2018 10:09:56 -0800
Message-ID: <CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com>
Subject: Re: VLA removal (was Re: [RFC 2/2] lustre: use VLA_SAFE)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>, Joern Engel <joern@logfs.org>
Cc: "Tobin C. Harding" <tobin@apporbit.com>, "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 7, 2018 at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
>
> Building with -Wvla, I see 209 unique locations reported in 60 directorie=
s:
> http://paste.ubuntu.com/p/srQxwPQS9s/

Ok, that's not so bad. Maybe Greg could even add it to one of those
things he encourages new people to do?

Because at least *some* of them are pretty trivial. For example,
looking at the core code, I was surprised to see something in
lib/btree.c

And that is just garbage: it uses

        unsigned long key[geo->keylen];

which looks really dangerous, but that "struct btree_geo" is internal
to that file, and there are exactly three instances of it, with 32, 64
and 128 bit keys respectively. Note that "keylen" isn't actually
number of hits, but how many long-words you need.

So in actual fact, that array is limited to that 128 bits - just 16
bytes. So keylen is at most 4 (on 32-bit architectures) or 2 (on
64-bit ones).

Using

   #define MAXKEYLEN BITS_TO_LONGS(128)

or something like that would be trivial.

AND USING VLA'S IS ACTIVELY STUPID! It generates much more code, and
much _slower_ code (and more fragile code), than just using a fixed
key size would have done.

Ok, so lib/btree.c looks more core (by being in lib/) than it actually
is - I don't see the 128-bit btree being used *anywhere*, and the
others are only used by two drivers: the qla2xxx scsi driver and the
bcm2835-camera driver in staging.

Anyway, some of these are definitely easy to just fix, and using VLA's
is actively bad not just for security worries, but simply because
VLA's are a really horribly bad idea in general in the kernel.

Added J=C3=B6rn Engel to the cc, since I looked at that lib/btree.c thing.

But that is just three of the 209 instances. Some of the others might
be slightly more painful to fix.

                  Linus
