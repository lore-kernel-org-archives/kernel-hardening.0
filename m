Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Apr 2013 12:24:22 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20130410192422.GA17344@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v3] x86: use a read-only IDT alias on all CPUs
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Kees Cook <keescook@chromium.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, kernel-hardening@lists.openwall.com, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Make a copy of the IDT (as seen via the "sidt" instruction) read-only.
This primarily removes the IDT from being a target for arbitrary memory
write attacks, and has the added benefit of also not leaking the kernel
base offset, if it has been relocated.

We already did this on vendor == Intel and family == 5 because of the
F0 0F bug -- regardless of if a particular CPU had the F0 0F bug or
not.  Since the workaround was so cheap, there simply was no reason to
be very specific.  This patch extends the readonly alias to all CPUs,
but does not activate the #PF to #UD conversion code needed to deliver
the proper exception in the F0 0F case except on Intel family 5
processors.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Northup <digitaleric@google.com>
---
v3:
 - clarify commit, thanks to HPA
 - add missing header file, thanks to buildbot. :)
v2:
 - clarify commit and comments
---
 arch/x86/include/asm/fixmap.h |    4 +---
 arch/x86/kernel/cpu/intel.c   |   18 +-----------------
 arch/x86/kernel/traps.c       |    9 +++++++++
 arch/x86/xen/mmu.c            |    4 +---
 4 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..51b9e32 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -104,9 +104,7 @@ enum fixed_addresses {
 	FIX_LI_PCIA,	/* Lithium PCI Bridge A */
 	FIX_LI_PCIB,	/* Lithium PCI Bridge B */
 #endif
-#ifdef CONFIG_X86_F00F_BUG
-	FIX_F00F_IDT,	/* Virtual mapping for IDT */
-#endif
+	FIX_RO_IDT,	/* Virtual mapping for read-only IDT */
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..7170024 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -164,20 +164,6 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
 	/* calling is from identify_secondary_cpu() ? */
@@ -206,8 +192,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the
-	 * system.
-	 * Note that the workaround only should be initialized once...
+	 * system. Announce that the fault handler will be checking for it.
 	 */
 	c->f00f_bug = 0;
 	if (!paravirt_enabled() && c->x86 == 5) {
@@ -215,7 +200,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 		c->f00f_bug = 1;
 		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 68bda7a..10e2446 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -56,6 +56,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
 #include <asm/context_tracking.h>
+#include <asm/fixmap.h>
 
 #include <asm/mach_traps.h>
 
@@ -753,6 +754,14 @@ void __init trap_init(void)
 #endif
 
 	/*
+	 * Set the IDT descriptor to a fixed read-only location, so that the
+	 * "sidt" instruction will not leak the location of the kernel, and
+	 * to defend the IDT against arbitrary memory write vulnerabilities.
+	 * It will be reloaded in cpu_init() */
+	__set_fixmap(FIX_RO_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
+	idt_descr.address = fix_to_virt(FIX_RO_IDT);
+
+	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6afbb2c..8bc4dec 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2039,9 +2039,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	switch (idx) {
 	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
-#ifdef CONFIG_X86_F00F_BUG
-	case FIX_F00F_IDT:
-#endif
+	case FIX_RO_IDT:
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
 	case FIX_VDSO:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
