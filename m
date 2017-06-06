From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170605192216.21596-1-igor.stoppa@huawei.com>
	<20170605192216.21596-3-igor.stoppa@huawei.com>
	<201706060444.v564iWds024768@www262.sakura.ne.jp>
	<a4ef229f-0dce-fa15-117b-2c7e904be7e7@huawei.com>
In-Reply-To: <a4ef229f-0dce-fa15-117b-2c7e904be7e7@huawei.com>
Message-Id: <201706062108.JDD17143.MOQFFVtHLJOFOS@I-love.SAKURA.ne.jp>
Date: Tue, 6 Jun 2017 21:08:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH 2/5] Protectable Memory Allocator
To: igor.stoppa@huawei.com
Cc: keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Igor Stoppa wrote:
> >> +struct pmalloc_node {
> >> +	struct hlist_node nodes_list;
> >> +	atomic_t used_words;
> >> +	unsigned int total_words;
> >> +	__PMALLOC_ALIGNED align_t data[];
> >> +};
> >
> > Is this __PMALLOC_ALIGNED needed? Why not use "long" and "BITS_PER_LONG" ?
> 
> In an earlier version I actually asked the same question.
> It is currently there because I just don't know enough about various
> architectures. The idea of having "align_t" was that it could be tied
> into what is the most desirable alignment for each architecture.
> But I'm actually looking for advise on this.

I think that let the compiler use natural alignment is OK.



> > You need to check for node != NULL before dereference it.
> 
> So, if I understood correctly, there shouldn't be a case where node is
> NULL, right?
> Unless it has been tampered/damaged. Is that what you mean?

I meant to say

+	node = __pmalloc_create_node(req_words);
// this location.
+	starting_word = atomic_fetch_add(req_words, &node->used_words);



> >> +const char *__pmalloc_check_object(const void *ptr, unsigned long n)
> >> +{
> >> +	unsigned long p;
> >> +
> >> +	p = (unsigned long)ptr;
> >> +	n += (unsigned long)ptr;
> >> +	for (; (PAGE_MASK & p) <= (PAGE_MASK & n); p += PAGE_SIZE) {
> >> +		if (is_vmalloc_addr((void *)p)) {
> >> +			struct page *page;
> >> +
> >> +			page = vmalloc_to_page((void *)p);
> >> +			if (!(page && PagePmalloc(page)))
> >> +				return msg;
> >> +		}
> >> +	}
> >> +	return NULL;
> >> +}
> > 
> > I feel that n is off-by-one if (ptr + n) % PAGE_SIZE == 0
> > according to check_page_span().
> 
> It seems to work. If I am missing your point, could you please
> use the same format of the example I made, to explain me?

If ptr == NULL and n == PAGE_SIZE so that (ptr + n) % PAGE_SIZE == 0,
this loop will access two pages (one page containing p == 0 and another
page containing p == PAGE_SIZE) when this loop should access only one
page containing p == 0. When checking n bytes, it's range is 0 to n - 1.
