Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 20:03:09 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160726200309.GJ4541@io.lakedaemon.net>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: william.c.roberts@intel.com
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, keescook@chromium.org, gregkh@linuxfoundation.org, nnk@google.com, jeffv@google.com, salyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi William!

On Tue, Jul 26, 2016 at 11:22:26AM -0700, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
> 
> This patch introduces the ability randomize mmap locations where the
> address is not requested, for instance when ld is allocating pages for
> shared libraries. It chooses to randomize based on the current
> personality for ASLR.

Now I see how you found the randomize_range() fix. :-P

> Currently, allocations are done sequentially within unmapped address
> space gaps. This may happen top down or bottom up depending on scheme.
> 
> For instance these mmap calls produce contiguous mappings:
> int size = getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40026000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40027000
> 
> Note no gap between.
> 
> After patches:
> int size = getpagesize();
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x400b4000
> mmap(NULL, size, flags, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40055000
> 
> Note gap between.
> 
> Using the test program mentioned here, that allocates fixed sized blocks
> till exhaustion: https://www.linux-mips.org/archives/linux-mips/2011-05/msg00252.html,
> no difference was noticed in the number of allocations. Most varied from
> run to run, but were always within a few allocations of one another
> between patched and un-patched runs.

Did you test this with different allocation sizes?

> Performance Measurements:
> Using strace with -T option and filtering for mmap on the program
> ls shows a slowdown of approximate 3.7%

I think it would be helpful to show the effect on the resulting object
code.

> Signed-off-by: William Roberts <william.c.roberts@intel.com>
> ---
>  mm/mmap.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index de2c176..7891272 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -43,6 +43,7 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/moduleparam.h>
>  #include <linux/pkeys.h>
> +#include <linux/random.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> @@ -1582,6 +1583,24 @@ unacct_error:
>  	return error;
>  }
>  
> +/*
> + * Generate a random address within a range. This differs from randomize_addr() by randomizing
> + * on len sized chunks. This helps prevent fragmentation of the virtual memory map.
> + */
> +static unsigned long randomize_mmap(unsigned long start, unsigned long end, unsigned long len)
> +{
> +	unsigned long slots;
> +
> +	if ((current->personality & ADDR_NO_RANDOMIZE) || !randomize_va_space)
> +		return 0;

Couldn't we avoid checking this every time?  Say, by assigning a
function pointer during init?

> +
> +	slots = (end - start)/len;
> +	if (!slots)
> +		return 0;
> +
> +	return PAGE_ALIGN(start + ((get_random_long() % slots) * len));
> +}
> +

Personally, I'd prefer this function noop out based on a configuration
option.

>  unsigned long unmapped_area(struct vm_unmapped_area_info *info)
>  {
>  	/*
> @@ -1676,6 +1695,8 @@ found:
>  	if (gap_start < info->low_limit)
>  		gap_start = info->low_limit;
>  
> +	gap_start = randomize_mmap(gap_start, gap_end, length) ? : gap_start;
> +
>  	/* Adjust gap address to the desired alignment */
>  	gap_start += (info->align_offset - gap_start) & info->align_mask;
>  
> @@ -1775,6 +1796,9 @@ found:
>  found_highest:
>  	/* Compute highest gap address at the desired alignment */
>  	gap_end -= info->length;
> +
> +	gap_end = randomize_mmap(gap_start, gap_end, length) ? : gap_end;
> +
>  	gap_end -= (gap_end - info->align_offset) & info->align_mask;
>  
>  	VM_BUG_ON(gap_end < info->low_limit);

I'll have to dig into the mm code more before I can comment
intelligently on this.

thx,

Jason.
