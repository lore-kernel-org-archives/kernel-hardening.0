MIME-Version: 1.0
In-Reply-To: <CAGXu5j+PQ1unqbJa6hh9OMxBx3+sKUmfycjFAb1FFH0e5C0FtQ@mail.gmail.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
 <20170620093642.3ri6dct5qkf7vhuc@thunk.org> <CAH8yC8nD3kn1DZVzvruvq3tMZ=JLED_9RWkfRGUWgsNx-gBKCQ@mail.gmail.com>
 <CACXcFmkdMbn6xHnJvwtkPJQ0ZSUUK26-9DB+V0oq6Sj6U+gMTA@mail.gmail.com> <CAGXu5j+PQ1unqbJa6hh9OMxBx3+sKUmfycjFAb1FFH0e5C0FtQ@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Jun 2017 22:09:06 +0200
Message-ID: <CAHmME9qNSUFr+NsmzELJM49pkHUnuZpRFhW4v5N7XcVn0c06rw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH] random: silence compiler warnings
 and fix race
To: Kees Cook <keescook@chromium.org>
Cc: Sandy Harris <sandyinchina@gmail.com>, Jeffrey Walton <noloader@gmail.com>, Theodore Ts'o <tytso@mit.edu>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 8:14 PM, Kees Cook <keescook@chromium.org> wrote:
> How about doing this:
>
>    default DEBUG_KERNEL
>
> Most distro kernel select DEBUG_KERNEL because it unhides a bunch of
> other useful configs. Since it doesn't strictly _depend_ on
> DEBUG_KERNEL, I think it's probably a mistake to enforce a false
> dependency. Using it as a hint for the default seems maybe like a good
> middle ground. (And if people can't agree on that, then I guess
> "default n"...)

I didn't know you could do that with Kconfig. Great idea. I'll make
this change and submit a new patch to Ted.

Jason
