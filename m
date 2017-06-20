Date: Tue, 20 Jun 2017 08:44:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <20170620064438.fcfnyklbhf7pqrc3@linutronix.de>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com>
 <20170616143515.yn6oo6tvmcsrxidw@linutronix.de>
 <CAHmME9pLs2rKnuZ_La+PqYivEJDKEUdxUWS7eZthaw0jd8APVQ@mail.gmail.com>
 <20170619074553.wo3ec6i2yaojn7qs@linutronix.de>
 <CAHmME9rnSaB+wqrhefhPPNOPOK-zVCvdFQAxmKtPajD97mYqNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAHmME9rnSaB+wqrhefhPPNOPOK-zVCvdFQAxmKtPajD97mYqNw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-19 22:55:37 [+0200], Jason A. Donenfeld wrote:
> On Mon, Jun 19, 2017 at 9:45 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > ehm. You sure? I simply delayed the lock-dropping _after_ the state
> > variable was been modified. So it was basically what your patch did
> > except it was unlocked later=E2=80=A6
>=20
> Yes, I'm sure. You moved the call to invalidate_batched_entropy() to
> be after the assignment of crng_init. However, the call to
> invalidate_batched_entropy() must be made _before_ the assignment of
> crng_init.

so you need to find a another way then. Doing the assignment after
dropping the lock opens another race.

> >> > Are use about that? I am not sure that the gcc will inline "crng_ini=
t"
> >> > read twice. It is not a local variable. READ_ONCE() is usually used
> >> > where gcc could cache a memory access but you do not want this. But =
hey!
> >> > If someone knows better I am here to learn.
> >>
> >> The whole purpose is that I _want_ it to cache the memory access so
> >> that it is _not_ inlined. So, based on your understanding, it does
> >> exactly what I intended it to do. The reason is that I'd like to avoid
> >> a lock imbalance, which could happen if the read is inlined.
> >
> > So it was good as it was which means you can drop that READ_ONCE().
>=20
> Except READ_ONCE ensures that the compiler will never inline it, so it
> actually needs to stay.

I don't think the compiler is allowed to inline it the way you describe
it. This would render any assignment to local variable useless. Also
the READ_ONCE creates worse code in this case (because the read can not
be delayed).

Sebastian
