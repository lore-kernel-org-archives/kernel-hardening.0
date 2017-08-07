MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170806110627.16242-1-ard.biesheuvel@linaro.org>
References: <20170806110627.16242-1-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Aug 2017 10:45:56 -0700
Message-ID: <CAGXu5j+Zz0F_Co+2LtFp6fGc5NnJF=j6NPr-xuFpqQ71eiad-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: structleak: add option to init all vars used
 as byref args
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Micay <danielmicay@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, PaX Team <pageexec@freemail.hu>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 6, 2017 at 4:06 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> In the Linux kernel, struct type variables are rarely passed by-value,
> and so functions that initialize such variables typically take an input
> reference to the variable rather than returning a value that can
> subsequently be used in an assignment.
>
> If the initalization function is not part of the same compilation unit,
> the lack of an assignment operation defeats any analysis the compiler
> can perform as to whether the variable may be used before having been
> initialized. This means we may end up passing on such variables
> uninitialized, resulting in potential information leaks.
>
> So extend the existing structleak GCC plugin so it will [optionally]
> apply to all struct type variables that have their address taken at any
> point, rather than only to variables of struct types that have a __user
> annotation.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks! This looks good to me; I'll get it into -next.

-Kees

> ---
>  arch/Kconfig                            |  7 +++++++
>  scripts/Makefile.gcc-plugins            |  1 +
>  scripts/gcc-plugins/structleak_plugin.c | 13 +++++++++++--
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 21d0089117fe..edc6fd41b7ea 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -468,6 +468,13 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>           initialized. Since not all existing initializers are detected
>           by the plugin, this can produce false positive warnings.
>
> +config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
> +       bool "Force initialize all struct type variables passed by reference"
> +       depends on GCC_PLUGIN_STRUCTLEAK
> +       help
> +         Zero initialize any struct type local variable that may be passed by
> +         reference without having been initialized.
> +
>  config GCC_PLUGIN_RANDSTRUCT
>         bool "Randomize layout of sensitive kernel structures"
>         depends on GCC_PLUGINS
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 2e0e2eaa397f..d1f7b0d6be66 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -27,6 +27,7 @@ ifdef CONFIG_GCC_PLUGINS
>
>    gcc-plugin-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)   += structleak_plugin.so
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)    += -fplugin-arg-structleak_plugin-verbose
> +  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)  += -fplugin-arg-structleak_plugin-byref-all
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)    += -DSTRUCTLEAK_PLUGIN
>
>    gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)   += randomize_layout_plugin.so
> diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
> index fa3d7a4b26f2..3f8dd4868178 100644
> --- a/scripts/gcc-plugins/structleak_plugin.c
> +++ b/scripts/gcc-plugins/structleak_plugin.c
> @@ -16,6 +16,7 @@
>   * Options:
>   * -fplugin-arg-structleak_plugin-disable
>   * -fplugin-arg-structleak_plugin-verbose
> + * -fplugin-arg-structleak_plugin-byref-all
>   *
>   * Usage:
>   * $ # for 4.5/4.6/C based 4.7
> @@ -42,6 +43,7 @@ static struct plugin_info structleak_plugin_info = {
>  };
>
>  static bool verbose;
> +static bool byref_all;
>
>  static tree handle_user_attribute(tree *node, tree name, tree args, int flags, bool *no_add_attrs)
>  {
> @@ -150,7 +152,9 @@ static void initialize(tree var)
>         /* these aren't the 0days you're looking for */
>         if (verbose)
>                 inform(DECL_SOURCE_LOCATION(var),
> -                       "userspace variable will be forcibly initialized");
> +                       "%s variable will be forcibly initialized",
> +                       (byref_all && TREE_ADDRESSABLE(var)) ? "byref"
> +                                                            : "userspace");
>
>         /* build the initializer expression */
>         initializer = build_constructor(TREE_TYPE(var), NULL);
> @@ -190,7 +194,8 @@ static unsigned int structleak_execute(void)
>                         continue;
>
>                 /* if the type is of interest, examine the variable */
> -               if (TYPE_USERSPACE(type))
> +               if (TYPE_USERSPACE(type) ||
> +                   (byref_all && TREE_ADDRESSABLE(var)))
>                         initialize(var);
>         }
>
> @@ -232,6 +237,10 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
>                         verbose = true;
>                         continue;
>                 }
> +               if (!strcmp(argv[i].key, "byref-all")) {
> +                       byref_all = true;
> +                       continue;
> +               }
>                 error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
>         }
>
> --
> 2.11.0
>



-- 
Kees Cook
Pixel Security
