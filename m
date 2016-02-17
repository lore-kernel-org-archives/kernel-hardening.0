Reply-To: kernel-hardening@lists.openwall.com
References: <20160216214904.GA23723@www.outflux.net>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56C3C796.7050206@redhat.com>
Date: Tue, 16 Feb 2016 17:06:30 -0800
MIME-Version: 1.0
In-Reply-To: <20160216214904.GA23723@www.outflux.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 02/16/2016 01:49 PM, Kees Cook wrote:
> Make sure that the read-only data section isn't executable.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/misc/lkdtm.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index 11fdadc68e53..9835fcc0506e 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -100,6 +100,7 @@ enum ctype {
>   	CT_EXEC_STACK,
>   	CT_EXEC_KMALLOC,
>   	CT_EXEC_VMALLOC,
> +	CT_EXEC_RODATA,
>   	CT_EXEC_USERSPACE,
>   	CT_ACCESS_USERSPACE,
>   	CT_WRITE_RO,
> @@ -137,6 +138,7 @@ static char* cp_type[] = {
>   	"EXEC_STACK",
>   	"EXEC_KMALLOC",
>   	"EXEC_VMALLOC",
> +	"EXEC_RODATA",
>   	"EXEC_USERSPACE",
>   	"ACCESS_USERSPACE",
>   	"WRITE_RO",
> @@ -315,6 +317,12 @@ static int recursive_loop(int remaining)
>   		return recursive_loop(remaining - 1);
>   }
>
> +static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
> +do_nothing_rodata(void)
> +{
> +	return;
> +}
> +

>

This doesn't cross compile for me on arm64 with two different toolchains

CC drivers/misc/lkdtm.o
/tmp/ccHzIWIx.s: Assembler messages:
/tmp/ccHzIWIx.s:21: Error: junk at end of line, first unrecognized character is `#'
/tmp/ccHzIWIx.s: Error: unaligned opcodes detected in executable segment
scripts/Makefile.build:258: recipe for target 'drivers/misc/lkdtm.o' failed
make[2]: *** [drivers/misc/lkdtm.o] Error 1
scripts/Makefile.build:407: recipe for target 'drivers/misc' failed
make[1]: *** [drivers/misc] Error 2
Makefile:950: recipe for target 'drivers' failed
make: *** [drivers] Error 2

I don't know the assembler well enough to give any insight.

Thanks,
Laura

>   static void do_nothing(void)
>   {
>   	return;
> @@ -335,15 +343,18 @@ static noinline void corrupt_stack(void)
>   	memset((void *)data, 0, 64);
>   }
>
> -static void execute_location(void *dst)
> +static void execute_location(void *dst, bool write)
>   {
>   	void (*func)(void) = dst;
>
>   	pr_info("attempting ok execution at %p\n", do_nothing);
>   	do_nothing();
>
> -	memcpy(dst, do_nothing, EXEC_SIZE);
> -	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
> +	if (write) {
> +		memcpy(dst, do_nothing, EXEC_SIZE);
> +		flush_icache_range((unsigned long)dst,
> +				   (unsigned long)dst + EXEC_SIZE);
> +	}
>   	pr_info("attempting bad execution at %p\n", func);
>   	func();
>   }
> @@ -438,25 +449,28 @@ static void lkdtm_do_action(enum ctype which)
>   		schedule();
>   		break;
>   	case CT_EXEC_DATA:
> -		execute_location(data_area);
> +		execute_location(data_area, true);
>   		break;
>   	case CT_EXEC_STACK: {
>   		u8 stack_area[EXEC_SIZE];
> -		execute_location(stack_area);
> +		execute_location(stack_area, true);
>   		break;
>   	}
>   	case CT_EXEC_KMALLOC: {
>   		u32 *kmalloc_area = kmalloc(EXEC_SIZE, GFP_KERNEL);
> -		execute_location(kmalloc_area);
> +		execute_location(kmalloc_area, true);
>   		kfree(kmalloc_area);
>   		break;
>   	}
>   	case CT_EXEC_VMALLOC: {
>   		u32 *vmalloc_area = vmalloc(EXEC_SIZE);
> -		execute_location(vmalloc_area);
> +		execute_location(vmalloc_area, true);
>   		vfree(vmalloc_area);
>   		break;
>   	}
> +	case CT_EXEC_RODATA:
> +		execute_location(do_nothing_rodata, false);
> +		break;
>   	case CT_EXEC_USERSPACE: {
>   		unsigned long user_addr;
>
>
