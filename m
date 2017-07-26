References: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <0816933d-7e58-0773-1441-891823983ff9@huawei.com>
Date: Wed, 26 Jul 2017 12:11:52 +0800
MIME-Version: 1.0
In-Reply-To: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v2] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, keescook@chromium.org, mark.rutland@arm.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard，


on 2017/7/26 2:15, Ard Biesheuvel wrote:
> +#define REFCOUNT_OP(op, asm_op, cond, l, clobber...)			\
> +__LL_SC_INLINE int							\
> +__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))			\
> +{									\
> +	unsigned long tmp;						\
> +	int result;							\
> +									\
> +	asm volatile("// refcount_" #op "\n"				\
> +"	prfm		pstl1strm, %2\n"				\
> +"1:	ldxr		%w0, %2\n"					\
> +"	" #asm_op "	%w0, %w0, %w[i]\n"				\
> +"	st" #l "xr	%w1, %w0, %2\n"					\
> +"	cbnz		%w1, 1b\n"					\
> +	REFCOUNT_CHECK(cond)						\
> +	: "=&r" (result), "=&r" (tmp), "+Q" (r->counter)		\
> +	: REFCOUNT_INPUTS(r) [i] "Ir" (i)				\
> +	clobber);							\
> +									\
> +	return result;							\
> +}									\
> +__LL_SC_EXPORT(__refcount_##op);
> +
> +REFCOUNT_OP(add_lt, adds, mi,  , REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_lt_neg, adds, mi, l, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_le_neg, adds, ls, l, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_lt, subs, mi, l, REFCOUNT_CLOBBERS);
> +REFCOUNT_OP(sub_le, subs, ls, l, REFCOUNT_CLOBBERS);
> +
I'm not quite sure if we use b.lt to judge whether the result of adds is 
less than zero is correct or not.
The b.lt means N!=V, take an extreme example, if we operate like below, 
the b.lt will also be true.

refcount_set(&ref_c,0x80000000);
refcount_dec_and_test(&ref_c);

maybe we should use PL/NE/MI/EQ to judge the LT_ZERO or LE_ZERO condition ?

-- 
Best Regards
Li Kun
