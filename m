MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170623224820.neo5b4k7dxar5mqs@smitten>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com> <20170623224820.neo5b4k7dxar5mqs@smitten>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Jun 2017 14:33:20 -0700
Message-ID: <CAGXu5jLps0PA6uoRGwb3xo_q9q0NBCh786YJtihVU6a74mvduw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 23, 2017 at 3:48 PM, Tycho Andersen <tycho@docker.com> wrote:
> On Fri, Jun 09, 2017 at 10:28:39AM -0700, Kees Cook wrote:
>> Since this is mostly an anti-exposure defense, LKDTM is probably not a
>> good match (i.e. organizing a test for the uninit variable case can be
>> very fragile). I think something similar to test_user_copy.c would be
>> better.
>
> I think parts of it make sense, e.g. testing that the BUG() in
> check_alloca() is hit (see the patch below). It would be nice to do
> some end-to-end testing of a syscall on this, though. For that to work
> in a kernel module, we'd need to be able to execute a syscall, which
> I've not been able to get to work (but also seems... strange).

Yeah, that portion could be done (as in your patch here).

> One option is to write a kernel module that exposes some device that
> we could do an ioctl(fd, IO_CHECK_STACK_POISON, pid) or something to
> check it, but it's not clear how to fit this into the kernel's current
> testing infrastructure.

Hmm, so one pid would do deep syscall, return and then spin in
userspace so its stack could be examined by another thread? I'm
lacking imagination about how to wire that kind of thing up, though,
as you say.

> From 1a5013cdc8f1520a0b220fe92047817a68e0be21 Mon Sep 17 00:00:00 2001
> From: Tycho Andersen <tycho@docker.com>
> Date: Thu, 8 Jun 2017 12:43:07 -0600
> Subject: [PATCH] lkdtm: add a test for STACKLEAK plugin
>
> This test does two things: it checks that the current syscall's stack (i.e.
> the call that's loading the module) is poisoned correctly and then checks
> that an alloca that will be too large causes a BUG().
>
> Ideally we'd be able to check end-to-end that a syscall results in an
> entirely poisoned stack, but I'm not sure how to do a syscall from lkdtm.

I like this. I think it needs some tweaking, notes below...

> Signed-off-by: Tycho Andersen <tycho@docker.com>
> ---
>  drivers/misc/Makefile          |  1 +
>  drivers/misc/lkdtm.h           |  3 ++
>  drivers/misc/lkdtm_core.c      |  1 +
>  drivers/misc/lkdtm_stackleak.c | 79 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 84 insertions(+)
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
> index 3b4976396ec4..f497c3df1d44 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -64,4 +64,7 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
>  void lkdtm_USERCOPY_STACK_BEYOND(void);
>  void lkdtm_USERCOPY_KERNEL(void);
>
> +/* lkdtm_stackleak.c */
> +void lkdtm_CHECK_STACKLEAK(void);
> +
>  #endif
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 42d2b8e31e6b..0808bf1b37a8 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -235,6 +235,7 @@ struct crashtype crashtypes[] = {
>         CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
>         CRASHTYPE(USERCOPY_STACK_BEYOND),
>         CRASHTYPE(USERCOPY_KERNEL),
> +       CRASHTYPE(CHECK_STACKLEAK),
>  };
>
>
> diff --git a/drivers/misc/lkdtm_stackleak.c b/drivers/misc/lkdtm_stackleak.c
> new file mode 100644
> index 000000000000..6c343be488db
> --- /dev/null
> +++ b/drivers/misc/lkdtm_stackleak.c
> @@ -0,0 +1,79 @@

This file should have a comment describing its purpose, etc.

> +#include "lkdtm.h"
> +
> +#include <linux/sched.h>
> +
> +static bool check_poison(unsigned long *ptr, unsigned long n)
> +{
> +       unsigned long i;
> +
> +       for (i = 1; i < n; i++) {
> +               pr_info("%lu %p: %lx\n", i, ptr-i, *(ptr - i));
> +               if (*(ptr - i) != -0xbeefL)

We really need a macro for -0xBEEFL for sure now :P

> +                       return false;

Maybe only print out the values if they're a mismatch?

> +       }
> +
> +       return true;
> +}
> +
> +static bool check_my_stack(void)
> +{
> +       char *lowest;
> +       unsigned long i, left, check;
> +
> +       lowest = (char *) (&i + 1);
> +       if (current->thread.lowest_stack < (unsigned long) lowest)
> +               lowest = (char *) current->thread.lowest_stack;
> +
> +       left = ((unsigned long) lowest) % THREAD_SIZE;
> +
> +       /* See note in arch/x86/entry/entry_64.S about the or. */

I wasn't able to find this note. Which did you mean?

> +       left = left - 2 * sizeof(unsigned long);

Can we make this not arch-specific? (I realize the stackleak code is
x86 only at the moment.)

> +
> +       for (i = 0; i < left; i++) {
> +               unsigned long *cur = (void *) lowest - i;
> +
> +               if (*cur == -0xbeefL &&
> +                               (left - i < 16 || check_poison(cur, 16)))
> +                       break;
> +       }
> +
> +       if ((left - i) % sizeof(unsigned long))
> +               pr_warn("found unaligned stack poison?\n");
> +
> +       check = (left - i) / sizeof(unsigned long);
> +       if (check_poison((unsigned long *) (lowest - i), check))
> +               pr_info("current stack poisoned correctly\n");
> +       else
> +               pr_err("current stack not poisoned correctly\n");
> +
> +       return true;
> +}
> +
> +static noinline bool do_alloca(unsigned long size)
> +{
> +       char buf[size];
> +
> +       /* so this doesn't get inlined or optimized out */
> +       snprintf(buf, size, "hello world\n");
> +       return true;
> +}
> +
> +static void big_alloca(void)
> +{
> +       char base;
> +       unsigned long left;
> +
> +       left = ((unsigned long) &base) % THREAD_SIZE;
> +

Right here I'd add a small alloca just to check both working and
non-working cases.

> +       pr_info("attempting large alloca of %lu\n", left);
> +       do_alloca(left);
> +       pr_warn("alloca succeded?\n");
> +}
> +
> +void lkdtm_CHECK_STACKLEAK(void)
> +{
> +       if (!check_my_stack())
> +               return;

This function only ever returns true?

> +
> +       big_alloca();
> +}
> --
> 2.11.0
>

Cool, this would be a nice addition to the stackleak plugin series!

-Kees

-- 
Kees Cook
Pixel Security
