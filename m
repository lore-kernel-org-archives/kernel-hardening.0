Reply-To: kernel-hardening@lists.openwall.com
References: <20160217212202.GA25268@www.outflux.net>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56C51574.80304@redhat.com>
Date: Wed, 17 Feb 2016 16:51:00 -0800
MIME-Version: 1.0
In-Reply-To: <20160217212202.GA25268@www.outflux.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] lkdtm: add test for executing .rodata
To: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/17/2016 01:22 PM, Kees Cook wrote:
> Make sure that the read-only data section isn't executable. To avoid
> making per-architecture assembly functions, just mark the new function
> as living in the .rodata section and force the flags (which requires
> adding a comment to hide the generated flags from the assembler).
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
> - fix the section bits hack to be more friendly

This is producing different assembler errors:

   CC      drivers/misc/lkdtm.o
/tmp/ccAJjNlS.s: Assembler messages:
/tmp/ccAJjNlS.s: Error: unaligned opcodes detected in executable segment
scripts/Makefile.build:258: recipe for target 'drivers/misc/lkdtm.o' failed

Doesn't seem to be toolchain dependent as I see it with two different ones

$ /opt/gcc-linaro-5.1-2015.08-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-as --version
GNU assembler (GNU Binutils) 2.25.0 Linaro 2015.10

$ aarch64-linux-gnu-as --version
GNU assembler version 2.26.20160125

The latter is the toolchain from Fedora 23.

Sticking an extra align directive in there doesn't seem to help.
Playing around a bit, this works if I don't have debuginfo turned on.
Possible gcc issue where something is not being calculated correctly
or gcc working as intended?

Thanks,
Laura

> ---
>   drivers/misc/lkdtm.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index 11fdadc68e53..b15d08ff71a9 100644
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
> +static void __attribute__((__section__(".rodata,\"a\",\%progbits;//")))
> +do_nothing_rodata(void)
> +{
> +	return;
> +}
> +
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
