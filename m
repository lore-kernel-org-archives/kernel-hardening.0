MIME-Version: 1.0
In-Reply-To: <20170606170319.5eva2yoxxeru5p74@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org> <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz> <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 19:28:07 +0200
Message-ID: <CAHmME9pXeSFWoeWmOpQ16e62y3_0hoHchU2o+RFAT9CKBPKsDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 7:03 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> So it's not clear what you mean by Stephan's work.

I just meant that there's a guy out there who seems really motivated
to work on this stuff in detail, but hasn't seen too much love, AFAIK.
I'm sure there's an interesting technical discussion to be had about
his contributions.

> The reality though is that Linux is a volunteer effort

Yep! And here I am volunteering, writing some code, in my free time,
just for willies. I hope you'll be a kind, helpful, and supportive
maintainer who welcomes contributions and discussion.

> So it may in
> fact be _rational_ for people who are working on hardening the kernel
> to focus on other areas.
> improve things on all fronts, not just the sexy ones.

I don't want people to use some aspects of a module I'm writing before
get_random_bytes() will return good randomness. You made some point
about what's sexy and what isn't and what is rational for people to
work on, but I think I missed the thrust of it. I'm working on this
particular problem now with get_random_bytes, as something motivated
by simple considerations, not complex ulterior motives.


But anyway, moving on...


> I think this is a soluble problem, but it may be rather tricky.  For
> example, it may be that for a certain class of init calls, even though
> they are in subsystems that are compiled into the kernel, those init
> calls perhaps could be deferred so they are running in parallel with
> the init scripts.  (Or maybe we could just require that certain kernel
> modules can *only* be compiled as modules if they use rng_init ---
> although that may get annoying for those of us who like being able to
> build custom configured monolithic kernels.  So I'd prefer the first
> possibility if at all possible.)

Right, indeed this is tricky, and you bring up good points about
complex interactions on different architectures. Based on your
comments about whack-a-mole, I think we're mostly on the same page
about how arduous this is going to be to fix. My plan is to first get
in this simple blocking API, because while it doesn't solve _every_
use case, there are particular use cases that are helped nearly
perfectly by it. Namely, places where userspace is going to configure
something. So, soon after I finish up this testing I've been doing all
day on my series, I'll post v4, and hopefully we can get that merged,
and then move onto interesting other solutions for the general
problem.

Regards,
Jason
