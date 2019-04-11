MIME-Version: 1.0
References: <20190410131726.250295-1-glider@google.com> <20190410131726.250295-3-glider@google.com>
 <CAGXu5jJt3uNWVXDD=GR6oVwn=g7O=Jcz9sxai5q10X9yyR56XA@mail.gmail.com>
In-Reply-To: <CAGXu5jJt3uNWVXDD=GR6oVwn=g7O=Jcz9sxai5q10X9yyR56XA@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 11 Apr 2019 10:39:20 +0200
Message-ID: <CAG_fn=Vkod40bxxP8PU-+zXs2u4arqAB_bYxqei1bb_tgsg8GA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 6:09 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Apr 10, 2019 at 6:18 AM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > This config option adds the possibility to initialize newly allocated
> > pages and heap objects with a 0xAA pattern.
> > There's already a number of places where allocations are initialized
> > based on the presence of __GFP_ZERO flag. We just change this code so
> > that under CONFIG_INIT_ALL_HEAP these allocations are always initialize=
d
> > with either 0x00 or 0xAA depending on the __GFP_ZERO.
>
> Why not just make __GFP_ZERO unconditional instead? This looks like
> it'd be simpler and not need arch-specific implementation?
Right, but it would mean we can only initialize with 0x00 pattern.
I believe that for testing purposes a nonzero pattern is better,
because it'll not only assure the execution is deterministic, but will
also uncover logic bugs earlier (see the discussion at
https://reviews.llvm.org/D54604?id=3D174471)
For hardening purposes the pattern shouldn't matter much.

If you think arch-specific code is too much of a trouble, we could
implement clear_page_pattern() using memset() on every architecture,
but allow the user to choose between slow (0xAA) and production (0x00)
modes.
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
