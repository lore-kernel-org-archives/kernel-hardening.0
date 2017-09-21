References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten>
 <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
 <20170816211636.4zwublkvpn6hbo5n@smitten>
 <CAGXu5j+qe052JAcZUe7mOBHAXNCdLT1z4U-2kRxoeJXyL6VxDQ@mail.gmail.com>
 <20170817175807.ejgsrfdgojgbtkwf@smitten>
 <1d0963e6-4a89-9859-5379-8575a925ef08@linux.com>
 <20170920211814.pq43vq3o53nh2xcn@smitten>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <499874eb-48bb-f7f7-176a-b0b1e37cc9c6@linux.com>
Date: Thu, 21 Sep 2017 22:39:02 +0300
MIME-Version: 1.0
In-Reply-To: <20170920211814.pq43vq3o53nh2xcn@smitten>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 21.09.2017 00:18, Tycho Andersen wrote:
> On Wed, Sep 20, 2017 at 02:27:05PM +0300, Alexander Popov wrote:
>> On 17.08.2017 20:58, Tycho Andersen wrote:
>>> From 5cae1f904cd3d813628a5b22ca5fe054b5eb7378 Mon Sep 17 00:00:00 2001
>>> From: Tycho Andersen <tycho@docker.com>
>>> Date: Thu, 8 Jun 2017 12:43:07 -0600
>>> Subject: [PATCH] lkdtm: add a test for STACKLEAK plugin
>>>
>>> There are two tests here, one to test that the BUG() in check_alloca is hit
>>> correctly, and the other to test that the BUG() in track_stack is hit
>>> correctly.
>>>
>>> Ideally we'd also be able to check end-to-end that a syscall results in an
>>> entirely poisoned stack, but I'm not sure how to do a syscall from lkdtm.
>>
>> Could you please elaborate on this? I didn't get the idea.
> 
> Sorry, I realized I never replied to this comment. The idea would be
> to simulate an entire syscall as a user would do, from beginning to
> end, so that we can ensure all the machinery works as it is supposed
> to (i.e. when the syscall returns, we can check that the task's stack
> is completely poisoned).

A quick search gives that Greg's article:
https://www.linuxjournal.com/article/8110
He shows the examples of syscalls from the kernelspace. But it might not be
enough, since the actual stack erasing is happening during kernel -> user
context switch. Do you think the idea is possible at all?

> Below is an updated patch based on your feedback. Thanks!

Please see the comments below.

> From 34f68b92ac2f2a8d770765e47ae3612d5bb29fae Mon Sep 17 00:00:00 2001
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
> 
> v3: * fix whitespace in casts
>     * consistently use FAIL for errors
>     * drop extra whitespace
>     * fix up unaligned stack logic
>     * print the number of unpoisoned bytes on successful check
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
> index 000000000000..8849500e7bc9
> --- /dev/null
> +++ b/drivers/misc/lkdtm_stackleak.c
> @@ -0,0 +1,142 @@
> +/*
> + * This file tests a few aspects of the stackleak compiler plugin:
> + *   - the current task stack is properly canaried

Here and further: maybe "poisoned" or "erased" is better than "canaried" since
STACKLEAK_POISON is not used as a canary.

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
> +static noinline bool check_poison(unsigned long *ptr, unsigned long n)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < n; i++) {
> +		if (*(ptr - i) != STACKLEAK_POISON)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool check_my_stack(void)
> +{
> +	unsigned long *lowest, canaries, left, i;
> +
> +	lowest = &i;
> +	left = (unsigned long)lowest % THREAD_SIZE;
> +
> +	/*
> +	 * See note in arch/x86/entry/entry_64.S about the or; the bottom two
> +	 * qwords are not canaried.
> +	 */

Do you mean "are not poisoned" here? STACK_END_MAGIC at the bottom of the stack
is indeed used as canary.

I would also suggest to make this comment less x86_64-specific, since your test
will be used on other platforms too.

> +	left -= 2 * sizeof(unsigned long);
> +
> +	/*
> +	 * Check each byte, as we don't know the current stack alignment.
> +	 */

Excuse me, what do you mean by the "current stack alignment"?

The STACKLEAK_POISON position is always 8-byte aligned for x86_64 and 4-byte
aligned for x86 (see the shr instruction in the asm implementation).

I would suggest to simply align lowest. In case of unaligned poison, the test
will not find it and report the FAIL (which is correct).

> +	for (i = 0; i < left; i++) {
> +		if (*(lowest - i) != STACKLEAK_POISON)
> +			continue;
> +
> +		if (!check_poison((void *)lowest - i, 16))
> +			continue;
> +
> +		break;
> +	}

You've dropped "left /= sizeof(unsigned long)" and now the logic in this loop is
broken - it gives the kernel crash with disabled STACKLEAK.

IMHO counting like in your v2 is better, you just need to fix the off-by-one error.

> +
> +	if (i == left) {
> +		pr_err("FAIL: didn't find canary?\n");
> +		return false;
> +	}
> +
> +	if (i % sizeof(unsigned long)) {
> +		pr_err("FAIL: unaligned canary?\n");
> +		return false;
> +	}
> +
> +	/*
> +	 * How many canaries (not bytes) do we actually need to check?
> +	 */

Ditto about canaries vs poison values.

> +	canaries = (left - i) / sizeof(unsigned long *);
> +
> +	if (check_poison((void *)lowest - i, canaries)) {
> +		pr_info("stack poisoned correctly, %lu unpoisoned bytes\n", i);
> +		return true;
> +	} else {
> +		pr_err("FAIL: stack not poisoned correctly\n");
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
> +	unsigned long left = (unsigned long)&left % THREAD_SIZE;
> +
> +	if (!check_my_stack())
> +		return;
> +
> +	/* try a small allocation to see if it works */
> +	do_alloca(16, NULL);
> +	pr_info("small allocation successful\n");
> +
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

If we agree on making CONFIG_GCC_PLUGIN_STACKLEAK depend on CONFIG_VMAP_STACK
(and dropping the BUG() in track_stack()), the STACKLEAK_BIG_FRAME test case can
be omitted and there will be only one lkdtm_STACKLEAK test.

> +void lkdtm_STACKLEAK_BIG_FRAME(void)
> +{
> +	unsigned long left = (unsigned long)&left % THREAD_SIZE;
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

Thanks.
Best regards,
Alexander
