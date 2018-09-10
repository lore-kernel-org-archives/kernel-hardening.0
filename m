From: Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH] x86: entry: flush the cache if syscall error
Date: Mon, 10 Sep 2018 12:10:02 -0700
Message-Id: <20180910191002.350195-1-kristen@linux.intel.com>
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch aims to make it harder to perform cache timing attacks on data
left behind by system calls. If we have an error returned from a syscall,
flush the L1 cache.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/Kconfig        |  8 ++++++++
 arch/x86/entry/common.c | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c5ff296bc5d1..8a67642ff9fe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -445,6 +445,14 @@ config RETPOLINE
 	  code are eliminated. Since this includes the syscall entry path,
 	  it is not entirely pointless.
 
+config SYSCALL_FLUSH
+	bool "Clear L1 Cache on syscall errors"
+	default y
+	help
+	  Select to allow the L1 cache to be cleared upon return of
+	  an error code from a syscall. This will reduce the likelyhood of
+	  speculative execution style attacks on syscalls.
+
 config INTEL_RDT
 	bool "Intel Resource Director Technology support"
 	default n
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 3b2490b81918..77beff541013 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -268,6 +268,22 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 	prepare_exit_to_usermode(regs);
 }
 
+__visible inline void l1_cache_flush(struct pt_regs *regs)
+{
+	if (IS_ENABLED(CONFIG_SYSCALL_FLUSH)) {
+		if (regs->ax == 0 || regs->ax == -EAGAIN ||
+		    regs->ax == -EEXIST || regs->ax == -ENOENT ||
+		    regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
+		    regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
+			return;
+
+		if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+			wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+			return;
+		}
+	}
+}
+
 #ifdef CONFIG_X86_64
 __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
@@ -290,6 +306,8 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 		regs->ax = sys_call_table[nr](regs);
 	}
 
+	l1_cache_flush(regs);
+
 	syscall_return_slowpath(regs);
 }
 #endif
@@ -338,6 +356,8 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 #endif /* CONFIG_IA32_EMULATION */
 	}
 
+	l1_cache_flush(regs);
+
 	syscall_return_slowpath(regs);
 }
 
-- 
2.14.4
