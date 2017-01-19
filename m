Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 15:46:58 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170119154658.GD27312@n2100.armlinux.org.uk>
References: <20170119153920.GA20363@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119153920.GA20363@pjb1027-Latitude-E5410>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] mm: add arch-independent testcases for RODATA
To: Jinbum Park <jinb.park7@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, keescook@chromium.org, arjan@linux.intel.com, akpm@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, labbott@redhat.com, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, kernel-janitors@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 12:39:20AM +0900, Jinbum Park wrote:
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index afcc550..e4f22ce 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -90,3 +90,9 @@ config DEBUG_PAGE_REF
>  	  careful when enabling this feature because it adds about 30 KB to the
>  	  kernel code.  However the runtime performance overhead is virtually
>  	  nil until the tracepoints are actually enabled.
> +
> +config DEBUG_RODATA_TEST
> +	bool "Testcase for the marking rodata read-only"
> +	depends on DEBUG_RODATA
> +	---help---
> +	  This option enables a testcase for the setting rodata read-only.
> \ No newline at end of file

It's worth reviewing your own patches before sending them out for
things like this (please ensure that all files are not left without
a newline at the end.)

> diff --git a/mm/rodata_test.c b/mm/rodata_test.c
> new file mode 100644
> index 0000000..fb953c0
> --- /dev/null
> +++ b/mm/rodata_test.c
> @@ -0,0 +1,64 @@
> +/*
> + * rodata_test.c: functional test for mark_rodata_ro function
> + *
> + * (C) Copyright 2008 Intel Corporation
> + * Author: Arjan van de Ven <arjan@linux.intel.com>
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

I don't think this is going to do what you think - at least not on sane
architectures.  put_user() to kernel space is denied, even if the
location is writable to normal accesses within the kernel.

put_user() and get_user() are for accessing user supplied pointers,
which means it has built-in security to prevent userspace passing in
kernel-space pointers and using that as a way to read or modify kernel
space.

I think you want to use probe_kernel_write() here.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
