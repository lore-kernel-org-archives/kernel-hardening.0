Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 30 Jun 2016 21:37:23 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160630193723.GE3932@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <fbaa1409c74ddc7b29b52c87303d2af1db91e2ba.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbaa1409c74ddc7b29b52c87303d2af1db91e2ba.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 08/29] dma-api: Teach the "DMA-from-stack" check about
 vmapped stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 02:55:30PM -0700, Andy Lutomirski wrote:
> If we're using CONFIG_VMAP_STACK and we manage to point an sg entry
> at the stack, then either the sg page will be in highmem or sg_virt
> will return the direct-map alias.  In neither case will the existing
> check_for_stack() implementation realize that it's a stack page.
> 
> Fix it by explicitly checking for stack pages.
> 
> This has no effect by itself.  It's broken out for ease of review.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  lib/dma-debug.c | 39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 51a76af25c66..5b2e63cba90e 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -22,6 +22,7 @@
>  #include <linux/stacktrace.h>
>  #include <linux/dma-debug.h>
>  #include <linux/spinlock.h>
> +#include <linux/vmalloc.h>
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
>  #include <linux/export.h>
> @@ -1162,11 +1163,35 @@ static void check_unmap(struct dma_debug_entry *ref)
>  	put_hash_bucket(bucket, &flags);
>  }
>  
> -static void check_for_stack(struct device *dev, void *addr)
> +static void check_for_stack(struct device *dev,
> +			    struct page *page, size_t offset)
>  {
> -	if (object_is_on_stack(addr))
> -		err_printk(dev, NULL, "DMA-API: device driver maps memory from "
> -				"stack [addr=%p]\n", addr);
> +	void *addr;
> +	struct vm_struct *stack_vm_area = task_stack_vm_area(current);

lib/dma-debug.c: In function ‘check_for_stack’:
lib/dma-debug.c:1170:36: error: implicit declaration of function ‘task_stack_vm_area’ [-Werror=implicit-function-declaration]
  struct vm_struct *stack_vm_area = task_stack_vm_area(current);
                                    ^
lib/dma-debug.c:1170:36: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
cc1: some warnings being treated as errors
make[1]: *** [lib/dma-debug.o] Error 1
make: *** [lib] Error 2
make: *** Waiting for unfinished jobs....

Probably reorder pieces from patch 9 to earlier ones...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
