MIME-Version: 1.0
In-Reply-To: <CAJcbSZH7nyLuSmE2imEdk-VzwZcLw4P9T3jZEE2EiRUVPEbL1g@mail.gmail.com>
References: <20170216215438.126111-1-thgarnie@google.com> <201702170838.cW5onrBk%fengguang.wu@intel.com>
 <CAJcbSZH7nyLuSmE2imEdk-VzwZcLw4P9T3jZEE2EiRUVPEbL1g@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 17 Feb 2017 12:52:59 -0800
Message-ID: <CAJcbSZGjuHQOK2MG-qanm_zgB6zhi0-dtmq4nd8U5dZodOoEvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 1/4] x86/mm: Adapt MODULES_END based on Fixmap section size
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch aligns MODULES_END to the beginning of the Fixmap section.
It optimizes the space available for both sections. The address is
pre-computed based on the number of pages required by the Fixmap
section.

It will allow GDT remapping in the Fixmap section. The current
MODULES_END static address does not provide enough space for the kernel
to support a large number of processors.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170213
Fixed fixmap dependencies on random configurations.
---
 Documentation/x86/x86_64/mm.txt         | 5 ++++-
 arch/x86/include/asm/pgtable_64_types.h | 3 ++-
 arch/x86/kernel/module.c                | 1 +
 arch/x86/mm/dump_pagetables.c           | 1 +
 arch/x86/mm/kasan_init_64.c             | 1 +
 mm/vmalloc.c                            | 1 +
 6 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 5724092db811..ee3f9c30957c 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -19,7 +19,7 @@ ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp
fixup stacks
 ffffffef00000000 - fffffffeffffffff (=64 GB) EFI region mapping space
 ... unused hole ...
 ffffffff80000000 - ffffffff9fffffff (=512 MB)  kernel text mapping, from phys 0
-ffffffffa0000000 - ffffffffff5fffff (=1526 MB) module mapping space
+ffffffffa0000000 - ffffffffff5fffff (=1526 MB) module mapping space (variable)
 ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
 ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole

@@ -39,6 +39,9 @@ memory window (this size is arbitrary, it can be
raised later if needed).
 The mappings are not part of any other kernel PGD and are only available
 during EFI runtime calls.

+The module mapping space size changes based on the CONFIG requirements for the
+following fixmap section.
+
 Note that if CONFIG_RANDOMIZE_MEMORY is enabled, the direct mapping of all
 physical memory, vmalloc/ioremap space and virtual memory map are randomized.
 Their order is preserved but their base will be offset early at boot time.
diff --git a/arch/x86/include/asm/pgtable_64_types.h
b/arch/x86/include/asm/pgtable_64_types.h
index 3a264200c62f..bb05e21cf3c7 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -67,7 +67,8 @@ typedef struct { pteval_t pte; } pte_t;
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 #define VMALLOC_END (VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
-#define MODULES_END      _AC(0xffffffffff000000, UL)
+/* The module sections ends with the start of the fixmap */
+#define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 #define ESPFIX_PGD_ENTRY _AC(-2, UL)
 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 477ae806c2fa..fad61caac75e 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -35,6 +35,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
+#include <asm/fixmap.h>

 #if 0
 #define DEBUGP(fmt, ...) \
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 8aa6bea1cd6c..90170415f08a 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>

 #include <asm/pgtable.h>
+#include <asm/fixmap.h>

 /*
  * The dumper groups pagetable entries of the same type into one, and for
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0493c17b8a51..34f167cf3316 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -8,6 +8,7 @@

 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/fixmap.h>

 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern struct range pfn_mapped[E820_X_MAX];
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 011b446f8758..84e637f2fa49 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -35,6 +35,7 @@
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
+#include <asm/fixmap.h>

 #include "internal.h"

-- 
2.11.0.483.g087da7b7c-goog

On Fri, Feb 17, 2017 at 8:00 AM, Thomas Garnier <thgarnie@google.com> wrote:
> I will send an update patch on this thread to fix the fixmap dependencies.
>
> On Thu, Feb 16, 2017 at 4:45 PM, kbuild test robot <lkp@intel.com> wrote:
>>
>> Hi Thomas,
>>
>> [auto build test ERROR on next-20170216]
>> [also build test ERROR on v4.10-rc8]
>> [cannot apply to tip/x86/core kvm/linux-next tip/auto-latest v4.9-rc8
>> v4.9-rc7 v4.9-rc6]
>> [if your patch is applied to the wrong git tree, please drop us a note to
>> help improve the system]
>>
>> url:
>> https://github.com/0day-ci/linux/commits/Thomas-Garnier/x86-mm-Adapt-MODULES_END-based-on-Fixmap-section-size/20170217-072759
>> config: x86_64-randconfig-s4-02170325 (attached as .config)
>> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=x86_64
>>
>> All errors (new ones prefixed by >>):
>>
>>    In file included from arch/x86/include/asm/pgtable_types.h:240:0,
>>                     from arch/x86/include/asm/paravirt_types.h:44,
>>                     from arch/x86/include/asm/ptrace.h:71,
>>                     from arch/x86/include/asm/math_emu.h:4,
>>                     from arch/x86/include/asm/processor.h:11,
>>                     from arch/x86/include/asm/cpufeature.h:4,
>>                     from arch/x86/include/asm/thread_info.h:52,
>>                     from include/linux/thread_info.h:25,
>>                     from arch/x86/include/asm/preempt.h:6,
>>                     from include/linux/preempt.h:59,
>>                     from include/linux/spinlock.h:50,
>>                     from include/linux/wait.h:8,
>>                     from include/linux/fs.h:5,
>>                     from include/linux/debugfs.h:18,
>>                     from arch/x86/mm/dump_pagetables.c:15:
>> >> arch/x86/include/asm/pgtable_64_types.h:71:23: error: implicit
>> >> declaration of function '__fix_to_virt'
>> >> [-Werror=implicit-function-declaration]
>>     #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>>                           ^
>>    arch/x86/mm/dump_pagetables.c:87:4: note: in expansion of macro
>> 'MODULES_END'
>>      { MODULES_END,          "End Modules" },
>>        ^~~~~~~~~~~
>>    arch/x86/include/asm/pgtable_64_types.h:71:37: error:
>> '__end_of_fixed_addresses' undeclared here (not in a function)
>>     #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>>                                         ^
>>    arch/x86/mm/dump_pagetables.c:87:4: note: in expansion of macro
>> 'MODULES_END'
>>      { MODULES_END,          "End Modules" },
>>        ^~~~~~~~~~~
>>    cc1: some warnings being treated as errors
>>
>> vim +/__fix_to_virt +71 arch/x86/include/asm/pgtable_64_types.h
>>
>>     65  #define VMALLOC_START   __VMALLOC_BASE
>>     66  #define VMEMMAP_START   __VMEMMAP_BASE
>>     67  #endif /* CONFIG_RANDOMIZE_MEMORY */
>>     68  #define VMALLOC_END     (VMALLOC_START + _AC((VMALLOC_SIZE_TB <<
>> 40) - 1, UL))
>>     69  #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
>>     70  /* The module sections ends with the start of the fixmap */
>>   > 71  #define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
>>     72  #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
>>     73  #define ESPFIX_PGD_ENTRY _AC(-2, UL)
>>     74  #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology
>> Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel
>> Corporation
>
>
>
>
> --
> Thomas



-- 
Thomas
