MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-2-glider@google.com>
 <201905161824.63B0DF0E@keescook>
In-Reply-To: <201905161824.63B0DF0E@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 16:38:51 +0200
Message-ID: <CAG_fn=U-8XiBVRDhr9QxLj0Yj+1ud41KvmUqEt9Gih9MAznuPw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 3:26 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> > [...]
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 43ac818b8592..24ae887359b8 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -524,4 +524,20 @@ static inline int cache_random_seq_create(struct k=
mem_cache *cachep,
> > [...]
> > +static inline bool slab_want_init_on_free(struct kmem_cache *c)
> > +{
> > +     if (static_branch_unlikely(&init_on_free))
> > +             return !(c->ctor);
>
> BTW, why is this checking for c->ctor here? Shouldn't it not matter for
> the free case?
It does matter, see e.g. the handling of __OBJECT_POISON in slub.c
If we just return true here, the kernel crashes.
> > +     else
> > +             return false;
> > +}
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
