MIME-Version: 1.0
References: <20190408170418.148554-1-glider@google.com> <20190408170418.148554-2-glider@google.com>
 <CAK7LNAS3+FKpgBvvxKDukD1xcHUZ1o3TsE1BjjVq5P13MrO7Fw@mail.gmail.com> <CAG_fn=WbvdqsXOr-TKY4kiw2Fd7zfbd5McgC2DEFvJwM7CR3sQ@mail.gmail.com>
In-Reply-To: <CAG_fn=WbvdqsXOr-TKY4kiw2Fd7zfbd5McgC2DEFvJwM7CR3sQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 9 Apr 2019 11:03:56 +0200
Message-ID: <CAG_fn=XuFehu_7gGmsfiNxhR9ttMA2v+PwJ5T32dcdgQUqAkFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 9, 2019 at 11:02 AM Alexander Potapenko <glider@google.com> wro=
te:
>
> On Tue, Apr 9, 2019 at 10:38 AM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Tue, Apr 9, 2019 at 2:04 AM Alexander Potapenko <glider@google.com> =
wrote:
> > >
> > > CONFIG_INIT_ALL_MEMORY is going to be an umbrella config for options
> > > that force heap and stack initialization.
> > > The rationale behind doing so is to reduce the severity of bugs cause=
d
> > > by using uninitialized memory.
> > >
> > > CONFIG_INIT_ALL_STACK turns on stack initialization based on
> > > -ftrivial-auto-var-init in Clang builds and on
> > > -fplugin-arg-structleak_plugin-byref-all in GCC builds.
> > >
> > > -ftrivial-auto-var-init is a Clang flag that provides trivial
> > > initializers for uninitialized local variables, variable fields and
> > > padding.
> > >
> > > It has three possible values:
> > >   pattern - uninitialized locals are filled with a fixed pattern
> > >     (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D5=
4604
> > >     for more details) likely to cause crashes when uninitialized valu=
e is
> > >     used;
> > >   zero (it's still debated whether this flag makes it to the official
> > >     Clang release) - uninitialized locals are filled with zeroes;
> > >   uninitialized (default) - uninitialized locals are left intact.
> > >
> > > The proposed config builds the kernel with
> > > -ftrivial-auto-var-init=3Dpattern.
> > >
> > > Developers have the possibility to opt-out of this feature on a
> > > per-variable basis by using __attribute__((uninitialized)).
> > >
> > > For GCC builds, CONFIG_INIT_ALL_STACK is simply wired up to
> > > CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL. No opt-out is possible at the
> > > moment.
> > >
> > > Signed-off-by: Alexander Potapenko <glider@google.com>
> > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Cc: James Morris <jmorris@namei.org>
> > > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Kostya Serebryany <kcc@google.com>
> > > Cc: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Sandeep Patil <sspatil@android.com>
> > > Cc: linux-security-module@vger.kernel.org
> > > Cc: linux-kbuild@vger.kernel.org
> > > Cc: kernel-hardening@lists.openwall.com
> > > ---
> > >  v2:
> > >   - addressed Kees Cook's comments: added GCC support
> > >  v3: addressed Masahiro Yamada's comments:
> > >   - dropped per-file opt-out mechanism
> > >   - fixed GCC_PLUGINS dependencies
> > > ---
> > >  Makefile                 |  3 ++-
> > >  scripts/Makefile.initmem | 10 ++++++++++
> > >  security/Kconfig         |  1 +
> > >  security/Kconfig.initmem | 29 +++++++++++++++++++++++++++++
> > >  4 files changed, 42 insertions(+), 1 deletion(-)
> > >  create mode 100644 scripts/Makefile.initmem
> > >  create mode 100644 security/Kconfig.initmem
> > >
> > > diff --git a/Makefile b/Makefile
> > > index f070e0d65186..028ca37878fd 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -448,7 +448,7 @@ export HOSTCXX KBUILD_HOSTCXXFLAGS LDFLAGS_MODULE=
 CHECK CHECKFLAGS
> > >
> > >  export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUI=
LD_LDFLAGS
> > >  export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
> > > -export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN
> > > +export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN CFLAGS_INIT=
MEM
> > >  export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
> > >  export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODU=
LE
> > >  export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
> > > @@ -840,6 +840,7 @@ KBUILD_ARFLAGS :=3D $(call ar-option,D)
> > >  include scripts/Makefile.kasan
> > >  include scripts/Makefile.extrawarn
> > >  include scripts/Makefile.ubsan
> > > +include scripts/Makefile.initmem
> > >
> > >  # Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLA=
GS as the
> > >  # last assignments
> > > diff --git a/scripts/Makefile.initmem b/scripts/Makefile.initmem
> > > new file mode 100644
> > > index 000000000000..a6253d78fe35
> > > --- /dev/null
> > > +++ b/scripts/Makefile.initmem
> > > @@ -0,0 +1,10 @@
> > > +ifdef CONFIG_INIT_ALL_STACK
> > > +
> > > +# Clang's -ftrivial-auto-var-init=3Dpattern flag initializes the
> > > +# uninitialized parts of local variables (including fields and paddi=
ng)
> > > +# with a fixed pattern (0xAA in most cases).
> > > +ifdef CONFIG_CC_HAS_AUTO_VAR_INIT
> > > +  CFLAGS_INITMEM :=3D -ftrivial-auto-var-init=3Dpattern
> > > +endif
> > > +
> > > +endif
> >
> > Now that you dropped per-file control,
> > why is this necessary?
> > Also, CFLAGS_INITMEM is not wired up to anything,
> > so this patch has no effect.
> There's CFLAGS_INITMEM in the top Makefile, so I suppose it should be wor=
king.
Ah, now I see. Yes, I was too hasty with this patchset.
> But I agree there's no point in adding extra files for a single build fla=
g.
> >
> > I think you can add the following to top Makefile, and that's it.
> >
> > ifdef CONFIG_AUTO_VAR_INIT
> > KBUILD_CFLAGS +=3D -ftrivial-auto-var-init=3Dpattern
> > endif
> >
> >
> >
> >
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index e4fe2f3c2c65..cc12a39424dd 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -230,6 +230,7 @@ config STATIC_USERMODEHELPER_PATH
> > >           If you wish for all usermode helper programs to be disabled=
,
> > >           specify an empty string here (i.e. "").
> > >
> > > +source "security/Kconfig.initmem"
> > >  source "security/selinux/Kconfig"
> > >  source "security/smack/Kconfig"
> > >  source "security/tomoyo/Kconfig"
> > > diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> > > new file mode 100644
> > > index 000000000000..5e49a55382ad
> > > --- /dev/null
> > > +++ b/security/Kconfig.initmem
> > > @@ -0,0 +1,29 @@
> > > +menu "Initialize all memory"
> > > +
> > > +config CC_HAS_AUTO_VAR_INIT
> > > +       def_bool $(cc-option,-ftrivial-auto-var-init=3Dpattern)
> > > +
> > > +config INIT_ALL_MEMORY
> > > +       bool "Initialize all memory"
> > > +       default n
> > > +       help
> > > +         Enforce memory initialization to mitigate infoleaks and mak=
e
> > > +         the control-flow bugs depending on uninitialized values mor=
e
> > > +         deterministic.
> > > +
> > > +if INIT_ALL_MEMORY
> > > +
> > > +config INIT_ALL_STACK
> > > +       bool "Initialize all stack"
> > > +       depends on INIT_ALL_MEMORY
> > > +       depends on CC_HAS_AUTO_VAR_INIT || (HAVE_GCC_PLUGINS && PLUGI=
N_HOSTCC !=3D "")
> > > +       select GCC_PLUGINS if !CC_HAS_AUTO_VAR_INIT
> > > +       select GCC_PLUGIN_STRUCTLEAK if !CC_HAS_AUTO_VAR_INIT
> > > +       select GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if !CC_HAS_AUTO_VAR_IN=
IT
> > > +       default y
> > > +       help
> > > +         Initialize uninitialized stack data with a fixed pattern
> > > +         (0x00 in GCC, 0xAA in Clang).
> > > +
> >
> >
> > I am not sure about the benefit of these umbrella CONFIGs
> > since these make 'depends on' and 'select' complicated.
> > I will leave it to Kees, though.
> >
> >
> >
> > > +endif # INIT_ALL_MEMORY
> > > +endmenu
> > > --
> > > 2.21.0.392.gf8f6787159e-goog
> > >
> >
> >
> > --
> > Best Regards
> > Masahiro Yamada
>
>
>
> --
> Alexander Potapenko
> Software Engineer
>
> Google Germany GmbH
> Erika-Mann-Stra=C3=9Fe, 33
> 80636 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> Registergericht und -nummer: Hamburg, HRB 86891
> Sitz der Gesellschaft: Hamburg



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
