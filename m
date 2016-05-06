Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160506070034.GB11792@gmail.com>
References: <1462486436-3707-1-git-send-email-keescook@chromium.org>
	<1462486436-3707-5-git-send-email-keescook@chromium.org>
	<20160506070034.GB11792@gmail.com>
Date: Fri, 6 May 2016 10:44:35 -0700
Message-ID: <CAGXu5j+wD2_t-ykn1MUhDE8-Ejw-BjV5oWgiTxEEks=c=+YeWw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 04/11] x86/KASLR: Build identity mappings on demand
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 6, 2016 at 12:00 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> Currently KASLR only supports relocation in a small physical range (from
>> 16M to 1G), due to using the initial kernel page table identity mapping.
>> To support ranges above this, we need to have an identity mapping for the
>> desired memory range before we can decompress (and later run) the kernel.
>>
>> 32-bit kernels already have the needed identity mapping. This patch adds
>> identity mappings for the needed memory ranges on 64-bit kernels. This
>> happens in two possible boot paths:
>>
>> If loaded via startup_32, we need to set up the identity mapping we need.
>>
>> If loaded from a 64-bit bootloader, the bootloader will have
>> already set up an identity mapping, and we'll start via ZO's
>> (arch/x86/boot/compressed/vmlinux) startup_64. In this case, the
>> bootloader's page tables need to be avoided when we select the new VO
>> (vmlinux) location. If not, the decompressor could overwrite them during
>> decompression.
>>
>> To accomplish avoiding the bootloader's page tables, we could walk the
>> pagetable and find every page that is used, and add them to mem_avoid,
>> but this needs extra code and will require increasing the size of the
>> mem_avoid array.
>>
>> Instead, we can create a new ident mapping instead, and pages for the
>> pagetable will come from the _pagetable section of ZO, which means they
>> are already in mem_avoid array. To do this, we reuse the code for the
>> kernel's identity mapping.
>>
>> The _pgtable will be shared by 32-bit and 64-bit path to reduce init_size,
>> as now ZO _rodata to _end will contribute init_size.
>>
>> To handle the possible mappings, we need to increase the pgt buffer size:
>>
>> When booting via startup_64, as we need to cover the old VO, params,
>> cmdline and new VO. In an extreme case we could have them all beyond the
>> 512G boundary, which needs (2+2)*4 pages with 2M mappings. And we'll
>> need 2 for first 2M for VGA RAM. One more is needed for level4. This
>> gets us to 19 pages total.
>>
>> When booting via startup_32, KASLR could move the new VO above 4G, so we
>> need to set extra identity mappings for the VO, which should only need
>> (2+2) pages at most when it is beyond the 512G boundary. So 19 pages is
>> sufficient for this case as well.
>
> In changelogs and comments please refer to C functions and symbols that point to
> executable code via '()', i.e. startup_64(), etc.
>
>> +#ifdef CONFIG_X86_VERBOSE_BOOTUP
>> +     /* for video ram */
>
> Please capitalize RAM and generally free flowing comment sentences, i.e.:
>
>> +     /* For video RAM: */
>
>> +#ifdef CONFIG_X86_64
>> +void fill_pagetable(unsigned long start, unsigned long size);
>> +void switch_pagetable(void);
>
> These are very ambiguous function names. Which pagetables are these? Kernel or
> user? Is it boot time or final page tables? etc.
>
> Also what does the switching do?
>
>> --- /dev/null
>> +++ b/arch/x86/boot/compressed/misc_pgt.c
>> @@ -0,0 +1,93 @@
>> +#define __pa(x)  ((unsigned long)(x))
>> +#define __va(x)  ((void *)((unsigned long)(x)))
>> +
>> +#include "misc.h"
>> +
>> +#include <asm/init.h>
>> +#include <asm/pgtable.h>
>> +
>> +#include "../../mm/ident_map.c"
>> +#include "../string.h"
>
> Again a new .c file with no comments whatsoever :-(
>
> Also, we just decided that 'misc.c' was a bad name. Is there really no better name
> than misc_pgt.c?
>
>> +struct alloc_pgt_data {
>> +     unsigned char *pgt_buf;
>> +     unsigned long pgt_buf_size;
>> +     unsigned long pgt_buf_offset;
>> +};
>> +
>> +static void *alloc_pgt_page(void *context)
>
> Non-obvious functions with no comments describing them.
>
>> +unsigned long __force_order;
>> +static struct alloc_pgt_data pgt_data;
>> +static struct x86_mapping_info mapping_info;
>> +static pgd_t *level4p;
>
> What's this __force_order flag? Why does it have double underscores?
>
>> +{
>> +     unsigned long end = start + size;
>> +
>> +     if (!level4p) {
>> +             pgt_data.pgt_buf_offset = 0;
>> +             mapping_info.alloc_pgt_page = alloc_pgt_page;
>> +             mapping_info.context = &pgt_data;
>> +             mapping_info.pmd_flag = __PAGE_KERNEL_LARGE_EXEC;
>> +
>> +             /*
>> +              * come from startup_32 ?
>> +              * then cr3 is _pgtable, we can reuse it.
>
> come what? What does this comment mean??
>
>> +              */
>> +             level4p = (pgd_t *)read_cr3();
>
> Argh, another type cast. A quick check shows:
>
> +static pgd_t *level4p;
> +       if (!level4p) {
> +               level4p = (pgd_t *)read_cr3();
> +               if ((unsigned long)level4p == (unsigned long)_pgtable) {
> +                       level4p = (pgd_t *)alloc_pgt_page(&pgt_data);
> +       kernel_ident_mapping_init(&mapping_info, level4p, start, end);
> +       write_cr3((unsigned long)level4p);
>
> ... that the natural type for level4p would be unsigned long, not pgt_t ...
>
>
>> +             if ((unsigned long)level4p == (unsigned long)_pgtable) {
>> +                     pgt_data.pgt_buf = (unsigned char *)_pgtable +
>> +                                              BOOT_INIT_PGT_SIZE;
>> +                     pgt_data.pgt_buf_size = BOOT_PGT_SIZE -
>> +                                              BOOT_INIT_PGT_SIZE;
>> +                     memset((unsigned char *)pgt_data.pgt_buf, 0,
>> +                             pgt_data.pgt_buf_size);
>
> Is that (unsigned char *) type cast really necessary??
>
> Type casts are the absolute exception, we avoid them whenever possible - and this
> code is using them like candy :-(
>
> Also, for heaven's sake, either ignore checkpatch.pl whining, or avoid the
> excessive indentation by using helper functions (or some other technique).
>
>> +                     debug_putstr("boot via startup_32\n");
>> +             } else {
>> +                     pgt_data.pgt_buf = (unsigned char *)_pgtable;
>> +                     pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
>> +                     memset((unsigned char *)pgt_data.pgt_buf, 0,
>> +                             pgt_data.pgt_buf_size);
>> +                     debug_putstr("boot via startup_64\n");
>> +                     level4p = (pgd_t *)alloc_pgt_page(&pgt_data);
>> +             }
>> +     }
>> +
>> +     /* align boundary to 2M */
>> +     start = round_down(start, PMD_SIZE);
>> +     end = round_up(end, PMD_SIZE);
>> +     if (start >= end)
>> +             return;
>> +
>> +     kernel_ident_mapping_init(&mapping_info, level4p, start, end);
>> +}
>> +
>> +void switch_pagetable(void)
>> +{
>> +     write_cr3((unsigned long)level4p);
>> +}
>> diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
>> index 6b8d6e8cd449..52a9cbc1419f 100644
>> --- a/arch/x86/include/asm/boot.h
>> +++ b/arch/x86/include/asm/boot.h
>> @@ -32,7 +32,26 @@
>>  #endif /* !CONFIG_KERNEL_BZIP2 */
>>
>>  #ifdef CONFIG_X86_64
>> +
>>  #define BOOT_STACK_SIZE      0x4000
>> +
>> +#define BOOT_INIT_PGT_SIZE (6*4096)
>> +#ifdef CONFIG_RANDOMIZE_BASE
>> +/*
>> + * 1 page for level4, 2 pages for first 2M.
>> + * (2+2)*4 pages for kernel, param, cmd_line, random kernel
>> + * if all cross 512G boundary.
>> + * So total will be 19 pages.
>> + */
>> +#ifdef CONFIG_X86_VERBOSE_BOOTUP
>> +#define BOOT_PGT_SIZE (19*4096)
>> +#else
>> +#define BOOT_PGT_SIZE (17*4096)
>> +#endif
>> +#else
>> +#define BOOT_PGT_SIZE BOOT_INIT_PGT_SIZE
>> +#endif
>
> Please use proper nesting of defines to make it more readable, i.e. something
> like:
>
> #define BOOT_INIT_PGT_SIZE (6*4096)
>
> #ifdef CONFIG_RANDOMIZE_BASE
> /*
>  * 1 page for level4, 2 pages for first 2M.
>  * (2+2)*4 pages for kernel, param, cmd_line, random kernel
>  * if all cross 512G boundary.
>  * So total will be 19 pages.
>  */
> # ifdef CONFIG_X86_VERBOSE_BOOTUP
> #  define BOOT_PGT_SIZE (19*4096)
> # else
> #  define BOOT_PGT_SIZE (17*4096)
> # endif
> #else
> # define BOOT_PGT_SIZE BOOT_INIT_PGT_SIZE
> #endif
>
> but more importantly, BOOT_PGT_SIZE is really a bad name for this. Since it's used
> by an allocator it's clear that this is a _maximum_. Why not put that fact into
> the name??
>
> Basically you took a butt-ugly patch from Yinghai that shat all over the kernel
> and rewrote its changelog - but that's not enough to make it acceptable! As a
> general rule, most Yinghai patches I've seen in the past couple of years were
> butt-ugly. If you take a patch from Yinghai you have to completely rewrite it in
> most cases.
>
> So I'm really annoyed, I see myself repeating the same kind of review feedback I
> gave to Yinghai again and again, and now to you?
>
> If it's less work for you then please rewrite Yinghai's patches from scratch - and
> possibly split them up as well wherever possible, as they are risky as hell.

Okay, noted. I'll rewrite them. And really, at this point, I've mostly
rewritten half of them as it is, so easier to just keep going with it.

> I've applied the first two patches because they look OK, but _please_ do a proper
> job with the rest of the series as well!

Okay, I'll give it a shot!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
