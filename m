MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1491513513-84351-2-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org> <1491513513-84351-2-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 12 Apr 2017 15:12:52 -0700
Message-ID: <CAGXu5jL6XvC0gSFhtpOKRJ3nR2ZQjz4aaaMyak8PAvuHF2Ee1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 01/18] gcc-plugins: Add the randstruct plugin
To: Jessica Yu <jeyu@redhat.com>
Cc: Michael Leibowitz <michael.leibowitz@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 6, 2017 at 2:18 PM, Kees Cook <keescook@chromium.org> wrote:
> From: Michael Leibowitz <michael.leibowitz@intel.com>
>
> This plugin randomizes the layout of selected structures at compile
> time. This is a probabilistic defense against attacks that need to
> know the layout of structures within the kernel. While less useful for
> distribution kernels (where the randomization seed must be exposed for
> third party kernel module builds), it still has some value there since
> now all kernel builds would need to be tracked by an attacker.
>
> This introduces two defines __randomize_layout and __no_randomize_layout.
> Which, in turn, tell the compiler to either randomize or not to randomize
> the struct in question. Follow-on patches enable the auto-detection
> logic for selecting structures that contain only function pointers.
>
> This feature is ported over from grsecurity.  The implementation is
> almost entirely identical to the original code written by the PaX Team
> and Brad Spengler. To make integration simpler, this version has the
> auto-detection logic temporarily disabled. Structures that are to be
> randomized are required to use the C99 designated initializer form,
> which will be in follow-on patches.
>
> Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>
> [kees: refreshed plugin, disabled all-fptr-struct detection, update commit log]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/dontdiff                        |   2 +
>  arch/Kconfig                                  |  38 ++
>  include/linux/compiler-gcc.h                  |   5 +
>  include/linux/compiler.h                      |   8 +
>  include/linux/vermagic.h                      |   9 +-
>  kernel/module.c                               |  27 +-
>  scripts/Makefile.gcc-plugins                  |   5 +
>  scripts/gcc-plugins/.gitignore                |   1 +
>  scripts/gcc-plugins/Makefile                  |   8 +
>  scripts/gcc-plugins/gen-random-seed.sh        |   8 +
>  scripts/gcc-plugins/randomize_layout_plugin.c | 943 ++++++++++++++++++++++++++
>  11 files changed, 1052 insertions(+), 2 deletions(-)
>  create mode 100644 scripts/gcc-plugins/.gitignore
>  create mode 100644 scripts/gcc-plugins/gen-random-seed.sh
>  create mode 100644 scripts/gcc-plugins/randomize_layout_plugin.c
>
> [...]
> diff --git a/include/linux/vermagic.h b/include/linux/vermagic.h
> index 6f8fbcf10dfb..af6c03f7f986 100644
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
> index f953df992a11..2887660b0e9c 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1316,13 +1316,30 @@ static int check_version(Elf_Shdr *sechdrs,
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
>         /* Broken toolchain. Warn once, then let it go.. */
>         pr_warn_once("%s: no symbol version for %s\n", mod->name, symname);
> +#endif
>         return 1;
>
>  bad_version:
> +#ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
> +       /*
> +        * avoid potentially printing jibberish on attempted load
> +        * of a module randomized with a different seed
> +        */
> +       pr_warn("attempted module disagrees about version of symbol %s\n",
> +              symname);
> +#else
>         pr_warn("%s: disagrees about version of symbol %s\n",
>                mod->name, symname);
> +#endif
>         return 0;
>  }
>
> @@ -2964,7 +2981,15 @@ static struct module *setup_load_info(struct load_info *info, int flags)
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

Hi Jessica,

I was curious to get your input on these module-related changes that
are needed to support structure layout randomization. In the face of a
vermagic failure on a kernel built with randstruct, the module errors
can't dereference the from-disk module structure name field since it
may not be in the place it's expected.

I was thinking, instead of these explicit #ifdef chunks, maybe making
a helper macro/function would be better?

Also, can we get the module filename from somewhere, and use that
instead of the name field?

-Kees

-- 
Kees Cook
Pixel Security
