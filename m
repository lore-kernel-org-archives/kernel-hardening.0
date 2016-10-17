Reply-To: kernel-hardening@lists.openwall.com
References: <1476311522-15381-1-git-send-email-labbott@redhat.com>
 <1476311522-15381-2-git-send-email-labbott@redhat.com>
 <20161017105252.GA29095@leverpostej>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <76e2bd52-7efc-c8af-74ea-90fb7426e044@redhat.com>
Date: Mon, 17 Oct 2016 15:16:07 -0700
MIME-Version: 1.0
In-Reply-To: <20161017105252.GA29095@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2 1/4] arm64: dump: Make ptdump debugfs a separate option
To: Mark Rutland <mark.rutland@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On 10/17/2016 03:52 AM, Mark Rutland wrote:
> Hi Laura,
>
> In looking at this, I realised I was confused about ptdump_initialize()
> previously, and now see why we can't decouple the debugfs registration
> of the kernel page tables from the rest of the ptdump init. Sorry for
> the noise on that.
>
> Aside from one issue below, this looks good to me.
>
> On Wed, Oct 12, 2016 at 03:31:59PM -0700, Laura Abbott wrote:
>> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
>> index 07b8ed0..7c35689 100644
>> --- a/arch/arm64/include/asm/ptdump.h
>> +++ b/arch/arm64/include/asm/ptdump.h
>> @@ -16,9 +16,10 @@
>>  #ifndef __ASM_PTDUMP_H
>>  #define __ASM_PTDUMP_H
>>
>> -#ifdef CONFIG_ARM64_PTDUMP
>> +#ifdef CONFIG_ARM64_PTDUMP_CORE
>>
>>  #include <linux/mm_types.h>
>> +#include <linux/seq_file.h>
>>
>>  struct addr_marker {
>>  	unsigned long start_address;
>> @@ -32,13 +33,15 @@ struct ptdump_info {
>>  	unsigned long			max_addr;
>>  };
>>
>> -int ptdump_register(struct ptdump_info *info, const char *name);
>> -
>> +void ptdump_walk_pgd(struct seq_file *s, struct ptdump_info *info);
>> +#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
>> +int ptdump_debugfs_register(struct ptdump_info *info, const char *name);
>>  #else
>> -static inline int ptdump_register(struct ptdump_info *info, const char *name)
>> +static inline int ptdump_debugfs_register(struct ptdump_info *info,
>> +					const char *name)
>>  {
>>  	return 0;
>>  }
>> -#endif /* CONFIG_ARM64_PTDUMP */
>> +#endif
>
> I think you didn't mean to remove the existing endif here?
>
> It's still needed to guard the CONFIG_ARM64_PTDUMP_CORE case, and the
> new one is needed for the new #ifdef CONFIG_ARM64_PTDUMP_DEBUGFS.
> Without it, I get a build error with this patch atop of v4.9-rc1 with
> CONFIG_ARM64_PTDUMP_DEBUGFS selected:
>
> [mark@leverpostej:~/src/linux]% uselinaro 15.08 make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j10 -s
> In file included from arch/arm64/mm/ptdump_debugfs.c:4:0:
> ./arch/arm64/include/asm/ptdump.h:16:0: error: unterminated #ifndef
>  #ifndef __ASM_PTDUMP_H
>  ^
> make[1]: *** [arch/arm64/mm/ptdump_debugfs.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
>
> With that #endif restored, everything works fine. So FWIW, with that:
>

Ugh rebase/refactor failure on my part.

> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
>
> [...]
>
>> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
>> index 7c75a8d..33d35e8 100644
>> --- a/drivers/firmware/efi/arm-runtime.c
>> +++ b/drivers/firmware/efi/arm-runtime.c
>> @@ -39,7 +39,7 @@ static struct mm_struct efi_mm = {
>>  	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
>>  };
>>
>> -#ifdef CONFIG_ARM64_PTDUMP
>> +#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
>>  #include <asm/ptdump.h>
>>
>>  static struct ptdump_info efi_ptdump_info = {
>> @@ -53,10 +53,9 @@ static struct ptdump_info efi_ptdump_info = {
>>
>>  static int __init ptdump_init(void)
>>  {
>> -	return ptdump_register(&efi_ptdump_info, "efi_page_tables");
>> +	return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
>>  }
>>  device_initcall(ptdump_init);
>> -
>>  #endif
>
> For the EFI changes, we'll need an ack from Ard or Matt; this should
> probably be Cc'd to the linux-efi list for that.

Good point, I'll do that for v3.

>
> Thanks,
> Mark.
>

Thanks,
Laura
