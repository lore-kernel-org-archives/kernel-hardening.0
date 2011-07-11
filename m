Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 11 Jul 2011 22:56:35 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110711185635.GA2072@albatros>
References: <20110612130953.GA3709@albatros>
 <20110706173631.GA5431@albatros>
 <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
 <20110706185932.GB3299@albatros>
 <20110711165900.GA14319@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711165900.GA14319@openwall.com>
Subject: Re: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Mon, Jul 11, 2011 at 20:59 +0400, Solar Designer wrote:
> On Wed, Jul 06, 2011 at 10:59:32PM +0400, Vasiliy Kulikov wrote:
> > On Wed, Jul 06, 2011 at 11:01 -0700, Linus Torvalds wrote:
> > > My reaction is: "let's just remote the crazy check from set_user()
> > > entirely".
> > 
> > Honestly, I didn't expect such a positive reaction from you in the first
> > reply :)
> 
> After this is taken care of, please also consider other ways set*id()
> syscalls might fail on errors unrelated to the process possessing
> appropriate privileges.  IIRC, set_user() could also fail when it's not
> able to allocate an instance of "struct user" - unlikely, but possible.
> I think the process must be killed on those errors.  There's no better
> action to take on them.

As Spender has noticed, small allocations may not fail, they are forced
to use __GFP_NOFAIL.


/*
 * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
 * costly to service.  That is between allocation orders which should
 * coelesce naturally under reasonable reclaim pressure and those which
 * will not.
 */
#define PAGE_ALLOC_COSTLY_ORDER 3

int should_alloc_retry() {

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

So, all these allocations are fail-safe.  I see no reasons to fail for
these privilege dropping functions.

Thanks,

-- 
Vasiliy
