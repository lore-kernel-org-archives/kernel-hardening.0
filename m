References: <20170731120144.14214-1-ard.biesheuvel@linaro.org>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <a0b6690d-039e-04ed-9847-b4521935375f@huawei.com>
Date: Mon, 31 Jul 2017 21:17:40 +0800
MIME-Version: 1.0
In-Reply-To: <20170731120144.14214-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v3] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, keescook@chromium.org, mark.rutland@arm.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>



在 2017/7/31 20:01, Ard Biesheuvel 写道:
> +static __always_inline __must_check bool refcount_add_not_zero(unsigned int i,
> +							       refcount_t *r)
> +{
> +	unsigned long tmp;
> +	int result;
> +
> +	asm volatile("// refcount_add_not_zero \n"
> +"	prfm		pstl1strm, %2\n"
> +"1:	ldxr		%w[val], %2\n"
> +"	cbz		%w[val], 2f\n"
> +"	adds		%w[val], %w[val], %w[i]\n"
> +"	stxr		%w1, %w[val], %2\n"
> +"	cbnz		%w1, 1b\n"
> +	REFCOUNT_POST_CHECK_NEG
> +"2:"
> +	: [val] "=&r" (result), "=&r" (tmp), "+Q" (r->refs.counter)
> +	: REFCOUNT_INPUTS(&r->refs) [i] "Ir" (i)
> +	: REFCOUNT_CLOBBERS);
> +
> +	return result != 0;
> +}
> +
Could we use "cas" here instead of ll/sc ?

-- 
Best Regards
Li Kun
