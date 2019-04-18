MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-3-glider@google.com>
 <497b1201-b2ae-5e0c-d191-ff1830d92fc1@redhat.com>
In-Reply-To: <497b1201-b2ae-5e0c-d191-ff1830d92fc1@redhat.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 18 Apr 2019 15:02:46 +0200
Message-ID: <CAG_fn=WhBxSLkD3BdTP3Z72B7mGkegezwkjyMjmY7oVjb+kVWw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Laura Abbott <labbott@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 8, 2019 at 6:43 PM Laura Abbott <labbott@redhat.com> wrote:
>
> On 3/8/19 5:27 AM, Alexander Potapenko wrote:
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
> >   mm/page_poison.c         |  5 +++++
> >   mm/slub.c                |  2 ++
> >   security/Kconfig.initmem | 11 +++++++++++
> >   3 files changed, 18 insertions(+)
> >
> > diff --git a/mm/page_poison.c b/mm/page_poison.c
> > index 21d4f97cb49b..a1985f33f635 100644
> > --- a/mm/page_poison.c
> > +++ b/mm/page_poison.c
> > @@ -12,9 +12,14 @@ static bool want_page_poisoning __read_mostly;
> >
> >   static int __init early_page_poison_param(char *buf)
> >   {
> > +#ifdef CONFIG_INIT_ALL_HEAP
> > +     want_page_poisoning =3D true;
> > +     return 0;
> > +#else
> >       if (!buf)
> >               return -EINVAL;
> >       return strtobool(buf, &want_page_poisoning);
> > +#endif
> >   }
> >   early_param("page_poison", early_page_poison_param);
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 1b08fbcb7e61..00e0197d3f35 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1287,6 +1287,8 @@ static int __init setup_slub_debug(char *str)
> >       if (*str =3D=3D ',')
> >               slub_debug_slabs =3D str + 1;
> >   out:
> > +     if (IS_ENABLED(CONFIG_INIT_ALL_HEAP))
> > +             slub_debug |=3D SLAB_POISON;
> >       return 1;
> >   }
> >
>
> I've looked at doing something similar in the past (failing to find
> the thread this morning...) and while this will work, it has pretty
> serious performance issues. It's not actually the poisoning which
> is expensive but that turning on debugging removes the cpu slab
> which has significant performance penalties.
>
> I'd rather go back to the proposal of just poisoning the slab
> at alloc/free without using SLAB_POISON.
Hi Laura,

May I wonder what were the performance numbers you were seeing?
I've found this patch:
https://www.openwall.com/lists/kernel-hardening/2016/01/26/1, but
that's around 100% slowdown.
> Thanks,
> Laura
>
>
> > diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> > index 27aec394365e..5ce49663777a 100644
> > --- a/security/Kconfig.initmem
> > +++ b/security/Kconfig.initmem
> > @@ -13,6 +13,17 @@ config INIT_ALL_MEMORY
> >
> >   if INIT_ALL_MEMORY
> >
> > +config INIT_ALL_HEAP
> > +     bool "Initialize all heap"
> > +     depends on INIT_ALL_MEMORY
> > +     select CONFIG_PAGE_POISONING
> > +     select CONFIG_PAGE_POISONING_NO_SANITY
> > +     select CONFIG_PAGE_POISONING_ZERO
> > +     select CONFIG_SLUB_DEBUG
> > +     default y
> > +     help
> > +       Enable page poisoning and slub poisoning by default.
> > +
> >   config INIT_ALL_STACK
> >       bool "Initialize all stack"
> >       depends on INIT_ALL_MEMORY
> >
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
