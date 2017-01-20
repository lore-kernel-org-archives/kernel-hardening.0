From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 20 Jan 2017 08:41:25 -0800
Message-Id: <20170120164126.27624-2-thgarnie@google.com>
In-Reply-To: <20170120164126.27624-1-thgarnie@google.com>
References: <20170120164126.27624-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 2/3] x86: Remap GDT tables in the Fixmap section
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Baoquan He <bhe@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Each processor holds a GDT in its per-cpu structure. The sgdt
instruction gives the base address of the current GDT. This address can
be used to bypass KASLR memory randomization. With another bug, an
attacker could target other per-cpu structures or deduce the base of
the main memory section (PAGE_OFFSET).

This patch relocates the GDT table for each processor inside the
Fixmap section. The space is reserved based on number of supported
cpus.

For consistency, the remapping is done by default on 32 and 64 bit.

Each processor switches to its remapped GDT at the end of
initialization. For hibernation, the main processor returns with the
original GDT and switches back to the remapping at completion.

On 32 bit, the maximum number of processors is now 256. The Fixmap
section cannot handle the original 512. Additional asserts ensure that
the Fixmap section cannot grow beyond the space available.

This patch was tested on both architectures. Hibernation and KVM were
both tested specially for their usage of the GDT.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170119
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/include/asm/fixmap.h    |  4 ++++
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 18 +++++++++++++++++-
 arch/x86/mm/init_32.c            |  2 ++
 arch/x86/power/cpu.c             |  3 +++
 6 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f1d4e8f2131f..b4ed35db10a8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -912,6 +912,7 @@ config MAXSMP
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
+	range 2 256 if SMP && X86_32 && X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
 	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index c46289799b02..8b913b5e9383 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -100,6 +100,10 @@ enum fixed_addresses {
 #ifdef	CONFIG_X86_INTEL_MID
 	FIX_LNW_VRTC,
 #endif
+	/* Fixmap entries to remap the GDTs, one per processor. */
+	FIX_GDT_REMAP_BEGIN,
+	FIX_GDT_REMAP_END = FIX_GDT_REMAP_BEGIN + NR_CPUS - 1,
+
 	__end_of_permanent_fixed_addresses,
 
 	/*
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 1be64da0384e..280211ad8be9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -705,6 +705,7 @@ extern struct desc_ptr		early_gdt_descr;
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(int);
+extern void load_remapped_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e97ffc8d29f4..7d940b0e805a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -443,6 +443,19 @@ void load_percpu_segment(int cpu)
 	load_stack_canary_segment();
 }
 
+/* Load a fixmap remapping of the per-cpu GDT */
+void load_remapped_gdt(int cpu)
+{
+	struct desc_ptr gdt_descr;
+	unsigned long idx = FIX_GDT_REMAP_BEGIN + cpu;
+
+	__set_fixmap(idx, __pa(get_cpu_gdt_table(cpu)), PAGE_KERNEL);
+
+	gdt_descr.address = (long)__fix_to_virt(idx);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
+
 /*
  * Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one.
@@ -455,7 +468,6 @@ void switch_to_new_gdt(int cpu)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 	/* Reload the per-cpu base */
-
 	load_percpu_segment(cpu);
 }
 
@@ -1508,6 +1520,8 @@ void cpu_init(void)
 
 	if (is_uv_system())
 		uv_cpu_init();
+
+	load_remapped_gdt(cpu);
 }
 
 #else
@@ -1563,6 +1577,8 @@ void cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu__init_cpu();
+
+	load_remapped_gdt(cpu);
 }
 #endif
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 928d657de829..cfbcf42099d0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -798,9 +798,11 @@ void __init mem_init(void)
 #ifdef CONFIG_HIGHMEM
 	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
 	BUILD_BUG_ON(VMALLOC_END			> PKMAP_BASE);
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= PKMAP_BASE + LAST_PKMAP*PAGE_SIZE);
 #endif
 #define high_memory (-128UL << 20)
 	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= VMALLOC_END);
 #undef high_memory
 #undef __FIXADDR_TOP
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 66ade16c7693..7578de6db833 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -183,6 +183,9 @@ static void fix_processor_context(void)
 	load_mm_ldt(current->active_mm);	/* This does lldt */
 
 	fpu__resume_cpu();
+
+	/* Load remapped GDT */
+	load_remapped_gdt(cpu);
 }
 
 /**
-- 
2.11.0.483.g087da7b7c-goog
