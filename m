From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 26 Jan 2017 08:59:40 -0800
Message-Id: <20170126165940.30799-3-thgarnie@google.com>
In-Reply-To: <20170126165940.30799-1-thgarnie@google.com>
References: <20170126165940.30799-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v2 3/3] x86: Make the GDT remapping read-only on 64 bit
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Adam Buchbinder <adam.buchbinder@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, David Vrabel <david.vrabel@citrix.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch makes the GDT remapped pages read-only to prevent corruption.
This change is done only on 64 bit.

The native_load_tr_desc function was adapted to correctly handle a
read-only GDT. The LTR instruction always writes to the GDT TSS entry.
This generates a page fault if the GDT is read-only. This change checks
if the current GDT is a remap and swap GDTs as needed. This function was
tested by booting multiple machines and checking hibernation works
properly.

KVM SVM and VMX were adapted to use the writeable GDT. On VMX, the
per-cpu variable was removed for functions to fetch the original GDT.
Instead of reloading the previous GDT, VMX will reload the fixmap GDT as
expected. For testing, VMs were started and restored on multiple
configurations.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170125
---
 arch/x86/include/asm/desc.h      | 46 +++++++++++++++++++++++++++++++++++-----
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 28 ++++++++++++++++++------
 arch/x86/kvm/svm.c               |  4 +---
 arch/x86/kvm/vmx.c               | 15 +++++--------
 5 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 4cc176f57b78..ca7b2224fcb4 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -52,6 +52,12 @@ static inline struct desc_struct *get_cpu_direct_gdt(unsigned int cpu)
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
+/* Provide the current original GDT */
+static inline struct desc_struct *get_current_direct_gdt(void)
+{
+	return this_cpu_ptr(&gdt_page)->gdt;
+}
+
 /* Get the fixmap index for a specific processor */
 static inline unsigned int get_cpu_fixmap_gdt_index(int cpu)
 {
@@ -223,11 +229,6 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 	}
 }
 
-static inline void native_load_tr_desc(void)
-{
-	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
-}
-
 static inline void native_load_gdt(const struct desc_ptr *dtr)
 {
 	asm volatile("lgdt %0"::"m" (*dtr));
@@ -248,6 +249,41 @@ static inline void native_store_idt(struct desc_ptr *dtr)
 	asm volatile("sidt %0":"=m" (*dtr));
 }
 
+/*
+ * The LTR instruction marks the TSS GDT entry as busy. In 64bit, the GDT is
+ * a read-only remapping. To prevent a page fault, the GDT is switched to the
+ * original writeable version when needed.
+ */
+#ifdef CONFIG_X86_64
+static inline void native_load_tr_desc(void)
+{
+	struct desc_ptr gdt;
+	int cpu = raw_smp_processor_id();
+	bool restore = false;
+	struct desc_struct *fixmap_gdt;
+
+	native_store_gdt(&gdt);
+	fixmap_gdt = get_cpu_fixmap_gdt(cpu);
+
+	/*
+	 * If the current GDT is the read-only fixmap, swap to the original
+	 * writeable version. Swap back at the end.
+	 */
+	if (gdt.address == (unsigned long)fixmap_gdt) {
+		load_direct_gdt(cpu);
+		restore = true;
+	}
+	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
+	if (restore)
+		load_fixmap_gdt(cpu);
+}
+#else
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
+}
+#endif
+
 static inline unsigned long native_store_tr(void)
 {
 	unsigned long tr;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22801fd345dc..e8e68b00a2ec 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -705,6 +705,7 @@ extern struct desc_ptr		early_gdt_descr;
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(int);
+extern void load_direct_gdt(int);
 extern void load_fixmap_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 15f06cf3e3d4..a7a54f57b68a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -444,13 +444,31 @@ void load_percpu_segment(int cpu)
 	load_stack_canary_segment();
 }
 
+/* On 64bit the GDT remapping is read-only */
+#ifdef CONFIG_X86_64
+#define PAGE_FIXMAP_GDT PAGE_KERNEL_RO
+#else
+#define PAGE_FIXMAP_GDT PAGE_KERNEL
+#endif
+
 /* Setup the fixmap mapping only once per-processor */
 static inline void setup_fixmap_gdt(int cpu)
 {
 	__set_fixmap(get_cpu_fixmap_gdt_index(cpu),
-		     __pa(get_cpu_direct_gdt(cpu)), PAGE_KERNEL);
+		     __pa(get_cpu_direct_gdt(cpu)), PAGE_FIXMAP_GDT);
 }
 
+/* Load the original GDT from the per-cpu structure */
+void load_direct_gdt(int cpu)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_direct_gdt(cpu);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
+EXPORT_SYMBOL(load_direct_gdt);
+
 /* Load a fixmap remapping of the per-cpu GDT */
 void load_fixmap_gdt(int cpu)
 {
@@ -460,6 +478,7 @@ void load_fixmap_gdt(int cpu)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 }
+EXPORT_SYMBOL(load_fixmap_gdt);
 
 /*
  * Current gdt points %fs at the "master" per-cpu area: after this,
@@ -467,11 +486,8 @@ void load_fixmap_gdt(int cpu)
  */
 void switch_to_new_gdt(int cpu)
 {
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_direct_gdt(cpu);
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
+	/* Load the original GDT */
+	load_direct_gdt(cpu);
 	/* Reload the per-cpu base */
 	load_percpu_segment(cpu);
 }
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d0414f054bdf..7864f4c813a1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -741,7 +741,6 @@ static int svm_hardware_enable(void)
 
 	struct svm_cpu_data *sd;
 	uint64_t efer;
-	struct desc_ptr gdt_descr;
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
@@ -763,8 +762,7 @@ static int svm_hardware_enable(void)
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
 
-	native_store_gdt(&gdt_descr);
-	gdt = (struct desc_struct *)gdt_descr.address;
+	gdt = get_current_direct_gdt();
 	sd->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4e691035a32d..c64fa6e0417c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -935,7 +935,6 @@ static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
  */
 static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
-static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
 
 /*
  * We maintian a per-CPU linked-list of vCPU, so in wakeup_handler() we
@@ -1997,10 +1996,9 @@ static void reload_tss(void)
 	/*
 	 * VT restores TR but not its size.  Useless.
 	 */
-	struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
 	struct desc_struct *descs;
 
-	descs = (void *)gdt->address;
+	descs = (void *)get_current_direct_gdt();
 	descs[GDT_ENTRY_TSS].type = 9; /* available TSS */
 	load_TR_desc();
 }
@@ -2061,7 +2059,6 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 
 static unsigned long segment_base(u16 selector)
 {
-	struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
 	struct desc_struct *d;
 	unsigned long table_base;
 	unsigned long v;
@@ -2069,7 +2066,7 @@ static unsigned long segment_base(u16 selector)
 	if (!(selector & ~3))
 		return 0;
 
-	table_base = gdt->address;
+	table_base = (unsigned long)get_current_direct_gdt();
 
 	if (selector & 4) {           /* from ldt */
 		u16 ldt_selector = kvm_read_ldt();
@@ -2185,7 +2182,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 #endif
 	if (vmx->host_state.msr_host_bndcfgs)
 		wrmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
-	load_gdt(this_cpu_ptr(&host_gdt));
+	load_fixmap_gdt(raw_smp_processor_id());
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -2287,7 +2284,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	if (!already_loaded) {
-		struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
+		unsigned long gdt = (unsigned long)get_current_direct_gdt();
 		unsigned long sysenter_esp;
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
@@ -2297,7 +2294,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * processors.
 		 */
 		vmcs_writel(HOST_TR_BASE, kvm_read_tr_base()); /* 22.2.4 */
-		vmcs_writel(HOST_GDTR_BASE, gdt->address);   /* 22.2.4 */
+		vmcs_writel(HOST_GDTR_BASE, gdt);   /* 22.2.4 */
 
 		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
@@ -3523,8 +3520,6 @@ static int hardware_enable(void)
 		ept_sync_global();
 	}
 
-	native_store_gdt(this_cpu_ptr(&host_gdt));
-
 	return 0;
 }
 
-- 
2.11.0.483.g087da7b7c-goog
