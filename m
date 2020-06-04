Return-Path: <SRS0=/594=7R=lists.openwall.com=kernel-hardening-return-18933-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6FDC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 17:27:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47C8F206C3
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 17:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47C8F206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18933-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24501 invoked by uid 550); 4 Jun 2020 17:27:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24476 invoked from network); 4 Jun 2020 17:27:42 -0000
IronPort-SDR: QquI9PHwfyL2nhfDFc55CbZlPbOXvh8L9gOOz3S2ngmUtzZR7fMgd9ECj8NbghRtOOtPkNxbMY
 RDdGR91Kz+iQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: YTC949H0gHcppNaYyHdjr0hHLRksGBFg2FAmMrgtoUUl429LWpyRcOVJZ7a2LGlQVTnSoLn0+r
 KCj75wtoyCqQ==
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="304780070"
Message-ID: <7d95c165766be97843f11d2695d1538f94ceb1d4.camel@linux.intel.com>
Subject: Re: [PATCH v2 7/9] x86: Add support for function granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, Jonathan Corbet
	 <corbet@lwn.net>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	arjan@linux.intel.com, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, Tony Luck
	 <tony.luck@intel.com>, linux-doc@vger.kernel.org
Date: Thu, 04 Jun 2020 10:27:24 -0700
In-Reply-To: <202005211301.4853672E2@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
	 <20200521165641.15940-8-kristen@linux.intel.com>
	 <202005211301.4853672E2@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-05-21 at 14:08 -0700, Kees Cook wrote:
> On Thu, May 21, 2020 at 09:56:38AM -0700, Kristen Carlson Accardi
> wrote:
> > At boot time, find all the function sections that have separate
> > .text
> > sections, shuffle them, and then copy them to new locations. Adjust
> > any relocations accordingly.
> 
> Commit log length vs "11 files changed, 1159 insertions(+), 15
> deletions(-)" implies to me that a lot more detail is needed here. ;)
> 
> Perhaps describe what the code pieces are, why the code is being
> added
> are here, etc (I see at least the ELF parsing, the ELF shuffling, the
> relocation updates, the symbol list, and the re-sorting of kallsyms,
> ORC, and extables. I think the commit log should prepare someone to
> read
> the diff and know what to expect to find. (In the end, I wonder if
> these
> pieces should be split up into logically separate patches, but for
> now,
> let's just go with it -- though I've made some suggestions below
> about
> things that might be worth splitting out.)
> 
> More below...
> 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > Tested-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  Documentation/security/fgkaslr.rst       | 155 +++++
> >  Documentation/security/index.rst         |   1 +
> >  arch/x86/boot/compressed/Makefile        |   3 +
> >  arch/x86/boot/compressed/fgkaslr.c       | 823
> > +++++++++++++++++++++++
> >  arch/x86/boot/compressed/kaslr.c         |   4 -
> >  arch/x86/boot/compressed/misc.c          | 109 ++-
> >  arch/x86/boot/compressed/misc.h          |  34 +
> >  arch/x86/boot/compressed/utils.c         |  12 +
> >  arch/x86/boot/compressed/vmlinux.symbols |  17 +
> >  arch/x86/include/asm/boot.h              |  15 +-
> >  include/uapi/linux/elf.h                 |   1 +
> >  11 files changed, 1159 insertions(+), 15 deletions(-)
> >  create mode 100644 Documentation/security/fgkaslr.rst
> >  create mode 100644 arch/x86/boot/compressed/fgkaslr.c
> >  create mode 100644 arch/x86/boot/compressed/utils.c
> >  create mode 100644 arch/x86/boot/compressed/vmlinux.symbols
> > 
> > diff --git a/Documentation/security/fgkaslr.rst
> > b/Documentation/security/fgkaslr.rst
> > new file mode 100644
> > index 000000000000..94939c62c50d
> > --- /dev/null
> > +++ b/Documentation/security/fgkaslr.rst
> > @@ -0,0 +1,155 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==================================================================
> > ===
> > +Function Granular Kernel Address Space Layout Randomization
> > (fgkaslr)
> > +==================================================================
> > ===
> > +
> > +:Date: 6 April 2020
> > +:Author: Kristen Accardi
> > +
> > +Kernel Address Space Layout Randomization (KASLR) was merged into
> > the kernel
> > +with the objective of increasing the difficulty of code reuse
> > attacks. Code
> > +reuse attacks reused existing code snippets to get around existing
> > memory
> > +protections. They exploit software bugs which expose addresses of
> > useful code
> > +snippets to control the flow of execution for their own nefarious
> > purposes.
> > +KASLR as it was originally implemented moves the entire kernel
> > code text as a
> > +unit at boot time in order to make addresses less predictable. The
> > order of the
> > +code within the segment is unchanged - only the base address is
> > shifted. There
> > +are a few shortcomings to this algorithm.
> > +
> > +1. Low Entropy - there are only so many locations the kernel can
> > fit in. This
> > +   means an attacker could guess without too much trouble.
> > +2. Knowledge of a single address can reveal the offset of the base
> > address,
> > +   exposing all other locations for a published/known kernel
> > image.
> > +3. Info leaks abound.
> > +
> > +Finer grained ASLR has been proposed as a way to make ASLR more
> > resistant
> > +to info leaks. It is not a new concept at all, and there are many
> > variations
> > +possible. Function reordering is an implementation of finer
> > grained ASLR
> > +which randomizes the layout of an address space on a function
> > level
> > +granularity. The term "fgkaslr" is used in this document to refer
> > to the
> > +technique of function reordering when used with KASLR, as well as
> > finer grained
> > +KASLR in general.
> > +
> > +The objective of this patch set is to improve a technology that is
> > already
> > +merged into the kernel (KASLR). This code will not prevent all
> > code reuse
> > +attacks, and should be considered as one of several tools that can
> > be used.
> > +
> > +Implementation Details
> > +======================
> > +
> > +The over-arching objective of the fgkaslr implementation is
> > incremental
> > +improvement over the existing KASLR algorithm. It is designed to
> > work with
> > +the existing solution, and there are two main area where code
> > changes occur:
> > +Build time, and Load time.
> > +
> > +Build time
> > +----------
> > +
> > +GCC has had an option to place functions into individual .text
> > sections
> > +for many years now (-ffunction-sections). This option is used to
> > implement
> > +function reordering at load time. The final compiled vmlinux
> > retains all the
> > +section headers, which can be used to help find the address ranges
> > of each
> > +function. Using this information and an expanded table of
> > relocation addresses,
> > +individual text sections can be shuffled immediately after
> > decompression.
> > +Some data tables inside the kernel that have assumptions about
> > order
> > +require sorting after the update. In order to modify these tables,
> > +a few key symbols from the objcopy symbol stripping process are
> > preserved
> > +for use after shuffling the text segments.
> > +
> > +Load time
> > +---------
> > +
> > +The boot kernel was modified to parse the vmlinux elf file after
> > +decompression to check for symbols for modifying data tables, and
> > to
> > +look for any .text.* sections to randomize. The sections are then
> > shuffled,
> > +and tables are updated or resorted. The existing code which
> > updated relocation
> > +addresses was modified to account for not just a fixed delta from
> > the load
> > +address, but the offset that the function section was moved to.
> > This requires
> > +inspection of each address to see if it was impacted by a
> > randomization.
> > +
> > +In order to hide the new layout, symbols reported through
> > /proc/kallsyms will
> > +be sorted by name alphabetically rather than by address.
> > +
> > +Performance Impact
> > +==================
> > +
> > +There are two areas where function reordering can impact
> > performance: boot
> > +time latency, and run time performance.
> > +
> > +Boot time latency
> > +-----------------
> > +
> > +This implementation of finer grained KASLR impacts the boot time
> > of the kernel
> > +in several places. It requires additional parsing of the kernel
> > ELF file to
> > +obtain the section headers of the sections to be randomized. It
> > calls the
> > +random number generator for each section to be randomized to
> > determine that
> > +section's new memory location. It copies the decompressed kernel
> > into a new
> > +area of memory to avoid corruption when laying out the newly
> > randomized
> > +sections. It increases the number of relocations the kernel has to
> > perform at
> > +boot time vs. standard KASLR, and it also requires a lookup on
> > each address
> > +that needs to be relocated to see if it was in a randomized
> > section and needs
> > +to be adjusted by a new offset. Finally, it re-sorts a few data
> > tables that
> > +are required to be sorted by address.
> > +
> > +Booting a test VM on a modern, well appointed system showed an
> > increase in
> > +latency of approximately 1 second.
> > +
> > +Run time
> > +--------
> > +
> > +The performance impact at run-time of function reordering varies
> > by workload.
> > +Randomly reordering the functions will cause an increase in cache
> > misses
> > +for some workloads. Some workloads perform significantly worse
> > under FGKASLR,
> > +while others stay the same or even improve. In general, it will
> > depend on the
> > +code flow whether or not finer grained KASLR will impact a
> > workload, and how
> > +the underlying code was designed. Because the layout changes per
> > boot, each
> > +time a system is rebooted the performance of a workload may
> > change.
> > +
> > +Image Size
> > +==========
> > +
> > +fgkaslr increases the size of the kernel binary due to the extra
> > section
> > +headers that are included, as well as the extra relocations that
> > need to
> > +be added. You can expect fgkaslr to increase the size of the
> > resulting
> > +vmlinux by about 3%, and the compressed image (bzImage) by 15%.
> > +
> > +Memory Usage
> > +============
> > +
> > +fgkaslr increases the amount of heap that is required at boot
> > time,
> > +although this extra memory is released when the kernel has
> > finished
> > +decompression. As a result, it may not be appropriate to use this
> > feature
> > +on systems without much memory.
> > +
> > +Building
> > +========
> > +
> > +To enable fine grained KASLR, you need to have the following
> > config options
> > +set (including all the ones you would use to build normal KASLR)
> > +
> > +``CONFIG_FG_KASLR=y``
> > +
> > +fgkaslr for the kernel is only supported for the X86_64
> > architecture.
> > +
> > +Modules
> > +=======
> > +
> > +Modules are randomized similarly to the rest of the kernel by
> > shuffling
> > +the sections at load time prior to moving them into memory. The
> > module must
> > +also have been build with the -ffunction-sections compiler option.
> > +
> > +Although fgkaslr for the kernel is only supported for the X86_64
> > architecture,
> > +it is possible to use fgkaslr with modules on other architectures.
> > To enable
> > +this feature, select the following config option:
> > +
> > +``CONFIG_MODULE_FG_KASLR``
> > +
> > +This option is selected automatically for X86_64 when
> > CONFIG_FG_KASLR is set.
> > +
> > +Disabling
> > +=========
> > +
> > +Disabling normal kaslr using the nokaslr command line option also
> > disables
> > +fgkaslr. In addtion, it is possible to disable fgkaslr separately
> > by booting
> > +with fgkaslr=off on the commandline.
> 
> Yay documentation! Are you able to include the references to the
> papers
> you discuss in the cover letter in here too?

Yes, I will add the two papers I referenced, although it isn't a very
thorough list of references (ok, not even close to thorough).

> 
> > diff --git a/Documentation/security/index.rst
> > b/Documentation/security/index.rst
> > index fc503dd689a7..5e370c409ad2 100644
> > --- a/Documentation/security/index.rst
> > +++ b/Documentation/security/index.rst
> > @@ -7,6 +7,7 @@ Security Documentation
> >  
> >     credentials
> >     IMA-templates
> > +   fgkaslr
> >     keys/index
> >     lsm
> >     lsm-development
> > diff --git a/arch/x86/boot/compressed/Makefile
> > b/arch/x86/boot/compressed/Makefile
> > index 3a5a004498de..0ad5a31f1f0a 100644
> > --- a/arch/x86/boot/compressed/Makefile
> > +++ b/arch/x86/boot/compressed/Makefile
> > @@ -80,10 +80,12 @@ vmlinux-objs-y := $(obj)/vmlinux.lds
> > $(obj)/kernel_info.o $(obj)/head_$(BITS).o
> >  
> >  vmlinux-objs-$(CONFIG_EARLY_PRINTK) +=
> > $(obj)/early_serial_console.o
> >  vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr.o
> > +vmlinux-objs-$(CONFIG_FG_KASLR) += $(obj)/utils.o
> >  ifdef CONFIG_X86_64
> >  	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr_64.o
> >  	vmlinux-objs-y += $(obj)/mem_encrypt.o
> >  	vmlinux-objs-y += $(obj)/pgtable_64.o
> > +	vmlinux-objs-$(CONFIG_FG_KASLR) += $(obj)/fgkaslr.o
> >  endif
> 
> CONFIG_FG_KASLR is already gated by CONFIG_X86-64, so I think you can
> just put these all on the same line before the ifdef:
> 
> vmlinux-objs-$(CONFIG_FG_KASLR) += $(obj)/utils.o $(obj)/fgkaslr.o
> 
> >  
> >  vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
> > @@ -120,6 +122,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
> >  
> >  ifdef CONFIG_FG_KASLR
> >  	RELOCS_ARGS += --fg-kaslr
> > +	OBJCOPYFLAGS += --keep-
> > symbols=$(srctree)/$(src)/vmlinux.symbols
> >  endif
> >  
> >  $(obj)/vmlinux.bin: vmlinux FORCE
> > diff --git a/arch/x86/boot/compressed/fgkaslr.c
> > b/arch/x86/boot/compressed/fgkaslr.c
> > new file mode 100644
> > index 000000000000..451e807de276
> > --- /dev/null
> > +++ b/arch/x86/boot/compressed/fgkaslr.c
> > @@ -0,0 +1,823 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * fgkaslr.c
> > + *
> > + * This contains the routines needed to reorder the kernel text
> > section
> > + * at boot time.
> > + */
> > +#include "misc.h"
> > +#include "error.h"
> > +#include "pgtable.h"
> > +#include "../string.h"
> > +#include "../voffset.h"
> > +#include <linux/sort.h>
> > +#include <linux/bsearch.h>
> > +#include "../../include/asm/extable.h"
> > +#include "../../include/asm/orc_types.h"
> > +
> > +/*
> > + * Longest parameter of 'fgkaslr=' is 'off' right now, plus an
> > extra '\0'
> > + * for termination.
> > + */
> > +#define MAX_FGKASLR_ARG_LENGTH 4
> > +int nofgkaslr;
> 
> This can be static.
> 
> > +
> > +/*
> > + * Use normal definitions of mem*() from string.c. There are
> > already
> > + * included header files which expect a definition of memset() and
> > by
> > + * the time we define memset macro, it is too late.
> > + */
> > +#undef memcpy
> > +#undef memset
> > +#define memzero(s, n)	memset((s), 0, (n))
> > +#define memmove		memmove
> > +
> > +void *memmove(void *dest, const void *src, size_t n);
> > +
> > +static unsigned long percpu_start;
> > +static unsigned long percpu_end;
> > +
> > +static long kallsyms_names;
> > +static long kallsyms_offsets;
> > +static long kallsyms_num_syms;
> > +static long kallsyms_relative_base;
> > +static long kallsyms_markers;
> > +static long __start___ex_table_addr;
> > +static long __stop___ex_table_addr;
> > +static long _stext;
> > +static long _etext;
> > +static long _sinittext;
> > +static long _einittext;
> > +static long __start_orc_unwind_ip;
> > +static long __stop_orc_unwind_ip;
> > +static long __start_orc_unwind;
> > +
> > +/* addresses in mapped address space */
> > +static int *base;
> > +static u8 *names;
> > +static unsigned long relative_base;
> > +static unsigned int *markers_addr;
> > +
> > +struct kallsyms_name {
> > +	u8 len;
> > +	u8 indecis[256];
> > +};
> > +
> > +struct kallsyms_name *names_table;
> > +
> > +struct orc_entry *cur_orc_table;
> > +int *cur_orc_ip_table;
> 
> static?
> 
> > +
> > +/*
> > + * This is an array of pointers to sections headers for randomized
> > sections
> > + */
> > +Elf64_Shdr **sections;
> 
> Given the creation of the Elf_Shdr etc macros in the header, should
> all
> of the Elf64 things in here be updated to use the size-agnostic
> macros?
> (Is anyone actually going to run a 32-bit kernel with fgkaslr some
> day?)

I suppose it's not impossible, just ... not useful. I will make the
update.

> 
> > +
> > +/*
> > + * This is an array of all section headers, randomized or
> > otherwise.
> 
> Comments nitpick while I'm thinking about it: "This is" tends to be
> redundant, and I'd pick a single-sentence-comment punctuation style:
> i.e. with or without an ending period. I personally prefer including
> the
> period, but mainly I think it should just be consistent. :)
> 
> > + */
> > +Elf64_Shdr *sechdrs;
> 
> Also, these can be static?
> 
> > +
> > +/*
> > + * The number of elements in the randomized section header array
> > (sections)
> > + */
> > +int sections_size;
> 
> static? (Also, it seems this is related to "sections" above, so maybe
> more it closer?)
> 
> > +
> > +static bool is_text(long addr)
> > +{
> > +	if ((addr >= _stext && addr < _etext) ||
> > +	    (addr >= _sinittext && addr < _einittext))
> > +		return true;
> > +	return false;
> > +}
> > +
> > +bool is_percpu_addr(long pc, long offset)
> > +{
> > +	unsigned long ptr;
> > +	long address;
> > +
> > +	address = pc + offset + 4;
> > +
> > +	ptr = (unsigned long)address;
> > +
> > +	if (ptr >= percpu_start && ptr < percpu_end)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +static int cmp_section_addr(const void *a, const void *b)
> > +{
> > +	unsigned long ptr = (unsigned long)a;
> > +	Elf64_Shdr *s = *(Elf64_Shdr **)b;
> > +	unsigned long end = s->sh_addr + s->sh_size;
> > +
> > +	if (ptr >= s->sh_addr && ptr < end)
> > +		return 0;
> > +
> > +	if (ptr < s->sh_addr)
> > +		return -1;
> > +
> > +	return 1;
> > +}
> > +
> > +/*
> > + * Discover if the address is in a randomized section and if so,
> > adjust
> > + * by the saved offset.
> > + */
> > +Elf64_Shdr *adjust_address(long *address)
> > +{
> > +	Elf64_Shdr **s;
> > +	Elf64_Shdr *shdr;
> > +
> > +	if (nofgkaslr)
> > +		return NULL;
> > +
> > +	s = bsearch((const void *)*address, sections, sections_size,
> > sizeof(*s),
> > +		    cmp_section_addr);
> > +	if (s) {
> > +		shdr = *s;
> > +		*address += shdr->sh_offset;
> > +		return shdr;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +void adjust_relative_offset(long pc, long *value, Elf64_Shdr
> > *section)
> > +{
> > +	Elf64_Shdr *s;
> > +	long address;
> > +
> > +	if (nofgkaslr)
> > +		return;
> > +
> > +	/*
> > +	 * sometimes we are updating a relative offset that would
> > +	 * normally be relative to the next instruction (such as a
> > call).
> > +	 * In this case to calculate the target, you need to add 32bits
> > to
> > +	 * the pc to get the next instruction value. However, sometimes
> > +	 * targets are just data that was stored in a table such as
> > ksymtab
> > +	 * or cpu alternatives. In this case our target is not relative
> > to
> > +	 * the next instruction.
> > +	 */
> 
> Excellent and scary comment. ;) Was this found by trial and error?
> That
> sounds "fun" to debug. :P
> 
> > +
> > +	/*
> > +	 * Calculate the address that this offset would call.
> > +	 */
> > +	if (!is_text(pc))
> > +		address = pc + *value;
> > +	else
> > +		address = pc + *value + 4;
> > +
> > +	/*
> > +	 * if the address is in section that was randomized,
> > +	 * we need to adjust the offset.
> > +	 */
> > +	s = adjust_address(&address);
> > +	if (s)
> > +		*value += s->sh_offset;
> > +
> > +	/*
> > +	 * If the PC that this offset was calculated for was in a
> > section
> > +	 * that has been randomized, the value needs to be adjusted by
> > the
> > +	 * same amount as the randomized section was adjusted from it's
> > original
> > +	 * location.
> > +	 */
> > +	if (section)
> > +		*value -= section->sh_offset;
> > +}
> > +
> > +static void kallsyms_swp(void *a, void *b, int size)
> > +{
> > +	int idx1, idx2;
> > +	int temp;
> > +	struct kallsyms_name name_a;
> > +
> > +	/* determine our index into the array */
> > +	idx1 = (int *)a - base;
> > +	idx2 = (int *)b - base;
> > +	temp = base[idx1];
> > +	base[idx1] = base[idx2];
> > +	base[idx2] = temp;
> > +
> > +	/* also swap the names table */
> > +	memcpy(&name_a, &names_table[idx1], sizeof(name_a));
> > +	memcpy(&names_table[idx1], &names_table[idx2],
> > +	       sizeof(struct kallsyms_name));
> > +	memcpy(&names_table[idx2], &name_a, sizeof(struct
> > kallsyms_name));
> > +}
> > +
> > +static int kallsyms_cmp(const void *a, const void *b)
> > +{
> > +	int addr_a, addr_b;
> > +	unsigned long uaddr_a, uaddr_b;
> > +
> > +	addr_a = *(int *)a;
> > +	addr_b = *(int *)b;
> > +
> > +	if (addr_a >= 0)
> > +		uaddr_a = addr_a;
> > +	if (addr_b >= 0)
> > +		uaddr_b = addr_b;
> > +
> > +	if (addr_a < 0)
> > +		uaddr_a = relative_base - 1 - addr_a;
> > +	if (addr_b < 0)
> > +		uaddr_b = relative_base - 1 - addr_b;
> > +
> > +	if (uaddr_b > uaddr_a)
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static void deal_with_names(int num_syms)
> > +{
> > +	int num_bytes;
> > +	int i, j;
> > +	int offset;
> > +
> > +	/* we should have num_syms kallsyms_name entries */
> > +	num_bytes = num_syms * sizeof(*names_table);
> > +	names_table = malloc(num_syms * sizeof(*names_table));
> > +	if (!names_table) {
> > +		debug_putstr("\nbytes requested: ");
> > +		debug_puthex(num_bytes);
> > +		error("\nunable to allocate space for names table\n");
> > +	}
> > +
> > +	/* read all the names entries */
> > +	offset = 0;
> > +	for (i = 0; i < num_syms; i++) {
> > +		names_table[i].len = names[offset];
> > +		offset++;
> > +		for (j = 0; j < names_table[i].len; j++) {
> > +			names_table[i].indecis[j] = names[offset];
> > +			offset++;
> > +		}
> > +	}
> > +}
> > +
> > +static void write_sorted_names(int num_syms)
> > +{
> > +	int i, j;
> > +	int offset = 0;
> > +	unsigned int *markers;
> > +
> > +	/*
> > +	 * we are going to need to regenerate the markers table, which
> > is a
> > +	 * table of offsets into the compressed stream every 256
> > symbols.
> > +	 * this code copied almost directly from scripts/kallsyms.c
> > +	 */
> 
> Can any of this kallsyms sorting code be reasonably reused instead
> of copy/pasting? Or is this mostly novel in that it's taking the
> output
> of that earlier sort, which isn't the input format scripts/kallsyms.c
> uses?

No - I cut out only code blocks from scripts/kallsyms.c, but there was
no neat way to reuse entire functions without majorly refactoring a lot
of stuff in scripts/kallsyms.c

> 
> > +	markers = malloc(sizeof(unsigned int) * ((num_syms + 255) /
> > 256));
> > +	if (!markers) {
> > +		debug_putstr("\nfailed to allocate heap space of ");
> > +		debug_puthex(((num_syms + 255) / 256));
> > +		debug_putstr(" bytes\n");
> > +		error("Unable to allocate space for markers table");
> > +	}
> > +
> > +	for (i = 0; i < num_syms; i++) {
> > +		if ((i & 0xFF) == 0)
> > +			markers[i >> 8] = offset;
> > +
> > +		names[offset] = (u8)names_table[i].len;
> > +		offset++;
> > +		for (j = 0; j < names_table[i].len; j++) {
> > +			names[offset] = (u8)names_table[i].indecis[j];
> > +			offset++;
> > +		}
> > +	}
> > +
> > +	/* write new markers table over old one */
> > +	for (i = 0; i < ((num_syms + 255) >> 8); i++)
> > +		markers_addr[i] = markers[i];
> > +
> > +	free(markers);
> > +	free(names_table);
> > +}
> > +
> > +static void sort_kallsyms(unsigned long map)
> > +{
> > +	int num_syms;
> > +	int i;
> > +
> > +	debug_putstr("\nRe-sorting kallsyms...\n");
> > +
> > +	num_syms = *(int *)(kallsyms_num_syms + map);
> > +	base = (int *)(kallsyms_offsets + map);
> > +	relative_base = *(unsigned long *)(kallsyms_relative_base +
> > map);
> > +	markers_addr = (unsigned int *)(kallsyms_markers + map);
> > +	names = (u8 *)(kallsyms_names + map);
> > +
> > +	/*
> > +	 * the kallsyms table was generated prior to any randomization.
> > +	 * it is a bunch of offsets from "relative base". In order for
> > +	 * us to check if a symbol has an address that was in a
> > randomized
> > +	 * section, we need to reconstruct the address to it's original
> > +	 * value prior to handle_relocations.
> > +	 */
> > +	for (i = 0; i < num_syms; i++) {
> > +		unsigned long addr;
> > +		int new_base;
> > +
> > +		/*
> > +		 * according to kernel/kallsyms.c, positive offsets are
> > absolute
> > +		 * values and negative offsets are relative to the
> > base.
> > +		 */
> > +		if (base[i] >= 0)
> > +			addr = base[i];
> > +		else
> > +			addr = relative_base - 1 - base[i];
> > +
> > +		if (adjust_address(&addr)) {
> > +			/* here we need to recalcuate the offset */
> > +			new_base = relative_base - 1 - addr;
> > +			base[i] = new_base;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * here we need to read in all the kallsyms_names info
> > +	 * so that we can regenerate it.
> > +	 */
> > +	deal_with_names(num_syms);
> > +
> > +	sort(base, num_syms, sizeof(int), kallsyms_cmp, kallsyms_swp);
> > +
> > +	/* write the newly sorted names table over the old one */
> > +	write_sorted_names(num_syms);
> > +}
> > +
> > +#include "../../../../lib/extable.c"
> 
> Now that the earlier linking glitches have been sorted out, I wonder
> if
> it might be nicer to add this as a separate compilation unit, similar
> to
> how early_serial_console.c is done? (Or, I guess, more specifically,
> why
> can't this be in utils.c?)

The problem with putting this in utils.c was because there was an
inline function (static) that I use that is defined in extable.c
(ex_to_insn). If I move this to utils.c I'm not sure how to keep re-
using this inline function without modifying it with a define like
STATIC. I thought it was cleaner to just leave it alone and do it this
way.

> 
> > +
> > +static inline unsigned long
> > +ex_fixup_handler(const struct exception_table_entry *x)
> > +{
> > +	return ((unsigned long)&x->handler + x->handler);
> > +}
> > +
> > +static inline unsigned long
> > +ex_fixup_addr(const struct exception_table_entry *x)
> > +{
> > +	return ((unsigned long)&x->fixup + x->fixup);
> > +}
> > +
> > +static void update_ex_table(unsigned long map)
> > +{
> > +	struct exception_table_entry *start_ex_table =
> > +		(struct exception_table_entry
> > *)(__start___ex_table_addr + map);
> > +	struct exception_table_entry *stop_ex_table =
> > +		(struct exception_table_entry *)(__stop___ex_table_addr
> > + map);
> > +	int num_entries =
> > +		(__stop___ex_table_addr - __start___ex_table_addr) /
> > +		sizeof(struct exception_table_entry);
> > +	int i;
> > +
> > +	debug_putstr("\nUpdating exception table...");
> > +	for (i = 0; i < num_entries; i++) {
> > +		unsigned long insn = ex_to_insn(&start_ex_table[i]);
> > +		unsigned long fixup =
> > ex_fixup_addr(&start_ex_table[i]);
> > +		unsigned long handler =
> > ex_fixup_handler(&start_ex_table[i]);
> > +		unsigned long addr;
> > +		Elf64_Shdr *s;
> > +
> > +		/* check each address to see if it needs adjusting */
> > +		addr = insn - map;
> > +		s = adjust_address(&addr);
> > +		if (s)
> > +			start_ex_table[i].insn += s->sh_offset;
> > +
> > +		addr = fixup - map;
> > +		s = adjust_address(&addr);
> > +		if (s)
> > +			start_ex_table[i].fixup += s->sh_offset;
> > +
> > +		addr = handler - map;
> > +		s = adjust_address(&addr);
> > +		if (s)
> > +			start_ex_table[i].handler += s->sh_offset;
> > +	}
> > +}
> > +
> > +static void sort_ex_table(unsigned long map)
> > +{
> > +	struct exception_table_entry *start_ex_table =
> > +		(struct exception_table_entry
> > *)(__start___ex_table_addr + map);
> > +	struct exception_table_entry *stop_ex_table =
> > +		(struct exception_table_entry *)(__stop___ex_table_addr
> > + map);
> > +
> > +	debug_putstr("\nRe-sorting exception table...");
> > +
> > +	sort_extable(start_ex_table, stop_ex_table);
> > +}
> > +

<snip>

> > +void parse_sections_headers(void *output, Elf64_Ehdr *ehdr,
> > Elf64_Phdr *phdrs)
> > +{
> > +	Elf64_Phdr *phdr;
> > +	Elf64_Shdr *s;
> > +	Elf64_Shdr *text = NULL;
> > +	Elf64_Shdr *percpu = NULL;
> > +	char *secstrings;
> > +	const char *sname;
> > +	int num_sections = 0;
> > +	Elf64_Sym *symtab = NULL;
> > +	char *strtab = NULL;
> > +	long num_syms = 0;
> > +	void *dest;
> > +	int i;
> > +	char arg[MAX_FGKASLR_ARG_LENGTH];
> > +	Elf64_Shdr shdr;
> > +	unsigned long shnum;
> > +	unsigned int shstrndx;
> > +
> > +	debug_putstr("\nParsing ELF section headers... ");
> > +
> > +	/*
> > +	 * Even though fgkaslr may have been disabled, we still
> > +	 * need to parse through the section headers to get the
> > +	 * start and end of the percpu section. This is because
> > +	 * if we were built with CONFIG_FG_KASLR, there are more
> > +	 * relative relocations present in vmlinux.relocs than
> > +	 * just the percpu, and only the percpu relocs need to be
> > +	 * adjusted when using just normal base address kaslr.
> > +	 */
> > +	if (cmdline_find_option("fgkaslr", arg, sizeof(arg)) == 3 &&
> > +	    !strncmp(arg, "off", 3)) {
> > +		warn("FG_KASLR disabled on cmdline.");
> > +		nofgkaslr = 1;
> > +	}
> > +
> > +	/* read the first section header */
> > +	shnum = ehdr->e_shnum;
> > +	shstrndx = ehdr->e_shstrndx;
> > +	if (shnum == SHN_UNDEF || shstrndx == SHN_XINDEX) {
> > +		memcpy(&shdr, output + ehdr->e_shoff, sizeof(shdr));
> > +		if (shnum == SHN_UNDEF)
> > +			shnum = shdr.sh_size;
> > +		if (shstrndx == SHN_XINDEX)
> > +			shstrndx = shdr.sh_link;
> > +	}
> > +
> > +	/* we are going to need to allocate space for the section
> > headers */
> > +	sechdrs = malloc(sizeof(*sechdrs) * shnum);
> > +	if (!sechdrs)
> > +		error("Failed to allocate space for shdrs");
> > +
> > +	sections = malloc(sizeof(*sections) * shnum);
> > +	if (!sections)
> > +		error("Failed to allocate space for section pointers");
> > +
> > +	memcpy(sechdrs, output + ehdr->e_shoff,
> > +	       sizeof(*sechdrs) * shnum);
> > +
> > +	/* we need to allocate space for the section string table */
> > +	s = &sechdrs[shstrndx];
> > +
> > +	secstrings = malloc(s->sh_size);
> > +	if (!secstrings)
> > +		error("Failed to allocate space for shstr");
> > +
> > +	memcpy(secstrings, output + s->sh_offset, s->sh_size);
> > +
> > +	/*
> > +	 * now we need to walk through the section headers and collect
> > the
> > +	 * sizes of the .text sections to be randomized.
> > +	 */
> > +	for (i = 0; i < shnum; i++) {
> > +		s = &sechdrs[i];
> > +		sname = secstrings + s->sh_name;
> > +
> > +		if (s->sh_type == SHT_SYMTAB) {
> > +			/* only one symtab per image */
> 
> I would assert this claim in the code as well: check symtab is NULL
> here?
> 
> > +			symtab = malloc(s->sh_size);
> > +			if (!symtab)
> > +				error("Failed to allocate space for
> > symtab");
> > +
> > +			memcpy(symtab, output + s->sh_offset, s-
> > >sh_size);
> > +			num_syms = s->sh_size / sizeof(*symtab);
> > +			continue;
> > +		}
> > +
> > +		if (s->sh_type == SHT_STRTAB && i != ehdr->e_shstrndx)
> > {
> > +			strtab = malloc(s->sh_size);
> 
> Similar robustness check?
> 
> > +			if (!strtab)
> > +				error("Failed to allocate space for
> > strtab");
> > +
> > +			memcpy(strtab, output + s->sh_offset, s-
> > >sh_size);
> > +		}
> > +
> > +		if (!strcmp(sname, ".text")) {
> > +			text = s;
> > +			continue;
> > +		}
> 
> Check text is still NULL here?
> 
> Also, why the continue? This means the section isn't included in the
> sections[] array? (Obviously things still work, but I don't
> understand
> why.)

I don't include .text in the sections[] array because sections[] is
only for sections to be randomized, and we don't randomize .text.

> 
> > +
> > +		if (!strcmp(sname, ".data..percpu")) {
> > +			/* get start addr for later */
> > +			percpu = s;
> 
> Similar, check percpu is still NULL here?
> 
> Also, is a "continue" intended here? (This is kind of the reverse of
> the "continue" question above.) I think you get the same result
> during
> the next "if", but I was expecting this block to look like the .text
> test above.

You are right, I could have put a continue here and saved the next
compare.

> <snip>

> > diff --git a/arch/x86/boot/compressed/kaslr.c
> > b/arch/x86/boot/compressed/kaslr.c
> > index d7408af55738..6f596bd5b6e5 100644
> > --- a/arch/x86/boot/compressed/kaslr.c
> > +++ b/arch/x86/boot/compressed/kaslr.c
> > @@ -39,10 +39,6 @@
> >  #include <generated/utsrelease.h>
> >  #include <asm/efi.h>
> >  
> > -/* Macros used by the included decompressor code below. */
> > -#define STATIC
> > -#include <linux/decompress/mm.h>
> > -
> >  #ifdef CONFIG_X86_5LEVEL
> >  unsigned int __pgtable_l5_enabled;
> >  unsigned int pgdir_shift __ro_after_init = 39;
> > diff --git a/arch/x86/boot/compressed/misc.c
> > b/arch/x86/boot/compressed/misc.c
> > index 9652d5c2afda..5f08922fd12a 100644
> > --- a/arch/x86/boot/compressed/misc.c
> > +++ b/arch/x86/boot/compressed/misc.c
> > @@ -26,9 +26,6 @@
> >   * it is not safe to place pointers in static structures.
> >   */
> >  
> > -/* Macros used by the included decompressor code below. */
> > -#define STATIC		static
> 
> Can you split the STATIC macro rearrangement out into a separate
> patch?
> I think it deserves a dedicated commit log to explain why it's
> changing
> the way it is (i.e. we end up with "STATIC" no longer meaning
> "static"
> in misc.c now

This change was made to fix the issue of having malloc_ptr be declared
locally rather than globally - (that weird problem I was having that
made it so I had to #include all the .c files until I figured out what
the issue was. If I separate out the change, then I feel like the
commit doesn't make sense out of this context. What if I put a big
comment in misc.h?

> > 

<snip>

> 
> > +	if (!IS_ENABLED(CONFIG_FG_KASLR) ||
> > +	    cmdline_find_option_bool("nokaslr")) {
> > +		if (!delta) {
> > +			debug_putstr("No relocation needed... ");
> > +			return;
> > +		}
> >  	}
> > +
> > +	pre_relocations_cleanup(map);
> > +
> >  	debug_putstr("Performing relocations... ");
> >  
> >  	/*
> > @@ -230,35 +242,106 @@ static void handle_relocations(void *output,
> > unsigned long output_len,
> >  	 */
> >  	for (reloc = output + output_len - sizeof(*reloc); *reloc;
> > reloc--) {
> >  		long extended = *reloc;
> > +		long value;
> > +
> > +		/*
> > +		 * if using fgkaslr, we might have moved the address
> > +		 * of the relocation. Check it to see if it needs
> > adjusting
> > +		 * from the original address.
> > +		 */
> > +		(void)adjust_address(&extended);
> 
> I don't think "(void)" needed here?

I can delete it - it's not "needed", but was done to show an
intentional discard of the return value from adjust_address.


The rest of your feedback incorporated into v3.

Thanks!
Kristen




