MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170816211636.4zwublkvpn6hbo5n@smitten>
References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten> <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
 <20170816211636.4zwublkvpn6hbo5n@smitten>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 16 Aug 2017 15:16:13 -0700
Message-ID: <CAGXu5j+qe052JAcZUe7mOBHAXNCdLT1z4U-2kRxoeJXyL6VxDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 16, 2017 at 2:16 PM, Tycho Andersen <tycho@docker.com> wrote:
> Hi Alexander,
>
> On Wed, Aug 16, 2017 at 11:47:44PM +0300, Alexander Popov wrote:
>> Hello Tycho,
>>
>> On 15.08.2017 06:38, Tycho Andersen wrote:
>> > On Wed, Jul 12, 2017 at 09:17:51PM +0300, Alexander Popov wrote:
>> >> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> >> +void __used track_stack(void)
>> >> +{
>> >> +  unsigned long sp = (unsigned long)&sp;
>> >> +
>> >> +  if (sp < current->thread.lowest_stack &&
>> >> +      sp >= (unsigned long)task_stack_page(current) +
>> >> +                                  2 * sizeof(unsigned long)) {
>> >> +          current->thread.lowest_stack = sp;
>> >> +  }
>> >> +
>> >> +  if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
>> >
>> > I think this check is wrong, the lhs should be
>> > (sp & (THREAD_SIZE - 1)). Otherwise, we just check that the upper bits
>> > of the stack are < THREAD_SIZE / 16, which they never will be.
>>
>> Thank you, I think you are right!
>>
>> I can additionally notice that this erroneous check is not a part of PaX patch,
>> it is introduced by Grsecurity patch.
>>
>> Thanks again, I'll fix and annotate it in the next version of the patch.
>>
>> Did you manage to create a test for the correct check which hits the BUG()?
>
> Yes, see below. I've fixed all of the review feedback from the last
> time I posted it too. Feel free to add it to your tree and post it w/ the
> next version if that makes the most sense.
>
> Cheers,
>
> Tycho
>
>
> From 2c8a8f96a331b63e3aa52388fab9f111c516bf1c Mon Sep 17 00:00:00 2001
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
> Signed-off-by: Tycho Andersen <tycho@docker.com>
> ---
>  drivers/misc/Makefile          |   1 +
>  drivers/misc/lkdtm.h           |   4 ++
>  drivers/misc/lkdtm_core.c      |   2 +
>  drivers/misc/lkdtm_stackleak.c | 135 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 142 insertions(+)
>
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 81ef3e67acc9..805e4f06011a 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -61,6 +61,7 @@ lkdtm-$(CONFIG_LKDTM)         += lkdtm_heap.o
>  lkdtm-$(CONFIG_LKDTM)          += lkdtm_perms.o
>  lkdtm-$(CONFIG_LKDTM)          += lkdtm_rodata_objcopy.o
>  lkdtm-$(CONFIG_LKDTM)          += lkdtm_usercopy.o
> +lkdtm-$(CONFIG_LKDTM)          += lkdtm_stackleak.o
>
>  KCOV_INSTRUMENT_lkdtm_rodata.o := n
>
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index 3b4976396ec4..3b67cc4a070b 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -64,4 +64,8 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
>  void lkdtm_USERCOPY_STACK_BEYOND(void);
>  void lkdtm_USERCOPY_KERNEL(void);
>
> +/* lkdtm_stackleak.c */
> +void lkdtm_STACKLEAK_ALLOCA(void);
> +void lkdtm_STACKLEAK_BIG_FRAME(void);
> +
>  #endif
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 42d2b8e31e6b..f42b346bdf5c 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -235,6 +235,8 @@ struct crashtype crashtypes[] = {
>         CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
>         CRASHTYPE(USERCOPY_STACK_BEYOND),
>         CRASHTYPE(USERCOPY_KERNEL),
> +       CRASHTYPE(STACKLEAK_ALLOCA),
> +       CRASHTYPE(STACKLEAK_BIG_FRAME),
>  };
>
>
> diff --git a/drivers/misc/lkdtm_stackleak.c b/drivers/misc/lkdtm_stackleak.c
> new file mode 100644
> index 000000000000..daae36e0432e
> --- /dev/null
> +++ b/drivers/misc/lkdtm_stackleak.c
> @@ -0,0 +1,135 @@
> +/*
> + * This file tests a few aspects of the stackleak compiler plugin:
> + *   - the current task stack somewhere below lowest_stack is properly canaried
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
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK

I'd like tests to fail if the given config options are missing. That
way we're always running the same test code, but it's only the kernel
that is changing. If it's just STACKLEAK_POISON missing, we can just
#ifndef that and insert it manually here.

> +static bool check_poison(unsigned long *ptr, unsigned long n)
> +{
> +       unsigned long i;
> +
> +       for (i = 1; i < n; i++) {
> +               if (*(ptr - i) != STACKLEAK_POISON)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +static bool check_my_stack(void)
> +{
> +       unsigned long *lowest, left, i;
> +
> +       lowest = &i;
> +       if ((unsigned long *) current->thread.lowest_stack < lowest)
> +               lowest = (unsigned long *) current->thread.lowest_stack;
> +
> +       left = (unsigned long) lowest % THREAD_SIZE;
> +
> +       /* See note in arch/x86/entry/entry_64.S about the or; the bottom two
> +        * qwords are not
> +        */

Comment style nit: Please use opening blank "/*" line:

/*
 * See note in arch/x86/entry/entry_64.S about the or; the bottom two
 * qwords are not.
 */

> +       left -= 2 * sizeof(unsigned long);
> +
> +       /* let's count the number of canaries, not bytes */
> +       left /= sizeof(unsigned long);
> +
> +       for (i = 0; i < left; i++) {
> +               if (*(lowest - i) != STACKLEAK_POISON)
> +                       continue;
> +
> +               if (i > 32)
> +                       pr_warn_once("More than 256 bytes not canaried?");

Why the _once part here?

> +
> +               if (!check_poison(lowest - i, 16))
> +                       continue;
> +
> +               break;
> +       }
> +
> +       if (i == left) {
> +               pr_warn("didn't find canary?");
> +               return false;
> +       }
> +
> +       if (check_poison((unsigned long *) lowest - i, left - i)) {
> +               pr_info("current stack poisoned correctly\n");
> +               return true;
> +       } else {
> +               pr_err("current stack not poisoned correctly\n");
> +               return false;
> +       }
> +}
> +#else
> +bool check_my_stack(void)
> +{
> +       return false;
> +}
> +#endif
> +
> +static noinline void do_alloca(unsigned long size, void (*todo)(void))
> +{
> +       char buf[size];
> +
> +       if (todo)
> +               todo();
> +
> +       /* so this doesn't get inlined or optimized out */
> +       snprintf(buf, size, "hello world\n");
> +}
> +
> +/* Check the BUG() in check_alloca() */
> +void lkdtm_STACKLEAK_ALLOCA(void)
> +{
> +       unsigned long left = (unsigned long) &left % THREAD_SIZE;
> +
> +       if (!check_my_stack())
> +               return;
> +
> +       // try a small allocation to see if it works

Please use /* */ comments...

> +       do_alloca(16, NULL);
> +       pr_info("small allocation successful\n");
> +
> +
> +       pr_info("attempting large alloca of %lu\n", left);
> +       do_alloca(left, NULL);
> +       pr_warn("alloca succeded?\n");

Seems like this should be pr_err() since it shows it's a failure.
Maybe be explicit, too:

pr_err("FAIL: large alloca succeeded!\n");

> +}
> +
> +static void use_some_stack(void) {
> +
> +       /* Note: this needs to be a(n exported) function that has track_stack
> +        * inserted, i.e. it isn't in the various sections restricted by
> +        * stackleak_track_stack_gate.
> +        */
> +       security_inode_init_security(NULL, NULL, NULL, NULL, NULL);
> +}
> +
> +/* Note that the way this test fails is kind of ugly; it hits the BUG() in

Comment style nit...

> + * track_stack, but then the BUG() handler blows the stack and hits the stack
> + * guard page.
> + */
> +void lkdtm_STACKLEAK_BIG_FRAME(void)
> +{
> +       unsigned long left = (unsigned long) &left % THREAD_SIZE;
> +
> +       /* use almost all of the stack, minus the buffer space allowed in

Comment style nit...

> +        * track_stack and the space used by track_stack itself
> +        */
> +       do_alloca(left - THREAD_SIZE / 16 - sizeof(unsigned long), use_some_stack);

What should lkdtm report if this do_alloca() succeeds?

> +}
> --
> 2.11.0
>

Thanks for the new tests!

-Kees

-- 
Kees Cook
Pixel Security
