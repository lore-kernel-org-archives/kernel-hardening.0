MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-3-glider@google.com>
 <CAK7LNARV+_RNE4E5H37e9wH6iPyrzqsLtcWd0wLSt+vsEvncRA@mail.gmail.com>
In-Reply-To: <CAK7LNARV+_RNE4E5H37e9wH6iPyrzqsLtcWd0wLSt+vsEvncRA@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Apr 2019 16:00:05 +0200
Message-ID: <CAG_fn=X1CJ6+1rHeHLUjJmXYPLbOL8_2sSrFBv+oxpMvw87ACg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 5, 2019 at 1:36 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Fri, Mar 8, 2019 at 10:27 PM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> > index 27aec394365e..5ce49663777a 100644
> > --- a/security/Kconfig.initmem
> > +++ b/security/Kconfig.initmem
> > @@ -13,6 +13,17 @@ config INIT_ALL_MEMORY
> >
> >  if INIT_ALL_MEMORY
> >
> > +config INIT_ALL_HEAP
> > +       bool "Initialize all heap"
> > +       depends on INIT_ALL_MEMORY
> > +       select CONFIG_PAGE_POISONING
> > +       select CONFIG_PAGE_POISONING_NO_SANITY
> > +       select CONFIG_PAGE_POISONING_ZERO
> > +       select CONFIG_SLUB_DEBUG
>
> This should like follows (no CONFIG_ prefix):
>
>          select PAGE_POISONING
>          select PAGE_POISONING_NO_SANITY
>          select PAGE_POISONING_ZERO
>          select SLUB_DEBUG
Thanks!
> But, again, this causes unmet dependency if SLUB=3Dn
          select SLUB_DEBUG if SLUB
seems to help. Guess it's better than making CONFIG_INIT_ALL_HEAP
depend on SLUB.
>
>
>
>
> > +       default y
> > +       help
> > +         Enable page poisoning and slub poisoning by default.
> > +
> >  config INIT_ALL_STACK
> >         bool "Initialize all stack"
> >         depends on INIT_ALL_MEMORY
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
