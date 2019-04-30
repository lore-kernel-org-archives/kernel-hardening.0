Date: Tue, 30 Apr 2019 04:21:23 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-3c0dab44e22782359a0a706cbce72de99a22aa75@git.kernel.org>
In-Reply-To: <20190426001143.4983-10-namit@vmware.com>
References: <20190426001143.4983-10-namit@vmware.com>
Subject: [tip:x86/mm] x86/ftrace: Set trampoline pages as executable
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: bp@alien8.de, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, luto@kernel.org, ard.biesheuvel@linaro.org, akpm@linux-foundation.org, linux_dti@icloud.com, dave.hansen@linux.intel.com, tglx@linutronix.de, torvalds@linux-foundation.org, rick.p.edgecombe@intel.com, will.deacon@arm.com, rostedt@goodmis.org, namit@vmware.com, deneen.t.dock@intel.com, kristen@linux.intel.com, peterz@infradead.org, mingo@kernel.org, hpa@zytor.com, riel@surriel.com
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  3c0dab44e22782359a0a706cbce72de99a22aa75
Gitweb:     https://git.kernel.org/tip/3c0dab44e22782359a0a706cbce72de99a22aa75
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:29 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:53 +0200

x86/ftrace: Set trampoline pages as executable

Since alloc_module() will not set the pages as executable soon, set
ftrace trampoline pages as executable after they are allocated.

For the time being, do not change ftrace to use the text_poke()
interface. As a result, ftrace still breaks W^X.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
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
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-10-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ef49517f6bb2..53ba1aa3a01f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -730,6 +730,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long end_offset;
 	unsigned long op_offset;
 	unsigned long offset;
+	unsigned long npages;
 	unsigned long size;
 	unsigned long retq;
 	unsigned long *ptr;
@@ -762,6 +763,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		return 0;
 
 	*tramp_size = size + RET_SIZE + sizeof(void *);
+	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
 
 	/* Copy ftrace_caller onto the trampoline memory */
 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
@@ -806,6 +808,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
+	/*
+	 * Module allocation needs to be completed by making the page
+	 * executable. The page is still writable, which is a security hazard,
+	 * but anyhow ftrace breaks W^X completely.
+	 */
+	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
 	tramp_free(trampoline, *tramp_size);
