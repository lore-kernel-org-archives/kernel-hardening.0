MIME-Version: 1.0
References: <20190307133514.44378-1-glider@google.com> <20190307133514.44378-2-glider@google.com>
 <CAGXu5jJM4RNOUUSu5YnT_csdHjra=qJv3kiC6qh1aZTLCKvxdw@mail.gmail.com>
In-Reply-To: <CAGXu5jJM4RNOUUSu5YnT_csdHjra=qJv3kiC6qh1aZTLCKvxdw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 8 Mar 2019 12:57:38 +0100
Message-ID: <CAG_fn=Ug7FypD_vLMi9s0zYebC8MfoucNeqkfasa0L=yZp3hEg@mail.gmail.com>
Subject: Re: [PATCH 1/1] RFC: initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 7, 2019 at 6:12 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Mar 7, 2019 at 5:35 AM Alexander Potapenko <glider@google.com> wr=
ote:
> >
> > This patch is a part of a bigger initiative to allow initializing
> > heap/stack memory in the Linux kernels by default.
> > The rationale behind doing so is to reduce the severity of bugs caused
> > by using uninitialized memory.
> >
> > CONFIG_INIT_ALL_MEMORY is going to be an umbrella config for options
> > that force heap and stack initialization.
>
> We have some level of control over the heap portions already with the
> poisoning options, but they currently require command-line enabling.
>
> For the slab allocator:
> CONFIG_SLUB_DEBUG=3Dy
> and boot with "slub_debug=3DP"
>
> For the page allocator:
> CONFIG_PAGE_POISONING=3Dy
> CONFIG_PAGE_POISONING_NO_SANITY=3Dy
> CONFIG_PAGE_POISONING_ZERO=3Dy
> and boot with "page_poison=3D1"
>
> So I think it would make sense to wire up the boot defaults and
> continue some of the benchmarking work to improve the performance hit.
>
> > CONFIG_INIT_ALL_STACK turns on stack initialization based on the
> > -ftrivial-auto-var-init Clang flag.
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
>
> This should get wired up to CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL in
> the GCC case.
>
> > The proposed config builds the kernel with
> > -ftrivial-auto-var-init=3Dpattern.
> >
> > Developers have the possibility to opt-out of this feature on a
> > per-file (by using the INIT_ALL_MEMORY_ Makefile prefix) or per-variabl=
e
> > (by using __attribute__((uninitialized))) basis.
>
> I would like a clean way to offer a paranoid "true init all memory"
> config that will ignore the attribute. Also, BYREF_ALL needs to gain
> the attribute knowledge.
>
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
> >
> > ---
> >  Makefile                 |  3 ++-
> >  scripts/Makefile.initmem | 17 +++++++++++++++++
> >  scripts/Makefile.lib     |  6 ++++++
> >  security/Kconfig         |  1 +
> >  security/Kconfig.initmem | 22 ++++++++++++++++++++++
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
> > index 000000000000..f49be398f2c1
> > --- /dev/null
> > +++ b/scripts/Makefile.initmem
> > @@ -0,0 +1,17 @@
> > +ifdef CONFIG_INIT_ALL_MEMORY
> > +
> > +# Clang's -ftrivial-auto-var-init=3Dpattern flag initializes the
> > +# uninitialized parts of local variables (including fields and padding=
)
> > +# with a fixed pattern (0xAA in most cases).
> > +ifdef CONFIG_INIT_ALL_STACK
> > + CFLAGS_INITMEM :=3D -ftrivial-auto-var-init=3Dpattern
> > +endif
> > +
> > +ifeq ($(call cc-option, $(CFLAGS_INITMEM) -Werror),)
> > +   ifneq ($(CONFIG_COMPILE_TEST),y)
> > +        $(warning Cannot use CONFIG_INIT_ALL_MEMORY: \
> > +            -ftrivial-auto-var-init is not supported by compiler)
> > +   endif
> > +endif
>
> This should be done in the Kconfig (see how stack protector is
> handled), rather than the Makefile. See below.
>
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
> > index 000000000000..5ac3cf3e7f88
> > --- /dev/null
> > +++ b/security/Kconfig.initmem
> > @@ -0,0 +1,22 @@
> > +menu "Initialize all memory"
> > +
> > +config INIT_ALL_MEMORY
> > +       bool "Initialize all memory"
> > +       default n
> > +       help
> > +         Enforce memory initialization to mitigate infoleaks and make
> > +         the control-flow bugs depending on uninitialized values more
> > +         deterministic.
>
> See my notes about enabling page/slab poisoning via this option (which
> should probably be a separate HEAP option).
>
> > +
> > +if INIT_ALL_MEMORY
> > +
> > +config INIT_ALL_STACK
> > +       bool "Initialize all stack"
> > +       depends on INIT_ALL_MEMORY
>
> For example of doing this in Kconfig:
>
> config CC_HAS_AUTO_VAR_INIT
>         def_bool $(cc-option,-ftrivial-auto-var-init=3Dpattern)
>
> config INIT_ALL_STACK
>         bool "Initialize all stack"
>         depends on CC_HAS_AUTO_VAR_INIT || HAVE_GCC_PLUGINS
Shouldn't we also check for PLUGIN_HOSTCC !=3D "" here?
Otherwise not having gcc-*-plugin-dev installed results in an unmet depende=
ncy.
>         select GCC_PLUGINS if !CC_HAS_AUTO_VAR_INIT
>         select GCC_PLUGIN_STRUCTLEAK if !CC_HAS_AUTO_VAR_INIT
>         select GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if !CC_HAS_AUTO_VAR_INIT
>
> probably GCC_PLUGINS needs to be "default y" so this select mess is
> less crazy. I already started work on reorganizing the Kconfig there:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=
=3Dkspp/gcc-plugin/structleak&id=3D81a56f6dcd20325607d6008f4bb560c96f4c821a
>
> > +       default y
> > +       help
> > +         Initialize uninitialized stack data with a 0xAA pattern.
> > +         This config option only supports Clang builds at the moment.
> > +
> > +endif # INIT_ALL_MEMORY
> > +endmenu
> > --
> > 2.21.0.352.gf09ad66450-goog
> >
>
> --
> Kees Cook



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
