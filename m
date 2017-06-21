MIME-Version: 1.0
In-Reply-To: <20170620233836.75k5usug5w3xhwlw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
 <20170620093642.3ri6dct5qkf7vhuc@thunk.org> <CAHmME9oOUo-A-0NA5qPvcbTRf+xYKxmOtXb9fXVCmLwLcWPWug@mail.gmail.com>
 <20170620233836.75k5usug5w3xhwlw@thunk.org>
From: Jeffrey Walton <noloader@gmail.com>
Date: Wed, 21 Jun 2017 19:50:48 -0400
Message-ID: <CAH8yC8n-2SuRg3oD7pDRH8itJRoifSo=GQq13dDKBK1yjM_hoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 7:38 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jun 20, 2017 at 11:49:07AM +0200, Jason A. Donenfeld wrote:
>> ...
>>> I more or less agree with you that we should just turn this on for all
>>> users and they'll just have to live with the spam and report odd
>>> entries, and overtime we'll fix all the violations.
>
> There seems to be a fundamental misapprehension that it will be easy
> to "fix all the violations".  For certain hardware types, this is
> not easy, and the "eh, let them get spammed until we get around to
> fixing it" attitude is precisely what I was pushing back against.

I can't speak for others, but for me: I think they will fall into
three categories:

 1. easy to fix
 2. difficult to fix
 3. unable to fix

(1) is low hanging fruit and they will probably (hopefully?) be
cleared easily.  Like systemd on x86_64 with rdrand and rdseed.
There's no reason for systemd to find itself starved of entropy on
that platform. (cf., http://github.com/systemd/systemd/issues/4167).

Organizations that find themselves in (3) can choose to use a board or
server and accept the risk, or they can choose to remediate it in
another way. The "other way" may include a capital expenditure and a
hardware refresh.

The central point is, they know about the risk and they can make the decision.

Jeff
