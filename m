Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 25 Oct 2016 12:11:06 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161025091106.4hawzkkz57q362p5@thigreal>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-14-git-send-email-elena.reshetova@intel.com>
 <20161025085655.GW19531@linaro.org>
 <1477386248.2263.9.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477386248.2263.9.camel@cvidal.org>
Subject: Re: [kernel-hardening] [RFC v2 PATCH 13/13] lkdtm: add tests for
 atomic over-/underflow
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 25, 2016 at 11:04:08AM +0200, Colin Vidal wrote:
> On Tue, 2016-10-25 at 17:56 +0900, AKASHI Takahiro wrote:
> > On Thu, Oct 20, 2016 at 01:25:31PM +0300, Elena Reshetova wrote:
> > > 
> > > From: Hans Liljestrand <ishkamiel@gmail.com>
> > > 
> > > This adds additional tests for modified atomic functions.
> > > 
> > > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > > ---
> > >  drivers/misc/lkdtm.h      |  17 +++++++
> > >  drivers/misc/lkdtm_bugs.c | 122 +++++++++++++++++++++++++++++++++++++++-------
> > >  drivers/misc/lkdtm_core.c |  17 +++++++
> > >  3 files changed, 138 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> > > index cfa1039..224713a 100644
> > > --- a/drivers/misc/lkdtm.h
> > > +++ b/drivers/misc/lkdtm.h
> > > @@ -20,7 +20,24 @@ void lkdtm_HARDLOCKUP(void);
> > >  void lkdtm_SPINLOCKUP(void);
> > >  void lkdtm_HUNG_TASK(void);
> > >  void lkdtm_ATOMIC_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_DEC_RETURN_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_SUB_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_SUB_RETURN_UNDERFLOW(void);
> > >  void lkdtm_ATOMIC_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_INC_RETURN_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_ADD_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_ADD_RETURN_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_ADD_UNLESS_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_INC_AND_TEST_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_DEC_RETURN_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_SUB_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_SUB_RETURN_UNDERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_INC_RETURN_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_ADD_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_ADD_RETURN_OVERFLOW(void);
> > > +void lkdtm_ATOMIC_LONG_SUB_AND_TEST(void);
> > >  void lkdtm_CORRUPT_LIST_ADD(void);
> > >  void lkdtm_CORRUPT_LIST_DEL(void);
> > >  
> > > diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> > > index f336206..bd79a88 100644
> > > --- a/drivers/misc/lkdtm_bugs.c
> > > +++ b/drivers/misc/lkdtm_bugs.c
> > > @@ -128,30 +128,116 @@ void lkdtm_HUNG_TASK(void)
> > >  	schedule();
> > >  }
> > >  
> > > -void lkdtm_ATOMIC_UNDERFLOW(void)
> > > -{
> > > -	atomic_t under = ATOMIC_INIT(INT_MIN);
> > > -
> > > -	pr_info("attempting good atomic increment\n");
> > > -	atomic_inc(&under);
> > > -	atomic_dec(&under);
> > > -
> > > -	pr_info("attempting bad atomic underflow\n");
> > > -	atomic_dec(&under);
> > > +#define ATOMIC_LKDTM_MIN(tag,fun) void lkdtm_ATOMIC_##tag(void)	\
> > > +{									\
> > > +	atomic_t atomic = ATOMIC_INIT(INT_MIN);				\
> > > +									\
> > > +	pr_info("attempting good atomic_" #fun "\n");			\
> > > +	atomic_inc(&atomic);						\
> > > +	TEST_FUNC(&atomic);						\
> > > +									\
> > > +	pr_info("attempting bad atomic_" #fun "\n");			\
> > > +	TEST_FUNC(&atomic);						\
> > >  }
> > >  
> > > -void lkdtm_ATOMIC_OVERFLOW(void)
> > > -{
> > > -	atomic_t over = ATOMIC_INIT(INT_MAX);
> > > +#define ATOMIC_LKDTM_MAX(tag,fun,...)					\
> > > +void lkdtm_ATOMIC_##tag(void)						\
> > > +{									\
> > > +	atomic_t atomic = ATOMIC_INIT(INT_MAX);				\
> > > +									\
> > > +	pr_info("attempting good atomic_" #fun "\n");			\
> > > +	atomic_dec(&atomic);						\
> > > +	TEST_FUNC(&atomic);						\
> > > +									\
> > > +	pr_info("attempting bad atomic_" #fun "\n");			\
> > > +	TEST_FUNC(&atomic);						\
> > > +}
> > >  
> > > -	pr_info("attempting good atomic decrement\n");
> > > -	atomic_dec(&over);
> > > -	atomic_inc(&over);
> > > +#define ATOMIC_LKDTM_LONG_MIN(tag,fun,...)				\
> > > +void lkdtm_ATOMIC_LONG_##tag(void)					\
> > > +{									\
> > > +	atomic_long_t atomic  = ATOMIC_LONG_INIT(LONG_MIN);		\
> > > +									\
> > > +	pr_info("attempting good atomic_long_" #fun "\n");		\
> > > +	atomic_long_inc(&atomic);					\
> > > +	TEST_FUNC(&atomic);						\
> > > +									\
> > > +	pr_info("attempting bad atomic_long_" #fun "\n");		\
> > > +	TEST_FUNC(&atomic);						\
> > > +}
> > >  
> > > -	pr_info("attempting bad atomic overflow\n");
> > > -	atomic_inc(&over);
> > > +#define ATOMIC_LKDTM_LONG_MAX(tag,fun,...)				\
> > > +void lkdtm_ATOMIC_LONG_##tag(void)					\
> > > +{									\
> > > +	atomic_long_t atomic = ATOMIC_LONG_INIT(LONG_MAX);		\
> > > +									\
> > > +	pr_info("attempting good atomic_long_" #fun "\n");		\
> > > +	atomic_long_dec(&atomic);					\
> > > +	TEST_FUNC(&atomic);						\
> > > +									\
> > > +	pr_info("attempting bad atomic_long_" #fun "\n");		\
> > > +	TEST_FUNC(&atomic);						\
> > >  }
> > >  
> > > +#define TEST_FUNC(x) atomic_dec(x)
> > > +ATOMIC_LKDTM_MIN(UNDERFLOW,dec)
> > > +#undef TEST_FUNC
> > > +#define TEST_FUNC(x) atomic_dec_return(x)
> > > +ATOMIC_LKDTM_MIN(DEC_RETURN_UNDERFLOW,dec_return);
> > > +#undef TEST_FUNC
> > > +#define TEST_FUNC(x) atomic_sub(1,x)
> > > +ATOMIC_LKDTM_MIN(SUB_UNDERFLOW,sub);
> > > +#undef TEST_FUNC
> > > +#define TEST_FUNC(x) atomic_sub_return(1,x);
> > > +ATOMIC_LKDTM_MIN(SUB_RETURN_UNDERFLOW,sub_return);
> > > +#undef TEST_FUNC
> > > +#define TEST_FUNC(x) atomic_inc(x);
> > > +ATOMIC_LKDTM_MAX(OVERFLOW,inc);
> > > +#undef TEST_FUNC
> > > +#define TEST_FUNC(x) atomic_inc_return(x);
> > > +ATOMIC_LKDTM_MAX(INC_RETURN_OVERFLOW,inc_return);
> > 
> > Please note that this definition causes a compiler warning:
> > /home/akashi/arm/armv8/linaro/linux-aarch64/drivers/misc/lkdtm_bugs.c: In function 'lkdtm_ATOMIC_INC_AND_TEST_OVERFLOW':
> > /home/akashi/arm/armv8/linaro/linux-aarch64/arch/arm64/include/asm/atomic.h:222:55: warning: value computed is not used [-Wunused-value]
> >  #define atomic_inc_and_test(v)  (atomic_inc_return(v) == 0)
> >                                                        ^
> > /home/akashi/arm/armv8/linaro/linux-aarch64/drivers/misc/lkdtm_bugs.c:204:22: note: in expansion of macro 'atomic_inc_and_test'
> >  #define TEST_FUNC(x) atomic_inc_and_test(x);
> > 
> 
> There is the same issue with arm.
> 
> Thanks,
> 
> Colin
> 

Yes, thanks! Looks like the same issue should be on x86, not sure why I didn't
catch that. Will fix.

Best Regards,
-hans
