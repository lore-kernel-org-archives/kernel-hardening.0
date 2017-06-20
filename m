MIME-Version: 1.0
In-Reply-To: <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Jun 2017 10:53:35 +0200
Message-ID: <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: noloader@gmail.com
Cc: Theodore Ts'o <tytso@mit.edu>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 10:33 AM, Jeffrey Walton <noloader@gmail.com> wrote:
> I think it is a bad idea to suppress all messages from a security
> engineering point of view.
>
> Many folks don't run debug kernels. Most of the users who want or need
> to know of the issues won't realize its happening. Consider, the
> reason we learned of systemd's problems was due to dmesg's.
>
> Suppressing all messages for all configurations cast a wider net than
> necessary. Configurations that could potentially be detected and fixed
> likely will go unnoticed. If the problem is not brought to light, then
> it won't be fixed.

I more or less agree with you that we should just turn this on for all
users and they'll just have to live with the spam and report odd
entries, and overtime we'll fix all the violations.

But I think there's another camp that would mutiny in the face of this
kind of hubris.

That's why I moved pretty readily toward the compromise position of
default y, but depends on DEBUG_KERNEL. My hope was that it'd to an
extent satisfy both camps, and also disappoint both camps in an equal
way.
