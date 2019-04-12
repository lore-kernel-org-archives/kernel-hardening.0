MIME-Version: 1.0
References: <20190411180117.27704-1-keescook@chromium.org> <20190411180117.27704-4-keescook@chromium.org>
In-Reply-To: <20190411180117.27704-4-keescook@chromium.org>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Apr 2019 13:36:12 +0200
Message-ID: <CAG_fn=VqXUTF+rLPcGNR8=kmNFdSAqmMKb9r9=SkoDcg7RrKnQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] security: Implement Clang's stack initialization
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 8:01 PM Kees Cook <keescook@chromium.org> wrote:
>
> CONFIG_INIT_STACK_ALL turns on stack initialization based on
> -ftrivial-auto-var-init in Clang builds, which has greater coverage
> than CONFIG_GCC_PLUGINS_STRUCTLEAK_BYREF_ALL.
>
> -ftrivial-auto-var-init Clang option provides trivial initializers for
> uninitialized local variables, variable fields and padding.
>
> It has three possible values:
>   pattern - uninitialized locals are filled with a fixed pattern
>     (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D54604
>     for more details, but 0x000000AA for 32-bit pointers) likely to cause
>     crashes when uninitialized value is used;
>   zero (it's still debated whether this flag makes it to the official
>     Clang release) - uninitialized locals are filled with zeroes;
>   uninitialized (default) - uninitialized locals are left intact.
>
> This patch uses only the "pattern" mode when CONFIG_INIT_STACK_ALL is
> enabled.
>
> Developers have the possibility to opt-out of this feature on a
> per-variable basis by using __attribute__((uninitialized)), but such
> use should be well justified in comments.
>
> Co-developed-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Alexander Potapenko <glider@google.com>
> ---
>  Makefile                   |  5 +++++
>  security/Kconfig.hardening | 15 ++++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index c0a34064c574..a7d9c6cd0267 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -745,6 +745,11 @@ KBUILD_CFLAGS      +=3D -fomit-frame-pointer
>  endif
>  endif
>
> +# Initialize all stack variables with a pattern, if desired.
> +ifdef CONFIG_INIT_STACK_ALL
> +KBUILD_CFLAGS  +=3D -ftrivial-auto-var-init=3Dpattern
> +endif
> +
>  DEBUG_CFLAGS   :=3D $(call cc-option, -fno-var-tracking-assignments)
>
>  ifdef CONFIG_DEBUG_INFO
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 3dd7a28c3822..5dd61770d3f0 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -18,9 +18,12 @@ config GCC_PLUGIN_STRUCTLEAK
>
>  menu "Memory initialization"
>
> +config CC_HAS_AUTO_VAR_INIT
> +       def_bool $(cc-option,-ftrivial-auto-var-init=3Dpattern)
> +
>  choice
>         prompt "Initialize kernel stack variables at function entry"
> -       depends on GCC_PLUGINS
> +       depends on CC_HAS_AUTO_VAR_INIT || GCC_PLUGINS
>         default INIT_STACK_NONE
>         help
>           This option enables initialization of stack variables at
> @@ -76,6 +79,16 @@ choice
>                   of uninitialized stack variable exploits and informatio=
n
>                   exposures.
>
> +       config INIT_STACK_ALL
> +               bool "0xAA-init everything on the stack (strongest)"
> +               depends on CC_HAS_AUTO_VAR_INIT
> +               help
> +                 Initializes everything on the stack with a 0xAA
> +                 pattern. This is intended to eliminate all classes
> +                 of uninitialized stack variable exploits and informatio=
n
> +                 exposures, even variables that were warned to have been
> +                 left uninitialized.
> +
>  endchoice
>
>  config GCC_PLUGIN_STRUCTLEAK_VERBOSE
> --
> 2.17.1
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
