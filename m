MIME-Version: 1.0
In-Reply-To: <CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com>
References: <CAGXu5jJaVPPjqtpOLapk8ABT93zaUoaKR-i7Ga6LVSK2OiX_tQ@mail.gmail.com>
 <CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 8 Mar 2018 00:05:27 -0500
Message-ID: <CA+DvKQ+bZauBVA9G-E74ibRuDyfiZfduwycVwBH3jKDyjDe4Zg@mail.gmail.com>
Subject: Re: VLA removal (was Re: [RFC 2/2] lustre: use VLA_SAFE)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Joern Engel <joern@logfs.org>, "Tobin C. Harding" <tobin@apporbit.com>, "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 March 2018 at 13:09, Linus Torvalds <torvalds@linux-foundation.org> wr=
ote:
> On Wed, Mar 7, 2018 at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Building with -Wvla, I see 209 unique locations reported in 60 directori=
es:
>> http://paste.ubuntu.com/p/srQxwPQS9s/
>
> Ok, that's not so bad. Maybe Greg could even add it to one of those
> things he encourages new people to do?
>
> Because at least *some* of them are pretty trivial. For example,
> looking at the core code, I was surprised to see something in
> lib/btree.c

Some are probably just the issue of technically having a VLA that's
not really a VLA:

    static const int size =3D 5;

    void foo(void) {
      int x[size];
    }

% gcc -c -Wvla foo.c
foo.c: In function =E2=80=98foo=E2=80=99:
foo.c:4:3: warning: ISO C90 forbids variable length array =E2=80=98x=E2=80=
=99 [-Wvla]
   int x[size];
   ^~~

I don't really understand why the C standard didn't make `static
const` declarations usable as constant expressions like C++. They made
the pointer conversions more painful too.

It would be nice to get rid of those cases to use -Werror=3Dvla though.
