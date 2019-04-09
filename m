MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-3-glider@google.com>
 <497b1201-b2ae-5e0c-d191-ff1830d92fc1@redhat.com> <CAGXu5jJUWKiyW-_ygHpg9rJc7wQ2XTzjH71CtJfdefLu2zZHEg@mail.gmail.com>
In-Reply-To: <CAGXu5jJUWKiyW-_ygHpg9rJc7wQ2XTzjH71CtJfdefLu2zZHEg@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 9 Apr 2019 10:55:27 +0200
Message-ID: <CAG_fn=WGOCsHZ4stECA9nUBUMCL9SA76QKTy3FifLxmTfsQivg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 8, 2019 at 7:14 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Apr 8, 2019 at 9:43 AM Laura Abbott <labbott@redhat.com> wrote:
> > I've looked at doing something similar in the past (failing to find
> > the thread this morning...) and while this will work, it has pretty
> > serious performance issues. It's not actually the poisoning which
> > is expensive but that turning on debugging removes the cpu slab
> > which has significant performance penalties.
> >
> > I'd rather go back to the proposal of just poisoning the slab
> > at alloc/free without using SLAB_POISON.
>
> I still agree this would make the most sense. Fundamentally it's not a
> debugging feature.
Wasn't it you who suggested using SLAB_POISON in the first round of comment=
s? :)

I actually have a working implementation that piggybacks on existing
__GFP_ZERO code to initialize page_alloc() and SLUB allocations:
https://github.com/google/kmsan/commit/4907af529ad525378a0728435c96d3812f71=
e594
https://github.com/google/kmsan/commit/69618a9668bcf27700cc5da42eebf8ab50d1=
f56a

I'd better cook a patch based on that.

There's also some overhead when allocations are initialized twice (in
page_alloc() and kmalloc()) or thrice (page_alloc(), kmalloc() and
e.g. sock_alloc_send_pskb())
We can introduce another GFP flag explicitly telling the allocator to
not initialize the memory chunk if we know it'll be initialized by a
higher level allocator
(something along the lines of
https://github.com/google/kmsan/commit/4fc8cff79d868c29688c8a4186e504fda362=
f6fd)
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
