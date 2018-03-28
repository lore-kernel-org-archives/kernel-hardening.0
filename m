MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1522128575-5326-20-git-send-email-yamada.masahiro@socionext.com>
References: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com> <1522128575-5326-20-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Mar 2018 04:44:32 -0700
Message-ID: <CAGXu5jJB3AKMC8U--H61eUkFJeMogLMq00dBUUrfg4n2b4FbOQ@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] gcc-plugins: test GCC plugin support in Kconfig
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Ulf Magnusson <ulfalizer@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Nicolas Pitre <nico@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 26, 2018 at 10:29 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> Run scripts/gcc-plugin.sh from Kconfig.  Users can enable GCC_PLUGINS
> only when it is supported.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
> Changes in v2: None
>
>  arch/Kconfig                 |  4 +++
>  scripts/Makefile.gcc-plugins | 82 ++++++++++++++++----------------------------
>  scripts/gcc-plugin.sh        |  1 -
>  3 files changed, 33 insertions(+), 54 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index b42378d..88cc925 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -407,9 +407,13 @@ config HAVE_GCC_PLUGINS
>           An arch should select this symbol if it supports building with
>           GCC plugins.
>
> +config CC_HAS_GCC_PLUGINS
> +       bool
> +

This doesn't seem used anywhere?

>  menuconfig GCC_PLUGINS
>         bool "GCC plugins"
>         depends on HAVE_GCC_PLUGINS
> +       depends on $(success $srctree/scripts/gcc-plugin.sh $HOSTCXX $CC)
>         depends on !COMPILE_TEST
>         help
>           GCC plugins are loadable modules that provide extra features to the
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 25da4c0..19d0d5b 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> [...]
> -# If plugins aren't supported, abort the build before hard-to-read compiler
> -# errors start getting spewed by the main build.
> -PHONY += gcc-plugins-check
> -gcc-plugins-check: FORCE
> -ifdef CONFIG_GCC_PLUGINS
> -  ifeq ($(PLUGINCC),)
> -    ifneq ($(GCC_PLUGINS_CFLAGS),)
> -      $(Q)$(srctree)/scripts/gcc-plugin.sh --show-error $(HOSTCXX) $(CC) || true
> -      @echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1

As mentioned in the other email, we lose the error reporting. Now the
lack of plugins is just a silent =n in menuconfig. Keeping
--show-error in the Kconfig call and retaining stderr would be nice.

I need to do some further testing with SANCOV, but otherwise this all
looks correct, and my testing shows it behaving correctly.

-Kees

-- 
Kees Cook
Pixel Security
