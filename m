Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1232989951.18951930.1454759421059.JavaMail.zimbra@redhat.com>
References: <1436300428-21163-1-git-send-email-yinghai@kernel.org>
	<CAGXu5jKtBDziww4p_cJi-u=EHYdz9mqy87ca5xrCHY_MGN3+yw@mail.gmail.com>
	<CAGXu5jKLyYEgoz5yS+y5Gu-2xS3H9wWKu2YZWWt0Nof1ZTm3QQ@mail.gmail.com>
	<1232989951.18951930.1454759421059.JavaMail.zimbra@redhat.com>
Date: Mon, 8 Feb 2016 20:31:16 -0800
Message-ID: <CAGXu5jJy+N9=xF7=WmGVXxpM3f7vbb7nhN=RYQXt-NiUhqz=7w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 00/42] x86: updated patches for kaslr and setup_data etc
 for v4.3
To: Baoquan He <bhe@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 6, 2016 at 3:50 AM, Baoquan He <bhe@redhat.com> wrote:
> Hi,
>
> Recently people using big box servers are also very interested in kaslr and want
> to have it to enhance security. So allowing kaslr be able to randomize above 4G
> makes much sense for different kinds of system. I would like to repost patches
> realted to kaslr in this patchset, and leave the rest to Yinghai. Or I can try
> to understand and adjust the rest with yh and reviewers' help, then post. But
> firstly I will focus on kaslr and try to make it merge into Linus's tree.
>
> Since this patchset includes too many issues and people usually like reviewing
> post which takes care of one main issue in one thread, I will start from below
> thread. It mainly includes kaslr above 4G support and bug fixes and several clean
> up patch.
>
> x86, boot: kaslr cleanup and 64bit kaslr support
> https://lwn.net/Articles/637115/
>
> The following patch lists is taken from yh's cover letter of above patch thread.
>
> ************************
> Baoquan He (7):
>   x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
>   x86, kaslr: Introduce struct slot_area to manage randomization slot info
>   x86, kaslr: Add two functions which will be used later
>   x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
>   x86, kaslr: Randomize physical and virtual address of kernel separately
>   x86, kaslr: Add support of kernel physical address randomization above 4G
>   x86, kaslr: Remove useless codes
>
> Jiri Kosina (1):
>   x86, kaslr: Propagate base load address calculation v2
> *** this one has been merged. Jiri posted firslty, later Boris reverted it and
> handled in a better way in commit (78cac48 x86/mm/KASLR: Propagate KASLR status to kernel proper)
>
> Yinghai Lu (11):
>   x86, boot: Make data from decompress_kernel stage live longer
>   x86, boot: Simplify run_size calculation
>   x86, kaslr: Kill not used run_size related code.
>   x86, kaslr: Use output_run_size
>   x86, kaslr: Consolidate mem_avoid array filling
>   x86, boot: Move z_extract_offset calculation to header.S
>   x86, kaslr: Get correct max_addr for relocs pointer
>   x86, boot: Split kernel_ident_mapping_init to another file
>   x86, 64bit: Set ident_mapping for kaslr
>   x86, boot: Add checking for memcpy
>   x86, kaslr: Allow random address could be below loaded address
>
> **************************
> My plan is split them into
> 1) kaslr above 4G support
>   x86, boot: Split kernel_ident_mapping_init to another file
>   x86, 64bit: Set ident_mapping for kaslr
>   x86, boot: Add checking for memcpy
>   x86, boot: Move z_extract_offset calculation to header.S
>   x86, boot: Simplify run_size calculation
>   x86, kaslr: Kill not used run_size related code.
>   x86, kaslr: Use output_run_size
>   x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
>   x86, kaslr: Introduce struct slot_area to manage randomization slot info
>   x86, kaslr: Add two functions which will be used later
>   x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
>   x86, kaslr: Randomize physical and virtual address of kernel separately
>   x86, kaslr: Add support of kernel physical address randomization above 4G
>   x86, kaslr: Remove useless codes
> 2) allow kaslr to choose slots below loaded address
>   x86, kaslr: Consolidate mem_avoid array filling
>   x86, kaslr: Allow random address could be below loaded address
> 3) Make data from decompress_kernel stage live longer (bug fix)
>   x86, boot: Make data from decompress_kernel stage live longer
> 4) Get correct max_addr for relocs pointer (improvement)
>   x86, kaslr: Get correct max_addr for relocs pointer
>
> The 2) could be added into 1) post. I take it out because the mem_avoid issue is very
> complicated, can be discussed in a separate thread. And 1) post only focus the kaslr
> above 4G support.
>
> That's all I plan to do. Suggestion or comments are welcome.

That sounds great, thanks! Please check the rest of the thread where I
asked a number of questions that remain unanswered. If we can get some
clarification on those points, I think it would help move this along
more quickly.

Thanks for continuing this work!

-Kees

>
> Thanks
> Baoquan
>
> ----- Original Message -----
> From: "Kees Cook" <keescook@chromium.org>
> To: "Yinghai Lu" <yinghai@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>, "Baoquan He" <bhe@redhat.com>, "LKML" <linux-kernel@vger.kernel.org>
> Sent: Saturday, October 3, 2015 4:16:40 AM
> Subject: Re: [PATCH 00/42] x86: updated patches for kaslr and setup_data etc for v4.3
>
> Hi,
>
> Has there been any more work on these series of patches? I asked many
> questions in my earlier review, but nothing was answered.
>
> Thanks,
>
> -Kees
>
> On Tue, Jul 7, 2015 at 4:21 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jul 7, 2015 at 1:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Those patches are rebased on v4.2-rc1 that I sent before but were rejected
>>> by Ingo on changelog.
>>>
>>> Kees Cook said that he would like to give a try to make improvement on changelog
>>> to get things moving.
>>
>> Thanks for working on this! I think it might be best to split this
>> long series into shorter ones. It seems like there are several areas:
>>
>> - fixing kASLR
>> - extended kASLR above 4G
>> - setup_data cleanup
>> - various other cleanups
>>
>> It might make sense to keep them separate for easier review?
>>
>> -Kees
>>
>>>
>>> First part are kaslr related:
>>> 1. First put compressed kernel ZO near end of the buffer before decompressing
>>> so we can find the ZO position easily for kaslr buffer searchin
>>> 2. kill run_size calculation shell scripts.
>>> 3. create new ident mapping for kasl 64bit, so we can cover
>>>    above 4G random kernel base
>>> 4. 7 patches from He that support random random, as I already used his patches
>>>    to test the ident mapping code.
>>> 5. some debug patches for boot/kaslr.
>>>
>>> Second part are setup_data related:
>>> Now setup_data is reserved via memblock and e820 and different
>>> handlers have different ways, and it is confusing.
>>> 1. SETUP_E820_EXT: is consumed early and will not copy or access again.
>>>         have memory wasted.
>>> 2. SETUP_EFI: is accessed via ioremap every time at early stage.
>>>         have memory wasted.
>>> 3. SETUP_DTB: is copied locally.
>>>         have memory wasted.
>>> 4. SETUP_PCI: is accessed via ioremap for every pci devices, even run-time.
>>> Also setup_data is exported to debugfs for debug purpose.
>>> Here will convert to let every handler to decide how to handle it.
>>> and will not reserve the setup_data generally, so will not
>>> waste memory and also make memblock/e820 keep page aligned.
>>> 1. not touch E820 anymore.
>>> 2. copy SETUP_EFI to __initdata variable and access it without ioremap.
>>> 3. SETUP_DTB: reserver and copy to local and free.
>>> 4. SETUP_PCI: reverve localy and convert to list, to avoid keeping ioremap.
>>> 5. export SETUP_PCI via sysfs.
>>>
>>> Third part are some small cleanup patches.
>>>
>>> put those patches at
>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-v4.3-next
>>>
>>> Thanks
>>>
>>> Yinghai
>>>
>>>
>>> Baoquan He (7):
>>>   x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
>>>   x86, kaslr: Introduce struct slot_area to manage randomization slot info
>>>   x86, kaslr: Add two functions which will be used later
>>>   x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
>>>   x86, kaslr: Randomize physical and virtual address of kernel separately
>>>   x86, kaslr: Add support of kernel physical address randomization above 4G
>>>   x86, kaslr: Remove useless codes
>>>
>>> Yinghai Lu (35):
>>>   x86, kasl: Remove not needed parameter for choose_kernel_location
>>>   x86, boot: Move compressed kernel to end of buffer before decompressing
>>>   x86, boot: Fix run_size calculation
>>>   x86, kaslr: Kill not needed and wrong run_size calculation code.
>>>   x86, kaslr: rename output_size to output_run_size
>>>   x86, kaslr: Consolidate mem_avoid array filling
>>>   x86, boot: Move z_extract_offset calculation to header.S
>>>   x86, kaslr: Get correct max_addr for relocs pointer
>>>   x86, boot: Split kernel_ident_mapping_init to another file
>>>   x86, 64bit: Set ident_mapping for kaslr
>>>   x86, boot: Add checking for memcpy
>>>   x86, kaslr: Allow random address could be below loaded address
>>>   x86, boot: Add printf support for early console in compressed/misc.c
>>>   x86, boot: Add more debug printout in compressed/misc.c
>>>   x86, setup: Check early serial console per string instead of one char
>>>   x86, setup: Use puts() instead of printf() in edd code
>>>   x86: Setup early console as early as possible in x86_start_kernel()
>>>   x86, boot: print compression suffix in decompress stage
>>>   x86: remove not needed clear_page calling
>>>   x86: restore end_of_ram to E820_RAM
>>>   x86, boot: Allow 64bit EFI kernel to be loaded above 4G
>>>   x86: Find correct 64 bit ramdisk address for microcode early update
>>>   x86: Kill E820_RESERVED_KERN
>>>   x86, efi: Copy SETUP_EFI data and access directly
>>>   x86, of: Let add_dtb reserve setup_data locally
>>>   x86, boot: Add add_pci handler for SETUP_PCI
>>>   x86: Kill not used setup_data handling code
>>>   x86, boot, PCI: Convert SETUP_PCI data to list
>>>   x86, boot, PCI: Copy SETUP_PCI rom to kernel space
>>>   x86, boot, PCI: Export SETUP_PCI data via sysfs
>>>   x86: Fix typo in mark_rodata_ro
>>>   x86, 64bit: add pfn_range_is_highmapped()
>>>   x86, 64bit: remove highmap for not needed ranges
>>>   x86, 64bit: Add __pa_high/__va_high
>>>   x86: fix msr print again
>>>
>>>  Documentation/x86/boot.txt                  |  19 ++
>>>  arch/x86/boot/Makefile                      |  13 +-
>>>  arch/x86/boot/compressed/Makefile           |  21 +-
>>>  arch/x86/boot/compressed/aslr.c             | 258 ++++++++++++++++-------
>>>  arch/x86/boot/compressed/eboot.c            |  15 +-
>>>  arch/x86/boot/compressed/head_32.S          |  14 +-
>>>  arch/x86/boot/compressed/head_64.S          |  22 +-
>>>  arch/x86/boot/compressed/misc.c             | 129 +++++++++---
>>>  arch/x86/boot/compressed/misc.h             |  41 +++-
>>>  arch/x86/boot/compressed/misc_pgt.c         |  91 ++++++++
>>>  arch/x86/boot/compressed/mkpiggy.c          |  28 +--
>>>  arch/x86/boot/compressed/printf.c           |   5 +
>>>  arch/x86/boot/compressed/string.c           |  28 ++-
>>>  arch/x86/boot/compressed/vmlinux.lds.S      |   1 +
>>>  arch/x86/boot/edd.c                         |   4 +-
>>>  arch/x86/boot/header.S                      |  34 ++-
>>>  arch/x86/boot/tty.c                         |  14 +-
>>>  arch/x86/include/asm/boot.h                 |  19 ++
>>>  arch/x86/include/asm/efi.h                  |   2 +-
>>>  arch/x86/include/asm/page.h                 |   5 +
>>>  arch/x86/include/asm/pci.h                  |   4 +
>>>  arch/x86/include/asm/pgtable_64.h           |   2 +
>>>  arch/x86/include/asm/processor.h            |   1 -
>>>  arch/x86/include/asm/prom.h                 |   9 +-
>>>  arch/x86/include/asm/setup.h                |   5 +
>>>  arch/x86/include/uapi/asm/bootparam.h       |   1 +
>>>  arch/x86/include/uapi/asm/e820.h            |   8 -
>>>  arch/x86/kernel/asm-offsets.c               |   2 +
>>>  arch/x86/kernel/cpu/common.c                |  61 +++---
>>>  arch/x86/kernel/cpu/microcode/amd_early.c   |  10 +-
>>>  arch/x86/kernel/cpu/microcode/intel_early.c |   8 +-
>>>  arch/x86/kernel/devicetree.c                |  39 ++--
>>>  arch/x86/kernel/e820.c                      |  18 +-
>>>  arch/x86/kernel/head.c                      |  26 +++
>>>  arch/x86/kernel/head32.c                    |   1 +
>>>  arch/x86/kernel/head64.c                    |  21 +-
>>>  arch/x86/kernel/kdebugfs.c                  | 142 -------------
>>>  arch/x86/kernel/setup.c                     |  79 ++-----
>>>  arch/x86/kernel/tboot.c                     |   3 +-
>>>  arch/x86/kernel/vmlinux.lds.S               |   1 +
>>>  arch/x86/mm/ident_map.c                     |  74 +++++++
>>>  arch/x86/mm/init_64.c                       | 173 +++++++--------
>>>  arch/x86/mm/pageattr.c                      |  16 +-
>>>  arch/x86/pci/common.c                       | 313 ++++++++++++++++++++++++++--
>>>  arch/x86/platform/efi/efi.c                 |  13 +-
>>>  arch/x86/platform/efi/efi_64.c              |  10 +-
>>>  arch/x86/platform/efi/quirks.c              |  23 +-
>>>  arch/x86/tools/calc_run_size.sh             |  42 ----
>>>  drivers/tty/serial/8250/8250_early.c        |  17 ++
>>>  kernel/printk/printk.c                      |  11 +-
>>>  50 files changed, 1235 insertions(+), 661 deletions(-)
>>>  create mode 100644 arch/x86/boot/compressed/misc_pgt.c
>>>  create mode 100644 arch/x86/boot/compressed/printf.c
>>>  create mode 100644 arch/x86/mm/ident_map.c
>>>  delete mode 100644 arch/x86/tools/calc_run_size.sh
>>>
>>> --
>>> 1.8.4.5
>>>
>>
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
>
>
> --
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Kees Cook
Chrome OS & Brillo Security
