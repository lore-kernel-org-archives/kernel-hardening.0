Date: Tue, 30 Apr 2019 04:28:13 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Rick Edgecombe <tipbot@zytor.com>
Message-ID: <tip-7fdfe1e40b225b1d163f9afed2fa3f04442dbaad@git.kernel.org>
In-Reply-To: <20190426001143.4983-20-namit@vmware.com>
References: <20190426001143.4983-20-namit@vmware.com>
Subject: [tip:x86/mm] x86/ftrace: Use vmalloc special flag
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: hpa@zytor.com, bp@alien8.de, torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org, nadav.amit@gmail.com, will.deacon@arm.com, peterz@infradead.org, rostedt@goodmis.org, linux_dti@icloud.com, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, kristen@linux.intel.com, riel@surriel.com, deneen.t.dock@intel.com, luto@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  7fdfe1e40b225b1d163f9afed2fa3f04442dbaad
Gitweb:     https://git.kernel.org/tip/7fdfe1e40b225b1d163f9afed2fa3f04442dbaad
Author:     Rick Edgecombe <rick.p.edgecombe@intel.com>
AuthorDate: Thu, 25 Apr 2019 17:11:39 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:38:00 +0200

x86/ftrace: Use vmalloc special flag

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set NX
and RW before freeing which is no longer needed.

Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-20-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/ftrace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 53ba1aa3a01f..0caf8122d680 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -678,12 +678,8 @@ static inline void *alloc_tramp(unsigned long size)
 {
 	return module_alloc(size);
 }
-static inline void tramp_free(void *tramp, int size)
+static inline void tramp_free(void *tramp)
 {
-	int npages = PAGE_ALIGN(size) >> PAGE_SHIFT;
-
-	set_memory_nx((unsigned long)tramp, npages);
-	set_memory_rw((unsigned long)tramp, npages);
 	module_memfree(tramp);
 }
 #else
@@ -692,7 +688,7 @@ static inline void *alloc_tramp(unsigned long size)
 {
 	return NULL;
 }
-static inline void tramp_free(void *tramp, int size) { }
+static inline void tramp_free(void *tramp) { }
 #endif
 
 /* Defined as markers to the end of the ftrace default trampolines */
@@ -808,6 +804,8 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
+	set_vm_flush_reset_perms(trampoline);
+
 	/*
 	 * Module allocation needs to be completed by making the page
 	 * executable. The page is still writable, which is a security hazard,
@@ -816,7 +814,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
-	tramp_free(trampoline, *tramp_size);
+	tramp_free(trampoline);
 	return 0;
 }
 
@@ -947,7 +945,7 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
 	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
 		return;
 
-	tramp_free((void *)ops->trampoline, ops->trampoline_size);
+	tramp_free((void *)ops->trampoline);
 	ops->trampoline = 0;
 }
 
