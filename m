Date: Mon, 5 Jun 2017 23:25:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170606062505.GA18315@infradead.org>
References: <20170605192216.21596-1-igor.stoppa@huawei.com>
 <20170605192216.21596-3-igor.stoppa@huawei.com>
 <201706060444.v564iWds024768@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201706060444.v564iWds024768@www262.sakura.ne.jp>
Subject: [kernel-hardening] Re: [PATCH 2/5] Protectable Memory Allocator
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 01:44:32PM +0900, Tetsuo Handa wrote:
> Igor Stoppa wrote:
> > +int pmalloc_protect_pool(struct pmalloc_pool *pool)
> > +{
> > +	struct pmalloc_node *node;
> > +
> > +	if (!pool)
> > +		return -EINVAL;
> > +	mutex_lock(&pool->nodes_list_mutex);
> > +	hlist_for_each_entry(node, &pool->nodes_list_head, nodes_list) {
> > +		unsigned long size, pages;
> > +
> > +		size = WORD_SIZE * node->total_words + HEADER_SIZE;
> > +		pages = size / PAGE_SIZE;
> > +		set_memory_ro((unsigned long)node, pages);
> > +	}
> > +	pool->protected = true;
> > +	mutex_unlock(&pool->nodes_list_mutex);
> > +	return 0;
> > +}
> 
> As far as I know, not all CONFIG_MMU=y architectures provide
> set_memory_ro()/set_memory_rw(). You need to provide fallback for
> architectures which do not provide set_memory_ro()/set_memory_rw()
> or kernels built with CONFIG_MMU=n.

I think we'll just need to generalize CONFIG_STRICT_MODULE_RWX and/or
ARCH_HAS_STRICT_MODULE_RWX so there is a symbol to key this off.
