Date: Thu, 20 Jun 2019 18:37:30 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906201821.8887E75@keescook>
References: <20190606164845.179427-1-glider@google.com>
 <20190606164845.179427-2-glider@google.com>
 <201906070841.4680E54@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906070841.4680E54@keescook>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 07, 2019 at 08:42:27AM -0700, Kees Cook wrote:
> On Thu, Jun 06, 2019 at 06:48:43PM +0200, Alexander Potapenko wrote:
> > [...]
> > diff --git a/mm/slub.c b/mm/slub.c
> > index cd04dbd2b5d0..9c4a8b9a955c 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > [...]
> > @@ -2741,8 +2758,14 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
> >  		prefetch_freepointer(s, next_object);
> >  		stat(s, ALLOC_FASTPATH);
> >  	}
> > +	/*
> > +	 * If the object has been wiped upon free, make sure it's fully
> > +	 * initialized by zeroing out freelist pointer.
> > +	 */
> > +	if (unlikely(slab_want_init_on_free(s)) && object)
> > +		*(void **)object = NULL;

In looking at metadata again, I noticed that I don't think this is
correct, as it needs to be using s->offset to find the location of the
freelist pointer:

	memset(object + s->offset, 0, sizeof(void *));

> >  
> > -	if (unlikely(gfpflags & __GFP_ZERO) && object)
> > +	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
> >  		memset(object, 0, s->object_size);

init_on_alloc is using "object_size" but init_on_free is using "size". I
assume the "alloc" wipe is smaller because metadata was just written
for the allocation?

-- 
Kees Cook
