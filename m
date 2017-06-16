Date: Fri, 16 Jun 2017 16:35:16 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <20170616143515.yn6oo6tvmcsrxidw@linutronix.de>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170614224526.29076-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, tglx@linutronix.de
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-15 00:45:26 [+0200], Jason A. Donenfeld wrote:
> Odd versions of gcc for the sh4 architecture will actually warn about
> flags being used while uninitialized, so we set them to zero. Non crazy
> gccs will optimize that out again, so it doesn't make a difference.

that is minor

> Next, over aggressive gccs could inline the expression that defines
> use_lock, which could then introduce a race resulting in a lock
> imbalance. By using READ_ONCE, we prevent that fate. Finally, we make
> that assignment const, so that gcc can still optimize a nice amount.

Not sure about that, more below.

> Finally, we fix a potential deadlock between primary_crng.lock and
> batched_entropy_reset_lock, where they could be called in opposite
> order. Moving the call to invalidate_batched_entropy to outside the lock
> rectifies this issue.

and *that* is separate issue which has to pulled in for stable once it
has been addressed in Linus' tree.

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Ted -- the first part of this is the fixup patch we discussed earlier.
> Then I added on top a fix for a potentially related race.
> 
> I'm not totally convinced that moving this block to outside the spinlock
> is 100% okay, so please give this a close look before merging.
> 
> 
>  drivers/char/random.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index e870f329db88..01a260f67437 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -803,13 +803,13 @@ static int crng_fast_load(const char *cp, size_t len)
>  		p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
>  		cp++; crng_init_cnt++; len--;
>  	}
> +	spin_unlock_irqrestore(&primary_crng.lock, flags);
>  	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
>  		invalidate_batched_entropy();
>  		crng_init = 1;
>  		wake_up_interruptible(&crng_init_wait);
>  		pr_notice("random: fast init done\n");
>  	}
> -	spin_unlock_irqrestore(&primary_crng.lock, flags);
>  	return 1;

I wouldn't just push the lock one up as is but move that write part to
crng_init to remain within the locked section. Like that:

diff --git a/drivers/char/random.c b/drivers/char/random.c
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -804,12 +804,14 @@ static int crng_fast_load(const char *cp, size_t len)
 		cp++; crng_init_cnt++; len--;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		invalidate_batched_entropy();
 		crng_init = 1;
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
+		invalidate_batched_entropy();
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
+	} else {
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	return 1;
 }
 
@@ -842,13 +844,16 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	memzero_explicit(&buf, sizeof(buf));
 	crng->init_time = jiffies;
 	if (crng == &primary_crng && crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
+
+		invalidate_batched_entropy();
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: crng init done\n");
+	} else {
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
 static inline void crng_wait_ready(void)

>  }
>  
> @@ -2041,8 +2041,8 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
>  u64 get_random_u64(void)
>  {
>  	u64 ret;
> -	bool use_lock = crng_init < 2;
> -	unsigned long flags;
> +	bool use_lock = READ_ONCE(crng_init) < 2;

Are use about that? I am not sure that the gcc will inline "crng_init"
read twice. It is not a local variable. READ_ONCE() is usually used
where gcc could cache a memory access but you do not want this. But hey!
If someone knows better I am here to learn.
One thing that this change does for sure is that crng_init is read very
early in the function while without READ_ONCE it is delayed _after_
arch_get_random_XXX(). So if arch_get_random_XXX() is around and works
you have one read for nothing.

> +	unsigned long flags = 0;
>  	struct batched_entropy *batch;
>  
>  #if BITS_PER_LONG == 64

Sebastian
