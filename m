Reply-To: kernel-hardening@lists.openwall.com
References: <20160929213257.30505-1-labbott@redhat.com>
 <20160929213257.30505-2-labbott@redhat.com> <20160930001339.GA4369@remoulade>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <e17189c7-54e0-f0a1-2b16-36f486111c4c@redhat.com>
Date: Thu, 29 Sep 2016 17:31:09 -0700
MIME-Version: 1.0
In-Reply-To: <20160930001339.GA4369@remoulade>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] arm64: dump: Make ptdump debugfs a separate option
To: Mark Rutland <mark.rutland@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 09/29/2016 05:13 PM, Mark Rutland wrote:
> Hi,
>
> On Thu, Sep 29, 2016 at 02:32:55PM -0700, Laura Abbott wrote:
>> ptdump_register currently initializes a set of page table information and
>> registers debugfs. There are uses for the ptdump option without wanting the
>> debugfs options. Split this out to make it a separate option.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>  arch/arm64/Kconfig.debug        |  6 +++++-
>>  arch/arm64/include/asm/ptdump.h | 15 +++++++++++++--
>>  arch/arm64/mm/Makefile          |  3 ++-
>>  arch/arm64/mm/dump.c            | 30 +++++++++---------------------
>>  arch/arm64/mm/ptdump_debugfs.c  | 33 +++++++++++++++++++++++++++++++++
>>  5 files changed, 62 insertions(+), 25 deletions(-)
>>  create mode 100644 arch/arm64/mm/ptdump_debugfs.c
>
> As a heads-up, Ard has new ARM64_PTUMP user under drivers/firmware/efi queued
> up in the EFI tree, which will also need fixing up. See commit d80448ac92b72051
> ("efi/arm64: Add debugfs node to dump UEFI runtime page tables") [1].
>
> [...]
>

I'll take a look at that, thanks for the pointer!

>> +#include <linux/seq_file.h>
>>  #include <linux/mm_types.h>
>
> Nit: please keep headers in alphabetical order.
>
>> -static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
>> +static void __walk_pgd(struct pg_state *st, struct mm_struct *mm,
>
> Can we leave this name as-is? We didn't change walk_{pud,pmd,pte}, so this is
> inconsistent, and we haven't reused the name.
>

Yes, I think this is a relic of earlier refactoring attempts.

> [...]
>
>> +int ptdump_register(struct ptdump_info *info, const char *name)
>> +{
>> +	ptdump_initialize(info);
>> +	return ptdump_debugfs_create(info, name);
>>  }
>
> It feels like a layering violation to have the core ptdump code call the
> debugfs ptdump code. Is there some reason this has to live here?
>

Which 'this' are you referring to here? Are you suggesting moving
the ptdump_register elsewhere or moving the debugfs create elsewhere?

> Other than the above points, this looks good to me.
>
> Thanks,
> Mark.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=9d80448ac92b720512c415265597d349d8b5c3e8
>
