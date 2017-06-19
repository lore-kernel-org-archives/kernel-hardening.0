MIME-Version: 1.0
In-Reply-To: <20170614224526.29076-1-Jason@zx2c4.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc> <20170614224526.29076-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 19 Jun 2017 22:57:18 +0200
Message-ID: <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>
Cc: tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Ted,

With rc6 already released and rc7 coming up, I'd really appreciate you
stepping in here and either ACKing the above commit, or giving your
two cents about it in case I need to roll something different.

Thanks,
Jason

On Thu, Jun 15, 2017 at 12:45 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Odd versions of gcc for the sh4 architecture will actually warn about
> flags being used while uninitialized, so we set them to zero. Non crazy
> gccs will optimize that out again, so it doesn't make a difference.
>
> Next, over aggressive gccs could inline the expression that defines
> use_lock, which could then introduce a race resulting in a lock
> imbalance. By using READ_ONCE, we prevent that fate. Finally, we make
> that assignment const, so that gcc can still optimize a nice amount.
>
> Finally, we fix a potential deadlock between primary_crng.lock and
> batched_entropy_reset_lock, where they could be called in opposite
> order. Moving the call to invalidate_batched_entropy to outside the lock
> rectifies this issue.
>
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
>                 p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
>                 cp++; crng_init_cnt++; len--;
>         }
> +       spin_unlock_irqrestore(&primary_crng.lock, flags);
>         if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
>                 invalidate_batched_entropy();
>                 crng_init = 1;
>                 wake_up_interruptible(&crng_init_wait);
>                 pr_notice("random: fast init done\n");
>         }
> -       spin_unlock_irqrestore(&primary_crng.lock, flags);
>         return 1;
>  }
>
> @@ -841,6 +841,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
>         }
>         memzero_explicit(&buf, sizeof(buf));
>         crng->init_time = jiffies;
> +       spin_unlock_irqrestore(&primary_crng.lock, flags);
>         if (crng == &primary_crng && crng_init < 2) {
>                 invalidate_batched_entropy();
>                 crng_init = 2;
> @@ -848,7 +849,6 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
>                 wake_up_interruptible(&crng_init_wait);
>                 pr_notice("random: crng init done\n");
>         }
> -       spin_unlock_irqrestore(&primary_crng.lock, flags);
>  }
>
>  static inline void crng_wait_ready(void)
> @@ -2041,8 +2041,8 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
>  u64 get_random_u64(void)
>  {
>         u64 ret;
> -       bool use_lock = crng_init < 2;
> -       unsigned long flags;
> +       bool use_lock = READ_ONCE(crng_init) < 2;
> +       unsigned long flags = 0;
>         struct batched_entropy *batch;
>
>  #if BITS_PER_LONG == 64
> @@ -2073,8 +2073,8 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
>  u32 get_random_u32(void)
>  {
>         u32 ret;
> -       bool use_lock = crng_init < 2;
> -       unsigned long flags;
> +       bool use_lock = READ_ONCE(crng_init) < 2;
> +       unsigned long flags = 0;
>         struct batched_entropy *batch;
>
>         if (arch_get_random_int(&ret))
> --
> 2.13.1
>
