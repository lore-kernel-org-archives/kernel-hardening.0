MIME-Version: 1.0
References: <1543463791-18391-1-git-send-email-yamada.masahiro@socionext.com> <1543463791-18391-2-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1543463791-18391-2-git-send-email-yamada.masahiro@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Sat, 1 Dec 2018 23:56:31 +0900
Message-ID: <CAK7LNARoQweReaTV7cFkf1VmiS3JzO+iGGPBMvvzsFqpw3JJOw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kbuild: descend into scripts/gcc-plugins/ via scripts/Makefile
Content-Type: text/plain; charset="UTF-8"
To: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michal Marek <michal.lkml@markovi.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 29, 2018 at 12:57 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Now that 'archprepare' depends on 'scripts', Kbuild can descend into
> scripts/gcc-plugins in a more standard way.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---

Applied to linux-kbuild.


> Changes in v2:
>   - It turned out UML + CONFIG_GCC_PLUGINS is broken for a long time.
>     https://patchwork.kernel.org/patch/10703853/
>     Rebased on the top of the fix-up
>
>  Makefile                     | 2 +-
>  scripts/Makefile             | 3 ++-
>  scripts/Makefile.gcc-plugins | 8 --------
>  3 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 9eb3f4f..c1f87cf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1112,7 +1112,7 @@ prepare1: prepare2 $(version_h) $(autoksyms_h) include/generated/utsrelease.h
>
>  macroprepare: prepare1 archmacros
>
> -archprepare: archheaders archscripts macroprepare scripts gcc-plugins
> +archprepare: archheaders archscripts macroprepare scripts
>
>  prepare0: archprepare
>         $(Q)$(MAKE) $(build)=scripts/mod
> diff --git a/scripts/Makefile b/scripts/Makefile
> index b48259d..feb1f71 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -36,9 +36,10 @@ PHONY += build_unifdef
>  build_unifdef: $(obj)/unifdef
>         @:
>
> +subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
>  subdir-$(CONFIG_MODVERSIONS) += genksyms
>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>  subdir-$(CONFIG_GDB_SCRIPTS) += gdb
>
>  # Let clean descend into subdirs
> -subdir-        += basic dtc kconfig mod package gcc-plugins
> +subdir-        += basic dtc kconfig mod package
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 46c5c68..c36f199 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -49,11 +49,3 @@ KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>  # All enabled GCC plugins are collected here for building below.
>  GCC_PLUGIN := $(gcc-plugin-y)
>  export GCC_PLUGIN
> -
> -# Actually do the build, if requested.
> -PHONY += gcc-plugins
> -gcc-plugins: scripts_basic
> -ifdef CONFIG_GCC_PLUGINS
> -       $(Q)$(MAKE) $(build)=scripts/gcc-plugins
> -endif
> -       @:
> --
> 2.7.4
>


-- 
Best Regards
Masahiro Yamada
