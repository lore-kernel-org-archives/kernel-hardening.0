From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:28 -0700
Message-Id: <1491513513-84351-14-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 13/18] randstruct: opt-out externally exposed function pointer structs
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Some function pointer structures are used externally to the kernel, like
the paravirt structures. These should never be randomized, so mark them as
such. This set was extracted from grsecurity.

One difference from grsecurity is the opting out of sgi-xp, until
maintainers can decide if randomization is actually safe there.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/cacheflush.h     |  2 +-
 arch/x86/include/asm/paravirt_types.h | 16 ++++++++--------
 drivers/misc/sgi-xp/xp.h              |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index d69bebf697e7..74504b154256 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -116,7 +116,7 @@ struct cpu_cache_fns {
 	void (*dma_unmap_area)(const void *, size_t, int);
 
 	void (*dma_flush_range)(const void *, const void *);
-};
+} __no_randomize_layout;
 
 /*
  * Select the calling method
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 93c49cf09b63..82f7d92b9232 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -83,7 +83,7 @@ struct pv_init_ops {
 	 */
 	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
 			  unsigned long addr, unsigned len);
-};
+} __no_randomize_layout;
 
 
 struct pv_lazy_ops {
@@ -91,12 +91,12 @@ struct pv_lazy_ops {
 	void (*enter)(void);
 	void (*leave)(void);
 	void (*flush)(void);
-};
+} __no_randomize_layout;
 
 struct pv_time_ops {
 	unsigned long long (*sched_clock)(void);
 	unsigned long long (*steal_clock)(int cpu);
-};
+} __no_randomize_layout;
 
 struct pv_cpu_ops {
 	/* hooks for various privileged instructions */
@@ -175,7 +175,7 @@ struct pv_cpu_ops {
 
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
-};
+} __no_randomize_layout;
 
 struct pv_irq_ops {
 	/*
@@ -198,7 +198,7 @@ struct pv_irq_ops {
 #ifdef CONFIG_X86_64
 	void (*adjust_exception_frame)(void);
 #endif
-};
+} __no_randomize_layout;
 
 struct pv_mmu_ops {
 	unsigned long (*read_cr2)(void);
@@ -301,7 +301,7 @@ struct pv_mmu_ops {
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
 			   phys_addr_t phys, pgprot_t flags);
-};
+} __no_randomize_layout;
 
 struct arch_spinlock;
 #ifdef CONFIG_SMP
@@ -318,7 +318,7 @@ struct pv_lock_ops {
 	void (*kick)(int cpu);
 
 	struct paravirt_callee_save vcpu_is_preempted;
-};
+} __no_randomize_layout;
 
 /* This contains all the paravirt structures: we get a convenient
  * number for each function using the offset which we use to indicate
@@ -330,7 +330,7 @@ struct paravirt_patch_template {
 	struct pv_irq_ops pv_irq_ops;
 	struct pv_mmu_ops pv_mmu_ops;
 	struct pv_lock_ops pv_lock_ops;
-};
+} __no_randomize_layout;
 
 extern struct pv_info pv_info;
 extern struct pv_init_ops pv_init_ops;
diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index c862cd4583cc..a23a373d8707 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -288,7 +288,7 @@ struct xpc_interface {
 					xpc_notify_func, void *);
 	void (*received) (short, int, void *);
 	enum xp_retval (*partid_to_nasids) (short, void *);
-};
+} __no_randomize_layout;
 
 extern struct xpc_interface xpc_interface;
 
-- 
2.7.4
