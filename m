MIME-Version: 1.0
In-Reply-To: <20170619074553.wo3ec6i2yaojn7qs@linutronix.de>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <20170616143515.yn6oo6tvmcsrxidw@linutronix.de>
 <CAHmME9pLs2rKnuZ_La+PqYivEJDKEUdxUWS7eZthaw0jd8APVQ@mail.gmail.com> <20170619074553.wo3ec6i2yaojn7qs@linutronix.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 19 Jun 2017 22:55:37 +0200
Message-ID: <CAHmME9rnSaB+wqrhefhPPNOPOK-zVCvdFQAxmKtPajD97mYqNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 9:45 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> ehm. You sure? I simply delayed the lock-dropping _after_ the state
> variable was been modified. So it was basically what your patch did
> except it was unlocked later=E2=80=A6

Yes, I'm sure. You moved the call to invalidate_batched_entropy() to
be after the assignment of crng_init. However, the call to
invalidate_batched_entropy() must be made _before_ the assignment of
crng_init.

>> > Are use about that? I am not sure that the gcc will inline "crng_init"
>> > read twice. It is not a local variable. READ_ONCE() is usually used
>> > where gcc could cache a memory access but you do not want this. But he=
y!
>> > If someone knows better I am here to learn.
>>
>> The whole purpose is that I _want_ it to cache the memory access so
>> that it is _not_ inlined. So, based on your understanding, it does
>> exactly what I intended it to do. The reason is that I'd like to avoid
>> a lock imbalance, which could happen if the read is inlined.
>
> So it was good as it was which means you can drop that READ_ONCE().

Except READ_ONCE ensures that the compiler will never inline it, so it
actually needs to stay.
