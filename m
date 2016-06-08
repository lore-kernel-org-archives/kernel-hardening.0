Reply-To: kernel-hardening@lists.openwall.com
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
 <1465336628-18219-4-git-send-email-keescook@chromium.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <941dc7f5-03a2-8a98-8888-7e92985699e3@redhat.com>
Date: Tue, 7 Jun 2016 18:02:01 -0700
MIME-Version: 1.0
In-Reply-To: <1465336628-18219-4-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/5] lkdtm: add function for testing .rodata section
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/07/2016 02:57 PM, Kees Cook wrote:
> This adds a function that lives in the .rodata section. The section
> flags are corrected using objcopy since there is no way with gcc to
> declare section flags in an architecture-agnostic way.
>

Permit me to be the bearer of bad architecture news once again. With
arm64 cross compiler (both Fedora 6.1.1 and Linaro 5.1)

   CC      drivers/misc/lkdtm_rodata.o
   OBJCOPY drivers/misc/lkdtm_rodata_objcopy.o
   LD      drivers/misc/lkdtm.o
drivers/misc/lkdtm_rodata_objcopy.o: file not recognized: File format not recognized
scripts/Makefile.build:423: recipe for target 'drivers/misc/lkdtm.o' failed
make[2]: *** [drivers/misc/lkdtm.o] Error 1
scripts/Makefile.build:440: recipe for target 'drivers/misc' failed
make[1]: *** [drivers/misc] Error 2
Makefile:985: recipe for target 'drivers' failed
make: *** [drivers] Error 2


As far as I can tell this is because arm64 defines OBJCOPYFLAGS and they get
propagated to objcopy

aarch64-linux-gnu-objcopy -O binary -R .note -R .note.gnu.build-id -R .comment
	-S --set-section-flags .text=alloc,readonly
	--rename-section .text=.rodata drivers/misc/lkdtm_rodata.o drivers/misc/lkdtm_rodata_objcopy.o

vs x86

objcopy  --set-section-flags .text=alloc,readonly --rename-section .text=.rodata
	drivers/misc/lkdtm_rodata.o drivers/misc/lkdtm_rodata_objcopy.o


specifically it's the -O binary that seems to break things, the same failure
happens on x86 as well with the the same commands. It works if I clear out
the OBJCOPYFLAGS variable first but I don't think that's the correct way to
fix this.

Thanks,
Laura

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/misc/Makefile       |  7 +++++++
>  drivers/misc/lkdtm.h        |  6 ++++++
>  drivers/misc/lkdtm_core.c   | 24 +++++++++++++++++-------
>  drivers/misc/lkdtm_rodata.c | 10 ++++++++++
>  4 files changed, 40 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/misc/lkdtm.h
>  create mode 100644 drivers/misc/lkdtm_rodata.c
>
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c3cb6ad8cc37..b2d3d68dfa22 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -59,3 +59,10 @@ obj-$(CONFIG_CXL_BASE)		+= cxl/
>  obj-$(CONFIG_PANEL)             += panel.o
>
>  lkdtm-$(CONFIG_LKDTM)		+= lkdtm_core.o
> +lkdtm-$(CONFIG_LKDTM)		+= lkdtm_rodata_objcopy.o
> +
> +OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
> +			--set-section-flags .text=alloc,readonly \
> +			--rename-section .text=.rodata
> +$(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o
> +	$(call if_changed,objcopy)
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> new file mode 100644
> index 000000000000..9531fa3be4c3
> --- /dev/null
> +++ b/drivers/misc/lkdtm.h
> @@ -0,0 +1,6 @@
> +#ifndef __LKDTM_H
> +#define __LKDTM_H
> +
> +void lkdtm_rodata_do_nothing(void);
> +
> +#endif
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 605050c60f10..187cd9b63e9a 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -52,6 +52,8 @@
>  #include <linux/ide.h>
>  #endif
>
> +#include "lkdtm.h"
> +
>  /*
>   * Make sure our attempts to over run the kernel stack doesn't trigger
>   * a compiler warning when CONFIG_FRAME_WARN is set. Then make sure we
> @@ -103,6 +105,7 @@ enum ctype {
>  	CT_EXEC_STACK,
>  	CT_EXEC_KMALLOC,
>  	CT_EXEC_VMALLOC,
> +	CT_EXEC_RODATA,
>  	CT_EXEC_USERSPACE,
>  	CT_ACCESS_USERSPACE,
>  	CT_WRITE_RO,
> @@ -145,6 +148,7 @@ static char* cp_type[] = {
>  	"EXEC_STACK",
>  	"EXEC_KMALLOC",
>  	"EXEC_VMALLOC",
> +	"EXEC_RODATA",
>  	"EXEC_USERSPACE",
>  	"ACCESS_USERSPACE",
>  	"WRITE_RO",
> @@ -346,15 +350,18 @@ static noinline void corrupt_stack(void)
>  	memset((void *)data, 0, 64);
>  }
>
> -static void noinline execute_location(void *dst)
> +static noinline void execute_location(void *dst, bool write)
>  {
>  	void (*func)(void) = dst;
>
>  	pr_info("attempting ok execution at %p\n", do_nothing);
>  	do_nothing();
>
> -	memcpy(dst, do_nothing, EXEC_SIZE);
> -	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
> +	if (write) {
> +		memcpy(dst, do_nothing, EXEC_SIZE);
> +		flush_icache_range((unsigned long)dst,
> +				   (unsigned long)dst + EXEC_SIZE);
> +	}
>  	pr_info("attempting bad execution at %p\n", func);
>  	func();
>  }
> @@ -551,25 +558,28 @@ static void lkdtm_do_action(enum ctype which)
>  		schedule();
>  		break;
>  	case CT_EXEC_DATA:
> -		execute_location(data_area);
> +		execute_location(data_area, true);
>  		break;
>  	case CT_EXEC_STACK: {
>  		u8 stack_area[EXEC_SIZE];
> -		execute_location(stack_area);
> +		execute_location(stack_area, true);
>  		break;
>  	}
>  	case CT_EXEC_KMALLOC: {
>  		u32 *kmalloc_area = kmalloc(EXEC_SIZE, GFP_KERNEL);
> -		execute_location(kmalloc_area);
> +		execute_location(kmalloc_area, true);
>  		kfree(kmalloc_area);
>  		break;
>  	}
>  	case CT_EXEC_VMALLOC: {
>  		u32 *vmalloc_area = vmalloc(EXEC_SIZE);
> -		execute_location(vmalloc_area);
> +		execute_location(vmalloc_area, true);
>  		vfree(vmalloc_area);
>  		break;
>  	}
> +	case CT_EXEC_RODATA:
> +		execute_location(lkdtm_rodata_do_nothing, false);
> +		break;
>  	case CT_EXEC_USERSPACE: {
>  		unsigned long user_addr;
>
> diff --git a/drivers/misc/lkdtm_rodata.c b/drivers/misc/lkdtm_rodata.c
> new file mode 100644
> index 000000000000..4d0d851f02b9
> --- /dev/null
> +++ b/drivers/misc/lkdtm_rodata.c
> @@ -0,0 +1,10 @@
> +/*
> + * This includes functions that are meant to live entirely in .rodata
> + * (via objcopy tricks), to validate the non-executability of .rodata.
> + */
> +#include <linux/kernel.h>
> +
> +void lkdtm_rodata_do_nothing(void)
> +{
> +	/* Does nothing. We just want an architecture agnostic "return". */
> +}
>
