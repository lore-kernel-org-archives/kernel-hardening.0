References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten>
 <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
 <20170816211636.4zwublkvpn6hbo5n@smitten>
 <CAGXu5j+qe052JAcZUe7mOBHAXNCdLT1z4U-2kRxoeJXyL6VxDQ@mail.gmail.com>
 <20170817175807.ejgsrfdgojgbtkwf@smitten>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <1d0963e6-4a89-9859-5379-8575a925ef08@linux.com>
Date: Wed, 20 Sep 2017 14:27:05 +0300
MIME-Version: 1.0
In-Reply-To: <20170817175807.ejgsrfdgojgbtkwf@smitten>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Tycho and Kees,

Please see the comments below.

On 17.08.2017 20:58, Tycho Andersen wrote:
> From 5cae1f904cd3d813628a5b22ca5fe054b5eb7378 Mon Sep 17 00:00:00 2001
> From: Tycho Andersen <tycho@docker.com>
> Date: Thu, 8 Jun 2017 12:43:07 -0600
> Subject: [PATCH] lkdtm: add a test for STACKLEAK plugin
> 
> There are two tests here, one to test that the BUG() in check_alloca is hit
> correctly, and the other to test that the BUG() in track_stack is hit
> correctly.
> 
> Ideally we'd also be able to check end-to-end that a syscall results in an
> entirely poisoned stack, but I'm not sure how to do a syscall from lkdtm.

Could you please elaborate on this? I didn't get the idea.

> v2: * use good comment style
>     * drop references to lowest_stack, and #define STACKLEAK_POISON if
>       necessary
>     * drop unnecessary warning about canary space
>     * add error messages, make them explicit, and use pr_err()
> 
> Signed-off-by: Tycho Andersen <tycho@docker.com>

[...]

> diff --git a/drivers/misc/lkdtm_stackleak.c b/drivers/misc/lkdtm_stackleak.c
> new file mode 100644
> index 000000000000..2fa44c641d11
> --- /dev/null
> +++ b/drivers/misc/lkdtm_stackleak.c
> @@ -0,0 +1,133 @@
> +/*
> + * This file tests a few aspects of the stackleak compiler plugin:
> + *   - the current task stack somewhere below lowest_stack is properly canaried

You've dropped the reference to the lowest_stack in v2.

> + *   - small allocas are allowed properly via check_alloca()
> + *   - big allocations that exhaust the stack are BUG()s
> + *   - function calls whose stack frames blow the stack are BUG()s
> + *
> + * Copyright (C) Docker, Inc. 2017
> + *
> + * Author: Tycho Andersen <tycho@docker.com>
> + */
> +
> +#include "lkdtm.h"
> +
> +#include <linux/sched.h>
> +#include <linux/compiler.h>
> +
> +/* for security_inode_init_security */
> +#include <linux/security.h>
> +
> +#ifndef STACKLEAK_POISON
> +# define STACKLEAK_POISON -0xBEEF
> +#endif
> +
> +static bool check_poison(unsigned long *ptr, unsigned long n)
> +{
> +	unsigned long i;
> +
> +	for (i = 1; i < n; i++) {
> +		if (*(ptr - i) != STACKLEAK_POISON)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool check_my_stack(void)
> +{
> +	unsigned long *lowest, left, i;
> +
> +	lowest = &i;
> +	left = (unsigned long) lowest % THREAD_SIZE;

Here and in other places type cast should not have a whitespace after it, right?

> +
> +	/*
> +	 * See note in arch/x86/entry/entry_64.S about the or; the bottom two
> +	 * qwords are not
> +	 */
> +	left -= 2 * sizeof(unsigned long);
> +
> +	/* let's count the number of canaries, not bytes */
> +	left /= sizeof(unsigned long);
> +
> +	for (i = 0; i < left; i++) {
> +		if (*(lowest - i) != STACKLEAK_POISON)
> +			continue;
> +
> +		if (!check_poison(lowest - i, 16))
> +			continue;
> +
> +		break;
> +	}

What do you think about printing the number of bytes between *lowest and the
poisoned part of the stack?

> +
> +	if (i == left) {
> +		pr_warn("didn't find canary?");

Maybe pr_err("FAIL:...") here for the consistency?

> +		return false;
> +	}
> +
> +	if (check_poison((unsigned long *) lowest - i, left - i)) {
> +		pr_info("current stack poisoned correctly\n");

1. You cast here, but didn't do that above.

2. IMO, there is an error here. You don't check one last poison value at the
bottom of the stack. Your loop in check_poison() starts from 1, so it actually
checks (left - i - 1) values.

3. And I would suggest "stack is poisoned correctly".

> +		return true;
> +	} else {
> +		pr_err("current stack not poisoned correctly\n");

I would suggest pr_err("FAIL: stack is not poisoned correctly\n").

> +		return false;
> +	}
> +}
> +
> +static noinline void do_alloca(unsigned long size, void (*todo)(void))
> +{
> +	char buf[size];
> +
> +	if (todo)
> +		todo();
> +
> +	/* so this doesn't get inlined or optimized out */
> +	snprintf(buf, size, "hello world\n");
> +}
> +
> +/* Check the BUG() in check_alloca() */
> +void lkdtm_STACKLEAK_ALLOCA(void)
> +{
> +	unsigned long left = (unsigned long) &left % THREAD_SIZE;
> +
> +	if (!check_my_stack())
> +		return;
> +
> +	/* try a small allocation to see if it works */
> +	do_alloca(16, NULL);
> +	pr_info("small allocation successful\n");
> +
> +

Two blank lines here.

> +	pr_info("attempting large alloca of %lu\n", left);
> +	do_alloca(left, NULL);
> +	pr_err("FAIL: large alloca succeded!\n");
> +}
> +
> +static void use_some_stack(void) {
> +
> +	/*
> +	 * Note: this needs to be a(n exported) function that has track_stack
> +	 * inserted, i.e. it isn't in the various sections restricted by
> +	 * stackleak_track_stack_gate.
> +	 */
> +	security_inode_init_security(NULL, NULL, NULL, NULL, NULL);
> +}
> +
> +/*
> + * Note that the way this test fails is kind of ugly; it hits the BUG() in
> + * track_stack, but then the BUG() handler blows the stack and hits the stack
> + * guard page.
> + */

Yes, actually, the reason is deeper.

When there are less than (THREAD_SIZE / 16) bytes left in the kernel stack, the
BUG() in track_stack() is hit. But do_error_trap(), which handles the invalid
opcode, has a big stack frame. So it is instrumented by the STACKLEAK gcc plugin
and itself calls track_stack() at the beginning. Hence we have a recursive
BUG(), which eventually hits the guard page.

I banned the instrumentation of do_error_trap() in the plugin, but it didn't
really help, since there are several other instrumented functions called during
BUG() handling.

So it seems to me that this BUG() in track_stack() is really useless and can be
dropped. Moreover:
 - it is not a part of the PaX patch;
 - it never worked in Grsecurity kernel because of the error spotted by Tycho.

What do you think about it?

> +void lkdtm_STACKLEAK_BIG_FRAME(void)
> +{
> +	unsigned long left = (unsigned long) &left % THREAD_SIZE;
> +
> +	if (!check_my_stack())
> +		return;
> +
> +	/*
> +	 * use almost all of the stack up to the padding allowed by track_stack
> +	 */
> +	do_alloca(left - THREAD_SIZE / 16 - 1, use_some_stack);
> +	pr_err("FAIL: stack frame should have blown stack!\n");
> +}
> 

Best regards,
Alexander
