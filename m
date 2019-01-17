From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 09/17] x86/kprobes: Instruction pages initialization enhancements
Date: Wed, 16 Jan 2019 16:32:51 -0800
Message-Id: <20190117003259.23141-10-rick.p.edgecombe@intel.com>
In-Reply-To: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
To: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Masami Hiramatsu <mhiramat@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Nadav Amit <namit@vmware.com>

This patch is a preparatory patch for a following patch that makes
module allocated pages non-executable. The patch sets the page as
executable after allocation.

In the future, we may get better protection of executables. For example,
by using hypercalls to request the hypervisor to protect VM executable
pages from modifications using nested page-tables. This would allow
us to ensure the executable has not changed between allocation and
its write-protection.

While at it, do some small cleanup of what appears to be unnecessary
masking.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/kprobes/core.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4ba75afba527..fac692e36833 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -431,8 +431,20 @@ void *alloc_insn_page(void)
 	void *page;
 
 	page = module_alloc(PAGE_SIZE);
-	if (page)
-		set_memory_ro((unsigned long)page & PAGE_MASK, 1);
+	if (page == NULL)
+		return NULL;
+
+	/*
+	 * First make the page read-only, and then only then make it executable
+	 * to prevent it from being W+X in between.
+	 */
+	set_memory_ro((unsigned long)page, 1);
+
+	/*
+	 * TODO: Once additional kernel code protection mechanisms are set, ensure
+	 * that the page was not maliciously altered and it is still zeroed.
+	 */
+	set_memory_x((unsigned long)page, 1);
 
 	return page;
 }
@@ -440,8 +452,12 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	set_memory_nx((unsigned long)page & PAGE_MASK, 1);
-	set_memory_rw((unsigned long)page & PAGE_MASK, 1);
+	/*
+	 * First make the page non-executable, and then only then make it
+	 * writable to prevent it from being W+X in between.
+	 */
+	set_memory_nx((unsigned long)page, 1);
+	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
-- 
2.17.1
