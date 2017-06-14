Date: Wed, 14 Jun 2017 21:28:39 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
References: <20170607232607.26870-1-Jason@zx2c4.com>
 <20170607232607.26870-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170607232607.26870-2-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v5 01/13] random: invalidate batched entropy after crng
 init
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, tglx@breakpoint.cc
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-08 01:25:55 [+0200], Jason A. Donenfeld wrote:
> It's possible that get_random_{u32,u64} is used before the crng has
> initialized, in which case, its output might not be cryptographically
> secure. For this problem, directly, this patch set is introducing the
> *_wait variety of functions, but even with that, there's a subtle issue:
> what happens to our batched entropy that was generated before
> initialization. Prior to this commit, it'd stick around, supplying bad
> numbers. After this commit, we force the entropy to be re-extracted
> after each phase of the crng has initialized.
> 
> In order to avoid a race condition with the position counter, we
> introduce a simple rwlock for this invalidation. Since it's only during
> this awkward transition period, after things are all set up, we stop
> using it, so that it doesn't have an impact on performance.
> 
> This should probably be backported to 4.11.
> 
> (Also: adding my copyright to the top. With the patch series from
> January, this patch, and then the ones that come after, I think there's
> a relevant amount of code in here to add my name to the top.)
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I don't understand why lockdep notices this possible deadlock only in
RT:

| the existing dependency chain (in reverse order) is:
|
| -> #1 (primary_crng.lock){+.+...}:
|        lock_acquire+0xb5/0x2b0
|        rt_spin_lock+0x46/0x50
|        _extract_crng+0x39/0xa0
|        extract_crng+0x3a/0x40
|        get_random_u64+0x17a/0x200
|        cache_random_seq_create+0x51/0x100
|        init_cache_random_seq+0x35/0x90
|        __kmem_cache_create+0xd3/0x560
|        create_boot_cache+0x8c/0xb2
|        create_kmalloc_cache+0x54/0x9f
|        create_kmalloc_caches+0xe3/0xfd
|        kmem_cache_init+0x14f/0x1f0
|        start_kernel+0x1e7/0x3b3
|        x86_64_start_reservations+0x2a/0x2c
|        x86_64_start_kernel+0x13d/0x14c
|        verify_cpu+0x0/0xfc
|
| -> #0 (batched_entropy_reset_lock){+.+...}:
|        __lock_acquire+0x11b4/0x1320
|        lock_acquire+0xb5/0x2b0
|        rt_write_lock+0x26/0x40
|        rt_write_lock_irqsave+0x9/0x10
|        invalidate_batched_entropy+0x28/0xb0
|        crng_fast_load+0xb5/0xe0
|        add_interrupt_randomness+0x16c/0x1a0
|        irq_thread+0x15c/0x1e0
|        kthread+0x112/0x150
|        ret_from_fork+0x31/0x40

We have	the path add_interrupt_randomness() -> crng_fast_load() which
take
  primary_crng.lock -> batched_entropy_reset_lock
and we have get_random_uXX() -> extract_crng() which take the locks in
opposite order:
  batched_entropy_reset_lock -> crng->lock

however batched_entropy_reset_lock() is only taken if "crng_init < 2" so
it is possible RT hits this constraint more reliably.

> ---
>  drivers/char/random.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index a561f0c2f428..d35da1603e12 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1,6 +1,9 @@
>  /*
>   * random.c -- A strong random number generator
>   *
> + * Copyright (C) 2017 Jason A. Donenfeld <Jason@zx2c4.com>. All
> + * Rights Reserved.
> + *
>   * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
>   *
>   * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999.  All
> @@ -762,6 +765,8 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
>  static struct crng_state **crng_node_pool __read_mostly;
>  #endif
>  
> +static void invalidate_batched_entropy(void);
> +
>  static void crng_initialize(struct crng_state *crng)
>  {
>  	int		i;
> @@ -799,6 +804,7 @@ static int crng_fast_load(const char *cp, size_t len)
>  		cp++; crng_init_cnt++; len--;
>  	}
>  	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
> +		invalidate_batched_entropy();
>  		crng_init = 1;
>  		wake_up_interruptible(&crng_init_wait);
>  		pr_notice("random: fast init done\n");
> @@ -836,6 +842,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
>  	memzero_explicit(&buf, sizeof(buf));
>  	crng->init_time = jiffies;
>  	if (crng == &primary_crng && crng_init < 2) {
> +		invalidate_batched_entropy();
>  		crng_init = 2;
>  		process_random_ready_list();
>  		wake_up_interruptible(&crng_init_wait);
> @@ -2023,6 +2030,7 @@ struct batched_entropy {
>  	};
>  	unsigned int position;
>  };
> +static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_reset_lock);
>  
>  /*
>   * Get a random word for internal kernel use only. The quality of the random
> @@ -2033,6 +2041,8 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
>  u64 get_random_u64(void)
>  {
>  	u64 ret;
> +	const bool use_lock = READ_ONCE(crng_init) < 2;
> +	unsigned long flags = 0;
>  	struct batched_entropy *batch;
>  
>  #if BITS_PER_LONG == 64
> @@ -2045,11 +2055,15 @@ u64 get_random_u64(void)
>  #endif
>  
>  	batch = &get_cpu_var(batched_entropy_u64);
> +	if (use_lock)
> +		read_lock_irqsave(&batched_entropy_reset_lock, flags);
>  	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
>  		extract_crng((u8 *)batch->entropy_u64);
>  		batch->position = 0;
>  	}
>  	ret = batch->entropy_u64[batch->position++];
> +	if (use_lock)
> +		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
>  	put_cpu_var(batched_entropy_u64);
>  	return ret;
>  }
> @@ -2059,22 +2073,45 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
>  u32 get_random_u32(void)
>  {
>  	u32 ret;
> +	const bool use_lock = READ_ONCE(crng_init) < 2;
> +	unsigned long flags = 0;
>  	struct batched_entropy *batch;
>  
>  	if (arch_get_random_int(&ret))
>  		return ret;
>  
>  	batch = &get_cpu_var(batched_entropy_u32);
> +	if (use_lock)
> +		read_lock_irqsave(&batched_entropy_reset_lock, flags);
>  	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
>  		extract_crng((u8 *)batch->entropy_u32);
>  		batch->position = 0;
>  	}
>  	ret = batch->entropy_u32[batch->position++];
> +	if (use_lock)
> +		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
>  	put_cpu_var(batched_entropy_u32);
>  	return ret;
>  }
>  EXPORT_SYMBOL(get_random_u32);
>  
> +/* It's important to invalidate all potential batched entropy that might
> + * be stored before the crng is initialized, which we can do lazily by
> + * simply resetting the counter to zero so that it's re-extracted on the
> + * next usage. */
> +static void invalidate_batched_entropy(void)
> +{
> +	int cpu;
> +	unsigned long flags;
> +
> +	write_lock_irqsave(&batched_entropy_reset_lock, flags);
> +	for_each_possible_cpu (cpu) {
> +		per_cpu_ptr(&batched_entropy_u32, cpu)->position = 0;
> +		per_cpu_ptr(&batched_entropy_u64, cpu)->position = 0;
> +	}
> +	write_unlock_irqrestore(&batched_entropy_reset_lock, flags);
> +}
> +
>  /**
>   * randomize_page - Generate a random, page aligned address
>   * @start:	The smallest acceptable address the caller will take.
> -- 
> 2.13.0

Sebastian
