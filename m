Reply-To: kernel-hardening@lists.openwall.com
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
 <20161030150307.33vc2m7y5y6wzbqc@localhost>
 <20161107153802.GJ19796@leverpostej>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <07589590-7b7d-4ba1-67af-b39c40b16939@redhat.com>
Date: Mon, 7 Nov 2016 08:26:34 -0800
MIME-Version: 1.0
In-Reply-To: <20161107153802.GJ19796@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv4 0/4] WX checking for arm64
To: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On 11/07/2016 07:38 AM, Mark Rutland wrote:
> On Sun, Oct 30, 2016 at 03:03:07PM +0000, Catalin Marinas wrote:
>> On Thu, Oct 27, 2016 at 09:27:30AM -0700, Laura Abbott wrote:
>>> Laura Abbott (4):
>>>   arm64: dump: Make ptdump debugfs a separate option
>>>   arm64: dump: Make the page table dumping seq_file optional
>>>   arm64: dump: Remove max_addr
>>>   arm64: dump: Add checking for writable and exectuable pages
>>
>> Queued for 4.10. Thanks.
>
> Catalin mentioned to me that he saw some KASAN splats when testing; it
> looks like need a fixup something like the below.
>
> Apologies for not having spotted this when testing!
>
> Thanks,
> Mark.
>
> ---->8----
> From 06fef1ad1138d0808eec770e64458a350941bd2d Mon Sep 17 00:00:00 2001
> From: Mark Rutland <mark.rutland@arm.com>
> Date: Mon, 7 Nov 2016 15:24:40 +0000
> Subject: [PATCH] Fix KASAN splats with DEBUG_WX
>
> Booting a kernel built with both CONFIG_KASAN and CONFIG_DEBUG_WX
> results in a stream of KASAN splats for stack-out-of-bounds accesses,
> e.g.
>
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in note_page+0xd8/0x650 at addr ffff8009364ebdd0
> Read of size 8 by task swapper/0/1
> page:ffff7e0024d93ac0 count:0 mapcount:0 mapping:          (null) index:0x0
> flags: 0x4000000000000000()
> page dumped because: kasan: bad access detected
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.9.0-rc3-00004-g25f7267 #77
> Hardware name: ARM Juno development board (r1) (DT)
> Call trace:
> [<ffff20000808b2d8>] dump_backtrace+0x0/0x278
> [<ffff20000808b564>] show_stack+0x14/0x20
> [<ffff2000084e4e4c>] dump_stack+0xa4/0xc8
> [<ffff200008256ee0>] kasan_report_error+0x4a8/0x4d0
> [<ffff200008257330>] kasan_report+0x40/0x48
> [<ffff200008255894>] __asan_load8+0x84/0x98
> [<ffff2000080a0928>] note_page+0xd8/0x650
> [<ffff2000080a0fb4>] walk_pgd.isra.1+0x114/0x220
> [<ffff2000080a1248>] ptdump_check_wx+0xa8/0x118
> [<ffff20000809ed40>] mark_rodata_ro+0x90/0xd0
> [<ffff200008cafb88>] kernel_init+0x28/0x110
> [<ffff200008083680>] ret_from_fork+0x10/0x50
> Memory state around the buggy address:
>  ffff8009364ebc80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8009364ebd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff8009364ebd80: 00 00 00 00 f1 f1 f1 f1 00 00 f4 f4 f2 f2 f2 f2
>                                                  ^
>  ffff8009364ebe00: 00 00 00 00 00 00 00 00 f3 f3 f3 f3 00 00 00 00
>  ffff8009364ebe80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
>
> ... this happens because note_page assumes that the marker array has at
> least two elements (the latter of which may be the terminator), but the
> marker array for ptdump_check_wx only contains one element. Thus we
> dereference some garbage on the stack when looking at
> marker[1].start_address.
>
> Given we don't need the markers for the WX checks, we could modify
> note_page to allow for a NULL marker array, but for now it's simpler to
> add an entry to the ptdump_check_wx marker array, so let's do that. As
> it's somewhat confusing to have two identical entries, we add an initial
> entry with a start address of zero.
>
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/mm/dump.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> index ef8aca8..ca74a2a 100644
> --- a/arch/arm64/mm/dump.c
> +++ b/arch/arm64/mm/dump.c
> @@ -383,6 +383,7 @@ void ptdump_check_wx(void)
>  	struct pg_state st = {
>  		.seq = NULL,
>  		.marker = (struct addr_marker[]) {
> +			{ 0, NULL},
>  			{ -1, NULL},
>  		},
>  		.check_wx = true,
>

Acked-by: Laura Abbott <labbott@redhat.com>
