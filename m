MIME-Version: 1.0
References: <20190606164845.179427-1-glider@google.com> <20190606164845.179427-2-glider@google.com>
 <201906070841.4680E54@keescook> <201906201821.8887E75@keescook>
In-Reply-To: <201906201821.8887E75@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 25 Jun 2019 17:42:45 +0200
Message-ID: <CAG_fn=VceGkQPuJ45ffmy-9rRdx515z10N97FApeZR9YrXSHVA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 21, 2019 at 3:37 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Jun 07, 2019 at 08:42:27AM -0700, Kees Cook wrote:
> > On Thu, Jun 06, 2019 at 06:48:43PM +0200, Alexander Potapenko wrote:
> > > [...]
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index cd04dbd2b5d0..9c4a8b9a955c 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > [...]
> > > @@ -2741,8 +2758,14 @@ static __always_inline void *slab_alloc_node(s=
truct kmem_cache *s,
> > >             prefetch_freepointer(s, next_object);
> > >             stat(s, ALLOC_FASTPATH);
> > >     }
> > > +   /*
> > > +    * If the object has been wiped upon free, make sure it's fully
> > > +    * initialized by zeroing out freelist pointer.
> > > +    */
> > > +   if (unlikely(slab_want_init_on_free(s)) && object)
> > > +           *(void **)object =3D NULL;
>
> In looking at metadata again, I noticed that I don't think this is
> correct, as it needs to be using s->offset to find the location of the
> freelist pointer:
>
>         memset(object + s->offset, 0, sizeof(void *));
In the cases we support s->offset is always zero (we don't initialize
slabs with ctors or RCU), but using its value is a sane
generalization.

> > >
> > > -   if (unlikely(gfpflags & __GFP_ZERO) && object)
> > > +   if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
> > >             memset(object, 0, s->object_size);
>
> init_on_alloc is using "object_size" but init_on_free is using "size". I
> assume the "alloc" wipe is smaller because metadata was just written
> for the allocation?
As noted in another thread, using "size" is incorrect, because it may
overwrite the redzone after the object.
I'll send a patch to fix that.
Overwriting the metadata indeed shouldn't make sense in the allocation case=
.
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
