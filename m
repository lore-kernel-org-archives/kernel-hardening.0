MIME-Version: 1.0
In-Reply-To: <20170620093642.3ri6dct5qkf7vhuc@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com> <20170620093642.3ri6dct5qkf7vhuc@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Jun 2017 11:49:07 +0200
Message-ID: <CAHmME9oOUo-A-0NA5qPvcbTRf+xYKxmOtXb9fXVCmLwLcWPWug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, noloader@gmail.com, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 11:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> But I think there's another camp that would mutiny in the face of this
>> kind of hubris.
>
> Blocking the boot for hours and hours until we have enough entropy to
> initialize the CRNG is ***not*** an acceptable way of making the
> warning messages go away.  Do that and the users **will** mutiny.
>
> It's this sort of attitude which is why Linus has in the past said
> that security people are sometimes insane....

Uh, talk about a totally unnecessary punch... In case my last email
wasn't clear, I fully recognize that `default y` is a tad too extreme,
which is why from one of the earliest revisions in this series, I
moved directly to the compromise solution (`depends DEBUG_KERNEL`)
without even waiting for people to complain first.
