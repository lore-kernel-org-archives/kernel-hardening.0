Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 1 Nov 2016 14:55:16 +0200
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161101125516.qwf5ccaun2nd3qvi@thigreal>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
 <1478001210.2236.28.camel@cvidal.org>
 <2236FBA76BA1254E88B949DDB74E612B41BFAD4B@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BFAD4B@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Colin Vidal <colin@cvidal.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 01, 2016 at 12:15:25PM +0000, Reshetova, Elena wrote:
> >Hi (again :-)) Elena, Hans,
> 
> > diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> <snip>
> > +#ifndef atomic_cmpxchg_wrap
> > +#define  atomic_cmpxchg_wrap(...)				\
> > +	__atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__) #endif
> >  #endif /* atomic_cmpxchg_relaxed */
> > 
> 
> >I have a problem here. With ARMv7 (without any of my patches), I have a
> >implicit declaration of atomic_cmpxchg_wrap. Perhaps something like
> 
> >    #ifndef atomic_cmpxchg_wrap_relaxed
> >    #define atomic_cmpxchg_wrap_relaxed atomic_cmpxchg_wrap
> 
> >is missing? I didn't follow the recent changes of that part, so I am
> >not quite sure...
> 
> >Thanks!
> 
> >Colin
> 
> >In file included from ./include/linux/spinlock.h:406:0,
>                  from ./include/linux/seqlock.h:35,
>                  from ./include/linux/time.h:5,
>                  from ./include/linux/stat.h:18,
>                  from ./include/linux/module.h:10,
>                  from net/ipv4/route.c:67:
> >net/ipv4/route.c: In function ‘ip_idents_reserve’:
> >./include/linux/atomic.h:459:20: error: implicit declaration of function ‘atomic_cmpxchg_wrap_relaxed’ [-Werror=implicit-function-declaration]
>   __atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
>                     ^
> >./include/linux/atomic.h:62:9: note: in definition of macro ‘__atomic_op_fence’
>  > typeof(op##_relaxed(args)) __ret;    \
>          ^~
> >net/ipv4/route.c:488:11: note: in expansion of macro ‘atomic_cmpxchg_wrap’
> >  } while (atomic_cmpxchg_wrap(p_id, old, new) != old);
> 
> Oh, I think this is because we don't have atomic_cmpxchg_wrap_relaxed defined neither atomic_xchg_wrap_relaxed. Wonder why this doesn't show up on x86, I did many builds without our x86 changes to verify. 
> Hans could you please handle this change today to unblock Colin? 

Could have been this was an error that didn't show up on x86, but not sure why
cmpxchg and xchg wasn't guarded as the other atomic_*_relaxed functions. This
whole section is a bit iffy, the aim is to be analogous to the non-wrap relaxed
functions, but without actually having relaxed_wrap functions, so basically
these probably always just end up defining the _wrap_relaxed as _wrap functions.

I've committed a possible "fix". But I cannot confirm since I don't see the
error on my build setups.

BR,
-hans

> 
> Actually this brings us to the fact that we tried to stay away from various relaxed/acquire/release functions (in providing default wrap implementations), but it seems that they are also needed...
> Sigh.. This grows bigger and bigger every day. I hope atomic doesn't plan to come with more functions in the nearest future :)
> 
> Kees, what is your opinion on relaxed/acquire/release coverage?
> 
> Best Regards,
> Elena. 
