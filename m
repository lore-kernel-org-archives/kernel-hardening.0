Date: Thu, 16 May 2019 18:26:22 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905161824.63B0DF0E@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-2-glider@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> [...]
> diff --git a/mm/slab.h b/mm/slab.h
> index 43ac818b8592..24ae887359b8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -524,4 +524,20 @@ static inline int cache_random_seq_create(struct kmem_cache *cachep,
> [...]
> +static inline bool slab_want_init_on_free(struct kmem_cache *c)
> +{
> +	if (static_branch_unlikely(&init_on_free))
> +		return !(c->ctor);

BTW, why is this checking for c->ctor here? Shouldn't it not matter for
the free case?

> +	else
> +		return false;
> +}

-- 
Kees Cook
