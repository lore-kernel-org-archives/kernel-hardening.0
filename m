MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-3-glider@google.com>
 <7bf6bd62-c8e0-df3d-8e98-70063f2d175a@intel.com>
In-Reply-To: <7bf6bd62-c8e0-df3d-8e98-70063f2d175a@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Apr 2019 12:14:36 -0700
Message-ID: <CAGXu5j+Lm0ba4ZQ91vZ8nZFvpJSxu_j_bEKMaa0NMsurmyZjjA@mail.gmail.com>
Subject: Re: [PATCH 2/3] gfp: mm: introduce __GFP_NOINIT
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 9:52 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index be84f5f95c97..f9d1f1236cd0 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -302,7 +302,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
> >  {
> >       struct page *pages;
> >
> > -     pages = alloc_pages(gfp_mask & ~__GFP_ZERO, order);
> > +     pages = alloc_pages((gfp_mask & ~__GFP_ZERO) | __GFP_NOINIT, order);
> >       if (pages) {
> >               unsigned int count, i;
>
> While this is probably not super security-sensitive, it's also not
> performance sensitive.

It is, however, a pretty clear case of "and then we immediately zero it".

> These sl*b ones seem like a bad idea.  We already have rules that sl*b
> allocations must be initialized by callers, and we have reasonably
> frequent bugs where the rules are broken.

Hm? No, this is saying that the page allocator can skip the auto-init
because the slab internals will be doing it later.

> Setting __GFP_NOINIT might be reasonable to do, though, for slabs that
> have a constructor.  We have much higher confidence that *those* are
> going to get initialized properly.

That's already handled in patch 1.

-- 
Kees Cook
