Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 14:38:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170118143815.GG3231@leverpostej>
References: <20170118135310.GA4733@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170118135310.GA4733@pjb1027-Latitude-E5410>
Subject: [kernel-hardening] Re: [PATCH] ARM: mm: add testcases for RODATA
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux@armlinux.org.uk, will.deacon@arm.com, mingo@kernel.org, andy.gross@linaro.org, keescook@chromium.org, vladimir.murzin@arm.com, f.fainelli@gmail.com, pawel.moll@arm.com, jonathan.austin@arm.com, ard.biesheuvel@linaro.org, labbott@redhat.com, arjan@linux.intel.com, paul.gortmaker@windriver.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kernel-janitors@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 10:53:10PM +0900, Jinbum Park wrote:
> This patch adds testcases for the CONFIG_DEBUG_RODATA option.
> It's similar to x86's testcases.
> It tests read-only mapped data and page-size aligned rodata section.

I note that LKDTM already has a similar test (though it just has a raw
write, and will crash the kernel).

> +	asm volatile(
> +		"0:	str %[zero], [%[rodata_test]]\n"
> +		"	mov %[rslt], %[zero]\n"
> +		"1:\n"
> +		".pushsection .text.fixup,\"ax\"\n"
> +		".align 2\n"
> +		"2:\n"
> +		"b 1b\n"
> +		".popsection\n"
> +		".pushsection __ex_table,\"a\"\n"
> +		".align 3\n"
> +		".long 0b, 2b\n"
> +		".popsection\n"
> +		: [rslt] "=r" (result)
> +		: [zero] "r" (0UL), [rodata_test] "r" (&rodata_test_data)
> +	);

This is the only architecture-specific part of the file.

Rather than duplicating the logic from x86, can't we use generic
infrastructure for this part, and move the existing test into a shared
location?

e.g. could we change to KERNEL_DS and use put_user here?

> +	if (!result) {
> +		pr_err("rodata_test: test data was not read only\n");
> +		return -ENODEV;
> +	}
> +
> +	/* test 3: check the value hasn't changed */
> +	/* If this test fails, we managed to overwrite the data */
> +	if (!rodata_test_data) {
> +		pr_err("rodata_test: Test 3 fails (end data)\n");
> +		return -ENODEV;
> +	}
> +
> +	/* test 4: check if the rodata section is 4Kb aligned */
> +	start = (unsigned long)__start_rodata;
> +	end = (unsigned long)__end_rodata;
> +	if (start & (PAGE_SIZE - 1)) {
> +		pr_err("rodata_test: .rodata is not 4k aligned\n");
> +		return -ENODEV;
> +	}
> +	if (end & (PAGE_SIZE - 1)) {
> +		pr_err("rodata_test: .rodata end is not 4k aligned\n");
> +		return -ENODEV;
> +	}

s/4k/page/ in the prints, if this becomes generic.

Thanks,
Mark.
