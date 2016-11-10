Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 21:40:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110204046.GW3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
>  static __always_inline void atomic_add(int i, atomic_t *v)
>  {
> +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +		     "jno 0f\n"
> +		     LOCK_PREFIX "subl %1,%0\n"
> +		     "int $4\n0:\n"
> +		     _ASM_EXTABLE(0b, 0b)


This is unreadable gunk.

> +#endif
> +
>  		     : "+m" (v->counter)
>  		     : "ir" (i));
>  }
