MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1530578352-18613-1-git-send-email-yamada.masahiro@socionext.com>
References: <1530578352-18613-1-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 2 Jul 2018 19:18:26 -0700
Message-ID: <CAGXu5jKcWjm-56VRj=0kKU0Fb1ZrGgJ8WgesD0cN2x9WHTGwDw@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: remove unused GCC_PLUGIN_SUBDIR
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild <linux-kbuild@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 2, 2018 at 5:39 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> GCC_PLUGIN_SUBDIR has never been used.  If you really need this in
> the future, please re-add it then.
>
> For now, the code is unused. Remove.
>
> 'export HOSTLIBS' is not necessary either.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Acked-by: Kees Cook <keescook@chromium.org>

Is this going via your tree, or should I take it via the gcc-plugins tree?

Thanks!

-Kees

> ---
>
>  scripts/Makefile.gcc-plugins | 3 +--
>  scripts/gcc-plugins/Makefile | 5 -----
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index c961b9a..f9942d9 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -19,7 +19,7 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE) += -fplugin-arg-ra
>
>  GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
>
> -export GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
> +export GCC_PLUGINS_CFLAGS GCC_PLUGIN
>  export DISABLE_LATENT_ENTROPY_PLUGIN
>
>  # sancov_plugin.so can be only in CFLAGS_KCOV because avoid duplication.
> @@ -27,7 +27,6 @@ GCC_PLUGINS_CFLAGS := $(filter-out %/sancov_plugin.so, $(GCC_PLUGINS_CFLAGS))
>
>  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>  GCC_PLUGIN := $(gcc-plugin-y)
> -GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
>
>  # Actually do the build, if requested.
>  PHONY += gcc-plugins
> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> index 3262546..aa0d0ec 100644
> --- a/scripts/gcc-plugins/Makefile
> +++ b/scripts/gcc-plugins/Makefile
> @@ -14,8 +14,6 @@ else
>    export HOST_EXTRACXXFLAGS
>  endif
>
> -export HOSTLIBS
> -
>  $(obj)/randomize_layout_plugin.o: $(objtree)/$(obj)/randomize_layout_seed.h
>  quiet_cmd_create_randomize_layout_seed = GENSEED $@
>  cmd_create_randomize_layout_seed = \
> @@ -29,7 +27,4 @@ always := $($(HOSTLIBS)-y)
>
>  $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
>
> -subdir-y := $(GCC_PLUGIN_SUBDIR)
> -subdir-  += $(GCC_PLUGIN_SUBDIR)
> -
>  clean-files += *.so
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
