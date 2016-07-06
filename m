Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160626173820.13ad67e14e7a29a6563fe129@gmail.com>
References: <20160626173820.13ad67e14e7a29a6563fe129@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 6 Jul 2016 14:56:19 -0400
Message-ID: <CAGXu5j+C19jsLt9o9kDW6t2-FOrPTnSM8HGkKe8V-qhYmFVc2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Add support for complex gcc plugins that don't fit in a
 single file
To: Emese Revfy <re.emese@gmail.com>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 11:38 AM, Emese Revfy <re.emese@gmail.com> wrote:
>
> Reported-by: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

I've added a commit message body to this and applied it to my tree
(though nothing uses it yet...)

-Kees

> ---
>  scripts/Makefile.gcc-plugins | 3 ++-
>  scripts/gcc-plugins/Makefile | 9 ++++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 61fc4bb..1f922df 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -27,7 +27,7 @@ ifdef CONFIG_GCC_PLUGINS
>
>    GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
>
> -  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
> +  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
>
>    ifneq ($(PLUGINCC),)
>      # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
> @@ -36,6 +36,7 @@ ifdef CONFIG_GCC_PLUGINS
>
>    KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>    GCC_PLUGIN := $(gcc-plugin-y)
> +  GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
>  endif
>
>  # If plugins aren't supported, abort the build before hard-to-read compiler
> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> index 898449d..94fa139 100644
> --- a/scripts/gcc-plugins/Makefile
> +++ b/scripts/gcc-plugins/Makefile
> @@ -12,14 +12,17 @@ else
>    export HOST_EXTRACXXFLAGS
>  endif
>
> -export GCCPLUGINS_DIR HOSTLIBS
> -
>  ifneq ($(CFLAGS_KCOV), $(SANCOV_PLUGIN))
>    GCC_PLUGIN := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGIN))
>  endif
>
> -$(HOSTLIBS)-y := $(GCC_PLUGIN)
> +export HOSTLIBS
> +
> +$(HOSTLIBS)-y := $(foreach p,$(GCC_PLUGIN),$(if $(findstring /,$(p)),,$(p)))
>  always := $($(HOSTLIBS)-y)
>  $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
>
> +subdir-y := $(GCC_PLUGIN_SUBDIR)
> +subdir-  += $(GCC_PLUGIN_SUBDIR)
> +
>  clean-files += *.so
> --
> 2.8.1



-- 
Kees Cook
Chrome OS & Brillo Security
