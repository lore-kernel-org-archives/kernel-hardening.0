Date: Tue, 30 Apr 2019 04:29:34 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-3950746d9d8ef981c1cb842384e0e86e8d1aad76@git.kernel.org>
In-Reply-To: <20190426001143.4983-22-namit@vmware.com>
References: <20190426001143.4983-22-namit@vmware.com>
Subject: [tip:x86/mm] x86/alternatives: Add comment about module removal
 races
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, bp@alien8.de, dave.hansen@linux.intel.com, linux_dti@icloud.com, riel@surriel.com, akpm@linux-foundation.org, deneen.t.dock@intel.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, kristen@linux.intel.com, hpa@zytor.com, will.deacon@arm.com, mingo@kernel.org, mhiramat@kernel.org, tglx@linutronix.de, rick.p.edgecombe@intel.com, luto@kernel.org, kernel-hardening@lists.openwall.com, peterz@infradead.org, namit@vmware.com
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  3950746d9d8ef981c1cb842384e0e86e8d1aad76
Gitweb:     https://git.kernel.org/tip/3950746d9d8ef981c1cb842384e0e86e8d1aad76
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:41 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:38:01 +0200

x86/alternatives: Add comment about module removal races

Add a comment to clarify that users of text_poke() must ensure that
no races with module removal take place.

Signed-off-by: Nadav Amit <namit@vmware.com>
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
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-22-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 18f959975ea0..7b9b49dfc05a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -810,6 +810,11 @@ static void *__text_poke(void *addr, const void *opcode, size_t len)
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * Note that the caller must ensure that if the modified code is part of a
+ * module, the module would not be removed during poking. This can be achieved
+ * by registering a module notifier, and ordering module removal and patching
+ * trough a mutex.
  */
 void *text_poke(void *addr, const void *opcode, size_t len)
 {
