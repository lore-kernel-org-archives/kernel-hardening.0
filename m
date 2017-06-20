MIME-Version: 1.0
In-Reply-To: <20170620233836.75k5usug5w3xhwlw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
 <20170620093642.3ri6dct5qkf7vhuc@thunk.org> <CAHmME9oOUo-A-0NA5qPvcbTRf+xYKxmOtXb9fXVCmLwLcWPWug@mail.gmail.com>
 <20170620233836.75k5usug5w3xhwlw@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 21 Jun 2017 01:54:05 +0200
Message-ID: <CAHmME9qvPL+vdY16SgV2VzuDDyM4r+hkYy8yGG3LJaa-3igxfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 21, 2017 at 1:38 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The punch was in response to this statement, which I personally found
> fairly infuriating:
>
>>> I more or less agree with you that we should just turn this on for all
>>> users and they'll just have to live with the spam and report odd
>>> entries, and overtime we'll fix all the violations.

Holy cow, please cool it. I think the "or less" part was relevant, as
was the subsequent sentence which characterized that sentiment as
"hubris". Also, the subsequent email when I made explicit the fact
that I was more in agreement with you than you interpreted. So, in
case you're really really really not getting the message I'm trying to
make so explicitly clear to you: I AGREE WITH YOU. So, no more
punching, pretty please?

>
> There seems to be a fundamental misapprehension that it will be easy
> to "fix all the violations".

I don't think it will be easy. I agree with you.

> But for other
> platforms, it really, REALLY isn't that easy to fix.

Other platforms will be hard. I agree with you.

> So personally, I think

I'm going to roll Kees' suggestion into a PATCH and send it to you.
You can decide if you want to apply it. I'll be satisfied with
whatever you choose and will follow your lead.

Jason
