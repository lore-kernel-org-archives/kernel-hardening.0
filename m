Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon, 31 Oct 2016 13:43:43 +0200
Message-Id: <1477914225-11298-12-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v3 PATCH 11/13] x86: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Hans Liljestrand <ishkamiel@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 arch/x86/include/asm/hw_irq.h    |  4 ++--
 arch/x86/kernel/apic/apic.c      |  2 +-
 arch/x86/kernel/apic/io_apic.c   |  4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++------
 arch/x86/kernel/i8259.c          |  2 +-
 arch/x86/kernel/irq.c            |  8 ++++----
 arch/x86/kernel/kgdb.c           |  6 +++---
 arch/x86/kernel/pvclock.c        |  8 ++++----
 arch/x86/kernel/tboot.c          |  8 ++++----
 arch/x86/mm/mmio-mod.c           |  4 ++--
 10 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b90e105..e1dd406 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -164,8 +164,8 @@ static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
 /* Statistics */
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+extern atomic_wrap_t irq_err_count;
+extern atomic_wrap_t irq_mis_count;
 
 extern void elcr_set_level_irq(unsigned int irq);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 88c657b..06dc09b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1904,7 +1904,7 @@ static void __smp_error_interrupt(struct pt_regs *regs)
 		apic_write(APIC_ESR, 0);
 	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc_wrap(&irq_err_count);
 
 	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
 		    smp_processor_id(), v);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 48e6d84..3369eb9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1683,7 +1683,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-atomic_t irq_mis_count;
+atomic_wrap_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 static bool io_apic_level_ack_pending(struct mp_chip_data *data)
@@ -1822,7 +1822,7 @@ static void ioapic_ack_level(struct irq_data *irq_data)
 	 * at the cpu.
 	 */
 	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
+		atomic_inc_wrap(&irq_mis_count);
 		eoi_ioapic_pin(cfg->vector, irq_data->chip_data);
 	}
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a7fdf45..ca3503c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -322,10 +322,10 @@ static void print_mce(struct mce *m)
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
-static atomic_t mce_panicked;
+static atomic_wrap_t mce_panicked;
 
 static int fake_panic;
-static atomic_t mce_fake_panicked;
+static atomic_wrap_t mce_fake_panicked;
 
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
@@ -351,7 +351,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 		/*
 		 * Make sure only one CPU runs in machine check panic
 		 */
-		if (atomic_inc_return(&mce_panicked) > 1)
+		if (atomic_inc_return_wrap(&mce_panicked) > 1)
 			wait_for_panic();
 		barrier();
 
@@ -359,7 +359,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 		console_verbose();
 	} else {
 		/* Don't log too much for fake panic */
-		if (atomic_inc_return(&mce_fake_panicked) > 1)
+		if (atomic_inc_return_wrap(&mce_fake_panicked) > 1)
 			return;
 	}
 	pending = mce_gen_pool_prepare_records();
@@ -787,7 +787,7 @@ static int mce_timed_out(u64 *t, const char *msg)
 	 * might have been modified by someone else.
 	 */
 	rmb();
-	if (atomic_read(&mce_panicked))
+	if (atomic_read_wrap(&mce_panicked))
 		wait_for_panic();
 	if (!mca_cfg.monarch_timeout)
 		goto out;
@@ -2652,7 +2652,7 @@ struct dentry *mce_get_debugfs_dir(void)
 static void mce_reset(void)
 {
 	cpu_missing = 0;
-	atomic_set(&mce_fake_panicked, 0);
+	atomic_set_wrap(&mce_fake_panicked, 0);
 	atomic_set(&mce_executing, 0);
 	atomic_set(&mce_callin, 0);
 	atomic_set(&global_nwo, 0);
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index be22f5a..de1b332 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -208,7 +208,7 @@ static void mask_and_ack_8259A(struct irq_data *data)
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc_wrap(&irq_err_count);
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9f669fd..85fcbb8 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -28,7 +28,7 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
-atomic_t irq_err_count;
+atomic_wrap_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
 void (*x86_platform_ipi_callback)(void) = NULL;
@@ -146,9 +146,9 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_puts(p, "  Hypervisor callback interrupts\n");
 	}
 #endif
-	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
+	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read_wrap(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
-	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
+	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read_wrap(&irq_mis_count));
 #endif
 #ifdef CONFIG_HAVE_KVM
 	seq_printf(p, "%*s: ", prec, "PIN");
@@ -200,7 +200,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 u64 arch_irq_stat(void)
 {
-	u64 sum = atomic_read(&irq_err_count);
+	u64 sum = atomic_read_wrap(&irq_err_count);
 	return sum;
 }
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8e36f24..dd4fe27 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -476,12 +476,12 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 	case 'k':
 		/* clear the trace bit */
 		linux_regs->flags &= ~X86_EFLAGS_TF;
-		atomic_set(&kgdb_cpu_doing_single_step, -1);
+		atomic_set_wrap(&kgdb_cpu_doing_single_step, -1);
 
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->flags |= X86_EFLAGS_TF;
-			atomic_set(&kgdb_cpu_doing_single_step,
+			atomic_set_wrap(&kgdb_cpu_doing_single_step,
 				   raw_smp_processor_id());
 		}
 
@@ -551,7 +551,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 
 	switch (cmd) {
 	case DIE_DEBUG:
-		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
+		if (atomic_read_wrap(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
 			break;
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 5b2cc88..c13e84b 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -51,11 +51,11 @@ void pvclock_touch_watchdogs(void)
 	reset_hung_task_detector();
 }
 
-static atomic64_t last_value = ATOMIC64_INIT(0);
+static atomic64_wrap_t last_value = ATOMIC64_INIT(0);
 
 void pvclock_resume(void)
 {
-	atomic64_set(&last_value, 0);
+	atomic64_set_wrap(&last_value, 0);
 }
 
 u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src)
@@ -107,11 +107,11 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	 * updating at the same time, and one of them could be slightly behind,
 	 * making the assumption that last_value always go forward fail to hold.
 	 */
-	last = atomic64_read(&last_value);
+	last = atomic64_read_wrap(&last_value);
 	do {
 		if (ret < last)
 			return last;
-		last = atomic64_cmpxchg(&last_value, last, ret);
+		last = atomic64_cmpxchg_wrap(&last_value, last, ret);
 	} while (unlikely(last != ret));
 
 	return ret;
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 8402907..bc939ad 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -304,7 +304,7 @@ static int tboot_extended_sleep(u8 sleep_state, u32 val_a, u32 val_b)
 	return -ENODEV;
 }
 
-static atomic_t ap_wfs_count;
+static atomic_wrap_t ap_wfs_count;
 
 static int tboot_wait_for_aps(int num_aps)
 {
@@ -325,9 +325,9 @@ static int tboot_wait_for_aps(int num_aps)
 
 static int tboot_dying_cpu(unsigned int cpu)
 {
-	atomic_inc(&ap_wfs_count);
+	atomic_inc_wrap(&ap_wfs_count);
 	if (num_online_cpus() == 1) {
-		if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
+		if (tboot_wait_for_aps(atomic_read_wrap(&ap_wfs_count)))
 			return -EBUSY;
 	}
 	return 0;
@@ -407,7 +407,7 @@ static __init int tboot_late_init(void)
 
 	tboot_create_trampoline();
 
-	atomic_set(&ap_wfs_count, 0);
+	atomic_set_wrap(&ap_wfs_count, 0);
 	cpuhp_setup_state(CPUHP_AP_X86_TBOOT_DYING, "AP_X86_TBOOT_DYING", NULL,
 			  tboot_dying_cpu);
 #ifdef CONFIG_DEBUG_FS
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index bef3662..c19ea03 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -234,7 +234,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 							void __iomem *addr)
 {
-	static atomic_t next_id;
+	static atomic_wrap_t next_id;
 	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
 	/* These are page-unaligned. */
 	struct mmiotrace_map map = {
@@ -258,7 +258,7 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 			.private = trace
 		},
 		.phys = offset,
-		.id = atomic_inc_return(&next_id)
+		.id = atomic_inc_return_wrap(&next_id)
 	};
 	map.map_id = trace->id;
 
-- 
2.7.4
