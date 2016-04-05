Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160405015613.GA4654@x1.redhat.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
	<20160405015613.GA4654@x1.redhat.com>
Date: Tue, 5 Apr 2016 13:00:41 -0700
Message-ID: <CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 4, 2016 at 6:56 PM, Baoquan He <bhe@redhat.com> wrote:
> On 03/22/16 at 03:31pm, Baoquan He wrote:
>> ***Background:
>> Previously a bug is reported that kdump didn't work when kaslr is enabled. During
>> discussing that bug fix, we found current kaslr has a limilation that it can
>> only randomize in 1GB region.
>>
>> This is because in curent kaslr implementaion only physical address of kernel
>> loading is randomized. Then calculate the delta of physical address where
>> vmlinux was linked to load and where it is finally loaded. If delta is not
>> equal to 0, namely there's a new physical address where kernel is actually
>> decompressed, relocation handling need be done. Then delta is added to offset
>> of kernel symbol relocation, this makes the address of kernel text mapping move
>> delta long. Though in principle kernel can be randomized to any physical address,
>> kernel text mapping address space is limited and only 1G, namely as follows on
>> x86_64:
>>       [0xffffffff80000000, 0xffffffffc0000000)
>>
>> In one word, kernel text physical address and virtual address randomization is
>> coupled. This causes the limitation.
>>
>> Then hpa and Vivek suggested we should change this. To decouple the physical
>> address and virtual address randomization of kernel text and let them work
>> separately. Then kernel text physical address can be randomized in region
>> [16M, 64T), and kernel text virtual address can be randomized in region
>> [0xffffffff80000000, 0xffffffffc0000000).
>>
>> ***Problems we need solved:
>>   - For kernel boot from startup_32 case, only 0~4G identity mapping is built.
>>     If kernel will be randomly put anywhere from 16M to 64T at most, the price
>>     to build all region of identity mapping is too high. We need build the
>>     identity mapping on demand, not covering all physical address space.
>>
>>   - Decouple the physical address and virtual address randomization of kernel
>>     text and let them work separately.
>>
>> ***Parts:
>>    - The 1st part is Yinghai's identity mapping building on demand patches.
>>      This is used to solve the first problem mentioned above.
>>      (Patch 09-10/19)
>>    - The 2nd part is decoupling the physical address and virtual address
>>      randomization of kernel text and letting them work separately patches
>>      based on Yinghai's ident mapping patches.
>>      (Patch 12-19/19)
>>    - The 3rd part is some clean up patches which Yinghai found when he reviewed
>>      my patches and the related code around.
>>      (Patch 01-08/19)
>>
>> ***Patch status:
>> This patchset went through several rounds of review.
>>
>>     v1:
>>     - The first round can be found here:
>>       https://lwn.net/Articles/637115/
>>
>>     v1->v2:
>>     - In 2nd round Yinghai made a big patchset including this kaslr fix and another
>>       setup_data related fix. The link is here:
>>        http://lists-archives.com/linux-kernel/28346903-x86-updated-patches-for-kaslr-and-setup_data-etc-for-v4-3.html
>>       You can get the code from Yinghai's git branch:
>>       git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-v4.3-next
>>
>>     v2->v3:
>>     - It only takes care of the kaslr related patches.
>>       For reviewers it's better to discuss only one issue in one thread.
>>         * I take off one patch as follows from Yinghai's because I think it's unnecessay.
>>            - Patch 05/19 x86, kaslr: rename output_size to output_run_size
>>              output_size is enough to represen the value:
>>               output_len > run_size ? output_len : run_size
>>
>>         * I add Patch 04/19, it's a comment update patch. For other patches, I just
>>           adjust patch log and do several places of change comparing with 2nd round.
>>           Please check the change log under patch log of each patch for details.
>>
>>         * Adjust sequence of several patches to make review easier. It doesn't
>>           affect codes.
>>
>>     v3->v4:
>>     - Made changes according to Kees's comments.
>>       Add one patch 20/20 as Kees suggested to use KERNEL_IMAGE_SIZE as offset
>>       max of virtual random, meanwhile clean up useless CONFIG_RANDOM_OFFSET_MAX
>>
>>         x86, kaslr: Use KERNEL_IMAGE_SIZE as the offset max for kernel virtual randomization
>>
>> You can also get this patchset from my github:
>>    https://github.com/baoquan-he/linux.git kaslr-above-4G
>>
>> Any comments about code changes, code comments, patch logs are welcome and
>> appreciated.
>>
>> Baoquan He (9):
>>   x86, kaslr: Fix a bug that relocation can not be handled when kernel
>>     is loaded above 2G
>>   x86, kaskr: Update the description for decompressor worst case
>>   x86, kaslr: Introduce struct slot_area to manage randomization slot
>>     info
>>   x86, kaslr: Add two functions which will be used later
>>   x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel
>>     text mapping address
>>   x86, kaslr: Randomize physical and virtual address of kernel
>>     separately
>>   x86, kaslr: Add support of kernel physical address randomization above
>>     4G
>>   x86, kaslr: Remove useless codes
>>   x86, kaslr: Use KERNEL_IMAGE_SIZE as the offset max for kernel virtual
>>     randomization
>>
>> Yinghai Lu (11):
>>   x86, kaslr: Remove not needed parameter for choose_kernel_location
>>   x86, boot: Move compressed kernel to end of buffer before
>>     decompressing
>>   x86, boot: Move z_extract_offset calculation to header.S
>>   x86, boot: Fix run_size calculation
>>   x86, kaslr: Clean up useless code related to run_size.
>>   x86, kaslr: Get correct max_addr for relocs pointer
>>   x86, kaslr: Consolidate mem_avoid array filling
>>   x86, boot: Split kernel_ident_mapping_init to another file
>>   x86, 64bit: Set ident_mapping for kaslr
>>   x86, boot: Add checking for memcpy
>>   x86, kaslr: Allow random address to be below loaded address
>>
>>  arch/x86/Kconfig                       |  57 +++----
>>  arch/x86/boot/Makefile                 |  13 +-
>>  arch/x86/boot/compressed/Makefile      |  19 ++-
>>  arch/x86/boot/compressed/aslr.c        | 300 +++++++++++++++++++++++++--------
>>  arch/x86/boot/compressed/head_32.S     |  14 +-
>>  arch/x86/boot/compressed/head_64.S     |  15 +-
>>  arch/x86/boot/compressed/misc.c        |  89 +++++-----
>>  arch/x86/boot/compressed/misc.h        |  34 ++--
>>  arch/x86/boot/compressed/misc_pgt.c    |  93 ++++++++++
>>  arch/x86/boot/compressed/mkpiggy.c     |  28 +--
>>  arch/x86/boot/compressed/string.c      |  29 +++-
>>  arch/x86/boot/compressed/vmlinux.lds.S |   1 +
>>  arch/x86/boot/header.S                 |  22 ++-
>>  arch/x86/include/asm/boot.h            |  19 +++
>>  arch/x86/include/asm/page.h            |   5 +
>>  arch/x86/include/asm/page_64_types.h   |   5 +-
>>  arch/x86/kernel/asm-offsets.c          |   1 +
>>  arch/x86/kernel/vmlinux.lds.S          |   1 +
>>  arch/x86/mm/ident_map.c                |  74 ++++++++
>>  arch/x86/mm/init_32.c                  |   3 -
>>  arch/x86/mm/init_64.c                  |  74 +-------
>>  arch/x86/tools/calc_run_size.sh        |  42 -----
>>  22 files changed, 605 insertions(+), 333 deletions(-)
>>  create mode 100644 arch/x86/boot/compressed/misc_pgt.c
>>  create mode 100644 arch/x86/mm/ident_map.c
>>  delete mode 100644 arch/x86/tools/calc_run_size.sh
>>
> Hi Ingo,
>
> Ping.
>
> Do you have any suggestions or comments for this patchset? As you
> suggested for Yinghai's earlier post, I re-check the whole patchset and
> try to understand them all, and try to re-write patch logs with my own
> understanding. I hope this patch logs can help people who are interested
> in this issue can understand what the patch is doing. Meanwhile Kees
> is very kind to help review the code change and patch log, help adjust
> or re-write some of them.
>
> If still there's something you don't like, your suggestions, ideas and
> comments are welcome and appreciated. I will continue making changes
> until it's satisfactory.

FWIW, I've also had this tree up in my git branches, and the 0day
tester hasn't complained at all about it in the last two weeks. I'd
really like to see this in -next to fix the >4G (mainly kexec) issues
and get us to feature parity with the arm64 kASLR work (randomized
virtual address).

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
