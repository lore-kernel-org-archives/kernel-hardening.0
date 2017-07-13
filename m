Date: Thu, 13 Jul 2017 12:26:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170713112639.GE26194@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-3-git-send-email-mark.rutland@arm.com>
 <596748FB.20902@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <596748FB.20902@arm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 2/6] arm64: avoid open-coding THREAD_SIZE{,_ORDER}
To: James Morse <james.morse@arm.com>
Cc: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 13, 2017 at 11:18:35AM +0100, James Morse wrote:
> Hi Mark,
> 
> On 12/07/17 23:32, Mark Rutland wrote:
> > Currently we define THREAD_SIZE_ORDER dependent on which arm64-specific
> > page size kconfig symbol was selected. This is unfortunate, as it hides
> > the relationship between THREAD_SIZE_ORDER and THREAD_SIZE, and makes it
> > painful more painful than necessary to modify the thread size as we will
> > need to do for some debug configurations.
> > 
> > This patch follows arch/metag's approach of consistently defining
> > THREAD_SIZE in terms of THREAD_SIZE_ORDER. This avoids having ifdefs for
> > particular page size configurations, and allows us to change a single
> > definition to change the thread size.
> 
> I think this has unintended side effects for 64K page systems.  (or at least not
> yet intended)
> 
> Today:
> > #ifdef CONFIG_ARM64_4K_PAGES
> > #define THREAD_SIZE_ORDER	2
> > #elif defined(CONFIG_ARM64_16K_PAGES)
> > #define THREAD_SIZE_ORDER	0
> > #endif
> 
> Means THREAD_SIZE_ORDER is unset on 64K, and THREAD_SIZE is always:
> > #define THREAD_SIZE		16384
> 
> /kernel/fork.c matches this with its:
> > # if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
> [...]
> > #else
> [...]
> > void thread_stack_cache_init(void)
> > {
> >	thread_stack_cache = kmem_cache_create("thread_stack", THREAD_SIZE,
> > 					      THREAD_SIZE, 0, NULL);
> > 	BUG_ON(thread_stack_cache == NULL);
> > }
> > #endif
> 
> To create a kmemcache to share 64K pages as 16K stacks.
> 
> 
> After this patch:
> > #define THREAD_SHIFT		14
> >
> > #if THREAD_SHIFT >= PAGE_SHIFT
> > #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
> > #else
> > #define THREAD_SIZE_ORDER	0
> > #endif
> 
> Means THREAD_SIZE_ORDER is 0, and:
> > #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
> 
> gives us a 64K THREAD_SIZE.

Yes; I'd gotten confused as to what I was doing here. Thanks for
spotting that.

I've folded this and the next patch, with the resultant logic being as
below, which I think fixes this.

Thanks,
Mark.

---->8----
#define MIN_THREAD_SHIFT	14

/*
 * Each VMAP stack is a separate VMALLOC allocation, which is at least
 * PAGE_SIZE.
 */
#if defined(CONFIG_VMAP_STACK) && (MIN_THREAD_SHIFT < PAGE_SHIFT)
#define THREAD_SHIFT		PAGE_SHIFT
#else
#define THREAD_SHIFT		MIN_THREAD_SHIFT
#endif

#if THREAD_SHIFT >= PAGE_SHIFT
#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
#endif

#define THREAD_SIZE		(1UL << THREAD_SHIFT)
#define THREAD_START_SP		(THREAD_SIZE - 16)
