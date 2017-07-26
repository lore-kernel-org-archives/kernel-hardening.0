References: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <b3c2f9b4-8cf2-6290-ad2b-2acbbb3b28cd@huawei.com>
Date: Wed, 26 Jul 2017 11:32:55 +0800
MIME-Version: 1.0
In-Reply-To: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, keescook@chromium.org, mark.rutland@arm.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

on 2017/7/26 2:15, Ard Biesheuvel wrote:
> +static __always_inline __must_check int __refcount_add_unless(refcount_t *r,
> +							      int a, int u)
> +{
> +	int c, new;
> +
> +	c = atomic_read(&(r->refs));
> +	do {
> +		if (unlikely(c == u))
> +			break;
> +
> +		asm volatile(
> +			"adds	%0, %0, %2	;"
> +			REFCOUNT_CHECK(lt)
> +			: "=r" (new)
> +			: "0" (c), "Ir" (a),
> +			  [counter] "r" (&r->refs.counter),
> +			  [brk_imm] "i" (REFCOUNT_BRK_IMM)
> +			: "cc", "x16", "x17");
> +
> +	} while (!atomic_try_cmpxchg(&(r->refs), &c, new));
> +
> +	return c;
> +}
> +
As my reply to Kee's v8 patch,  the logic here is a little incorrect, if 
we saturate the

r->refs.counter and return from the exception, the value of "new" is not changed
and will be written back to the refcount.
I implement the logic like this, maybe you can take some reference if you find it usefull.

int __refcount_add_unless(refcount_t *r, int a, int u)
{
	int c;
	volatile int new;

	c = atomic_read(&(r->refs));
	do {
		if (unlikely(c == u))
			break;

		asm volatile("adds %w0,%w1,%w2\n"
			: "=&r" (new)
			: "r" (c), "Ir" (a)
			: "memory");
		asm volatile(REFCOUNT_CHECK_LT_ZERO
			::[imm] "i"(REFCOUNT_BRK_IMM),[counter] "r" (&new)
			: "cc", "x19");

	} while (!atomic_try_cmpxchg(&(r->refs), &c, new));

	return c;
}


>   /* This registration must happen early, before debug_traps_init(). */
>   void __init trap_init(void)
>   {
>   	register_break_hook(&bug_break_hook);
> +	register_break_hook(&refcount_break_hook);
>   }
> diff --git a/arch/arm64/lib/atomic_ll_sc.c b/arch/arm64/lib/atomic_ll_sc.c
> index b0c538b0da28..5f038abdc635 100644
> --- a/arch/arm64/lib/atomic_ll_sc.c
> +++ b/arch/arm64/lib/atomic_ll_sc.c
> @@ -1,3 +1,9 @@
>   #include <asm/atomic.h>
>   #define __ARM64_IN_ATOMIC_IMPL
> +#undef REFCOUNT_CHECK
> +#undef REFCOUNT_INPUTS
> +#undef REFCOUNT_CLOBBERS
> +#define REFCOUNT_CHECK(cond)
> +#define REFCOUNT_INPUTS(r)
> +#define REFCOUNT_CLOBBERS : "cc"
>   #include <asm/atomic_ll_sc.h>

-- 
Best Regards
Li Kun
