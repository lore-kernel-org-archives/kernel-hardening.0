Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1462468869-6210-3-git-send-email-michael.leibowitz@intel.com>
References: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
	<1462468869-6210-3-git-send-email-michael.leibowitz@intel.com>
Date: Thu, 5 May 2016 11:15:00 -0700
Message-ID: <CAGXu5jKP=zoHJL0dFJdopcXFoWdq-T9zZ16t6dF-U04LB50hOg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 2/3] Enable the RANDSTRUCT plugin
To: Michael Leibowitz <michael.leibowitz@intel.com>
Cc: Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 5, 2016 at 10:21 AM, Michael Leibowitz
<michael.leibowitz@intel.com> wrote:
> These are config changes necessary to configure/enable the
> structure layout randomizing gcc plugin
>
> This feature is ported over from grsecurity.  This is largely
> unchanged from the Original code written by the PaX Team and Spender.
>
> Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>
> ---
>  arch/Kconfig                 | 43 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/compiler-gcc.h |  5 +++++
>  include/linux/compiler.h     |  9 +++++++++
>  include/linux/vermagic.h     |  9 ++++++++-
>  kernel/module.c              | 27 +++++++++++++++++++++++++++
>  5 files changed, 92 insertions(+), 1 deletion(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 8af17ae..c3955a2 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -389,6 +389,49 @@ config GCC_PLUGIN_SANCOV
>           gcc-4.5 on). It is based on the commit "Add fuzzing coverage support"
>           by Dmitry Vyukov <dvyukov@google.com>.
>
> +config GCC_PLUGIN_RANDSTRUCT
> +       bool "Randomize layout of sensitive kernel structures"
> +       default n
> +       depends on GCC_PLUGINS
> +       select MODVERSIONS if MODULES
> +       help
> +
> +         If you say Y here, the layouts of a number of sensitive kernel
> +         structures and all structures composed entirely of function pointers
> +         (aka "ops" structs) will be randomized at compile-time.  This can make
> +         exploitation that targets these structures more difficult by either
> +         requiring an additional information leak vulnerability, or knowing the
> +         pricise build that the target is running.
> +
> +         Enabling this feature will have a performance impact, slightly
> +         increase memory usage, and prevent the use of forensic tools like
> +         Volatility against the system (unless the kernel source tree isn't
> +         cleaned after kernel installation).
> +
> +         Additionally, enabling this feature causes modules compiled with one
> +         random seed to have gibberish names when loaded by a kernel with a
> +         different random seed.

I think this paragraph can be dropped, since the module name is
avoided in the code below.

> +
> +         The seed used for compilation is located at
> +         scripts/gcc-plugins/randomize_layout_seed.h.  It remains after a make
> +         clean to allow for external modules to be compiled with the existing
> +         seed and will be removed by a make mrproper or make distclean.
> +
> +         Note that the implementation requires gcc 4.6.4. or newer.  You may need
> +         to install the supporting headers explicitly in addition to the normal
> +         gcc package.

Does this use headers not already detected by the gcc plugin infrastructure?

> +
> +config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
> +       bool "Use cacheline-aware structure randomization"
> +       default n
> +       depends on GCC_PLUGIN_RANDSTRUCT
> +       help
> +         If you say Y here, the RANDSTRUCT randomization will make a best effort
> +         at restricting randomization to cacheline-sized groups of elements.  It
> +         will further not randomize bitfields in structures.  This reduces the
> +         performance hit of RANDSTRUCT at the cost of weakened randomization.
> +
> +
>  config HAVE_CC_STACKPROTECTOR
>         bool
>         help
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index 22ab246..7bfa763 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -201,6 +201,11 @@
>  /* Mark a function definition as prohibited from being cloned. */
>  #define __noclone      __attribute__((__noclone__))
>
> +#ifdef RANDSTRUCT_PLUGIN
> +#define __randomize_layout __attribute__((randomize_layout))
> +#define __no_randomize_layout __attribute__((no_randomize_layout))
> +#endif
> +
>  #endif /* GCC_VERSION >= 40500 */
>
>  #if GCC_VERSION >= 40600
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 48f5aab..8d0776e 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -416,6 +416,15 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>  # define __attribute_const__   /* unimplemented */
>  #endif
>
> +#ifndef __randomize_layout
> +# define __randomize_layout
> +#endif
> +
> +#ifndef __no_randomize_layout
> +# define __no_randomize_layout
> +#endif
> +
> +
>  /*
>   * Tell gcc if a function is cold. The compiler will assume any path
>   * directly leading to the call is unlikely.
> diff --git a/include/linux/vermagic.h b/include/linux/vermagic.h
> index 6f8fbcf..af6c03f 100644
> --- a/include/linux/vermagic.h
> +++ b/include/linux/vermagic.h
> @@ -24,10 +24,17 @@
>  #ifndef MODULE_ARCH_VERMAGIC
>  #define MODULE_ARCH_VERMAGIC ""
>  #endif
> +#ifdef RANDSTRUCT_PLUGIN
> +#include <generated/randomize_layout_hash.h>
> +#define MODULE_RANDSTRUCT_PLUGIN "RANDSTRUCT_PLUGIN_" RANDSTRUCT_HASHED_SEED
> +#else
> +#define MODULE_RANDSTRUCT_PLUGIN
> +#endif
>
>  #define VERMAGIC_STRING                                                \
>         UTS_RELEASE " "                                                 \
>         MODULE_VERMAGIC_SMP MODULE_VERMAGIC_PREEMPT                     \
>         MODULE_VERMAGIC_MODULE_UNLOAD MODULE_VERMAGIC_MODVERSIONS       \
> -       MODULE_ARCH_VERMAGIC
> +       MODULE_ARCH_VERMAGIC                                            \
> +       MODULE_RANDSTRUCT_PLUGIN
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 794ebe8..74cf098 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1296,12 +1296,31 @@ static int check_version(Elf_Shdr *sechdrs,
>                 goto bad_version;
>         }
>
> +#ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
> +       /*
> +        * avoid potentially printing jibberish on attempted load
> +        * of a module randomized with a different seed
> +        */
> +       pr_warn("no symbol version for %s\n", symname);
> +#else
> +       pr_warn("%s: no symbol version for %s\n", mod->name, symname);
> +#endif
> +
>         pr_warn("%s: no symbol version for %s\n", mod->name, symname);

I think this pr_warn needs to be removed (it looks to have moved
inside the define).

I wonder if the module filename can be propagated in some other way
besides mod->name?

>         return 0;
>
>  bad_version:
> +#ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
> +       /*
> +        * avoid potentially printing jibberish on attempted load
> +        * of a module randomized with a different seed
> +        */
> +       pr_warn("attempted module disagrees about version of symbol %s\n",
> +               symname);
> +#else
>         pr_warn("%s: disagrees about version of symbol %s\n",
>                mod->name, symname);
> +#endif
>         return 0;
>  }
>
> @@ -2835,7 +2854,15 @@ static struct module *setup_load_info(struct load_info *info, int flags)
>         mod = (void *)info->sechdrs[info->index.mod].sh_addr;
>
>         if (info->index.sym == 0) {
> +#ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
> +               /*
> +                * avoid potentially printing jibberish on attempted load
> +                * of a module randomized with a different seed
> +                */
> +               pr_warn("module has no symbols (stripped?)\n");
> +#else
>                 pr_warn("%s: module has no symbols (stripped?)\n", mod->name);
> +#endif
>                 return ERR_PTR(-ENOEXEC);
>         }
>
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS & Brillo Security
