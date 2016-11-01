Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477993456.2236.7.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 01 Nov 2016 10:44:16 +0100
In-Reply-To: <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
	 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Elena,

> +As mentioned above, HARDENED_ATOMIC modifies the atomic_t API to provide its
> +protections. Following is a description of the functions that have been
> +modified.
> +
> +Benchmarks show that no measurable performance difference occurs when
> +HARDENED_ATOMIC is enabled.
> +
> +First, the type atomic_wrap_t needs to be defined for those kernel users who
> +want an atomic type that may be allowed to overflow/wrap (e.g. statistical
> +counters). Otherwise, the built-in protections (and associated costs) for
> +atomic_t would erroneously apply to these non-reference counter users of
> +atomic_t:
> +
> +  * include/linux/types.h: define atomic_wrap_t and atomic64_wrap_t
> +
> +Next, we define the mechanism for reporting an overflow of a protected 
> +atomic type:
> +
> +  * kernel/panic.c: void hardened_atomic_overflow(struct pt_regs)
> +

<snip>

> diff --git a/include/linux/types.h b/include/linux/types.h
> index baf7183..b47a7f8 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -175,10 +175,27 @@ typedef struct {
>  	int counter;
>  } atomic_t;
>  
> +#ifdef CONFIG_HARDENED_ATOMIC
> +typedef struct {
> +	int counter;
> +} atomic_wrap_t;
> +#else
> +typedef atomic_t atomic_wrap_t;
> +#endif
> +
>  #ifdef CONFIG_64BIT
>  typedef struct {
>  	long counter;
>  } atomic64_t;
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +typedef struct {
> +	long counter;
> +} atomic64_wrap_t;
> +#else
> +typedef atomic64_t atomic64_wrap_t;
> +#endif
> +
>  #endif
>  

I still think it would be a good idea to always distinct atomic*_wrap_t
and atomic_t. Otherwise, it is possible to mix those two types without
getting any error, if CONFIG_HARDENED_ATOMIC is disabled (no big deal
in that case, since there is no protection anyways, but it is quite
unclean...). What do you think?

Thanks

Colin
