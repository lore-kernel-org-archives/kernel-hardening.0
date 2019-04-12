MIME-Version: 1.0
References: <20190411180117.27704-1-keescook@chromium.org> <20190411180117.27704-2-keescook@chromium.org>
In-Reply-To: <20190411180117.27704-2-keescook@chromium.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 12 Apr 2019 10:38:38 +0900
Message-ID: <CAK7LNATvNJprA94Qypfub2rpbEEJkAeV3yqVyuk2aNEraDKZ6w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] security: Create "kernel hardening" config area
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module@vger.kernel.org, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 12, 2019 at 3:01 AM Kees Cook <keescook@chromium.org> wrote:
>
> Right now kernel hardening options are scattered around various Kconfig
> files. This can be a central place to collect these kinds of options
> going forward. This is initially populated with the memory initialization
> options from the gcc-plugins.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  scripts/gcc-plugins/Kconfig | 74 +++--------------------------
>  security/Kconfig            |  2 +
>  security/Kconfig.hardening  | 93 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 102 insertions(+), 67 deletions(-)
>  create mode 100644 security/Kconfig.hardening
>
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index 74271dba4f94..84d471dea2b7 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -13,10 +13,11 @@ config HAVE_GCC_PLUGINS
>           An arch should select this symbol if it supports building with
>           GCC plugins.
>
> -menuconfig GCC_PLUGINS
> -       bool "GCC plugins"
> +config GCC_PLUGINS
> +       bool
>         depends on HAVE_GCC_PLUGINS
>         depends on PLUGIN_HOSTCC != ""
> +       default y
>         help
>           GCC plugins are loadable modules that provide extra features to the
>           compiler. They are useful for runtime instrumentation and static analysis.
> @@ -25,6 +26,8 @@ menuconfig GCC_PLUGINS
>
>  if GCC_PLUGINS
>
> +menu "GCC plugins"
> +



Just a tip to save "if" ... "endif" block.


If you like, you can write like follows:


menu "GCC plugins"
          depends on GCC_PLUGINS

  <menu body>

endmenu



instead of



if GCC_PLUGINS

menu "GCC plugins"

 <menu body>

endmenu

fi




> +menu "Memory initialization"
> +
> +choice
> +       prompt "Initialize kernel stack variables at function entry"
> +       depends on GCC_PLUGINS

On second thought,
this 'depends on' is unnecessary
because INIT_STACK_NONE should be always visible.


> +       default INIT_STACK_NONE
> +       help
> +         This option enables initialization of stack variables at
> +         function entry time. This has the possibility to have the
> +         greatest coverage (since all functions can have their
> +         variables initialized), but the performance impact depends
> +         on the function calling complexity of a given workload's
> +         syscalls.
> +
> +         This chooses the level of coverage over classes of potentially
> +         uninitialized variables. The selected class will be
> +         initialized before use in a function.
> +
> +       config INIT_STACK_NONE
> +               bool "no automatic initialization (weakest)"
> +               help
> +                 Disable automatic stack variable initialization.
> +                 This leaves the kernel vulnerable to the standard
> +                 classes of uninitialized stack variable exploits
> +                 and information exposures.
> +
> +       config GCC_PLUGIN_STRUCTLEAK_USER
> +               bool "zero-init structs marked for userspace (weak)"
> +               depends on GCC_PLUGINS
> +               select GCC_PLUGIN_STRUCTLEAK
> +               help
> +                 Zero-initialize any structures on the stack containing
> +                 a __user attribute. This can prevent some classes of
> +                 uninitialized stack variable exploits and information
> +                 exposures, like CVE-2013-2141:
> +                 https://git.kernel.org/linus/b9e146d8eb3b9eca
> +
> +       config GCC_PLUGIN_STRUCTLEAK_BYREF
> +               bool "zero-init structs passed by reference (strong)"
> +               depends on GCC_PLUGINS
> +               select GCC_PLUGIN_STRUCTLEAK
> +               help
> +                 Zero-initialize any structures on the stack that may
> +                 be passed by reference and had not already been
> +                 explicitly initialized. This can prevent most classes
> +                 of uninitialized stack variable exploits and information
> +                 exposures, like CVE-2017-1000410:
> +                 https://git.kernel.org/linus/06e7e776ca4d3654
> +
> +       config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
> +               bool "zero-init anything passed by reference (very strong)"
> +               depends on GCC_PLUGINS
> +               select GCC_PLUGIN_STRUCTLEAK
> +               help
> +                 Zero-initialize any stack variables that may be passed
> +                 by reference and had not already been explicitly
> +                 initialized. This is intended to eliminate all classes
> +                 of uninitialized stack variable exploits and information
> +                 exposures.
> +
> +endchoice



Another behavior change is
GCC_PLUGIN_STRUCTLEAK was previously enabled by all{yes,mod}config,
and in the compile-test coverage.

It will be disabled for all{yes,mod}config with this patch.

This is up to you. Just FYI.


-- 
Best Regards
Masahiro Yamada
