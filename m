Date: Thu, 11 Jan 2018 11:06:56 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
In-Reply-To: <1515636190-24061-3-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.20.1801111101420.6443@nuc-kabylake>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org> <1515636190-24061-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 02/38] usercopy: Enhance and rename report_usercopy()
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, David Windsor <dave@nullcore.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 10 Jan 2018, Kees Cook wrote:

> diff --git a/mm/slab.h b/mm/slab.h
> index ad657ffa44e5..7d29e69ac310 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -526,4 +526,10 @@ static inline int cache_random_seq_create(struct kmem_cache *cachep,
>  static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
>  #endif /* CONFIG_SLAB_FREELIST_RANDOM */
>
> +#ifdef CONFIG_HARDENED_USERCOPY
> +void __noreturn usercopy_abort(const char *name, const char *detail,
> +			       bool to_user, unsigned long offset,
> +			       unsigned long len);
> +#endif
> +
>  #endif /* MM_SLAB_H */

This code has nothing to do with slab allocation. Move it into
include/linux/uaccess.h where the other user space access definitions are?
