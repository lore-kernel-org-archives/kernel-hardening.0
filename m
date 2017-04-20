MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170225003232.GA123380@beast>
References: <20170225003232.GA123380@beast>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 20 Apr 2017 14:02:16 -0700
Message-ID: <CAGXu5jLfrNp=8Mr=DbY35egC8q_iA0tpiQRteK3_+vc3LZGbmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] mm: enable sanitizing via CONFIG
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2017 at 4:32 PM, Kees Cook <keescook@chromium.org> wrote:
> This enables page and slab poisoning by default under CONFIG_MEMORY_SANITIZE.
> Based on work by Kaiwan N Billimoria.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is more what I had in mind. This is based on the latest patch, but
> handles slab and slub. I tested slub with lkdtm's READ_AFTER_FREE and
> READ_BUDDY_AFTER_FREE which both trip the poisoning tests.
>
> While doing this, I noticed one major issue with slub/slab poisoning:
> it performs poisoning both on alloc and free, which is a rather large
> performance hit, so the next step is likely to find a way to split the
> poisoning into alloc and free halves so that CONFIG_MEMORY_SANITIZE
> poisoning will only happen on the free.

While this has performance flaws (to say the least), what do people
think of this general approach to dealing with having a single CONFIG
to control this at least? Should I (or someone) see what the slab
cache maintainers think of this?

-Kees

> ---
>  init/main.c      |  5 +++++
>  mm/Kconfig.debug | 23 +++++++++++++++++++++++
>  mm/page_poison.c |  3 ++-
>  mm/slab.c        |  4 ++++
>  mm/slub.c        |  7 +++++++
>  5 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/init/main.c b/init/main.c
> index 24ea48745061..e5f571bfe56f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1030,6 +1030,11 @@ static noinline void __init kernel_init_freeable(void)
>
>         do_basic_setup();
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +       pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
> +                page_poisoning_enabled() ? "yes" : "no");
> +#endif
> +
>         /* Open the /dev/console on the rootfs, this should never fail */
>         if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>                 pr_err("Warning: unable to open an initial console.\n");
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index afcc550877ff..910a7a359b96 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -90,3 +90,26 @@ config DEBUG_PAGE_REF
>           careful when enabling this feature because it adds about 30 KB to the
>           kernel code.  However the runtime performance overhead is virtually
>           nil until the tracepoints are actually enabled.
> +
> +config MEMORY_SANITIZE
> +       bool "Enable memory sanitization features"
> +       depends on SLUB || SLAB
> +       select SLUB_DEBUG if SLUB
> +       select PAGE_POISONING
> +       select PAGE_POISONING_NO_SANITY
> +       help
> +         This option enables memory sanitization features. Particularly,
> +         when you turn on this option, it auto-enables:
> +         - page poisoning (without sanity checking)
> +         - kmem_cache poisoning
> +
> +         Implication: turning this option on will implicitly enable:
> +         - the SLUB_DEBUG switch to the equivalent of the kernel command-line
> +           'slub_debug=p' (where p=SLAB_POISON).
> +         - page poisoning, equivalent to passing the kernel command-line
> +           option 'page_poison=on'.
> +
> +         Of course, kernel command-line options 'page_poison' and 'slub_debug'
> +         are still honored.
> +
> +         If unsure, say N.
> diff --git a/mm/page_poison.c b/mm/page_poison.c
> index 2e647c65916b..6f7e37c8ac2f 100644
> --- a/mm/page_poison.c
> +++ b/mm/page_poison.c
> @@ -7,7 +7,8 @@
>  #include <linux/ratelimit.h>
>
>  static bool __page_poisoning_enabled __read_mostly;
> -static bool want_page_poisoning __read_mostly;
> +static bool want_page_poisoning __read_mostly =
> +                                       IS_ENABLED(CONFIG_MEMORY_SANITIZE);
>
>  static int early_page_poison_param(char *buf)
>  {
> diff --git a/mm/slab.c b/mm/slab.c
> index bd63450a9b16..1462b0b8b0a0 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1894,6 +1894,10 @@ unsigned long kmem_cache_flags(unsigned long object_size,
>         unsigned long flags, const char *name,
>         void (*ctor)(void *))
>  {
> +#ifdef CONFIG_MEMORY_SANITIZE
> +       flags |= SLAB_POISON;
> +#endif
> +
>         return flags;
>  }
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 7f4bc7027ed5..5041f42c942b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -452,6 +452,8 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
>   */
>  #if defined(CONFIG_SLUB_DEBUG_ON)
>  static int slub_debug = DEBUG_DEFAULT_FLAGS;
> +#elif defined(CONFIG_MEMORY_SANITIZE)
> +static int slub_debug = SLAB_POISON;
>  #else
>  static int slub_debug;
>  #endif
> @@ -5755,6 +5757,11 @@ static int __init slab_sysfs_init(void)
>         struct kmem_cache *s;
>         int err;
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +       pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug = P? %s [0x%x]\n",
> +               slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
> +#endif
> +
>         mutex_lock(&slab_mutex);
>
>         slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security



-- 
Kees Cook
Pixel Security
