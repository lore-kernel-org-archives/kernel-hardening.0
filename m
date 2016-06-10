Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160610154403.1d906134@annuminas.surriel.com>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
 <20160609193927.2f03f128@annuminas.surriel.com> <20160610154403.1d906134@annuminas.surriel.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Jun 2016 13:46:56 -0700
Message-ID: <CAGXu5jLhs67eRhkcJRf+vZc9=ruBcVc2Rb7xSUZZV-Szrm6YfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH v2 6/4] mm: disallow user copy to/from separately
 allocated pages
To: Rik van Riel <riel@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 10, 2016 at 12:44 PM, Rik van Riel <riel@redhat.com> wrote:
> v2 of yesterday's patch, this one seems to completely work on my
> system, after taking _bdata & _edata into account.
>
> I am still looking into CMA, but am leaning towards doing that as
> a follow-up patch.

Cool. It looks like this is slowly changing to more of a whitelist
than a blacklist, which I think would be a welcome improvement if it's
feasible. That way we don't need an explicit check for kernel text, it
would already be outside the allowed areas.

-Kees

>
> ---8<---
>
> Subject: mm: disallow user copy to/from separately allocated pages
>
> A single copy_from_user or copy_to_user should go to or from a single
> kernel object. Inside the slab, or on the stack, we can track the
> individual objects.
>
> For the general kernel heap, we do not know exactly where each object
> is, but we can tell whether the whole range from ptr to ptr + n is
> inside the same page, or inside the same compound page.
>
> If the start and end of the "object" are in pages that were not allocated
> together, we are likely dealing with an overflow from one object into
> the next page, and should disallow this copy.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> v2:
>  - also test against _bdata & _edata, this appears to be necessary for
>    some kernfs/sysfs stuff
>  - clean up the code a little bit
>
>  mm/usercopy.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index e09c33070759..78869ea73194 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -109,7 +109,8 @@ static inline bool check_kernel_text_object(const void *ptr, unsigned long n)
>
>  static inline const char *check_heap_object(const void *ptr, unsigned long n)
>  {
> -       struct page *page;
> +       struct page *page, *endpage;
> +       const void *end = ptr + n - 1;
>
>         if (ZERO_OR_NULL_PTR(ptr))
>                 return "<null>";
> @@ -118,11 +119,29 @@ static inline const char *check_heap_object(const void *ptr, unsigned long n)
>                 return NULL;
>
>         page = virt_to_head_page(ptr);
> -       if (!PageSlab(page))
> +       if (PageSlab(page))
> +               /* Check allocator for flags and size. */
> +               return __check_heap_object(ptr, n, page);
> +
> +       /* Is the object wholly within one base page? */
> +       if (likely(((unsigned long)ptr & (unsigned long)PAGE_MASK) ==
> +                  ((unsigned long)end & (unsigned long)PAGE_MASK)))
> +               return NULL;
> +
> +       /* Are the start and end inside the same compound page? */
> +       endpage = virt_to_head_page(end);
> +       if (likely(endpage == page))
> +               return NULL;
> +
> +       /* Is this a special area, eg. .rodata, .bss, or device memory? */
> +       if (ptr >= (const void *)_sdata && end <= (const void *)_edata)
> +               return NULL;
> +
> +       if (PageReserved(page) && PageReserved(endpage))
>                 return NULL;
>
> -       /* Check allocator for flags and size. */
> -       return __check_heap_object(ptr, n, page);
> +       /* Uh oh. The "object" spans several independently allocated pages. */
> +       return "<spans multiple pages>";
>  }
>
>  /*



-- 
Kees Cook
Chrome OS & Brillo Security
