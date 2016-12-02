Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1480652545-4457-1-git-send-email-mpe@ellerman.id.au>
References: <1480652545-4457-1-git-send-email-mpe@ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Dec 2016 13:32:24 -0800
Message-ID: <CAGXu5j+B=BTvLWzW7nYCgvdBeL682HibAGisEi=cJUPa0K1U2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] lkdtm: Add tests for LIST_POISON and ZERO_SIZE_PTR
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 1, 2016 at 8:22 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> This adds two tests, to check that a read or write to LIST_POISON1 and
> ZERO_SIZE_PTR are blocked.
>
> The default values for both (256 and 16) typically fall in the range
> of valid user space addresses. However in general mmap_min_addr is 64K,
> which prevents user space from mapping anything at those addresses.
>
> However it's feasible that an attacker will be able to find a way to
> cause an access at an offset from either value, and if that offset is
> greater than 64K then they can access user space again.
>
> To simulate that case, in the test we create a user mapping at
> approximately mmap_min_addr, and offset the pointer by that amount. This
> gives the test the greatest chance of failing (ie. an access
> succeeding). We don't actually use mmap_min_addr, because that would
> require exporting it to modules, instead we use the default value at
> compile time as a reasonable approximation.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Thanks for this! I like it. :)

Acked-by: Kees Cook <keescook@chromium.org>

Greg, can you take this into your tree?

-Kees

> ---
>  drivers/misc/lkdtm.h      |  2 ++
>  drivers/misc/lkdtm_bugs.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/lkdtm_core.c |  2 ++
>  3 files changed, 52 insertions(+)
>
> v2: Fix 32-bit compile errors by using int not long.
>     Avoid need to export mmap_min_addr by using CONFIG_DEFAULT_MMAP_MIN_ADDR.
>
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index fdf954c2107f..cc207f7824f9 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -21,6 +21,8 @@ void lkdtm_SPINLOCKUP(void);
>  void lkdtm_HUNG_TASK(void);
>  void lkdtm_ATOMIC_UNDERFLOW(void);
>  void lkdtm_ATOMIC_OVERFLOW(void);
> +void lkdtm_ACCESS_LIST_POISON(void);
> +void lkdtm_ACCESS_ZERO_SIZE_PTR(void);
>
>  /* lkdtm_heap.c */
>  void lkdtm_OVERWRITE_ALLOCATION(void);
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index 30e62dd7e7ca..9ae079ac9a93 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -5,7 +5,10 @@
>   * test source files.
>   */
>  #include "lkdtm.h"
> +#include <linux/mman.h>
>  #include <linux/sched.h>
> +#include <linux/security.h>
> +#include <linux/slab.h>
>
>  /*
>   * Make sure our attempts to over run the kernel stack doesn't trigger
> @@ -147,3 +150,48 @@ void lkdtm_ATOMIC_OVERFLOW(void)
>         pr_info("attempting bad atomic overflow\n");
>         atomic_inc(&over);
>  }
> +
> +static void test_poison_ptr(void *base, const char *desc)
> +{
> +       unsigned int *ptr, bias, val;
> +       unsigned long uaddr;
> +
> +       /* We'd rather not export mmap_min_addr, so use the default instead */
> +       bias = PAGE_ALIGN(CONFIG_DEFAULT_MMAP_MIN_ADDR);
> +
> +       uaddr = vm_mmap(NULL, bias, PAGE_SIZE, PROT_READ | PROT_WRITE,
> +                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, 0);
> +       if (uaddr >= TASK_SIZE) {
> +               pr_warn("Failed to allocate user memory, can't perform test.\n");
> +               return;
> +       }
> +
> +       /*
> +        * Creating a mapping and adding mmap_min_addr to the value is cheating
> +        * in a way. But it simulates the case where an attacker is able to
> +        * cause an access at a small offset from the base value, leading to a
> +        * user space access. If an arch doesn't define CONFIG_ILLEGAL_POINTER_VALUE
> +        * then it's likely this will work in the absence of other protections.
> +        */
> +       ptr = bias + base;
> +
> +       pr_info("attempting read of %s %p\n", desc, ptr);
> +       val = *ptr;
> +       pr_info("FAIL: Was able to read %s! Got 0x%x\n", desc, val);
> +
> +       pr_info("attempting write of %s %p\n", desc, ptr);
> +       *ptr = 0xdeadbeefU;
> +       pr_info("FAIL: Was able to write %s! Now = 0x%x\n", desc, *ptr);
> +
> +       vm_munmap(uaddr, PAGE_SIZE);
> +}
> +
> +void lkdtm_ACCESS_LIST_POISON(void)
> +{
> +       test_poison_ptr(LIST_POISON1, "LIST_POISON");
> +}
> +
> +void lkdtm_ACCESS_ZERO_SIZE_PTR(void)
> +{
> +       test_poison_ptr(ZERO_SIZE_PTR, "ZERO_SIZE_PTR");
> +}
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index f9154b8d67f6..025a0ee8d8ee 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -220,6 +220,8 @@ struct crashtype crashtypes[] = {
>         CRASHTYPE(WRITE_KERN),
>         CRASHTYPE(ATOMIC_UNDERFLOW),
>         CRASHTYPE(ATOMIC_OVERFLOW),
> +       CRASHTYPE(ACCESS_LIST_POISON),
> +       CRASHTYPE(ACCESS_ZERO_SIZE_PTR),
>         CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
>         CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
>         CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
> --
> 2.7.4
>



-- 
Kees Cook
Nexus Security
