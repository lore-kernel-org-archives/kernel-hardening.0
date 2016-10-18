Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476779058.2421.14.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 18 Oct 2016 10:24:18 +0200
In-Reply-To: <20161018070656.GO19531@linaro.org>
References: <1476472255-15851-1-git-send-email-colin@cvidal.org>
	 <20161018070656.GO19531@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: include/asm-generic/atomic-long.h: Reordering atomic_*_wrap
 macros
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Takahiro,

> > +#ifndef CONFIG_HARDENED_ATOMIC
> > +#define atomic_read_wrap(v) atomic_read(v)
> > +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> > +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> > +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> > +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> > +#define atomic_inc_wrap(v) atomic_inc(v)
> > +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> > +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> > +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> > +#define atomic_dec_wrap(v) atomic_dec(v)
> > +#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> > +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> > +#define atomic_long_sub_and_test_wrap(i, v) atomic_long_sub_and_test(i, v)
> 
> removing this definition (atomic_long_sub_and_test_wrap) in
> the original location and
> 
> > 
> > +#endif /* CONFIG_HARDENED_ATOMIC */
> > +
> >  #define ATOMIC_LONG_READ_OP(mo, suffix)						\
> >  static inline long atomic_long_read##mo##suffix(const atomic_long##suffix##_t *l)\
> >  {									\
> > @@ -233,12 +249,14 @@ static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
> >  	return ATOMIC_LONG_PFX(_sub_and_test)(i, v);
> >  }
> >  
> > +#ifdef CONFIG_HARDENED_ATOMIC
> removing this guard would work both for HARDENED_ATOMIC and
> !HARDENED_ATOMIC.
> 
> Anyway, IMO, we should (and can) generate _wrap version of definitions
> in a more systematic way to cover whole functions.

Absolutely, thanks. I will remove them and re-test this evening.

Besides, I actually try to be must generic possible (I don't know in
arm64, but in arm most of atomic functions are generated via macro).
Still, I fall down on some specific cases. For instance, we need to
guard atomic_inc_return_wrap in the ifndef bloc (it is missing in my
previous patch) since the definition is made via a macro in arm (via
atomic_inc_return_wrap_relaxed, which will define and generate
atomic_inc_return_wrap in include/linux/atomic.h).

Except if there is a big unexpected problem, I will send a RFC this
week (overflow detection begin to works in my first attempt), I would
be grateful if there is a nicer solution to those problem :-)

Thanks!

Colin
