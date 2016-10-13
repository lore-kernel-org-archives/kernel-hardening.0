Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDE37B@IRSMSX102.ger.corp.intel.com>
References: <1476301332.19131.24.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BDE37B@IRSMSX102.ger.corp.intel.com>
From: David Windsor <dwindsor@gmail.com>
Date: Thu, 13 Oct 2016 15:21:27 -0400
Message-ID: <CAEXv5_h_N2VjHnjZHgNovwcJtKgObD6=jPsJjitLf61m_UEV+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] RE: atomic64_wrap_t generic implementation
To: kernel-hardening@lists.openwall.com
Cc: Colin Vidal <colin@cvidal.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, paulus@samba.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 13, 2016 at 1:25 PM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> Hi Colin,
>
> diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h index dad68bf..4987419 100644
> --- a/include/asm-generic/atomic64.h
> +++ b/include/asm-generic/atomic64.h
> @@ -16,6 +16,8 @@ typedef struct {
>         long long counter;
>  } atomic64_t;
>
> +typedef atomic64_t atomic64_wrap_t;
> +
>  #define ATOMIC64_INIT(i)       { (i) }
>
>  extern long long atomic64_read(const atomic64_t *v); @@ -62,4 +64,15 @@ extern int    atomic64_add_unless(atomic64_t *v, long long a, long long u);
>  #define atomic64_dec_and_test(v)       (atomic64_dec_return((v)) == 0)
>  #define atomic64_inc_not_zero(v)       atomic64_add_unless((v), 1LL, 0LL)
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
>>Isen't there a type error ? For instance:
>>atomic64_wrap_t atom_wrap;
>>atomic64_read_wrap(atom_wrap) will be expanded into atomic64_read(atom_wrap), which would lead to a type error (atomic64_t expected).
>
> I have been double checking this now and I think for x86, all the changes in asm-generic/atomic64.h are not needed.
> X86 overrides them with arch. specific implementations in include/asm/atomic64_64.h and include/asm/atomic64_32.h
>
> Takahiro, you have been looking into arm. Are the above ones used in any way in arm or can we simply get rid of the whole bundle of changes?
>

I think it best to leave the definitions in asm-generic/atomic64.h.
While not used on x86, there are other architectures lacking 64-bit
atomic operations that need this definition of atomic64_t (and its
associated implementation with hashed spinlocks): this original
feature was added in support of the perf_counter subsystem [1]; yet
another perf-related exception.  If we want the support of
HARDENED_ATOMIC to extend to these other architectures, I think we
should leave this in there.

[1] https://lwn.net/Articles/337534/

> Best Regards,
> Elena.
>
>
