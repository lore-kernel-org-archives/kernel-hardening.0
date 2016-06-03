Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Jun 2016 11:40:23 -0700
Message-Id: <1464979224-2085-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1464979224-2085-1-git-send-email-keescook@chromium.org>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/2] x86: apply more __ro_after_init and const
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mathias Krause <minipli@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Guided by grsecurity's analogous __read_only markings in arch/x86,
this applies several uses of __ro_after_init to structures that are
only updated during __init, and const for some structures that are
never updated.  Additionally extends __init markings to some functions
that are only used during __init, and cleans up some missing C99 style
static initializers.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/desc.h           |  2 +-
 arch/x86/include/asm/fpu/xstate.h     |  3 ++-
 arch/x86/kernel/apic/apic_flat_64.c   |  6 +++---
 arch/x86/kernel/apic/apic_noop.c      |  2 +-
 arch/x86/kernel/apic/bigsmp_32.c      |  2 +-
 arch/x86/kernel/apic/msi.c            |  2 +-
 arch/x86/kernel/apic/probe_32.c       |  4 ++--
 arch/x86/kernel/apic/x2apic_cluster.c |  2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |  2 +-
 arch/x86/kernel/cpu/common.c          | 11 ++++++++---
 arch/x86/kernel/cpu/mtrr/main.c       |  4 ++--
 arch/x86/kernel/cpu/mtrr/mtrr.h       |  2 +-
 arch/x86/kernel/ksysfs.c              |  2 +-
 arch/x86/kernel/kvmclock.c            |  2 +-
 arch/x86/kernel/paravirt.c            |  2 +-
 arch/x86/kernel/ptrace.c              |  6 +++---
 arch/x86/kernel/reboot.c              |  2 +-
 arch/x86/kernel/setup.c               |  4 ++--
 arch/x86/kernel/setup_percpu.c        |  2 +-
 arch/x86/kernel/smp.c                 |  2 +-
 arch/x86/kernel/x86_init.c            |  6 +++---
 arch/x86/kvm/svm.c                    |  2 +-
 arch/x86/kvm/vmx.c                    |  2 +-
 arch/x86/mm/init_32.c                 |  2 +-
 arch/x86/mm/init_64.c                 |  2 +-
 arch/x86/mm/ioremap.c                 |  3 ++-
 arch/x86/pci/pcbios.c                 |  7 +++++--
 28 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 4e10d73cf018..12080d87da3b 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -36,7 +36,7 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
-extern struct desc_ptr debug_idt_descr;
+extern const struct desc_ptr debug_idt_descr;
 extern gate_desc debug_idt_table[];
 
 struct gdt_page {
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 38951b0fcc5a..9c1a4ceddacb 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -43,7 +43,8 @@ extern unsigned int xstate_size;
 extern u64 xfeatures_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
-extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
+extern void __init update_regset_xstate_info(unsigned int size,
+					     u64 xstate_mask);
 
 void fpu__xstate_clear_all_cpu_caps(void);
 void *get_xsave_addr(struct xregs_state *xsave, int xstate);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 76f89e2b245a..1d0a8bac17be 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -25,7 +25,7 @@
 static struct apic apic_physflat;
 static struct apic apic_flat;
 
-struct apic __read_mostly *apic = &apic_flat;
+struct apic *apic __ro_after_init = &apic_flat;
 EXPORT_SYMBOL_GPL(apic);
 
 static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
@@ -154,7 +154,7 @@ static int flat_probe(void)
 	return 1;
 }
 
-static struct apic apic_flat =  {
+static struct apic apic_flat __ro_after_init = {
 	.name				= "flat",
 	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
@@ -249,7 +249,7 @@ static int physflat_probe(void)
 	return 0;
 }
 
-static struct apic apic_physflat =  {
+static struct apic apic_physflat __ro_after_init = {
 
 	.name				= "physical flat",
 	.probe				= physflat_probe,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 13d19ed58514..8a6ce344fe9c 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -109,7 +109,7 @@ static void noop_apic_write(u32 reg, u32 v)
 	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_APIC) && !disable_apic);
 }
 
-struct apic apic_noop = {
+struct apic apic_noop __ro_after_init = {
 	.name				= "noop",
 	.probe				= noop_probe,
 	.acpi_madt_oem_check		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index cf9bd896c12d..9618dbd63361 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -142,7 +142,7 @@ static int probe_bigsmp(void)
 	return dmi_bigsmp;
 }
 
-static struct apic apic_bigsmp = {
+static struct apic apic_bigsmp __ro_after_init = {
 
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index ade25320df96..015bbf30e3e3 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -269,7 +269,7 @@ static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 	hpet_msi_write(irq_data_get_irq_handler_data(data), msg);
 }
 
-static struct irq_chip hpet_msi_controller = {
+static struct irq_chip hpet_msi_controller __ro_after_init = {
 	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index f316e34abb42..b04eeec2950c 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -72,7 +72,7 @@ static int probe_default(void)
 	return 1;
 }
 
-static struct apic apic_default = {
+static struct apic apic_default __ro_after_init = {
 
 	.name				= "default",
 	.probe				= probe_default,
@@ -127,7 +127,7 @@ static struct apic apic_default = {
 
 apic_driver(apic_default);
 
-struct apic *apic = &apic_default;
+struct apic *apic __ro_after_init = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
 
 static int cmdline_apic __initdata;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index aca8b75c1552..fcaa27ee7b52 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -242,7 +242,7 @@ static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
 		cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 }
 
-static struct apic apic_x2apic_cluster = {
+static struct apic apic_x2apic_cluster __ro_after_init = {
 
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a1242e2c12e6..108e6307a076 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -98,7 +98,7 @@ static int x2apic_phys_probe(void)
 	return apic == &apic_x2apic_phys;
 }
 
-static struct apic apic_x2apic_phys = {
+static struct apic apic_x2apic_phys __ro_after_init = {
 
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 29003154fafd..831e1cea3917 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -554,7 +554,7 @@ static int uv_probe(void)
 	return apic == &apic_x2apic_uv_x;
 }
 
-static struct apic __refdata apic_x2apic_uv_x = {
+static struct apic apic_x2apic_uv_x __ro_after_init = {
 
 	.name				= "UV large system",
 	.probe				= uv_probe,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0fe6953f421c..d8f84250f139 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1265,9 +1265,14 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
-struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
-struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
-				    (unsigned long) debug_idt_table };
+struct desc_ptr idt_descr __ro_after_init = {
+	.size = NR_VECTORS * 16 - 1,
+	.address = (unsigned long) idt_table,
+};
+const struct desc_ptr debug_idt_descr = {
+	.size = NR_VECTORS * 16 - 1,
+	.address = (unsigned long) debug_idt_table,
+};
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE) __visible;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 7d393ecdeee6..5c367d9cde87 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -72,14 +72,14 @@ static DEFINE_MUTEX(mtrr_mutex);
 u64 size_or_mask, size_and_mask;
 static bool mtrr_aps_delayed_init;
 
-static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
+static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM] __ro_after_init;
 
 const struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(const struct mtrr_ops *ops)
+void __init set_mtrr_ops(const struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 6c7ced07d16d..ad8bd763efa5 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -54,7 +54,7 @@ void fill_mtrr_var_range(unsigned int index,
 bool get_mtrr_state(void);
 void mtrr_bp_pat_init(void);
 
-extern void set_mtrr_ops(const struct mtrr_ops *ops);
+extern void __init set_mtrr_ops(const struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
 extern const struct mtrr_ops *mtrr_if;
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
index c2bedaea11f7..4afc67f5facc 100644
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -184,7 +184,7 @@ out:
 
 static struct kobj_attribute type_attr = __ATTR_RO(type);
 
-static struct bin_attribute data_attr = {
+static struct bin_attribute data_attr __ro_after_init = {
 	.attr = {
 		.name = "data",
 		.mode = S_IRUGO,
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1d39bfbd26bb..0964399ef942 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -29,7 +29,7 @@
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
 
-static int kvmclock = 1;
+static int kvmclock __ro_after_init = 1;
 static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
 static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
 static cycle_t kvm_sched_clock_offset;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 7b3b3f24c3ea..59222a21ef0e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -388,7 +388,7 @@ NOKPROBE_SYMBOL(native_load_idt);
 #define PTE_IDENT	__PV_IS_CALLEE_SAVE(_paravirt_ident_64)
 #endif
 
-struct pv_mmu_ops pv_mmu_ops = {
+struct pv_mmu_ops pv_mmu_ops __ro_after_init = {
 
 	.read_cr2 = native_read_cr2,
 	.write_cr2 = native_write_cr2,
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 600edd225e81..acaf2fc7a2ae 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1247,7 +1247,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 #ifdef CONFIG_X86_64
 
-static struct user_regset x86_64_regsets[] __read_mostly = {
+static struct user_regset x86_64_regsets[] __ro_after_init = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1288,7 +1288,7 @@ static const struct user_regset_view user_x86_64_view = {
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static struct user_regset x86_32_regsets[] __read_mostly = {
+static struct user_regset x86_32_regsets[] __ro_after_init = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1341,7 +1341,7 @@ static const struct user_regset_view user_x86_32_view = {
  */
 u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
-void update_regset_xstate_info(unsigned int size, u64 xstate_mask)
+void __init update_regset_xstate_info(unsigned int size, u64 xstate_mask)
 {
 #ifdef CONFIG_X86_64
 	x86_64_regsets[REGSET_XSTATE].n = size / sizeof(u64);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index a9b31eb815f2..fe98493932ad 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -684,7 +684,7 @@ static void native_machine_power_off(void)
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
-struct machine_ops machine_ops = {
+struct machine_ops machine_ops __ro_after_init = {
 	.power_off = native_machine_power_off,
 	.shutdown = native_machine_shutdown,
 	.emergency_restart = native_machine_emergency_restart,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4e7b3991b60..eb2f3b5d9192 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -209,9 +209,9 @@ EXPORT_SYMBOL(boot_cpu_data);
 
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-__visible unsigned long mmu_cr4_features;
+__visible unsigned long mmu_cr4_features __ro_after_init;
 #else
-__visible unsigned long mmu_cr4_features = X86_CR4_PAE;
+__visible unsigned long mmu_cr4_features __ro_after_init = X86_CR4_PAE;
 #endif
 
 /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index e4fcb87ba7a6..8ce03678166e 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -33,7 +33,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+unsigned long __per_cpu_offset[NR_CPUS] __ro_after_init = {
 	[0 ... NR_CPUS-1] = BOOT_PERCPU_OFFSET,
 };
 EXPORT_SYMBOL(__per_cpu_offset);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 658777cf3851..75c0ab74fc7b 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -336,7 +336,7 @@ static int __init nonmi_ipi_setup(char *str)
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
 
-struct smp_ops smp_ops = {
+struct smp_ops smp_ops __ro_after_init = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index dad5fe9633a3..111b838db7fe 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -91,7 +91,7 @@ struct x86_cpuinit_ops x86_cpuinit = {
 static void default_nmi_init(void) { };
 static int default_i8042_detect(void) { return 1; };
 
-struct x86_platform_ops x86_platform = {
+struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
@@ -107,7 +107,7 @@ struct x86_platform_ops x86_platform = {
 EXPORT_SYMBOL_GPL(x86_platform);
 
 #if defined(CONFIG_PCI_MSI)
-struct x86_msi_ops x86_msi = {
+struct x86_msi_ops x86_msi __ro_after_init = {
 	.setup_msi_irqs		= native_setup_msi_irqs,
 	.teardown_msi_irq	= native_teardown_msi_irq,
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
@@ -136,7 +136,7 @@ void arch_restore_msi_irqs(struct pci_dev *dev)
 }
 #endif
 
-struct x86_io_apic_ops x86_io_apic_ops = {
+struct x86_io_apic_ops x86_io_apic_ops __ro_after_init = {
 	.read			= native_io_apic_read,
 	.disable		= native_disable_io_apic,
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1163e8173e5a..28f3c76b2f13 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4950,7 +4950,7 @@ static inline void avic_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static struct kvm_x86_ops svm_x86_ops = {
+static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fb93010beaa4..180b0ae661fe 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10901,7 +10901,7 @@ out:
 	return ret;
 }
 
-static struct kvm_x86_ops vmx_x86_ops = {
+static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.hardware_setup = hardware_setup,
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 84df150ee77e..54cbd100ee60 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -535,7 +535,7 @@ static void __init pagetable_init(void)
 	permanent_kmaps_init(pgd_base);
 }
 
-pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
+pteval_t __supported_pte_mask __ro_after_init = ~(_PAGE_NX | _PAGE_GLOBAL);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 /* user-defined highmem size */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bce2e5d9edd4..2837695ed7e0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -66,7 +66,7 @@
  * around without checking the pgd every time.
  */
 
-pteval_t __supported_pte_mask __read_mostly = ~0;
+pteval_t __supported_pte_mask __ro_after_init = ~0;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 int force_personality32;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index f0894910bdd7..4e5821896eec 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -419,7 +419,8 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
 }
 
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __ro_after_init
+					     __aligned(PAGE_SIZE);
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 9770e55e768f..1d97cea3b3a4 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -120,9 +120,12 @@ static unsigned long __init bios32_service(unsigned long service)
 static struct {
 	unsigned long address;
 	unsigned short segment;
-} pci_indirect = { 0, __KERNEL_CS };
+} pci_indirect __ro_after_init = {
+	.address = 0,
+	.segment = __KERNEL_CS,
+};
 
-static int pci_bios_present;
+static int pci_bios_present __ro_after_init;
 
 static int __init check_pcibios(void)
 {
-- 
2.7.4
