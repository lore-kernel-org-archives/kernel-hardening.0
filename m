MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170209090714.63ce6333@kaiwan-T460>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 09:28:20 -0800
Message-ID: <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 8, 2017 at 7:37 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Hi Kees,
>
>> I think CONFIG_MEMORY_SANITIZE would enable:
>>
>> CONFIG_SLUB_DEBUG=y
>> CONFIG_PAGE_POISONING=y
>> CONFIG_PAGE_POISONING_NO_SANITY=y
>>
>> but it would _also_ need to set these kernel command-line variables as
>> if they had been set:
>>
>> page_poison=1
>> slub_debug=P
>>
>> No, the first step would be for the config to only provide the above
>> changes.
>
> Have made a first cut (below). Pl take a look and let me know if okay
> and how I should proceed.
>
> Note-
>  - the printks' are just for checking that options are enabled as required
> (will get rid of them later)
>  - this is on linux-next (x86_64)
>  - dmesg filtered output when booted with this kernel (no page_posion or slub_debug
> cmdline options passed):
>
> $ dmesg |grep "MEMORY_SANITIZE"
> kern  :info  : [  +0.000387] [CONFIG_MEMORY_SANITIZE]: slub_debug = P? yes [0x800]
> kern  :debug : [  +0.000000] [CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? yes
> $
>
> ===
> diff --git a/init/main.c b/init/main.c
> index ef47035..ba44574 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1028,6 +1028,11 @@ static noinline void __init kernel_init_freeable(void)
>
>          do_basic_setup();
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +    pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
> +        page_poisoning_enabled() ? "yes" : "no");
> +#endif
> +
>          /* Open the /dev/console on the rootfs, this should never fail */
>          if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>                  pr_err("Warning: unable to open an initial console.\n");
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 3e5eada..8eed6ca 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -97,3 +97,11 @@ config DEBUG_RODATA_TEST
>         ---help---
>         This option enables a testcase for the setting rodata read-only.
>
> +config MEMORY_SANITIZE
> +       bool "Enable memory sanitization features"
> +       select SLUB_DEBUG
> +       select PAGE_POISONING
> +       select PAGE_POISONING_NO_SANITY if HIBERNATION
> +       ---help---
> +       This option enables ...

Good start! Why the "if HIBERNATION" bit? It seems like sanity checks
are very expensive, so we'd not want it as part of this config?

> +
> diff --git a/mm/page_poison.c b/mm/page_poison.c
> index 2e647c6..b45bc0a 100644
> --- a/mm/page_poison.c
> +++ b/mm/page_poison.c
> @@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_ops = {
>          .init = init_page_poisoning,
>  };
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +static int __init memory_sanitize_init(void)
> +{
> +    /* With 'memory sanitize' On, page poisoning Must be turned on */
> +    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> +        want_page_poisoning = true;
> +        __page_poisoning_enabled = true;
> +    }
> +    return 0;
> +}
> +early_initcall(memory_sanitize_init);
> +#endif

The ifdef and the IS_ENABLED seem redundant to me. I'd drop the ifdef.

> +
>  static inline void set_page_poison(struct page *page)
>  {
>          struct page_ext *page_ext;
> diff --git a/mm/slub.c b/mm/slub.c
> index d24e1ce..ed26b10 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -449,10 +449,15 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
>   * Debug settings:
>   */
>  #if defined(CONFIG_SLUB_DEBUG_ON)
> +#if defined(CONFIG_MEMORY_SANITIZE)
> +/* With 'memory sanitize' On, slub_debug should be 'P' */
> +static int slub_debug = SLAB_POISON;
> +#else
>  static int slub_debug = DEBUG_DEFAULT_FLAGS;
> +#endif /* CONFIG_MEMORY_SANITIZE */
>  #else
>  static int slub_debug;
> -#endif
> +#endif /* CONFIG_SLUB_DEBUG_ON */

Could the definition of DEBUG_DEFAULT_FLAGS be adjusted instead of
doing the ifdefs here in the .c file? Or, perhaps do a slub_debug |=
SLAB_POISON in memory_sanitize_init()?

>
>  static char *slub_debug_slabs;
>  static int disable_higher_order_debug;
> @@ -5675,6 +5680,11 @@ static int __init slab_sysfs_init(void)
>          struct kmem_cache *s;
>          int err;
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +    pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug = P? %s [0x%x]\n",
> +        slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
> +#endif
> +
>          mutex_lock(&slab_mutex);
>
>          slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);

Good first step to getting the CONFIG to do something meaningful, thanks!

-Kees

-- 
Kees Cook
Pixel Security
