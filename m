Date: Fri, 16 Jun 2017 10:31:12 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <20170616083111.5cwwkzyauocxafou@breakpoint.cc>
References: <20170607232607.26870-1-Jason@zx2c4.com>
 <20170607232607.26870-2-Jason@zx2c4.com>
 <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <CAHmME9oRG4Oe4zNN4D8Nc9+A51uXPC0y3m3+ws_QK2aq=K=zwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9oRG4Oe4zNN4D8Nc9+A51uXPC0y3m3+ws_QK2aq=K=zwA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 01/13] random: invalidate batched entropy after crng
 init
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, tglx@linutronix.de
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-15 00:33:12 [+0200], Jason A. Donenfeld wrote:
> There's a potential race that I fixed in my v5 of that patch set, but
> Ted only took v4, and for whatever reason has been to busy to submit
> the additional patch I already posted showing the diff between v4&v5.
> Hopefully he actually gets around to it and sends this for the next
> rc. Here it is:
> 
> https://patchwork.kernel.org/patch/9774563/

So you replace "crng_init < 2" with use_lock instead. That is not what I
am talking about. Again:
	add_interrupt_randomness()
->       crng_fast_load()	        spin_trylock_irqsave(&primary_crng.lock, )
->        invalidate_batched_entropy()  write_lock_irqsave(&batched_entropy_reset_lock, );

in that order while the code path
	get_random_uXX()                read_lock_irqsave(&batched_entropy_reset_lock, );
->       extract_crng()
->        _extract_crng()                spin_lock_irqsave(&crng->lock, );

which allocates the same lock in opposite order.
That means
  T1			T2
  crng_fast_load()	get_random_u64()
  			extract_crng()
              *dead lock*
invalidate_batched_entropy()
			_extract_crng()

So T1 waits for batched_entropy_reset_lock holding primary_crng.lock and
T2 waits for primary_crng.lock holding batched_entropy_reset_lock.

Sebastian
