Date: Thu, 16 May 2019 09:53:01 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905160923.BD3E530EFC@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-5-glider@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> Add sock_alloc_send_pskb_noinit(), which is similar to
> sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> This helps reduce the slowdown on hackbench in the init_on_alloc mode
> from 6.84% to 3.45%.

Out of curiosity, why the creation of the new function over adding a
gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
are only 6 callers, and this change already updates 2 of those.)

> Slowdown for the initialization features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

In the commit log it might be worth mentioning that this is only
changing the init_on_alloc case (in case it's not already obvious to
folks). Perhaps there needs to be a split of __GFP_NO_AUTOINIT into
__GFP_NO_AUTO_ALLOC_INIT and __GFP_NO_AUTO_FREE_INIT? Right now __GFP_NO_AUTOINIT is only checked for init_on_alloc:

static inline bool want_init_on_alloc(gfp_t flags)
{
        if (static_branch_unlikely(&init_on_alloc))
                return !(flags & __GFP_NO_AUTOINIT);
        return flags & __GFP_ZERO;
}
...
static inline bool want_init_on_free(void)
{
        return static_branch_unlikely(&init_on_free);
}

On a related note, it might be nice to add an exclusion list to
the kmem_cache_create() cases, since it seems likely that further
tuning will be needed there. For example, with the init_on_free-similar
PAX_MEMORY_SANITIZE changes in the last public release of PaX/grsecurity,
the following were excluded from wipe-on-free:

	buffer_head
	names_cache
	mm_struct
	vm_area_struct
	anon_vma
	anon_vma_chain
	skbuff_head_cache
	skbuff_fclone_cache

Adding these and others (with details on why they were selected),
might improve init_on_free performance further without trading too
much coverage.

Having a kernel param with a comma-separated list of cache names and
the logic to add __GFP_NO_AUTOINIT at creation time would be a nice
(and cheap!) debug feature to let folks tune things for their specific
workloads, if they choose to. (And it could maybe also know what "none"
meant, to actually remove the built-in exclusions, similar to what
PaX's "pax_sanitize_slab=full" does.)

-- 
Kees Cook
