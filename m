Date: Fri, 26 Jan 2018 23:31:01 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <alpine.LRH.2.00.1801262259300.27010@gjva.wvxbf.pm>
Message-ID: <alpine.LRH.2.00.1801262330200.27010@gjva.wvxbf.pm>
References: <20180117055015.GA15256@beast> <alpine.LRH.2.00.1801262259300.27010@gjva.wvxbf.pm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] fork: Allow stack to be wiped on fork
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Sahara <keun-o.park@darkmatter.ae>, "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Jan 2018, Jiri Kosina wrote:

> > diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> > index 34f053a150a9..091f53fe31cc 100644
> > --- a/include/linux/thread_info.h
> > +++ b/include/linux/thread_info.h
> > @@ -43,7 +43,9 @@ enum {
> >  #define THREAD_ALIGN	THREAD_SIZE
> >  #endif
> >  
> > -#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)
> > +#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || \
> > +    IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) || \
> > +    IS_ENABLED(CONFIG_CLEAR_STACK_FORK)
> >  # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
> >  #else
> >  # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 2295fc69717f..215b1ce2b2cd 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -215,7 +215,7 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
> >  		if (!s)
> >  			continue;
> >  
> > -#ifdef CONFIG_DEBUG_KMEMLEAK
> > +#if IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) || IS_ENABLED(CONFIG_CLEAR_STACK_FORK)
> >  		/* Clear stale pointers from reused stack. */
> >  		memset(s->addr, 0, THREAD_SIZE);
> >  #endif
> 
> Is there any good reason not to do it symmetricaly also for non-vmapped 
> stacks? (by passing __GFP_ZERO to alloc_pages_node())?

Ah, of course you already do by extending THREADINFO_GFP, sorry for the 
noise.

-- 
Jiri Kosina
