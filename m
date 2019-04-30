Date: Tue, 30 Apr 2019 04:28:54 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Rick Edgecombe <tipbot@zytor.com>
Message-ID: <tip-241a1f22380646bc4d1dd18e5bc246877513da68@git.kernel.org>
In-Reply-To: <20190426001143.4983-21-namit@vmware.com>
References: <20190426001143.4983-21-namit@vmware.com>
Subject: [tip:x86/mm] x86/kprobes: Use vmalloc special flag
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: deneen.t.dock@intel.com, luto@kernel.org, akpm@linux-foundation.org, rick.p.edgecombe@intel.com, nadav.amit@gmail.com, linux-kernel@vger.kernel.org, bp@alien8.de, peterz@infradead.org, linux_dti@icloud.com, dave.hansen@linux.intel.com, kernel-hardening@lists.openwall.com, hpa@zytor.com, torvalds@linux-foundation.org, will.deacon@arm.com, tglx@linutronix.de, riel@surriel.com, ard.biesheuvel@linaro.org, mhiramat@kernel.org, kristen@linux.intel.com, mingo@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  241a1f22380646bc4d1dd18e5bc246877513da68
Gitweb:     https://git.kernel.org/tip/241a1f22380646bc4d1dd18e5bc246877513da68
Author:     Rick Edgecombe <rick.p.edgecombe@intel.com>
AuthorDate: Thu, 25 Apr 2019 17:11:40 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:38:01 +0200

x86/kprobes: Use vmalloc special flag

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set NX
and RW before freeing which is no longer needed.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-21-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 06058c44ab57..800593f4ddf7 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -434,6 +434,7 @@ void *alloc_insn_page(void)
 	if (!page)
 		return NULL;
 
+	set_vm_flush_reset_perms(page);
 	/*
 	 * First make the page read-only, and only then make it executable to
 	 * prevent it from being W+X in between.
@@ -452,12 +453,6 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	/*
-	 * First make the page non-executable, and only then make it writable to
-	 * prevent it from being W+X in between.
-	 */
-	set_memory_nx((unsigned long)page, 1);
-	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
