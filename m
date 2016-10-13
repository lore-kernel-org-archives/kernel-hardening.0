Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476385184.18441.73.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Thu, 13 Oct 2016 20:59:44 +0200
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDE37B@IRSMSX102.ger.corp.intel.com>
References: <1476301332.19131.24.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BDE37B@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: atomic64_wrap_t generic implementation
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Elena,

On Thu, 2016-10-13 at 17:25 +0000, Reshetova, Elena wrote:
> Hi Colin, 
> 
> diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h index dad68bf..4987419 100644
> --- a/include/asm-generic/atomic64.h
> +++ b/include/asm-generic/atomic64.h
> @@ -16,6 +16,8 @@ typedef struct {
>         long long counter;
>  } atomic64_t;
>  
> +typedef atomic64_t atomic64_wrap_t;
> +
>  #define ATOMIC64_INIT(i)       { (i) }
>  
>  extern long long atomic64_read(const atomic64_t *v); @@ -62,4 +64,15 @@ extern int    atomic64_add_unless(atomic64_t *v, long long a, long long u);
>  #define atomic64_dec_and_test(v)       (atomic64_dec_return((v)) == 0)
>  #define atomic64_inc_not_zero(v)       atomic64_add_unless((v), 1LL, 0LL)
>  
> +#define atomic64_read_wrap(v) atomic64_read(v) #define 
> +atomic64_set_wrap(v, i) atomic64_set((v), (i)) #define 
> +atomic64_add_wrap(a, v) atomic64_add((a), (v)) #define 
> +atomic64_add_return_wrap(a, v) atomic64_add_return((a), (v)) #define 
> +atomic64_sub_wrap(a, v) atomic64_sub((a), (v)) #define 
> +atomic64_inc_wrap(v) atomic64_inc(v) #define 
> +atomic64_inc_return_wrap(v) atomic64_inc_return(v) #define 
> +atomic64_dec_wrap(v) atomic64_dec(v) #define atomic64_cmpxchg_wrap(v, 
> +o, n) atomic64_cmpxchg((v), (o), (n)) #define atomic64_xchg_wrap(v, n) 
> +atomic64_xchg((v), (n))
> 
> > 
> > Isen't there a type error ? For instance:
> > atomic64_wrap_t atom_wrap;
> > atomic64_read_wrap(atom_wrap) will be expanded into atomic64_read(atom_wrap), which would lead to a type error (atomic64_t expected).
> 
> I have been double checking this now and I think for x86, all the changes in asm-generic/atomic64.h are not needed. 
> X86 overrides them with arch. specific implementations in include/asm/atomic64_64.h and include/asm/atomic64_32.h
> 

Arghhh sorry, I was confused about the type error I was talking about,
of course the previous code obviously correct...

> Takahiro, you have been looking into arm. Are the above ones used in any way in arm or can we simply get rid of the whole bundle of changes?
> 

I can't tell for ARM64, but I note that ARM has its own implementation
of atomic64 only if CONFIG_GENERIC_ATOMIC64 is unset. It can be set
according to arch/arm/Kconfig:

select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)

Anyways, some architectures uses asm-generic/atomic64.h without guards
(metatag, microblaze, sparc32), so I supposed it is mandatory to keep
those macros.

Best regards,

Colin
