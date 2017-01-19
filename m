Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 15:57:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170119155701.GA24654@leverpostej>
References: <20170119145114.GA19772@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119145114.GA19772@pjb1027-Latitude-E5410>
Subject: [kernel-hardening] Re: [PATCH] mm: add arch-independent testcases for RODATA
To: Jinbum Park <jinb.park7@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, keescook@chromium.org, arjan@linux.intel.com, akpm@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, labbott@redhat.com, kernel-hardening@lists.openwall.com, kernel-janitors@vger.kernel.org, linux@armlinux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 19, 2017 at 11:51:14PM +0900, Jinbum Park wrote:
> This patch adds arch-independent testcases for RODATA.
> Both x86 and x86_64 already have testcases for RODATA,
> But they are arch-specific because using inline assembly directly.
> 
> and cacheflush.h is not suitable location for rodata-test related things.
> Since they were in cacheflush.h,
> If someone change the state of CONFIG_DEBUG_RODATA_TEST,
> It cause overhead of kernel build.
> 
> To solve above issue,
> write arch-independent testcases and move it to shared location. (main.c)

This is clearly a rework and move of the existing x86 test, and not the
addition of a completely new test (see Arjan's comment about his credit
being removed...).

I would recommend that you turn this into a series that makes the x86
code generic, then moves it out into a common location where it can be
used by others. e.g.

1) make the test use put_user()
2) move the rodata_test() call and the prototype to a common location
3) move the test out to mm/ (with no changes to the file itself)

Otherwise, comments below.

> diff --git a/mm/rodata_test.c b/mm/rodata_test.c
> new file mode 100644
> index 0000000..d5b0504
> --- /dev/null
> +++ b/mm/rodata_test.c
> @@ -0,0 +1,63 @@
> +/*
> + * rodata_test.c: functional test for mark_rodata_ro function
> + *
> + * (C) Copyright 2017 Jinbum Park <jinb.park7@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +#include <asm/uaccess.h>
> +#include <asm/sections.h>
> +
> +const int rodata_test_data = 0xC3;
> +EXPORT_SYMBOL_GPL(rodata_test_data);
> +
> +void rodata_test(void)
> +{
> +	unsigned long start, end, rodata_addr;
> +	int zero = 0;
> +
> +	/* prepare test */
> +	rodata_addr = ((unsigned long)&rodata_test_data);
> +
> +	/* test 1: read the value */
> +	/* If this test fails, some previous testrun has clobbered the state */
> +	if (!rodata_test_data) {
> +		pr_err("rodata_test: test 1 fails (start data)\n");
> +		return;
> +	}
> +
> +	/* test 2: write to the variable; this should fault */
> +	/*
> +	 * This must be written in assembly to be able to catch the
> +	 * exception that is supposed to happen in the correct case.
> +	 *
> +	 * So that put_user macro is used to write arch-independent assembly.
> +	 */
> +	if (!put_user(zero, (int *)rodata_addr)) {
> +		pr_err("rodata_test: test data was not read only\n");
> +		return;
> +	}

As I mentioned in the original posting, you need to change to KERNEL_DS
for the put_user.

Russell's suggestion to use probe_kernel_write() is strictly better;
please do that instead.

Thanks,
Mark.
