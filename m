MIME-Version: 1.0
References: <20190408170418.148554-1-glider@google.com> <20190408170418.148554-3-glider@google.com>
 <20190409093234.GB21979@lakrids.cambridge.arm.com>
In-Reply-To: <20190409093234.GB21979@lakrids.cambridge.arm.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 9 Apr 2019 11:53:44 +0200
Message-ID: <CAG_fn=V3Kvr_0fnzyFuhOMEnUgW+aM792sJ0rHr7Y-Tz0Yqn-A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 9, 2019 at 11:32 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Mon, Apr 08, 2019 at 07:04:18PM +0200, Alexander Potapenko wrote:
> > This config option enables CONFIG_SLUB_DEBUG and CONFIG_PAGE_POISONING
> > without the need to pass any boot parameters.
> >
> > No performance optimizations are done at the moment to reduce double
> > initialization of memory regions.
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
> >  v3:
> >   - addressed comments by Masahiro Yamada (Kconfig fixes)
> > ---
> >  mm/page_poison.c         |  5 +++++
> >  mm/slub.c                |  2 ++
> >  security/Kconfig.initmem | 11 +++++++++++
> >  3 files changed, 18 insertions(+)
> >
> > diff --git a/mm/page_poison.c b/mm/page_poison.c
> > index 21d4f97cb49b..a1985f33f635 100644
> > --- a/mm/page_poison.c
> > +++ b/mm/page_poison.c
> > @@ -12,9 +12,14 @@ static bool want_page_poisoning __read_mostly;
> >
> >  static int __init early_page_poison_param(char *buf)
> >  {
> > +#ifdef CONFIG_INIT_ALL_HEAP
> > +     want_page_poisoning =3D true;
> > +     return 0;
> > +#else
> >       if (!buf)
> >               return -EINVAL;
> >       return strtobool(buf, &want_page_poisoning);
> > +#endif
> >  }
> >  early_param("page_poison", early_page_poison_param);
>
> IIUC this is only called if page_poison is passed on the command line,
> so want_page_poisoning won't be set automatically unless that's passed.
>
> Presumably you want to initialize it at definition with:
>
> static bool want_page_poisoning __read_mostly =3D IS_ENABLED(CONFIG_INIT_=
ALL_HEAP);
Yes, I've misunderstood how boot parameters work.
Thanks for the suggestions!
We'd better look into wiping allocations without POISON_SLAB though.
> with:
>
> #ifndef CONFIG_INIT_ALL_HEAP
> static int __init early_page_poison_param(char *buf)
> {
>         ...
> }
> early_param("page_poison", early_page_poison_param);
> #endif
>
> ... so that it can't be disabled?
>
> Thanks,
> Mark.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
