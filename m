From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 16 Feb 2017 13:54:36 -0800
Message-Id: <20170216215438.126111-2-thgarnie@google.com>
In-Reply-To: <20170216215438.126111-1-thgarnie@google.com>
References: <20170216215438.126111-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 2/4] x86: Remap GDT tables in the Fixmap section
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Each processor holds a GDT in its per-cpu structure. The sgdt
instruction gives the base address of the current GDT. This address can
be used to bypass KASLR memory randomization. With another bug, an
attacker could target other per-cpu structures or deduce the base of
the main memory section (PAGE_OFFSET).

This patch relocates the GDT table for each processor inside the
Fixmap section. The space is reserved based on number of supported
processors.

For consistency, the remapping is done by default on 32 and 64-bit.

Each processor switches to its remapped GDT at the end of
initialization. For hibernation, the main processor returns with the
original GDT and switches back to the remapping at completion.

This patch was tested on both architectures. Hibernation and KVM were
both tested specially for their usage of the GDT.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170213
---
 arch/x86/entry/vdso/vma.c             |  2 +-
 arch/x86/include/asm/desc.h           | 33 +++++++++++++++++++++++++++++----
 arch/x86/include/asm/fixmap.h         |  4 ++++
 arch/x86/include/asm/processor.h      |  1 +
 arch/x86/include/asm/stackprotector.h |  2 +-
 arch/x86/kernel/acpi/sleep.c          |  2 +-
 arch/x86/kernel/apm_32.c              |  6 +++---
 arch/x86/kernel/cpu/common.c          | 26 ++++++++++++++++++++++++--
 arch/x86/kernel/setup_percpu.c        |  2 +-
 arch/x86/kernel/smpboot.c             |  2 +-
 arch/x86/platform/efi/efi_32.c        |  4 ++--
 arch/x86/power/cpu.c                  |  7 +++++--
 arch/x86/xen/enlighten.c              |  2 +-
 arch/x86/xen/smp.c                    |  2 +-
 drivers/lguest/x86/core.c             |  6 +++---
 drivers/pnp/pnpbios/bioscalls.c       | 10 +++++-----
 16 files changed, 83 insertions(+), 28 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 572cee3fccff..9c8bd4cfcc6e 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -353,7 +353,7 @@ static void vgetcpu_cpu_init(void *arg)
 	d.p = 1;		/* Present */
 	d.d = 1;		/* 32-bit */
 
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
+	write_gdt_entry(get_cpu_gdt_rw(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
 static int vgetcpu_online(unsigned int cpu)
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 12080d87da3b..5d4ba1311737 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -4,6 +4,7 @@
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
+#include <asm/fixmap.h>
 
 #include <linux/smp.h>
 #include <linux/percpu.h>
@@ -45,11 +46,35 @@ struct gdt_page {
 
 DECLARE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page);
 
-static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
+/* Provide the original GDT */
+static inline struct desc_struct *get_cpu_gdt_rw(unsigned int cpu)
 {
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
+static inline unsigned long get_cpu_gdt_rw_vaddr(unsigned int cpu)
+{
+	return (unsigned long)get_cpu_gdt_rw(cpu);
+}
+
+/* Get the fixmap index for a specific processor */
+static inline unsigned int get_cpu_gdt_ro_index(int cpu)
+{
+	return FIX_GDT_REMAP_BEGIN + cpu;
+}
+
+/* Provide the fixmap address of the remapped GDT */
+static inline struct desc_struct *get_cpu_gdt_ro(int cpu)
+{
+	unsigned int idx = get_cpu_gdt_ro_index(cpu);
+	return (struct desc_struct *)__fix_to_virt(idx);
+}
+
+static inline unsigned long get_cpu_gdt_ro_vaddr(int cpu)
+{
+	return (unsigned long)get_cpu_gdt_ro(cpu);
+}
+
 #ifdef CONFIG_X86_64
 
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
@@ -174,7 +199,7 @@ static inline void set_tssldt_descriptor(void *d, unsigned long addr, unsigned t
 
 static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
 {
-	struct desc_struct *d = get_cpu_gdt_table(cpu);
+	struct desc_struct *d = get_cpu_gdt_rw(cpu);
 	tss_desc tss;
 
 	/*
@@ -202,7 +227,7 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 
 		set_tssldt_descriptor(&ldt, (unsigned long)addr, DESC_LDT,
 				      entries * LDT_ENTRY_SIZE - 1);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
+		write_gdt_entry(get_cpu_gdt_rw(cpu), GDT_ENTRY_LDT,
 				&ldt, DESC_LDT);
 		asm volatile("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
@@ -244,7 +269,7 @@ static inline unsigned long native_store_tr(void)
 
 static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	struct desc_struct *gdt = get_cpu_gdt_rw(cpu);
 	unsigned int i;
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 8554f960e21b..b65155cc3760 100644
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
index e6cfe7ba2d65..c441d1f7e275 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -706,6 +706,7 @@ extern struct desc_ptr		early_gdt_descr;
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(int);
+extern void load_fixmap_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
 
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 58505f01962f..dcbd9bcce714 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -87,7 +87,7 @@ static inline void setup_stack_canary_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
 	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
-	struct desc_struct *gdt_table = get_cpu_gdt_table(cpu);
+	struct desc_struct *gdt_table = get_cpu_gdt_rw(cpu);
 	struct desc_struct desc;
 
 	desc = gdt_table[GDT_ENTRY_STACK_CANARY];
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 48587335ede8..ed014814ea35 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -101,7 +101,7 @@ int x86_acpi_suspend_lowlevel(void)
 #ifdef CONFIG_SMP
 	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
-			(unsigned long)get_cpu_gdt_table(smp_processor_id());
+			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 45d44c173cf9..dc4e89d93a10 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -608,7 +608,7 @@ static long __apm_bios_call(void *_call)
 
 	cpu = get_cpu();
 	BUG_ON(cpu != 0);
-	gdt = get_cpu_gdt_table(cpu);
+	gdt = get_cpu_gdt_rw(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
@@ -684,7 +684,7 @@ static long __apm_bios_call_simple(void *_call)
 
 	cpu = get_cpu();
 	BUG_ON(cpu != 0);
-	gdt = get_cpu_gdt_table(cpu);
+	gdt = get_cpu_gdt_rw(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
@@ -2351,7 +2351,7 @@ static int __init apm_init(void)
 	 * Note we only set APM segments on CPU zero, since we pin the APM
 	 * code to that CPU.
 	 */
-	gdt = get_cpu_gdt_table(0);
+	gdt = get_cpu_gdt_rw(0);
 	set_desc_base(&gdt[APM_CS >> 3],
 		 (unsigned long)__va((unsigned long)apm_info.bios.cseg << 4));
 	set_desc_base(&gdt[APM_CS_16 >> 3],
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1a4ee7082ad7..2853a42ded2d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -444,6 +444,23 @@ void load_percpu_segment(int cpu)
 	load_stack_canary_segment();
 }
 
+/* Setup the fixmap mapping only once per-processor */
+static inline void setup_fixmap_gdt(int cpu)
+{
+	__set_fixmap(get_cpu_gdt_ro_index(cpu),
+		     __pa(get_cpu_gdt_rw(cpu)), PAGE_KERNEL);
+}
+
+/* Load a fixmap remapping of the per-cpu GDT */
+void load_fixmap_gdt(int cpu)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_ro(cpu);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
+
 /*
  * Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one.
@@ -452,11 +469,10 @@ void switch_to_new_gdt(int cpu)
 {
 	struct desc_ptr gdt_descr;
 
-	gdt_descr.address = (long)get_cpu_gdt_table(cpu);
+	gdt_descr.address = (long)get_cpu_gdt_rw(cpu);
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 	/* Reload the per-cpu base */
-
 	load_percpu_segment(cpu);
 }
 
@@ -1524,6 +1540,9 @@ void cpu_init(void)
 
 	if (is_uv_system())
 		uv_cpu_init();
+
+	setup_fixmap_gdt(cpu);
+	load_fixmap_gdt(cpu);
 }
 
 #else
@@ -1579,6 +1598,9 @@ void cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu__init_cpu();
+
+	setup_fixmap_gdt(cpu);
+	load_fixmap_gdt(cpu);
 }
 #endif
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 9820d6d977c6..11338b0b3ad2 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -160,7 +160,7 @@ static inline void setup_percpu_segment(int cpu)
 	pack_descriptor(&gdt, per_cpu_offset(cpu), 0xFFFFF,
 			0x2 | DESCTYPE_S, 0x8);
 	gdt.s = 1;
-	write_gdt_entry(get_cpu_gdt_table(cpu),
+	write_gdt_entry(get_cpu_gdt_rw(cpu),
 			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
 #endif
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 99b920d0e516..2e61b4b6957b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -980,7 +980,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	unsigned long timeout;
 
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code = (unsigned long)start_secondary;
 	initial_stack  = idle->thread.sp;
 
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index cef39b097649..950071171436 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -68,7 +68,7 @@ pgd_t * __init efi_call_phys_prolog(void)
 	load_cr3(initial_page_table);
 	__flush_tlb_all();
 
-	gdt_descr.address = __pa(get_cpu_gdt_table(0));
+	gdt_descr.address = __pa(get_cpu_gdt_rw(0));
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
@@ -79,7 +79,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
 	struct desc_ptr gdt_descr;
 
-	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
+	gdt_descr.address = (unsigned long)get_cpu_gdt_rw(0);
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 66ade16c7693..6b05a9219ea2 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -95,7 +95,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 	 * 'pmode_gdt' in wakeup_start.
 	 */
 	ctxt->gdt_desc.size = GDT_SIZE - 1;
-	ctxt->gdt_desc.address = (unsigned long)get_cpu_gdt_table(smp_processor_id());
+	ctxt->gdt_desc.address = (unsigned long)get_cpu_gdt_rw(smp_processor_id());
 
 	store_tr(ctxt->tr);
 
@@ -162,7 +162,7 @@ static void fix_processor_context(void)
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(cpu_tss, cpu);
 #ifdef CONFIG_X86_64
-	struct desc_struct *desc = get_cpu_gdt_table(cpu);
+	struct desc_struct *desc = get_cpu_gdt_rw(cpu);
 	tss_desc tss;
 #endif
 	set_tss_desc(cpu, t);	/*
@@ -183,6 +183,9 @@ static void fix_processor_context(void)
 	load_mm_ldt(current->active_mm);	/* This does lldt */
 
 	fpu__resume_cpu();
+
+	/* The processor is back on the direct GDT, load back the fixmap */
+	load_fixmap_gdt(cpu);
 }
 
 /**
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ec1d5c46e58f..4951fcf95143 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -710,7 +710,7 @@ static void load_TLS_descriptor(struct thread_struct *t,
 
 	*shadow = t->tls_array[i];
 
-	gdt = get_cpu_gdt_table(cpu);
+	gdt = get_cpu_gdt_rw(cpu);
 	maddr = arbitrary_virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
 	mc = __xen_mc_entry(0);
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 0dee6f59ea82..6399bab936cd 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -391,7 +391,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	if (ctxt == NULL)
 		return -ENOMEM;
 
-	gdt = get_cpu_gdt_table(cpu);
+	gdt = get_cpu_gdt_rw(cpu);
 
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index d71f6323ac00..b4f79b923aea 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -504,7 +504,7 @@ void __init lguest_arch_host_init(void)
 		 * byte, not the size, hence the "-1").
 		 */
 		state->host_gdt_desc.size = GDT_SIZE-1;
-		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
+		state->host_gdt_desc.address = (long)get_cpu_gdt_rw(i);
 
 		/*
 		 * All CPUs on the Host use the same Interrupt Descriptor
@@ -554,8 +554,8 @@ void __init lguest_arch_host_init(void)
 		 * The Host needs to be able to use the LGUEST segments on this
 		 * CPU, too, so put them in the Host GDT.
 		 */
-		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
-		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+		get_cpu_gdt_rw(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+		get_cpu_gdt_rw(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
 	}
 
 	/*
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 438d4c72c7b3..ff563db025b3 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -54,7 +54,7 @@ __asm__(".text			\n"
 
 #define Q2_SET_SEL(cpu, selname, address, size) \
 do { \
-	struct desc_struct *gdt = get_cpu_gdt_table((cpu)); \
+	struct desc_struct *gdt = get_cpu_gdt_rw((cpu)); \
 	set_desc_base(&gdt[(selname) >> 3], (u32)(address)); \
 	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
@@ -95,8 +95,8 @@ static inline u16 call_pnp_bios(u16 func, u16 arg1, u16 arg2, u16 arg3,
 		return PNP_FUNCTION_NOT_SUPPORTED;
 
 	cpu = get_cpu();
-	save_desc_40 = get_cpu_gdt_table(cpu)[0x40 / 8];
-	get_cpu_gdt_table(cpu)[0x40 / 8] = bad_bios_desc;
+	save_desc_40 = get_cpu_gdt_rw(cpu)[0x40 / 8];
+	get_cpu_gdt_rw(cpu)[0x40 / 8] = bad_bios_desc;
 
 	/* On some boxes IRQ's during PnP BIOS calls are deadly.  */
 	spin_lock_irqsave(&pnp_bios_lock, flags);
@@ -134,7 +134,7 @@ static inline u16 call_pnp_bios(u16 func, u16 arg1, u16 arg2, u16 arg3,
 			     :"memory");
 	spin_unlock_irqrestore(&pnp_bios_lock, flags);
 
-	get_cpu_gdt_table(cpu)[0x40 / 8] = save_desc_40;
+	get_cpu_gdt_rw(cpu)[0x40 / 8] = save_desc_40;
 	put_cpu();
 
 	/* If we get here and this is set then the PnP BIOS faulted on us. */
@@ -477,7 +477,7 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.segment = PNP_CS16;
 
 	for_each_possible_cpu(i) {
-		struct desc_struct *gdt = get_cpu_gdt_table(i);
+		struct desc_struct *gdt = get_cpu_gdt_rw(i);
 		if (!gdt)
 			continue;
 		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_CS32],
-- 
2.11.0.483.g087da7b7c-goog
