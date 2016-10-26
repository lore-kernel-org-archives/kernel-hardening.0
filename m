Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 26 Oct 2016 16:38:47 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161026073845.GC19531@linaro.org>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-2-git-send-email-elena.reshetova@intel.com>
 <20161025085109.GV19531@linaro.org>
 <20161025094632.g266t632x5fplqua@thigreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161025094632.g266t632x5fplqua@thigreal>
Subject: Re: [kernel-hardening] [RFC v2 PATCH 01/13] Add architecture
 independent hardened atomic base
To: Hans Liljestrand <ishkamiel@gmail.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Hans,

On Tue, Oct 25, 2016 at 12:46:32PM +0300, Hans Liljestrand wrote:
> On Tue, Oct 25, 2016 at 05:51:11PM +0900, AKASHI Takahiro wrote:
> > On Thu, Oct 20, 2016 at 01:25:19PM +0300, Elena Reshetova wrote:
> > > This series brings the PaX/Grsecurity PAX_REFCOUNT [1]
> > > feature support to the upstream kernel. All credit for the
> > > feature goes to the feature authors.
> > > 
> > > The name of the upstream feature is HARDENED_ATOMIC
> > > and it is configured using CONFIG_HARDENED_ATOMIC and
> > > HAVE_ARCH_HARDENED_ATOMIC.
> > > 
> > > This series only adds x86 support; other architectures are expected
> > > to add similar support gradually.
> > > 
> > > Feature Summary
> > > ---------------
> > > The primary goal of KSPP is to provide protection against classes
> > > of vulnerabilities.  One such class of vulnerabilities, known as
> > > use-after-free bugs, frequently results when reference counters
> > > guarding shared kernel objects are overflowed.  The existence of
> > > a kernel path in which a reference counter is incremented more
> > > than it is decremented can lead to wrapping. This buggy path can be
> > > executed until INT_MAX/LONG_MAX is reached, at which point further
> > > increments will cause the counter to wrap to 0.  At this point, the
> > > kernel will erroneously mark the object as not in use, resulting in
> > > a multitude of undesirable cases: releasing the object to other users,
> > > freeing the object while it still has legitimate users, or other
> > > undefined conditions.  The above scenario is known as a use-after-free
> > > bug.
> > > 
> > > HARDENED_ATOMIC provides mandatory protection against kernel
> > > reference counter overflows.  In Linux, reference counters
> > > are implemented using the atomic_t and atomic_long_t types.
> > > HARDENED_ATOMIC modifies the functions dealing with these types
> > > such that when INT_MAX/LONG_MAX is reached, the atomic variables
> > > remain saturated at these maximum values, rather than wrapping.
> > > 
> > > There are several non-reference counter users of atomic_t and
> > > atomic_long_t (the fact that these types are being so widely
> > > misused is not addressed by this series).  These users, typically
> > > statistical counters, are not concerned with whether the values of
> > > these types wrap, and therefore can dispense with the added performance
> > > penalty incurred from protecting against overflows. New types have
> > > been introduced for these users: atomic_wrap_t and atomic_long_wrap_t.
> > > Functions for manipulating these types have been added as well.
> > > 
> > > Note that the protection provided by HARDENED_ATOMIC is not "opt-in":
> > > since atomic_t is so widely misused, it must be protected as-is.
> > > HARDENED_ATOMIC protects all users of atomic_t and atomic_long_t
> > > against overflow.  New users wishing to use atomic types, but not
> > > needing protection against overflows, should use the new types
> > > introduced by this series: atomic_wrap_t and atomic_long_wrap_t.
> > > 
> > > Bugs Prevented
> > > --------------
> > > HARDENED_ATOMIC would directly mitigate these Linux kernel bugs:
> > > 
> > > CVE-2016-3135 - Netfilter xt_alloc_table_info integer overflow
> > > CVE-2016-0728 - Keyring refcount overflow
> > > CVE-2014-2851 - Group_info refcount overflow
> > > CVE-2010-2959 - CAN integer overflow vulnerability,
> > > related post: https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/
> > > 
> > > And a relatively fresh exploit example:
> > > https://www.exploit-db.com/exploits/39773/
> > > 
> > > [1] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
> > > 
> > > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > > ---
> > >  Documentation/security/hardened-atomic.txt | 141 +++++++++++++++
> > >  include/asm-generic/atomic-long.h          | 264 ++++++++++++++++++++++++-----
> > >  include/asm-generic/atomic.h               |  56 ++++++
> > >  include/asm-generic/atomic64.h             |  13 ++
> > >  include/asm-generic/bug.h                  |   7 +
> > >  include/asm-generic/local.h                |  15 ++
> > >  include/linux/atomic.h                     | 114 +++++++++++++
> > >  include/linux/types.h                      |  17 ++
> > >  kernel/panic.c                             |  11 ++
> > >  security/Kconfig                           |  19 +++
> > >  10 files changed, 611 insertions(+), 46 deletions(-)
> > >  create mode 100644 Documentation/security/hardened-atomic.txt
> > > 
> > > diff --git a/Documentation/security/hardened-atomic.txt b/Documentation/security/hardened-atomic.txt
> > > new file mode 100644
> > > index 0000000..c17131e
> > > --- /dev/null
> > > +++ b/Documentation/security/hardened-atomic.txt
> > > @@ -0,0 +1,141 @@
> > > +=====================
> > > +KSPP: HARDENED_ATOMIC
> > > +=====================
> > > +
> > > +Risks/Vulnerabilities Addressed
> > > +===============================
> > > +
> > > +The Linux Kernel Self Protection Project (KSPP) was created with a mandate
> > > +to eliminate classes of kernel bugs. The class of vulnerabilities addressed
> > > +by HARDENED_ATOMIC is known as use-after-free vulnerabilities.
> > > +
> > > +HARDENED_ATOMIC is based off of work done by the PaX Team [1].  The feature
> > > +on which HARDENED_ATOMIC is based is called PAX_REFCOUNT in the original 
> > > +PaX patch.
> > > +
> > > +Use-after-free Vulnerabilities
> > > +------------------------------
> > > +Use-after-free vulnerabilities are aptly named: they are classes of bugs in
> > > +which an attacker is able to gain control of a piece of memory after it has
> > > +already been freed and use this memory for nefarious purposes: introducing
> > > +malicious code into the address space of an existing process, redirecting
> > > +the flow of execution, etc.
> > > +
> > > +While use-after-free vulnerabilities can arise in a variety of situations, 
> > > +the use case addressed by HARDENED_ATOMIC is that of referenced counted 
> > > +objects.  The kernel can only safely free these objects when all existing 
> > > +users of these objects are finished using them.  This necessitates the 
> > > +introduction of some sort of accounting system to keep track of current
> > > +users of kernel objects.  Reference counters and get()/put() APIs are the 
> > > +means typically chosen to do this: calls to get() increment the reference
> > > +counter, put() decrments it.  When the value of the reference counter
> > > +becomes some sentinel (typically 0), the kernel can safely free the counted
> > > +object.  
> > > +
> > > +Problems arise when the reference counter gets overflowed.  If the reference
> > > +counter is represented with a signed integer type, overflowing the reference
> > > +counter causes it to go from INT_MAX to INT_MIN, then approach 0.  Depending
> > > +on the logic, the transition to INT_MIN may be enough to trigger the bug,
> > > +but when the reference counter becomes 0, the kernel will free the
> > > +underlying object guarded by the reference counter while it still has valid
> > > +users.
> > > +
> > > +
> > > +HARDENED_ATOMIC Design
> > > +======================
> > > +
> > > +HARDENED_ATOMIC provides its protections by modifying the data type used in
> > > +the Linux kernel to implement reference counters: atomic_t. atomic_t is a
> > > +type that contains an integer type, used for counting. HARDENED_ATOMIC
> > > +modifies atomic_t and its associated API so that the integer type contained
> > > +inside of atomic_t cannot be overflowed.
> > > +
> > > +A key point to remember about HARDENED_ATOMIC is that, once enabled, it 
> > > +protects all users of atomic_t without any additional code changes. The
> > > +protection provided by HARDENED_ATOMIC is not “opt-in”: since atomic_t is so
> > > +widely misused, it must be protected as-is. HARDENED_ATOMIC protects all
> > > +users of atomic_t and atomic_long_t against overflow. New users wishing to
> > > +use atomic types, but not needing protection against overflows, should use
> > > +the new types introduced by this series: atomic_wrap_t and
> > > +atomic_long_wrap_t.
> > > +
> > > +Detect/Mitigate
> > > +---------------
> > > +The mechanism of HARDENED_ATOMIC can be viewed as a bipartite process:
> > > +detection of an overflow and mitigating the effects of the overflow, either
> > > +by not performing or performing, then reversing, the operation that caused
> > > +the overflow.
> > > +
> > > +Overflow detection is architecture-specific. Details of the approach used to
> > > +detect overflows on each architecture can be found in the PAX_REFCOUNT
> > > +documentation. [1]
> > > +
> > > +Once an overflow has been detected, HARDENED_ATOMIC mitigates the overflow
> > > +by either reverting the operation or simply not writing the result of the
> > > +operation to memory.
> > > +
> > > +
> > > +HARDENED_ATOMIC Implementation
> > > +==============================
> > > +
> > > +As mentioned above, HARDENED_ATOMIC modifies the atomic_t API to provide its
> > > +protections. Following is a description of the functions that have been
> > > +modified.
> > > +
> > > +First, the type atomic_wrap_t needs to be defined for those kernel users who
> > > +want an atomic type that may be allowed to overflow/wrap (e.g. statistical
> > > +counters). Otherwise, the built-in protections (and associated costs) for
> > > +atomic_t would erroneously apply to these non-reference counter users of
> > > +atomic_t:
> > > +
> > > +  * include/linux/types.h: define atomic_wrap_t and atomic64_wrap_t
> > > +
> > > +Next, we define the mechanism for reporting an overflow of a protected 
> > > +atomic type:
> > > +
> > > +  * kernel/panic.c: void hardened_atomic_overflow(struct pt_regs)
> > > +
> > > +The following functions are an extension of the atomic_t API, supporting
> > > +this new “wrappable” type:
> > > +
> > > +  * static inline int atomic_read_wrap()
> > > +  * static inline void atomic_set_wrap()
> > > +  * static inline void atomic_inc_wrap()
> > > +  * static inline void atomic_dec_wrap()
> > > +  * static inline void atomic_add_wrap()
> > > +  * static inline long atomic_inc_return_wrap()
> > > +
> > > +Departures from Original PaX Implementation
> > > +-------------------------------------------
> > > +While HARDENED_ATOMIC is based largely upon the work done by PaX in their
> > > +original PAX_REFCOUNT patchset, HARDENED_ATOMIC does in fact have a few
> > > +minor differences. We will be posting them here as final decisions are made
> > > +regarding how certain core protections are implemented.
> > > +
> > > +x86 Race Condition
> > > +------------------
> > > +In the original implementation of PAX_REFCOUNT, a known race condition
> > > +exists when performing atomic add operations.  The crux of the problem lies
> > > +in the fact that, on x86, there is no way to know a priori whether a 
> > > +prospective atomic operation will result in an overflow.  To detect an
> > > +overflow, PAX_REFCOUNT had to perform an operation then check if the 
> > > +operation caused an overflow.  
> > > +
> > > +Therefore, there exists a set of conditions in which, given the correct
> > > +timing of threads, an overflowed counter could be visible to a processor.
> > > +If multiple threads execute in such a way so that one thread overflows the
> > > +counter with an addition operation, while a second thread executes another
> > > +addition operation on the same counter before the first thread is able to
> > > +revert the previously executed addition operation (by executing a
> > > +subtraction operation of the same (or greater) magnitude), the counter will
> > > +have been incremented to a value greater than INT_MAX. At this point, the
> > > +protection provided by PAX_REFCOUNT has been bypassed, as further increments
> > > +to the counter will not be detected by the processor’s overflow detection
> > > +mechanism.
> > > +
> > > +The likelihood of an attacker being able to exploit this race was 
> > > +sufficiently insignificant such that fixing the race would be
> > > +counterproductive. 
> > > +
> > > +[1] https://pax.grsecurity.net
> > > +[2] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
> > > diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> > > index 288cc9e..425f34b 100644
> > > --- a/include/asm-generic/atomic-long.h
> > > +++ b/include/asm-generic/atomic-long.h
> > > @@ -22,6 +22,12 @@
> > >  
> > >  typedef atomic64_t atomic_long_t;
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +typedef atomic64_wrap_t atomic_long_wrap_t;
> > > +#else
> > > +typedef atomic64_t atomic_long_wrap_t;
> > > +#endif
> > > +
> > >  #define ATOMIC_LONG_INIT(i)	ATOMIC64_INIT(i)
> > >  #define ATOMIC_LONG_PFX(x)	atomic64 ## x
> > >  
> > > @@ -29,51 +35,77 @@ typedef atomic64_t atomic_long_t;
> > >  
> > >  typedef atomic_t atomic_long_t;
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +typedef atomic_wrap_t atomic_long_wrap_t;
> > > +#else
> > > +typedef atomic_t atomic_long_wrap_t;
> > > +#endif
> > > +
> > >  #define ATOMIC_LONG_INIT(i)	ATOMIC_INIT(i)
> > >  #define ATOMIC_LONG_PFX(x)	atomic ## x
> > >  
> > >  #endif
> > >  
> > > -#define ATOMIC_LONG_READ_OP(mo)						\
> > > -static inline long atomic_long_read##mo(const atomic_long_t *l)		\
> > > +#define ATOMIC_LONG_READ_OP(mo, suffix)						\
> > > +static inline long atomic_long_read##mo##suffix(const atomic_long##suffix##_t *l)\
> > >  {									\
> > > -	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
> > > +	ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> > >  									\
> > > -	return (long)ATOMIC_LONG_PFX(_read##mo)(v);			\
> > > +	return (long)ATOMIC_LONG_PFX(_read##mo##suffix)(v);		\
> > >  }
> > > -ATOMIC_LONG_READ_OP()
> > > -ATOMIC_LONG_READ_OP(_acquire)
> > > +ATOMIC_LONG_READ_OP(,)
> > > +ATOMIC_LONG_READ_OP(_acquire,)
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +ATOMIC_LONG_READ_OP(,_wrap)
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_read_wrap(v) atomic_long_read((v))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > >  
> > >  #undef ATOMIC_LONG_READ_OP
> > >  
> > > -#define ATOMIC_LONG_SET_OP(mo)						\
> > > -static inline void atomic_long_set##mo(atomic_long_t *l, long i)	\
> > > +#define ATOMIC_LONG_SET_OP(mo, suffix)					\
> > > +static inline void atomic_long_set##mo##suffix(atomic_long##suffix##_t *l, long i)\
> > >  {									\
> > > -	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
> > > +	ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> > >  									\
> > > -	ATOMIC_LONG_PFX(_set##mo)(v, i);				\
> > > +	ATOMIC_LONG_PFX(_set##mo##suffix)(v, i);			\
> > >  }
> > > -ATOMIC_LONG_SET_OP()
> > > -ATOMIC_LONG_SET_OP(_release)
> > > +ATOMIC_LONG_SET_OP(,)
> > > +ATOMIC_LONG_SET_OP(_release,)
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +ATOMIC_LONG_SET_OP(,_wrap)
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_set_wrap(v, i) atomic_long_set((v), (i))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > >  
> > >  #undef ATOMIC_LONG_SET_OP
> > >  
> > > -#define ATOMIC_LONG_ADD_SUB_OP(op, mo)					\
> > > +#define ATOMIC_LONG_ADD_SUB_OP(op, mo, suffix)				\
> > >  static inline long							\
> > > -atomic_long_##op##_return##mo(long i, atomic_long_t *l)			\
> > > +atomic_long_##op##_return##mo##suffix(long i, atomic_long##suffix##_t *l)\
> > >  {									\
> > > -	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
> > > +	ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> > >  									\
> > > -	return (long)ATOMIC_LONG_PFX(_##op##_return##mo)(i, v);		\
> > > +	return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(i, v);\
> > >  }
> > > -ATOMIC_LONG_ADD_SUB_OP(add,)
> > > -ATOMIC_LONG_ADD_SUB_OP(add, _relaxed)
> > > -ATOMIC_LONG_ADD_SUB_OP(add, _acquire)
> > > -ATOMIC_LONG_ADD_SUB_OP(add, _release)
> > > -ATOMIC_LONG_ADD_SUB_OP(sub,)
> > > -ATOMIC_LONG_ADD_SUB_OP(sub, _relaxed)
> > > -ATOMIC_LONG_ADD_SUB_OP(sub, _acquire)
> > > -ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> > > +ATOMIC_LONG_ADD_SUB_OP(add,,)
> > > +ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,)
> > > +ATOMIC_LONG_ADD_SUB_OP(add, _acquire,)
> > > +ATOMIC_LONG_ADD_SUB_OP(add, _release,)
> > > +ATOMIC_LONG_ADD_SUB_OP(sub,,)
> > > +ATOMIC_LONG_ADD_SUB_OP(sub, _relaxed,)
> > > +ATOMIC_LONG_ADD_SUB_OP(sub, _acquire,)
> > > +ATOMIC_LONG_ADD_SUB_OP(sub, _release,)
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
> > > +ATOMIC_LONG_ADD_SUB_OP(sub,,_wrap)
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_add_return_wrap(i,v) atomic_long_add_return((i), (v))
> > > +#define atomic_long_sub_return_wrap(i,v) atomic_long_sub_return((i), (v))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > >  
> > >  #undef ATOMIC_LONG_ADD_SUB_OP
> > >  
> > > @@ -89,6 +121,13 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> > >  #define atomic_long_cmpxchg(l, old, new) \
> > >  	(ATOMIC_LONG_PFX(_cmpxchg)((ATOMIC_LONG_PFX(_t) *)(l), (old), (new)))
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +#define atomic_long_cmpxchg_wrap(l, old, new) \
> > > +	(ATOMIC_LONG_PFX(_cmpxchg_wrap)((ATOMIC_LONG_PFX(_wrap_t) *)(l), (old), (new)))
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_cmpxchg_wrap(v, o, n) atomic_long_cmpxchg((v), (o), (n))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > >  #define atomic_long_xchg_relaxed(v, new) \
> > >  	(ATOMIC_LONG_PFX(_xchg_relaxed)((ATOMIC_LONG_PFX(_t) *)(v), (new)))
> > >  #define atomic_long_xchg_acquire(v, new) \
> > > @@ -98,6 +137,13 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> > >  #define atomic_long_xchg(v, new) \
> > >  	(ATOMIC_LONG_PFX(_xchg)((ATOMIC_LONG_PFX(_t) *)(v), (new)))
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +#define atomic_long_xchg_wrap(v, new) \
> > > +	(ATOMIC_LONG_PFX(_xchg_wrap)((ATOMIC_LONG_PFX(_wrap_t) *)(v), (new)))
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_xchg_wrap(v, i) atomic_long_xchg((v), (i))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > >  static __always_inline void atomic_long_inc(atomic_long_t *l)
> > >  {
> > >  	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > > @@ -105,6 +151,17 @@ static __always_inline void atomic_long_inc(atomic_long_t *l)
> > >  	ATOMIC_LONG_PFX(_inc)(v);
> > >  }
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +static __always_inline void atomic_long_inc_wrap(atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	ATOMIC_LONG_PFX(_inc_wrap)(v);
> > > +}
> > > +#else
> > > +#define atomic_long_inc_wrap(v) atomic_long_inc(v)
> > > +#endif
> > > +
> > >  static __always_inline void atomic_long_dec(atomic_long_t *l)
> > >  {
> > >  	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > > @@ -112,6 +169,17 @@ static __always_inline void atomic_long_dec(atomic_long_t *l)
> > >  	ATOMIC_LONG_PFX(_dec)(v);
> > >  }
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +static __always_inline void atomic_long_dec_wrap(atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	ATOMIC_LONG_PFX(_dec_wrap)(v);
> > > +}
> > > +#else
> > > +#define atomic_long_dec_wrap(v) atomic_long_dec(v)
> > > +#endif
> > > +
> > >  #define ATOMIC_LONG_FETCH_OP(op, mo)					\
> > >  static inline long							\
> > >  atomic_long_fetch_##op##mo(long i, atomic_long_t *l)			\
> > > @@ -168,21 +236,29 @@ ATOMIC_LONG_FETCH_INC_DEC_OP(dec, _release)
> > >  
> > >  #undef ATOMIC_LONG_FETCH_INC_DEC_OP
> > >  
> > > -#define ATOMIC_LONG_OP(op)						\
> > > +#define ATOMIC_LONG_OP(op, suffix)					\
> > >  static __always_inline void						\
> > > -atomic_long_##op(long i, atomic_long_t *l)				\
> > > +atomic_long_##op##suffix(long i, atomic_long##suffix##_t *l)		\
> > >  {									\
> > > -	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
> > > +	ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> > >  									\
> > > -	ATOMIC_LONG_PFX(_##op)(i, v);					\
> > > +	ATOMIC_LONG_PFX(_##op##suffix)(i, v);				\
> > >  }
> > >  
> > > -ATOMIC_LONG_OP(add)
> > > -ATOMIC_LONG_OP(sub)
> > > -ATOMIC_LONG_OP(and)
> > > -ATOMIC_LONG_OP(andnot)
> > > -ATOMIC_LONG_OP(or)
> > > -ATOMIC_LONG_OP(xor)
> > > +ATOMIC_LONG_OP(add,)
> > > +ATOMIC_LONG_OP(sub,)
> > > +ATOMIC_LONG_OP(and,)
> > > +ATOMIC_LONG_OP(or,)
> > > +ATOMIC_LONG_OP(xor,)
> > > +ATOMIC_LONG_OP(andnot,)
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +ATOMIC_LONG_OP(add,_wrap)
> > > +ATOMIC_LONG_OP(sub,_wrap)
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_add_wrap(i,v) atomic_long_add((i),(v))
> > > +#define atomic_long_sub_wrap(i,v) atomic_long_sub((i),(v))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > >  
> > >  #undef ATOMIC_LONG_OP
> > >  
> > > @@ -193,6 +269,15 @@ static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
> > >  	return ATOMIC_LONG_PFX(_sub_and_test)(i, v);
> > >  }
> > >  
> > > +/*
> > > +static inline int atomic_long_add_and_test(long i, atomic_long_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_add_and_test)(i, v);
> > > +}
> > > +*/
> > > +
> > >  static inline int atomic_long_dec_and_test(atomic_long_t *l)
> > >  {
> > >  	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > > @@ -214,22 +299,75 @@ static inline int atomic_long_add_negative(long i, atomic_long_t *l)
> > >  	return ATOMIC_LONG_PFX(_add_negative)(i, v);
> > >  }
> > >  
> > > -#define ATOMIC_LONG_INC_DEC_OP(op, mo)					\
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +static inline int atomic_long_sub_and_test_wrap(long i, atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_sub_and_test_wrap)(i, v);
> > > +}
> > > +
> > > +
> > > +static inline int atomic_long_add_and_test_wrap(long i, atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_add_and_test_wrap)(i, v);
> > > +}
> > 
> > This definition should be removed as atomic_add_and_test() above
> > since atomic*_add_and_test() are not defined.
> 
> The *_add_and_test* functionew were intentionally added for function coverage.
> The idea was to make that the *_sub_and_test* functions have corresponding add
> function, but maybe this was misguided?

Well, what I'm basically saying here is:
atomic_long_add_and_test() is not defined *in this file*, and so
atomic_long_add_and_test_wrap() should not be neither.

Quoting again:
> > > +/*
       ^^
> > > +static inline int atomic_long_add_and_test(long i, atomic_long_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_add_and_test)(i, v);
> > > +}
> > > +*/
       ^^

Is this also intentional?

Thanks,
-Takahiro AKASHI

> It might indeed be better to restrict the function coverage efforts to providing
> _wrap versions?
> 
> > 
> > > +
> > > +
> > > +static inline int atomic_long_dec_and_test_wrap(atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_dec_and_test_wrap)(v);
> > > +}
> > > +
> > > +static inline int atomic_long_inc_and_test_wrap(atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_inc_and_test_wrap)(v);
> > > +}
> > > +
> > > +static inline int atomic_long_add_negative_wrap(long i, atomic_long_wrap_t *l)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return ATOMIC_LONG_PFX(_add_negative_wrap)(i, v);
> > > +}
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_sub_and_test_wrap(i, v) atomic_long_sub_and_test((i), (v))
> > > +#define atomic_long_add_and_test_wrap(i, v) atomic_long_add_and_test((i), (v))
> > > +#define atomic_long_dec_and_test_wrap(i, v) atomic_long_dec_and_test((i), (v))
> > > +#define atomic_long_inc_and_test_wrap(i, v) atomic_long_inc_and_test((i), (v))
> > > +#define atomic_long_add_negative_wrap(i, v) atomic_long_add_negative((i), (v))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > > +#define ATOMIC_LONG_INC_DEC_OP(op, mo, suffix)				\
> > >  static inline long							\
> > > -atomic_long_##op##_return##mo(atomic_long_t *l)				\
> > > +atomic_long_##op##_return##mo##suffix(atomic_long##suffix##_t *l)	\
> > >  {									\
> > > -	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
> > > +	ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
> > >  									\
> > > -	return (long)ATOMIC_LONG_PFX(_##op##_return##mo)(v);		\
> > > +	return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(v);	\
> > >  }
> > > -ATOMIC_LONG_INC_DEC_OP(inc,)
> > > -ATOMIC_LONG_INC_DEC_OP(inc, _relaxed)
> > > -ATOMIC_LONG_INC_DEC_OP(inc, _acquire)
> > > -ATOMIC_LONG_INC_DEC_OP(inc, _release)
> > > -ATOMIC_LONG_INC_DEC_OP(dec,)
> > > -ATOMIC_LONG_INC_DEC_OP(dec, _relaxed)
> > > -ATOMIC_LONG_INC_DEC_OP(dec, _acquire)
> > > -ATOMIC_LONG_INC_DEC_OP(dec, _release)
> > > +ATOMIC_LONG_INC_DEC_OP(inc,,)
> > > +ATOMIC_LONG_INC_DEC_OP(inc, _relaxed,)
> > > +ATOMIC_LONG_INC_DEC_OP(inc, _acquire,)
> > > +ATOMIC_LONG_INC_DEC_OP(inc, _release,)
> > > +ATOMIC_LONG_INC_DEC_OP(dec,,)
> > > +ATOMIC_LONG_INC_DEC_OP(dec, _relaxed,)
> > > +ATOMIC_LONG_INC_DEC_OP(dec, _acquire,)
> > > +ATOMIC_LONG_INC_DEC_OP(dec, _release,)
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +ATOMIC_LONG_INC_DEC_OP(inc,,_wrap)
> > > +ATOMIC_LONG_INC_DEC_OP(dec,,_wrap)
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_inc_return_wrap(v) atomic_long_inc_return((v))
> > > +#define atomic_long_dec_return_wrap(v) atomic_long_dec_return((v))
> > > +#endif /*  CONFIG_HARDENED_ATOMIC */
> > >  
> > >  #undef ATOMIC_LONG_INC_DEC_OP
> > >  
> > > @@ -240,7 +378,41 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
> > >  	return (long)ATOMIC_LONG_PFX(_add_unless)(v, a, u);
> > >  }
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +static inline long atomic_long_add_unless_wrap(atomic_long_wrap_t *l, long a, long u)
> > > +{
> > > +	ATOMIC_LONG_PFX(_wrap_t) *v = (ATOMIC_LONG_PFX(_wrap_t) *)l;
> > > +
> > > +	return (long)ATOMIC_LONG_PFX(_add_unless_wrap)(v, a, u);
> > > +}
> > > +#else /* CONFIG_HARDENED_ATOMIC */
> > > +#define atomic_long_add_unless_wrap(v, i, j) atomic_long_add_unless((v), (i), (j))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > >  #define atomic_long_inc_not_zero(l) \
> > >  	ATOMIC_LONG_PFX(_inc_not_zero)((ATOMIC_LONG_PFX(_t) *)(l))
> > >  
> > > +#ifndef CONFIG_HARDENED_ATOMIC
> > > +#define atomic_read_wrap(v) atomic_read(v)
> > > +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> > > +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> > > +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> > > +#define atomic_inc_wrap(v) atomic_inc(v)
> > > +#define atomic_dec_wrap(v) atomic_dec(v)
> > > +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> > > +#define atomic_sub_return_wrap(i, v) atomic_sub_return((i), (v))
> > > +#define atoimc_dec_return_wrap(v) atomic_dec_return(v)
> > > +#ifndef atomic_inc_return_wrap
> > > +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> > > +#endif /* atomic_inc_return */
> > > +#define atomic_dec_and_test_wrap(v) atomic_dec_and_test(v)
> > > +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> > > +#define atomic_add_and_test_wrap(i, v) atomic_add_and_test((v), (i))
> > > +#define atomic_sub_and_test_wrap(i, v) atomic_sub_and_test((v), (i))
> > > +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> > > +#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> > > +#define atomic_add_negative_wrap(i, v) atomic_add_negative((i), (v))
> > > +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > >  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
> > > diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> > > index 9ed8b98..6c3ed48 100644
> > > --- a/include/asm-generic/atomic.h
> > > +++ b/include/asm-generic/atomic.h
> > > @@ -177,6 +177,10 @@ ATOMIC_OP(xor, ^)
> > >  #define atomic_read(v)	READ_ONCE((v)->counter)
> > >  #endif
> > >  
> > > +#ifndef atomic_read_wrap
> > > +#define atomic_read_wrap(v)	READ_ONCE((v)->counter)
> > > +#endif
> > > +
> > >  /**
> > >   * atomic_set - set atomic variable
> > >   * @v: pointer of type atomic_t
> > > @@ -186,6 +190,10 @@ ATOMIC_OP(xor, ^)
> > >   */
> > >  #define atomic_set(v, i) WRITE_ONCE(((v)->counter), (i))
> > >  
> > > +#ifndef atomic_set_wrap
> > > +#define atomic_set_wrap(v, i) WRITE_ONCE(((v)->counter), (i))
> > > +#endif
> > > +
> > >  #include <linux/irqflags.h>
> > >  
> > >  static inline int atomic_add_negative(int i, atomic_t *v)
> > > @@ -193,33 +201,72 @@ static inline int atomic_add_negative(int i, atomic_t *v)
> > >  	return atomic_add_return(i, v) < 0;
> > >  }
> > >  
> > > +static inline int atomic_add_negative_wrap(int i, atomic_wrap_t *v)
> > > +{
> > > +	return atomic_add_return_wrap(i, v) < 0;
> > > +}
> > > +
> > >  static inline void atomic_add(int i, atomic_t *v)
> > >  {
> > >  	atomic_add_return(i, v);
> > >  }
> > >  
> > > +static inline void atomic_add_wrap(int i, atomic_wrap_t *v)
> > > +{
> > > +	atomic_add_return_wrap(i, v);
> > > +}
> > > +
> > >  static inline void atomic_sub(int i, atomic_t *v)
> > >  {
> > >  	atomic_sub_return(i, v);
> > >  }
> > >  
> > > +static inline void atomic_sub_wrap(int i, atomic_wrap_t *v)
> > > +{
> > > +	atomic_sub_return_wrap(i, v);
> > > +}
> > > +
> > >  static inline void atomic_inc(atomic_t *v)
> > >  {
> > >  	atomic_add_return(1, v);
> > >  }
> > >  
> > > +static inline void atomic_inc_wrap(atomic_wrap_t *v)
> > > +{
> > > +	atomic_add_return_wrap(1, v);
> > > +}
> > > +
> > >  static inline void atomic_dec(atomic_t *v)
> > >  {
> > >  	atomic_sub_return(1, v);
> > >  }
> > >  
> > > +static inline void atomic_dec_wrap(atomic_wrap_t *v)
> > > +{
> > > +	atomic_sub_return_wrap(1, v);
> > > +}
> > > +
> > >  #define atomic_dec_return(v)		atomic_sub_return(1, (v))
> > >  #define atomic_inc_return(v)		atomic_add_return(1, (v))
> > >  
> > > +#define atomic_add_and_test(i, v)	(atomic_add_return((i), (v)) == 0)
> > >  #define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
> > >  #define atomic_dec_and_test(v)		(atomic_dec_return(v) == 0)
> > >  #define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
> > >  
> > > +#ifndef atomic_add_and_test_wrap
> > > +#define atomic_add_and_test_wrap(i, v)	(atomic_add_return_wrap((i), (v)) == 0)
> > > +#endif
> > > +#ifndef atomic_sub_and_test_wrap
> > > +#define atomic_sub_and_test_wrap(i, v)	(atomic_sub_return_wrap((i), (v)) == 0)
> > > +#endif
> > > +#ifndef atomic_dec_and_test_wrap
> > > +#define atomic_dec_and_test_wrap(v)		(atomic_dec_return_wrap(v) == 0)
> > > +#endif
> > > +#ifndef atomic_inc_and_test_wrap
> > > +#define atomic_inc_and_test_wrap(v)		(atomic_inc_return_wrap(v) == 0)
> > > +#endif
> > > +
> > >  #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
> > >  #define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
> > >  
> > > @@ -232,4 +279,13 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
> > >  	return c;
> > >  }
> > >  
> > > +static inline int __atomic_add_unless_wrap(atomic_wrap_t *v, int a, int u)
> > > +{
> > > +	int c, old;
> > > +	c = atomic_read_wrap(v);
> > > +	while (c != u && (old = atomic_cmpxchg_wrap(v, c, c + a)) != c)
> > > +		c = old;
> > > +	return c;
> > > +}
> > > +
> > >  #endif /* __ASM_GENERIC_ATOMIC_H */
> > > diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
> > > index dad68bf..0bb63b9 100644
> > > --- a/include/asm-generic/atomic64.h
> > > +++ b/include/asm-generic/atomic64.h
> > > @@ -56,10 +56,23 @@ extern int	 atomic64_add_unless(atomic64_t *v, long long a, long long u);
> > >  #define atomic64_inc(v)			atomic64_add(1LL, (v))
> > >  #define atomic64_inc_return(v)		atomic64_add_return(1LL, (v))
> > >  #define atomic64_inc_and_test(v) 	(atomic64_inc_return(v) == 0)
> > > +#define atomic64_add_and_test(a, v)	(atomic64_add_return((a), (v)) == 0)
> > >  #define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
> > >  #define atomic64_dec(v)			atomic64_sub(1LL, (v))
> > >  #define atomic64_dec_return(v)		atomic64_sub_return(1LL, (v))
> > >  #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
> > >  #define atomic64_inc_not_zero(v) 	atomic64_add_unless((v), 1LL, 0LL)
> > >  
> > > +#define atomic64_read_wrap(v) atomic64_read(v)
> > > +#define atomic64_set_wrap(v, i) atomic64_set((v), (i))
> > > +#define atomic64_add_wrap(a, v) atomic64_add((a), (v))
> > > +#define atomic64_add_return_wrap(a, v) atomic64_add_return((a), (v))
> > > +#define atomic64_sub_wrap(a, v) atomic64_sub((a), (v))
> > > +#define atomic64_inc_wrap(v) atomic64_inc(v)
> > > +#define atomic64_inc_return_wrap(v) atomic64_inc_return(v)
> > > +#define atomic64_dec_wrap(v) atomic64_dec(v)
> > > +#define atomic64_dec_return_wrap(v) atomic64_return_dec(v)
> > > +#define atomic64_cmpxchg_wrap(v, o, n) atomic64_cmpxchg((v), (o), (n))
> > > +#define atomic64_xchg_wrap(v, n) atomic64_xchg((v), (n))
> > > +
> > >  #endif  /*  _ASM_GENERIC_ATOMIC64_H  */
> > > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > > index 6f96247..20ce604 100644
> > > --- a/include/asm-generic/bug.h
> > > +++ b/include/asm-generic/bug.h
> > > @@ -215,6 +215,13 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
> > >  # define WARN_ON_SMP(x)			({0;})
> > >  #endif
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +void hardened_atomic_overflow(struct pt_regs *regs);
> > > +#else
> > > +static inline void hardened_atomic_overflow(struct pt_regs *regs){
> > > +}
> > > +#endif
> > > +
> > >  #endif /* __ASSEMBLY__ */
> > >  
> > >  #endif
> > > diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
> > > index 9ceb03b..a98ad1d 100644
> > > --- a/include/asm-generic/local.h
> > > +++ b/include/asm-generic/local.h
> > > @@ -23,24 +23,39 @@ typedef struct
> > >  	atomic_long_t a;
> > >  } local_t;
> > >  
> > > +typedef struct {
> > > +	atomic_long_wrap_t a;
> > > +} local_wrap_t;
> > > +
> > >  #define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
> > >  
> > >  #define local_read(l)	atomic_long_read(&(l)->a)
> > > +#define local_read_wrap(l)	atomic_long_read_wrap(&(l)->a)
> > >  #define local_set(l,i)	atomic_long_set((&(l)->a),(i))
> > > +#define local_set_wrap(l,i)	atomic_long_set_wrap((&(l)->a),(i))
> > >  #define local_inc(l)	atomic_long_inc(&(l)->a)
> > > +#define local_inc_wrap(l)	atomic_long_inc_wrap(&(l)->a)
> > >  #define local_dec(l)	atomic_long_dec(&(l)->a)
> > > +#define local_dec_wrap(l)	atomic_long_dec_wrap(&(l)->a)
> > >  #define local_add(i,l)	atomic_long_add((i),(&(l)->a))
> > > +#define local_add_wrap(i,l)	atomic_long_add_wrap((i),(&(l)->a))
> > >  #define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
> > > +#define local_sub_wrap(i,l)	atomic_long_sub_wrap((i),(&(l)->a))
> > >  
> > >  #define local_sub_and_test(i, l) atomic_long_sub_and_test((i), (&(l)->a))
> > > +#define local_sub_and_test_wrap(i, l) atomic_long_sub_and_test_wrap((i), (&(l)->a))
> > >  #define local_dec_and_test(l) atomic_long_dec_and_test(&(l)->a)
> > >  #define local_inc_and_test(l) atomic_long_inc_and_test(&(l)->a)
> > >  #define local_add_negative(i, l) atomic_long_add_negative((i), (&(l)->a))
> > >  #define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
> > > +#define local_add_return_wrap(i, l) atomic_long_add_return_wrap((i), (&(l)->a))
> > >  #define local_sub_return(i, l) atomic_long_sub_return((i), (&(l)->a))
> > >  #define local_inc_return(l) atomic_long_inc_return(&(l)->a)
> > > +/* verify that below function is needed */
> > > +#define local_dec_return(l) atomic_long_dec_return(&(l)->a)
> > >  
> > >  #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
> > > +#define local_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg_wrap((&(l)->a), (o), (n))
> > >  #define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
> > >  #define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
> > >  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
> > > diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> > > index e71835b..3cb48f0 100644
> > > --- a/include/linux/atomic.h
> > > +++ b/include/linux/atomic.h
> > > @@ -89,6 +89,11 @@
> > >  #define  atomic_add_return(...)						\
> > >  	__atomic_op_fence(atomic_add_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_add_return_wrap
> > > +#define atomic_add_return_wrap(...)					\
> > > +	__atomic_op_fence(atomic_add_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_add_return_relaxed */
> > >  
> > >  /* atomic_inc_return_relaxed */
> > > @@ -113,6 +118,11 @@
> > >  #define  atomic_inc_return(...)						\
> > >  	__atomic_op_fence(atomic_inc_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_inc_return_wrap
> > > +#define  atomic_inc_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic_inc_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_inc_return_relaxed */
> > >  
> > >  /* atomic_sub_return_relaxed */
> > > @@ -137,6 +147,11 @@
> > >  #define  atomic_sub_return(...)						\
> > >  	__atomic_op_fence(atomic_sub_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_sub_return_wrap
> > > +#define atomic_sub_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic_sub_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_sub_return_relaxed */
> > >  
> > >  /* atomic_dec_return_relaxed */
> > > @@ -161,6 +176,11 @@
> > >  #define  atomic_dec_return(...)						\
> > >  	__atomic_op_fence(atomic_dec_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_dec_return_wrap
> > > +#define  atomic_dec_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic_dec_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_dec_return_relaxed */
> > >  
> > >  
> > > @@ -397,6 +417,11 @@
> > >  #define  atomic_xchg(...)						\
> > >  	__atomic_op_fence(atomic_xchg, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_xchg_wrap
> > > +#define  atomic_xchg_wrap(...)				\
> > > +	_atomic_op_fence(atomic_xchg_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_xchg_relaxed */
> > >  
> > >  /* atomic_cmpxchg_relaxed */
> > > @@ -421,6 +446,11 @@
> > >  #define  atomic_cmpxchg(...)						\
> > >  	__atomic_op_fence(atomic_cmpxchg, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic_cmpxchg_wrap
> > > +#define  atomic_cmpxchg_wrap(...)				\
> > > +	_atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic_cmpxchg_relaxed */
> > >  
> > >  /* cmpxchg_relaxed */
> > > @@ -507,6 +537,22 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
> > >  }
> > >  
> > >  /**
> > > + * atomic_add_unless_wrap - add unless the number is already a given value
> > > + * @v: pointer of type atomic_wrap_t
> > > + * @a: the amount to add to v...
> > > + * @u: ...unless v is equal to u.
> > > + *
> > > + * Atomically adds @a to @v, so long as @v was not already @u.
> > > + * Returns non-zero if @v was not @u, and zero otherwise.
> > > + */
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +static inline int atomic_add_unless_wrap(atomic_wrap_t *v, int a, int u)
> > > +{
> > > +	return __atomic_add_unless_wrap(v, a, u) != u;
> > > +}
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > > +/**
> > >   * atomic_inc_not_zero - increment unless the number is zero
> > >   * @v: pointer of type atomic_t
> > >   *
> > > @@ -631,6 +677,43 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #include <asm-generic/atomic64.h>
> > >  #endif
> > >  
> > > +#ifndef CONFIG_HARDENED_ATOMIC
> > > +#define atomic64_wrap_t atomic64_t
> > > +#ifndef atomic64_read_wrap
> > > +#define atomic64_read_wrap(v)		atomic64_read(v)
> > > +#endif
> > > +#ifndef atomic64_set_wrap
> > > +#define atomic64_set_wrap(v, i)		atomic64_set((v), (i))
> > > +#endif
> > > +#ifndef atomic64_add_wrap
> > > +#define atomic64_add_wrap(a, v)		atomic64_add((a), (v))
> > > +#endif
> > > +#ifndef atomic64_add_return_wrap
> > > +#define atomic64_add_return_wrap(a, v)	atomic64_add_return((a), (v))
> > > +#endif
> > > +#ifndef atomic64_sub_wrap
> > > +#define atomic64_sub_wrap(a, v)		atomic64_sub((a), (v))
> > > +#endif
> > > +#ifndef atomic64_inc_wrap
> > > +#define atomic64_inc_wrap(v)		atomic64_inc((v))
> > > +#endif
> > > +#ifndef atomic64_inc_return_wrap
> > > +#define atomic64_inc_return_wrap(v)	atomic64_inc_return((v))
> > > +#endif
> > > +#ifndef atomic64_dec_wrap
> > > +#define atomic64_dec_wrap(v)		atomic64_dec((v))
> > > +#endif
> > > +#ifndef atomic64_dec_return_wrap
> > > +#define atomic64_dec_return_wrap(v)	atomic64_dec_return((v))
> > > +#endif
> > > +#ifndef atomic64_cmpxchg_wrap
> > > +#define atomic64_cmpxchg_wrap(v, o, n) atomic64_cmpxchg((v), (o), (n))
> > > +#endif
> > > +#ifndef atomic64_xchg_wrap
> > > +#define atomic64_xchg_wrap(v, n) atomic64_xchg((v), (n))
> > > +#endif
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > > +
> > >  #ifndef atomic64_read_acquire
> > >  #define  atomic64_read_acquire(v)	smp_load_acquire(&(v)->counter)
> > >  #endif
> > > @@ -661,6 +744,12 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_add_return(...)					\
> > >  	__atomic_op_fence(atomic64_add_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_add_return_wrap
> > > +#define  atomic64_add_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic64_add_return_wrap, __VA_ARGS__)
> > > +#endif
> > > +
> > >  #endif /* atomic64_add_return_relaxed */
> > >  
> > >  /* atomic64_inc_return_relaxed */
> > > @@ -685,6 +774,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_inc_return(...)					\
> > >  	__atomic_op_fence(atomic64_inc_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_inc_return_wrap
> > > +#define  atomic64_inc_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic64_inc_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic64_inc_return_relaxed */
> > >  
> > >  
> > > @@ -710,6 +804,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_sub_return(...)					\
> > >  	__atomic_op_fence(atomic64_sub_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_sub_return_wrap
> > > +#define  atomic64_sub_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic64_sub_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic64_sub_return_relaxed */
> > >  
> > >  /* atomic64_dec_return_relaxed */
> > > @@ -734,6 +833,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_dec_return(...)					\
> > >  	__atomic_op_fence(atomic64_dec_return, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_dec_return_wrap
> > > +#define  atomic64_dec_return_wrap(...)				\
> > > +	__atomic_op_fence(atomic64_dec_return_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic64_dec_return_relaxed */
> > >  
> > >  
> > > @@ -970,6 +1074,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_xchg(...)						\
> > >  	__atomic_op_fence(atomic64_xchg, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_xchg_wrap
> > > +#define  atomic64_xchg_wrap(...)				\
> > > +	__atomic_op_fence(atomic64_xchg_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic64_xchg_relaxed */
> > >  
> > >  /* atomic64_cmpxchg_relaxed */
> > > @@ -994,6 +1103,11 @@ static inline int atomic_dec_if_positive(atomic_t *v)
> > >  #define  atomic64_cmpxchg(...)						\
> > >  	__atomic_op_fence(atomic64_cmpxchg, __VA_ARGS__)
> > >  #endif
> > > +
> > > +#ifndef atomic64_cmpxchg_wrap
> > > +#define  atomic64_cmpxchg_wrap(...)					\
> > > +	__atomic_op_fence(atomic64_cmpxchg_wrap, __VA_ARGS__)
> > > +#endif
> > >  #endif /* atomic64_cmpxchg_relaxed */
> > >  
> > >  #ifndef atomic64_andnot
> > > diff --git a/include/linux/types.h b/include/linux/types.h
> > > index baf7183..b47a7f8 100644
> > > --- a/include/linux/types.h
> > > +++ b/include/linux/types.h
> > > @@ -175,10 +175,27 @@ typedef struct {
> > >  	int counter;
> > >  } atomic_t;
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +typedef struct {
> > > +	int counter;
> > > +} atomic_wrap_t;
> > > +#else
> > > +typedef atomic_t atomic_wrap_t;
> > > +#endif
> > > +
> > >  #ifdef CONFIG_64BIT
> > >  typedef struct {
> > >  	long counter;
> > >  } atomic64_t;
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +typedef struct {
> > > +	long counter;
> > > +} atomic64_wrap_t;
> > > +#else
> > > +typedef atomic64_t atomic64_wrap_t;
> > > +#endif
> > > +
> > >  #endif
> > >  
> > >  struct list_head {
> > > diff --git a/kernel/panic.c b/kernel/panic.c
> > > index e6480e2..cb1d6db 100644
> > > --- a/kernel/panic.c
> > > +++ b/kernel/panic.c
> > > @@ -616,3 +616,14 @@ static int __init oops_setup(char *s)
> > >  	return 0;
> > >  }
> > >  early_param("oops", oops_setup);
> > > +
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +void hardened_atomic_overflow(struct pt_regs *regs)
> > > +{
> > > +	pr_emerg(KERN_EMERG "HARDENED_ATOMIC: overflow detected in: %s:%d, uid/euid: %u/%u\n",
> > > +		current->comm, task_pid_nr(current),
> > > +		from_kuid_munged(&init_user_ns, current_uid()),
> > > +		from_kuid_munged(&init_user_ns, current_euid()));
> > > +	BUG();
> > 
> > BUG() will print a message like "kernel BUG at kernel/panic.c:627!"
> > and a stack trace dump with extra frames including hardened_atomic_overflow()
> > and some exception handler routines (do_trap() on x86), which are totally
> > useless. So I don't want to call BUG() here.
> > 
> > Instead, we will fall back to a normal "BUG" handler, bug_handler() on arm64,
> > which eventually calls die(), generating more *intuitive* messages:
> > ===8<===
> > [   29.082336] lkdtm: attempting good atomic_add_return
> > [   29.082391] lkdtm: attempting bad atomic_add_return
> > [   29.082830] ------------[ cut here ]------------
> > [   29.082889] Kernel BUG at ffff0000008b07fc [verbose debug info unavailable]
> >                             (Actually, this is lkdtm_ATOMIC_ADD_RETURN_OVERFLOW)
> > [   29.082968] HARDENED_ATOMIC: overflow detected in: insmod:1152, uid/euid: 0/0
> > [   29.083043] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> > [   29.083098] Modules linked in: lkdtm(+)
> > [   29.083189] CPU: 1 PID: 1152 Comm: insmod Not tainted 4.9.0-rc1-00024-gb757839-dirty #12
> > [   29.083262] Hardware name: FVP Base (DT)
> > [   29.083324] task: ffff80087aa21900 task.stack: ffff80087a36c000
> > [   29.083557] PC is at lkdtm_ATOMIC_ADD_RETURN_OVERFLOW+0x6c/0xa0 [lkdtm]
> > [   29.083627] LR is at 0x7fffffff
> > [   29.083687] pc : [<ffff0000008b07fc>] lr : [<000000007fffffff>] pstate: 90400149
> > [   29.083757] sp : ffff80087a36fbe0
> > [   29.083810] x29: ffff80087a36fbe0 [   29.083858] x28: ffff000008ec3000
> > [   29.083906]
> > 
> > ...
> > 
> > [   29.090842] [<ffff0000008b07fc>] lkdtm_ATOMIC_ADD_RETURN_OVERFLOW+0x6c/0xa0 [lkdtm]
> > [   29.091090] [<ffff0000008b20a4>] lkdtm_do_action+0x1c/0x28 [lkdtm]
> > [   29.091334] [<ffff0000008bb118>] lkdtm_module_init+0x118/0x210 [lkdtm]
> > [   29.091422] [<ffff000008083150>] do_one_initcall+0x38/0x128
> > [   29.091503] [<ffff000008166ad4>] do_init_module+0x5c/0x1c8
> > [   29.091586] [<ffff00000812e1ec>] load_module+0x1b24/0x20b0
> > [   29.091670] [<ffff00000812e920>] SyS_init_module+0x1a8/0x1d8
> > [   29.091753] [<ffff000008082ef0>] el0_svc_naked+0x24/0x28
> > [   29.091843] Code: 910063a1 b8e0003e 2b1e0010 540000c7 (d4210020)
> > ===>8===
> > 
> > Thanks,
> > -Takahiro AKASHI
> > 
> > > +}
> > > +#endif
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index 118f454..abcf1cc 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -158,6 +158,25 @@ config HARDENED_USERCOPY_PAGESPAN
> > >  	  been removed. This config is intended to be used only while
> > >  	  trying to find such users.
> > >  
> > > +config HAVE_ARCH_HARDENED_ATOMIC
> > > +	bool
> > > +	help
> > > +	  The architecture supports CONFIG_HARDENED_ATOMIC by
> > > +	  providing trapping on atomic_t wraps, with a call to
> > > +	  hardened_atomic_overflow().
> > > +
> > > +config HARDENED_ATOMIC
> > > +	bool "Prevent reference counter overflow in atomic_t"
> > > +	depends on HAVE_ARCH_HARDENED_ATOMIC
> > > +	select BUG
> > > +	help
> > > +	  This option catches counter wrapping in atomic_t, which
> > > +	  can turn refcounting overflow bugs into resource
> > > +	  consumption bugs instead of exploitable use-after-free
> > > +	  flaws. This feature has a negligible
> > > +	  performance impact and therefore recommended to be turned
> > > +	  on for security reasons.
> > > +
> > >  source security/selinux/Kconfig
> > >  source security/smack/Kconfig
> > >  source security/tomoyo/Kconfig
> > > -- 
> > > 2.7.4
> > > 
