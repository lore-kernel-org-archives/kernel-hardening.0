MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170621000300.11646-1-Jason@zx2c4.com>
References: <CAHmME9qvPL+vdY16SgV2VzuDDyM4r+hkYy8yGG3LJaa-3igxfA@mail.gmail.com>
 <20170621000300.11646-1-Jason@zx2c4.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 17:12:11 -0700
Message-ID: <CAGXu5jK5FPdSiTv259XHg7e11AeP9LGAfBE=YufkH1V=6XPZvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: warn when kernel uses unseeded randomness
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 5:03 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This enables an important dmesg notification about when drivers have
> used the crng without it being seeded first. Prior, these errors would
> occur silently, and so there hasn't been a great way of diagnosing these
> types of bugs for obscure setups. By adding this as a config option, we
> can leave it on by default, so that we learn where these issues happen,
> in the field, will still allowing some people to turn it off, if they
> really know what they're doing and do not want the log entries.
>
> However, we don't leave it _completely_ by default. An earlier version
> of this patch simply had `default y`. I'd really love that, but it turns
> out, this problem with unseeded randomness being used is really quite
> present and is going to take a long time to fix. Thus, as a compromise
> between log-messages-for-all and nobody-knows, this is `default y`,
> except it is also `depends on DEBUG_KERNEL`. This will ensure that the
> curious see the messages while others don't have to.

This commit log needs updating (default DEBUG_KERNEL, not depends).

But otherwise:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> Hi Ted,
>
> This patch is meant to replace d06bfd1989fe97623b32d6df4ffa6e4338c99dc8,
> which is currently in your dev tree. It switches from using `default y`
> and `depends on DEBUG_KERNEL` to using the more simple `default DEBUG_KERNEL`.
> This kind of change I think should satisfy most potential objections, by
> being present for those who might find it useful, but invisble for those
> who don't want the spam.
>
> If you'd like to replace the earlier commit with this one, feel free. If
> not, that's fine too.
>
> Jason
>
>  drivers/char/random.c | 15 +++++++++++++--
>  lib/Kconfig.debug     | 15 +++++++++++++++
>  2 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 3853dd4f92e7..fa5bbd5a7ca0 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -288,7 +288,6 @@
>  #define SEC_XFER_SIZE          512
>  #define EXTRACT_SIZE           10
>
> -#define DEBUG_RANDOM_BOOT 0
>
>  #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
>
> @@ -1481,7 +1480,7 @@ void get_random_bytes(void *buf, int nbytes)
>  {
>         __u8 tmp[CHACHA20_BLOCK_SIZE];
>
> -#if DEBUG_RANDOM_BOOT > 0
> +#ifdef CONFIG_WARN_UNSEEDED_RANDOM
>         if (!crng_ready())
>                 printk(KERN_NOTICE "random: %pF get_random_bytes called "
>                        "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
> @@ -2075,6 +2074,12 @@ u64 get_random_u64(void)
>             return ret;
>  #endif
>
> +#ifdef CONFIG_WARN_UNSEEDED_RANDOM
> +       if (!crng_ready())
> +               printk(KERN_NOTICE "random: %pF get_random_u64 called "
> +                      "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
> +#endif
> +
>         batch = &get_cpu_var(batched_entropy_u64);
>         if (use_lock)
>                 read_lock_irqsave(&batched_entropy_reset_lock, flags);
> @@ -2101,6 +2106,12 @@ u32 get_random_u32(void)
>         if (arch_get_random_int(&ret))
>                 return ret;
>
> +#ifdef CONFIG_WARN_UNSEEDED_RANDOM
> +       if (!crng_ready())
> +               printk(KERN_NOTICE "random: %pF get_random_u32 called "
> +                      "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
> +#endif
> +
>         batch = &get_cpu_var(batched_entropy_u32);
>         if (use_lock)
>                 read_lock_irqsave(&batched_entropy_reset_lock, flags);
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index e4587ebe52c7..41cf12288369 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1209,6 +1209,21 @@ config STACKTRACE
>           It is also used by various kernel debugging features that require
>           stack trace generation.
>
> +config WARN_UNSEEDED_RANDOM
> +       bool "Warn when kernel uses unseeded randomness"
> +       default DEBUG_KERNEL
> +       help
> +         Some parts of the kernel contain bugs relating to their use of
> +         cryptographically secure random numbers before it's actually possible
> +         to generate those numbers securely. This setting ensures that these
> +         flaws don't go unnoticed, by enabling a message, should this ever
> +         occur. This will allow people with obscure setups to know when things
> +         are going wrong, so that they might contact developers about fixing
> +         it.
> +
> +         Say Y here, unless you simply do not care about using unseeded
> +         randomness and do not want a potential warning message in your logs.
> +
>  config DEBUG_KOBJECT
>         bool "kobject debugging"
>         depends on DEBUG_KERNEL
> --
> 2.13.1
>



-- 
Kees Cook
Pixel Security
