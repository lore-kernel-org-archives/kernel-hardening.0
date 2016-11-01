Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1478001210.2236.28.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 01 Nov 2016 12:53:30 +0100
In-Reply-To: <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
	 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi (again :-)) Elena, Hans,

> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
<snip>
> +#ifndef atomic_cmpxchg_wrap
> +#define  atomic_cmpxchg_wrap(...)				\
> +	__atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
> +#endif
>  #endif /* atomic_cmpxchg_relaxed */
> 

I have a problem here. With ARMv7 (without any of my patches), I have a
implicit declaration of atomic_cmpxchg_wrap. Perhaps something like

    #ifndef atomic_cmpxchg_wrap_relaxed
    #define atomic_cmpxchg_wrap_relaxed atomic_cmpxchg_wrap

is missing? I didn't follow the recent changes of that part, so I am
not quite sure...

Thanks!

Colin

In file included from ./include/linux/spinlock.h:406:0,
                 from ./include/linux/seqlock.h:35,
                 from ./include/linux/time.h:5,
                 from ./include/linux/stat.h:18,
                 from ./include/linux/module.h:10,
                 from net/ipv4/route.c:67:
net/ipv4/route.c: In function ‘ip_idents_reserve’:
./include/linux/atomic.h:459:20: error: implicit declaration of function ‘atomic_cmpxchg_wrap_relaxed’ [-Werror=implicit-function-declaration]
  __atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
                    ^
./include/linux/atomic.h:62:9: note: in definition of macro ‘__atomic_op_fence’
  typeof(op##_relaxed(args)) __ret;    \
         ^~
net/ipv4/route.c:488:11: note: in expansion of macro ‘atomic_cmpxchg_wrap’
  } while (atomic_cmpxchg_wrap(p_id, old, new) != old);
