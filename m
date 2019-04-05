MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-2-glider@google.com>
 <CAK7LNATGJ9JZ8XxP2jQ-smDNH6igNvrSZB2TF62rykpqJBF8qg@mail.gmail.com>
In-Reply-To: <CAK7LNATGJ9JZ8XxP2jQ-smDNH6igNvrSZB2TF62rykpqJBF8qg@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Apr 2019 16:17:35 +0200
Message-ID: <CAG_fn=V=-iMdxH9YEVyLTr2qczCDOz37gwrVDk5POwnUOrne6g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 5, 2019 at 1:19 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Fri, Mar 8, 2019 at 10:27 PM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > CONFIG_INIT_ALL_MEMORY is going to be an umbrella config for options
> > that force heap and stack initialization.
> > The rationale behind doing so is to reduce the severity of bugs caused
> > by using uninitialized memory.
> >
> > CONFIG_INIT_ALL_STACK turns on stack initialization based on
> > -ftrivial-auto-var-init in Clang builds and on
> > -fplugin-arg-structleak_plugin-byref-all in GCC builds.
> >
> > -ftrivial-auto-var-init is a Clang flag that provides trivial
> > initializers for uninitialized local variables, variable fields and
> > padding.
> >
> > It has three possible values:
> >   pattern - uninitialized locals are filled with a fixed pattern
> >     (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D546=
04
> >     for more details) likely to cause crashes when uninitialized value =
is
> >     used;
> >   zero (it's still debated whether this flag makes it to the official
> >     Clang release) - uninitialized locals are filled with zeroes;
> >   uninitialized (default) - uninitialized locals are left intact.
> >
> > The proposed config builds the kernel with
> > -ftrivial-auto-var-init=3Dpattern.
> >
> > Developers have the possibility to opt-out of this feature on a
> > per-file (by using the INIT_ALL_MEMORY_ Makefile prefix)
>
> Do you have a plan to use this per-file prefix?
> If so, could you elaborate which parts should opt out?
I've added that when I started experimenting with auto-initialization,
but so far I haven't encountered a use-case for that, especially since
there's __attribute__((uninitialized)).
I'd better remove this part for now till we actually need it.
>
> > or per-variable
> > (by using __attribute__((uninitialized))) basis.
> >
> > For GCC builds, CONFIG_INIT_ALL_STACK is simply wired up to
> > CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL. No opt-out is possible at the
> > moment.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Kostya Serebryany <kcc@google.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Sandeep Patil <sspatil@android.com>
> > Cc: linux-security-module@vger.kernel.org
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: kernel-hardening@lists.openwall.com
> > ---
> >  v2:
> >   - addressed Kees Cook's comments: added GCC support
> > ---
> >  Makefile                 |  3 ++-
> >  scripts/Makefile.initmem | 10 ++++++++++
> >  scripts/Makefile.lib     |  6 ++++++
> >  security/Kconfig         |  1 +
> >  security/Kconfig.initmem | 29 +++++++++++++++++++++++++++++
> >  5 files changed, 48 insertions(+), 1 deletion(-)
> >  create mode 100644 scripts/Makefile.initmem
> >  create mode 100644 security/Kconfig.initmem
> >
> > diff --git a/Makefile b/Makefile
> > index f070e0d65186..028ca37878fd 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -448,7 +448,7 @@ export HOSTCXX KBUILD_HOSTCXXFLAGS LDFLAGS_MODULE C=
HECK CHECKFLAGS
> >
> >  export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD=
_LDFLAGS
> >  export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
> > -export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN
> > +export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN CFLAGS_INITME=
M
> >  export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
> >  export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
> >  export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
> > @@ -840,6 +840,7 @@ KBUILD_ARFLAGS :=3D $(call ar-option,D)
> >  include scripts/Makefile.kasan
> >  include scripts/Makefile.extrawarn
> >  include scripts/Makefile.ubsan
> > +include scripts/Makefile.initmem
> >
> >  # Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLAGS=
 as the
> >  # last assignments
> > diff --git a/scripts/Makefile.initmem b/scripts/Makefile.initmem
> > new file mode 100644
> > index 000000000000..a6253d78fe35
> > --- /dev/null
> > +++ b/scripts/Makefile.initmem
> > @@ -0,0 +1,10 @@
> > +ifdef CONFIG_INIT_ALL_STACK
> > +
> > +# Clang's -ftrivial-auto-var-init=3Dpattern flag initializes the
> > +# uninitialized parts of local variables (including fields and padding=
)
> > +# with a fixed pattern (0xAA in most cases).
> > +ifdef CONFIG_CC_HAS_AUTO_VAR_INIT
> > +  CFLAGS_INITMEM :=3D -ftrivial-auto-var-init=3Dpattern
> > +endif
> > +
> > +endif
> > diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> > index 12b88d09c3a4..53d18fd15c79 100644
> > --- a/scripts/Makefile.lib
> > +++ b/scripts/Makefile.lib
> > @@ -131,6 +131,12 @@ _c_flags +=3D $(if $(patsubst n%,, \
> >                 $(CFLAGS_UBSAN))
> >  endif
> >
> > +ifeq ($(CONFIG_INIT_ALL_MEMORY),y)
> > +_c_flags +=3D $(if $(patsubst n%,, \
> > +               $(INIT_ALL_MEMORY_$(basetarget).o)$(INIT_ALL_MEMORY)y),=
 \
> > +               $(CFLAGS_INITMEM))
> > +endif
> > +
> >  ifeq ($(CONFIG_KCOV),y)
> >  _c_flags +=3D $(if $(patsubst n%,, \
> >         $(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)$(CONFIG_KC=
OV_INSTRUMENT_ALL)), \
> > diff --git a/security/Kconfig b/security/Kconfig
> > index e4fe2f3c2c65..cc12a39424dd 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -230,6 +230,7 @@ config STATIC_USERMODEHELPER_PATH
> >           If you wish for all usermode helper programs to be disabled,
> >           specify an empty string here (i.e. "").
> >
> > +source "security/Kconfig.initmem"
> >  source "security/selinux/Kconfig"
> >  source "security/smack/Kconfig"
> >  source "security/tomoyo/Kconfig"
> > diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> > new file mode 100644
> > index 000000000000..27aec394365e
> > --- /dev/null
> > +++ b/security/Kconfig.initmem
> > @@ -0,0 +1,29 @@
> > +menu "Initialize all memory"
> > +
> > +config CC_HAS_AUTO_VAR_INIT
> > +       def_bool $(cc-option,-ftrivial-auto-var-init=3Dpattern)
> > +
> > +config INIT_ALL_MEMORY
> > +       bool "Initialize all memory"
> > +       default n
> > +       help
> > +         Enforce memory initialization to mitigate infoleaks and make
> > +         the control-flow bugs depending on uninitialized values more
> > +         deterministic.
> > +
> > +if INIT_ALL_MEMORY
> > +
> > +config INIT_ALL_STACK
> > +       bool "Initialize all stack"
> > +       depends on INIT_ALL_MEMORY
> > +       depends on CC_HAS_AUTO_VAR_INIT || HAVE_GCC_PLUGINS
> > +       select GCC_PLUGINS if !CC_HAS_AUTO_VAR_INIT
> > +       select GCC_PLUGIN_STRUCTLEAK if !CC_HAS_AUTO_VAR_INIT
> > +       select GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if !CC_HAS_AUTO_VAR_INIT
> > +       default y
> > +       help
> > +         Initialize uninitialized stack data with a fixed pattern
> > +         (0x00 in GCC, 0xAA in Clang).
>
> Ugh, the logic is getting complicated.
Not sure what's the best strategy here.
GCC provides only the 0x00 initialization.
Clang provides both, but 0x00 is hidden behind the
-enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
flag, which may be gone at some point.
Overall, initializing locals with 0xAA pattern is better, as it is
more likely to cause early detectable crashes when using those values.
>
> When I enabled INIT_ALL_MEMORY, I saw this:
>
> WARNING: unmet direct dependencies detected for GCC_PLUGINS
>   Depends on [n]: HAVE_GCC_PLUGINS [=3Dy] && PLUGIN_HOSTCC [=3D]!=3D
>   Selected by [y]:
>   - INIT_ALL_STACK [=3Dy] && INIT_ALL_MEMORY [=3Dy] &&
> (CC_HAS_AUTO_VAR_INIT [=3Dn] || HAVE_GCC_PLUGINS [=3Dy]) &&
> !CC_HAS_AUTO_VAR_INIT [=3Dn]
Yes, we need to check for PLUGIN_HOSTCC as well. I'll update the patch.
FWIW you need gcc-*-plugin-dev installed in order to use these plugins.
>
>
>
> > +endif # INIT_ALL_MEMORY
> > +endmenu
> > --
> > 2.21.0.360.g471c308f928-goog
> >
>
>
> --
> Best Regards
> Masahiro Yamada



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
