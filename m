MIME-Version: 1.0
References: <20190410161612.18545-1-keescook@chromium.org> <20190410161612.18545-4-keescook@chromium.org>
In-Reply-To: <20190410161612.18545-4-keescook@chromium.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Thu, 11 Apr 2019 17:05:13 +0900
Message-ID: <CAK7LNAQpm5Tz_Fo0rSq00emB7BLnfYB-+mwXd9GiMKAqKCfkrA@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: Implement Clang's stack initialization
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Alexander Popov <alpopov@ptsecurity.com>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 1:16 AM Kees Cook <keescook@chromium.org> wrote:
>
> CONFIG_INIT_STACK_ALL turns on stack initialization based on
> -ftrivial-auto-var-init in Clang builds and on
> -fplugin-arg-structleak_plugin-byref-all in GCC builds.

Is CONFIG_INIT_STACK_ALL wired up to GCC plugin in any way?
I could not understand it from the code.


>
> -ftrivial-auto-var-init is a Clang flag that provides trivial
> initializers for uninitialized local variables, variable fields and
> padding.
>
> It has three possible values:
>   pattern - uninitialized locals are filled with a fixed pattern
>     (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D54604
>     for more details) likely to cause crashes when uninitialized value is
>     used;
>   zero (it's still debated whether this flag makes it to the official
>     Clang release) - uninitialized locals are filled with zeroes;
>   uninitialized (default) - uninitialized locals are left intact.
>
> The proposed config builds the kernel with
> -ftrivial-auto-var-init=pattern when selected.
>
> Developers have the possibility to opt-out of this feature on a
> per-variable basis by using __attribute__((uninitialized)).
>
> Co-developed-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Makefile                   |  5 +++++
>  security/Kconfig.hardening | 14 ++++++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index c0a34064c574..a7d9c6cd0267 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -745,6 +745,11 @@ KBUILD_CFLAGS      += -fomit-frame-pointer
>  endif
>  endif
>
> +# Initialize all stack variables with a pattern, if desired.
> +ifdef CONFIG_INIT_STACK_ALL
> +KBUILD_CFLAGS  += -ftrivial-auto-var-init=pattern
> +endif
> +
>  DEBUG_CFLAGS   := $(call cc-option, -fno-var-tracking-assignments)
>
>  ifdef CONFIG_DEBUG_INFO
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 9942d9869864..d744e20140b4 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -19,9 +19,13 @@ config GCC_PLUGIN_STRUCTLEAK
>
>  menu "Memory initialization"
>
> +config CC_HAS_AUTO_VAR_INIT
> +       def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
> +
>  choice
>         prompt "Initialize kernel stack variables at function entry"
>         depends on CC_HAS_AUTO_VAR_INIT || GCC_PLUGINS
> +       default INIT_STACK_ALL if CC_HAS_AUTO_VAR_INIT

Why should this be enabled by default?
Ins't it a performance regression
since it inserts instructions in function prologue?





-- 
Best Regards
Masahiro Yamada
