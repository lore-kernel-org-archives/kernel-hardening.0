MIME-Version: 1.0
References: <20190410161612.18545-1-keescook@chromium.org> <20190410161612.18545-2-keescook@chromium.org>
In-Reply-To: <20190410161612.18545-2-keescook@chromium.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Thu, 11 Apr 2019 17:50:10 +0900
Message-ID: <CAK7LNASLdZKNNM-Gft5bfVxKOG=4Ak-LBMnjb2E-QR4q_5GmEQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kconfig: Create "kernel hardening" config area
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Alexander Popov <alpopov@ptsecurity.com>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 1:16 AM Kees Cook <keescook@chromium.org> wrote:
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index 74271dba4f94..01874ef0f883 100644
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


This will flatten the plugin config options.

If you want to keep the current menu structure, you can do:

menu "GCC plugins"
...
endmenu




Another side-effect is Kbuild will descend into scripts/gcc-plugins/
even when no plugin is selected.
It is not a big build speed regression, though.



> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> new file mode 100644
> index 000000000000..8223a8ab1a12
> --- /dev/null
> +++ b/security/Kconfig.hardening
> @@ -0,0 +1,94 @@
> +menu "Kernel hardening options"
> +
> +config GCC_PLUGIN_STRUCTLEAK
> +       bool
> +       depends on GCC_PLUGIN_STRUCTLEAK_USER || GCC_PLUGIN_STRUCTLEAK_BYREF || GCC_PLUGIN_STRUCTLEAK_BYREF_ALL


I think this 'depends on' is unnecessary.


> +menu "Memory initialization"
> +
> +choice
> +       prompt "Initialize kernel stack variables at function entry"
> +       depends on CC_HAS_AUTO_VAR_INIT || GCC_PLUGINS

Nit:
CC_HAS_AUTO_VAR_INIT does not exist at this point.
I will be added by 3/3.


-- 
Best Regards
Masahiro Yamada
