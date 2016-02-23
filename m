Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1456190872-30828-3-git-send-email-labbott@fedoraproject.org>
References: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
	<1456190872-30828-3-git-send-email-labbott@fedoraproject.org>
Date: Tue, 23 Feb 2016 14:13:28 -0800
Message-ID: <CAGXu5jJensK7Wx3CjyW7PVV4nXbbF76tpfXVE+-du+jovBqKow@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 2/2] lkdtm: Add read/write after free tests for buddy memory
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 22, 2016 at 5:27 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
>
> The current tests for read/write after free work on slab
> allocated memory. Memory straight from the buddy allocator
> may behave slightly differently and have a different set
> of parameters to test. Add tests for those cases as well.
>
> On a basic x86 boot:
>
>  # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
> [   20.358964] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
> [   20.359979] lkdtm: Writing to the buddy page before free
> [   20.360943] lkdtm: Writing to the buddy page after free
> [   20.361838] lkdtm: Wrote to free page successfully
>
>  # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
> [   32.590826] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
> [   32.591692] lkdtm: Value in memory before free: 12345678
> [   32.592459] lkdtm: Attempting to read from freed memory
> [   32.593213] lkdtm: Successfully read value: 12345678
>
> On x86 with CONFIG_DEBUG_PAGEALLOC and debug_pagealloc=on:
>
>  # echo WRITE_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
> [   49.761358] lkdtm: Performing direct entry WRITE_BUDDY_AFTER_FREE
> [   49.762177] lkdtm: Writing to the buddy page before free
> [   49.762890] lkdtm: Writing to the buddy page after free
> [   49.763606] BUG: unable to handle kernel paging request at
> ffff880000034000
>
>  # echo READ_BUDDY_AFTER_FREE > /sys/kernel/debug/provoke-crash/DIRECT
> [   20.454176] lkdtm: Performing direct entry READ_BUDDY_AFTER_FREE
> [   20.455198] lkdtm: Value in memory before free: 12345678
> [   20.456107] BUG: unable to handle kernel paging request at
> ffff880000039000
>
> Note that arches without ARCH_SUPPORTS_DEBUG_PAGEALLOC may not
> produce the same crash.

As part of my benchmarking of all these changes, I'm going to end up
with matrix of what results can be expected under various states.

>
> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
> ---
> The examples I gave were for ARCH_SUPPORTS_DEBUG_PAGEALLOC because
> that's going to look different that the slab allocators. With
> page poisoning, the behavior is going to look similar to the slab
> allocators (write will succeed quietly, read should abort).
> ---
>  drivers/misc/lkdtm.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index f95a582..2ef99e9 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -93,6 +93,8 @@ enum ctype {
>         CT_OVERWRITE_ALLOCATION,
>         CT_WRITE_AFTER_FREE,
>         CT_READ_AFTER_FREE,
> +       CT_WRITE_BUDDY_AFTER_FREE,
> +       CT_READ_BUDDY_AFTER_FREE,
>         CT_SOFTLOCKUP,
>         CT_HARDLOCKUP,
>         CT_SPINLOCKUP,
> @@ -131,6 +133,8 @@ static char* cp_type[] = {
>         "OVERWRITE_ALLOCATION",
>         "WRITE_AFTER_FREE",
>         "READ_AFTER_FREE",
> +       "WRITE_BUDDY_AFTER_FREE",
> +       "READ_BUDDY_AFTER_FREE",
>         "SOFTLOCKUP",
>         "HARDLOCKUP",
>         "SPINLOCKUP",
> @@ -451,6 +455,42 @@ static void lkdtm_do_action(enum ctype which)
>                 kfree(val);
>                 break;
>         }
> +       case CT_WRITE_BUDDY_AFTER_FREE: {
> +               unsigned long p = __get_free_page(GFP_KERNEL);
> +               if (!p)
> +                       break;
> +               pr_info("Writing to the buddy page before free\n");
> +               memset((void *)p, 0x3, PAGE_SIZE);
> +               free_page(p);
> +               schedule();
> +               pr_info("Writing to the buddy page after free\n");

I think it might be clearer to have these read like this:

Attempting good write to buddy page before free
Attempting bad write to buddy page after free
Unexpectedly wrote to free page!

> +               memset((void *)p, 0x78, PAGE_SIZE);
> +               pr_info("Wrote to free page successfully\n");
> +               break;
> +       }
> +       case CT_READ_BUDDY_AFTER_FREE: {
> +               unsigned long p = __get_free_page(GFP_KERNEL);
> +               int *tmp, *val = kmalloc(1024, GFP_KERNEL);
> +               int **base;
> +
> +               if (!p)
> +                       break;
> +
> +               if (!val)
> +                       break;
> +
> +               base = (int **)p;
> +
> +               *val = 0x12345678;
> +               pr_info("Value in memory before free: %x\n", *val);
> +               base[0] = val;
> +               free_page(p);
> +               tmp = base[0];
> +               pr_info("Attempting to read from freed memory\n");
> +               pr_info("Successfully read value: %x\n", *tmp);

Attempting bad read from freed memory
Unexpectedly read value: %x

> +               kfree(val);
> +               break;
> +       }
>         case CT_SOFTLOCKUP:
>                 preempt_disable();
>                 for (;;)
> --
> 2.5.0
>

But I think these changes could be done later -- best to try to make
all the test reports say similar things. (e.g. right now the EXEC_*
cases don't say "Oh no, I failed" if they failed to Oops.)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
