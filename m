MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170215125735.17920d58@kaiwan-T460>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460> <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
 <CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
 <CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com> <20170215125735.17920d58@kaiwan-T460>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Feb 2017 12:30:52 -0800
Message-ID: <CAGXu5jLRyDQ9M209JyNQRm3M+4ZtzdE9W0=7S7aXqSMavFZi1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>, Christoph Lameter <cl@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 11:27 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Okay, I've incorporated your suggestions.
> Of course, the printk's are temporary.
>
> Pl see:
> - the updated patch, and
> - a 'truth table' enumerating some basic testing with these configs,
> below:
>
> ---
> diff --git a/init/main.c b/init/main.c
> index ef47035..ba44574 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1028,6 +1028,11 @@ static noinline void __init kernel_init_freeable(void)
>
>         do_basic_setup();
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +       pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
> +               page_poisoning_enabled() ? "yes" : "no");
> +#endif
> +
>         /* Open the /dev/console on the rootfs, this should never fail */
>         if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>                 pr_err("Warning: unable to open an initial console.\n");
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 3e5eada..fbb4290 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -97,3 +97,24 @@ config DEBUG_RODATA_TEST
>      ---help---
>        This option enables a testcase for the setting rodata read-only.
>
> +config MEMORY_SANITIZE
> +    bool "Enable memory sanitization features"
> +    select SLUB_DEBUG
> +    select PAGE_POISONING
> +    select PAGE_POISONING_NO_SANITY
> +    ---help---
> +       This option enables memory sanitization features. Particularly,
> +       when you turn on this option, it auto-enables:
> +       - SLUB debug
> +       - page poisoning
> +       - page poisoning no sanity.
> +
> +       Implication: turning this option on _will_ implicitly enable:
> +       - the SLUB_DEBUG switch to the equivalent of the kernel command-line
> +         'slub_debug=p' ; (where p=PAGE_POISON),
> +       - page poisoning, equivalent to passing the kernel command-line option
> +         'page_poison=on',
> +       irrespective of whether the options are explicitly passed or not.

Hm, we don't want to force this on against other command line
settings, so how about what I suggest below...

> +
> +       If unsure, say N.
> +
> diff --git a/mm/page_poison.c b/mm/page_poison.c
> index 2e647c6..8d1e883 100644
> --- a/mm/page_poison.c
> +++ b/mm/page_poison.c
> @@ -49,6 +49,17 @@ struct page_ext_operations page_poisoning_ops = {
>         .init = init_page_poisoning,
>  };
>
> +static int __init memory_sanitize_pagepoison_init(void)
> +{
> +       /* With 'memory sanitize' On, page poisoning Must be turned on */
> +       if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> +               want_page_poisoning = true;
> +               __page_poisoning_enabled = true;
> +       }
> +       return 0;
> +}
> +early_initcall(memory_sanitize_pagepoison_init);

Can this be changed to interact better with the command line
arguments, in case someone selects CONFIG_MEMORY_SANITIZE, but boots
with page_poison=off?

e.g. instead of your init code, do this:

static bool want_page_poisoning __read_mostly =
IS_ENABLED(CONFIG_MEMORY_SANITIZE);

That way the logic for __page_poisoning_enabled is retained, etc.

> +
>  static inline void set_page_poison(struct page *page)
>  {
>         struct page_ext *page_ext;
> diff --git a/mm/slub.c b/mm/slub.c
> index d24e1ce..62de543 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -457,6 +457,17 @@ static int slub_debug;
>  static char *slub_debug_slabs;
>  static int disable_higher_order_debug;
>
> +static int __init memory_sanitize_slubdebug_init(void)
> +{
> +/* With 'memory sanitize' On, slub_debug Must be set to 'p' */
> +       if (IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
> +            IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> +               slub_debug |= SLAB_POISON;
> +       }
> +       return 0;
> +}
> +early_initcall(memory_sanitize_slubdebug_init);

And instead of this, use:

#if defined(CONFIG_SLUB_DEBUG_ON)
# define SLUB_DEBUG_INITIAL_FLAGS       DEBUG_DEFAULT_FLAGS
#elif defined(CONFIG_MEMORY_SANITIZE)
# define SLUB_DEBUG_INITIAL_FLAGS       SLAB_POISON
#else
# define SLUB_DEBUG_INITIAL_FLAGS       0
#endif

static int slub_debug = SLUB_DEBUG_INITIAL_FLAGS;

That way we're just setting the boot-time defaults and it'll safely
interact with everything else.

(I've added Christoph to CC to see what he thinks of this.)

-Kees

-- 
Kees Cook
Pixel Security
