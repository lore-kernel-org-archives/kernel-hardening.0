Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-2-glider@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <a0b69045-f6c4-0290-1c59-4dd75b05ee25@intel.com>
Date: Tue, 23 Apr 2019 13:36:28 -0700
MIME-Version: 1.0
In-Reply-To: <20190418154208.131118-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> +static void poison_dont(struct kmem_cache *c, void *object)
> +{
> +	/* Do nothing. Use for caches with constructors. */
> +}
> +
>  static struct kmem_cache *create_cache(const char *name,
>  		unsigned int object_size, unsigned int align,
>  		slab_flags_t flags, unsigned int useroffset,
> @@ -381,6 +391,10 @@ static struct kmem_cache *create_cache(const char *name,
>  	s->size = s->object_size = object_size;
>  	s->align = align;
>  	s->ctor = ctor;
> +	if (ctor)
> +		s->poison_fn = poison_dont;
> +	else
> +		s->poison_fn = poison_zero;
>  	s->useroffset = useroffset;
>  	s->usersize = usersize;
>  
> @@ -974,6 +988,7 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name,
>  	s->align = calculate_alignment(flags, ARCH_KMALLOC_MINALIGN, size);
>  	s->useroffset = useroffset;
>  	s->usersize = usersize;
> +	s->poison_fn = poison_zero;

An empty indirect call is probably a pretty bad idea on systems with
retpoline.  Isn't this just a bool anyway for either calling poison_dont
or poison_zero?  Can it call anything else?
