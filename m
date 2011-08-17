Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 17 Aug 2011 23:15:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110817191550.GA18554@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

As a follow up of setuid() subject - I'm thinking about such scheme of
making the kmalloc nofail allocation policy explicit.

Currently small allocations cannot fail:

static inline int
should_alloc_retry(gfp_t gfp_mask, unsigned int order,
				unsigned long pages_reclaimed)
{
    ...
	/*
	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
	 * means __GFP_NOFAIL, but that may not be true in other
	 * implementations.
	 */
	if (order <= PAGE_ALLOC_COSTLY_ORDER)
		return 1;
    ...
}

But this policy is not explicit and many core developers even don't know
about it.  Last year I sent many patches fixing missing kmalloc()
checks, which were actually redundant because of should_alloc_retry()
logic.  But I got *no* complains that kmalloc() cannot fail.  So, either
it doesn't really guaranteed or a few people know about it.

If the former, we should do something with set_user() error path and
similar places.

If the latter (which is likely case), I suggest this scheme:

For each structure, which is expected to be small, explicitly define
the expectation and use specialized function for the allocations.


In header.h:

struct some_struct {
    ...
};
MALLOC_CANNOT_FAIL(some_struct);

In .c:

struct some_struct *x = kmalloc_nofail(sizeof(some_struct *), GFP_KERNEL);
x->a = 12; /* no check x==NULL */


In generic .h:

#define MALLOC_CANNOT_FAIL(x) \
    BUILD_BUG_ON(sizeof(x) <= (1 << PAGE_ALLOC_COSTLY_ORDER))

static inline
void *kmalloc_nofail(size_t size, int flags)
{
    void *p;
    BUILD_BUG_ON(!__buildin_const_p(size));
    BUILD_BUG_ON(size > (1 << PAGE_ALLOC_COSTLY_ORDER));
    p = kmalloc(size, flags);
    BUG_ON(p == NULL);
    return p;
}


So, this code does 3 things:

1) explicitly exploits the property of nofail allocation for reducing
error handling code.

2) ensures that (1) works in runtime.

3) ensures that "occasional" future changes of allocated structure type
(or subfield types) don't cross NOFAIL size limits.


I'm not sure about 2 things:

1) whether BUG_ON(p == 0) is OK in sense of permormance.  As compared to
the current behaviour, the check is simply moved into kmalloc_nofail()
without any slowdown, but someone may say "hey, why then have _any_
runtime check at all?".

2) kmalloc_nofail() interface.  There was __NOFAIL flag for kmalloc(),
which was removed for some reasons.  So, it needs some investigation.


I expect to get positive feedback from LKML folks as it resolves some
nasty hardly debuggable bugs, which are quite often.


What do you think about it?

Thanks,

-- 
Vasiliy
