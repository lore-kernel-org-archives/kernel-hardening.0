MIME-Version: 1.0
In-Reply-To: <20170620093642.3ri6dct5qkf7vhuc@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com> <20170620093642.3ri6dct5qkf7vhuc@thunk.org>
From: Jeffrey Walton <noloader@gmail.com>
Date: Tue, 20 Jun 2017 05:49:00 -0400
Message-ID: <CAH8yC8nD3kn1DZVzvruvq3tMZ=JLED_9RWkfRGUWgsNx-gBKCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 5:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jun 20, 2017 at 10:53:35AM +0200, Jason A. Donenfeld wrote:
>> > Suppressing all messages for all configurations cast a wider net than
>> > necessary. Configurations that could potentially be detected and fixed
>> > likely will go unnoticed. If the problem is not brought to light, then
>> > it won't be fixed.
>>
>> I more or less agree with you that we should just turn this on for all
>> users and they'll just have to live with the spam and report odd
>> entries, and overtime we'll fix all the violations.
>
> Fix all the problems *how*?  If you are on an old system which doesn't
> a hardware random number generator, and which doesn't have a high
> resolution cycle counter, and may not have a lot of entropy easily
> harvestable from the environment, there may not be a lot you can do.
> Sure, you can pretend that the cache (which by the way is usually
> determinstic) is ***so*** complicated that no one can figure it out,
> and essentially pretend that you have entropy when you probably don't;
> that just simply becomes a different way of handwaving and suppressing
> the warning messages.
>
>> But I think there's another camp that would mutiny in the face of this
>> kind of hubris.
>
> Blocking the boot for hours and hours until we have enough entropy to
> initialize the CRNG is ***not*** an acceptable way of making the
> warning messages go away.  Do that and the users **will** mutiny.
>
> It's this sort of attitude which is why Linus has in the past said
> that security people are sometimes insane....

I don't believe it has anything to do with insanity. Its sound
security engineering.

Are there compelling reasons a single dmesg warning cannot be provided?

A single message avoids spamming the logs. It also informs the system
owner of the problem. An individual or organization can then take
action based on their risk posture. Finally, it avoids the kernel
making policy decisions for a user or organization.

Jeff
