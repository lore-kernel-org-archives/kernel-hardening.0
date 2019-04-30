Date: Tue, 30 Apr 2019 04:15:55 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-1fd8de46d01d95f875c12684a6a03559831e8b4c@git.kernel.org>
In-Reply-To: <20190426001143.4983-3-namit@vmware.com>
References: <20190426001143.4983-3-namit@vmware.com>
Subject: [tip:x86/mm] x86/jump_label: Use text_poke_early() during early
 init
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: riel@surriel.com, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, kristen@linux.intel.com, bp@alien8.de, tglx@linutronix.de, linux_dti@icloud.com, will.deacon@arm.com, keescook@chromium.org, deneen.t.dock@intel.com, namit@vmware.com, mhiramat@kernel.org, rick.p.edgecombe@intel.com, ard.biesheuvel@linaro.org, peterz@infradead.org, luto@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  1fd8de46d01d95f875c12684a6a03559831e8b4c
Gitweb:     https://git.kernel.org/tip/1fd8de46d01d95f875c12684a6a03559831e8b4c
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:49 +0200

x86/jump_label: Use text_poke_early() during early init

There is no apparent reason not to use text_poke_early() during
early-init, since no patching of code that might be on the stack is done
and only a single core is running.

This is required for the next patches that would set a temporary mm for
text poking, and this mm is only initialized after some static-keys are
enabled/disabled.

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
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-3-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/jump_label.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index f99bd26bd3f1..e7d8c636b228 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -50,7 +50,12 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
 	jmp.offset = jump_entry_target(entry) -
 		     (jump_entry_code(entry) + JUMP_LABEL_NOP_SIZE);
 
-	if (early_boot_irqs_disabled)
+	/*
+	 * As long as only a single processor is running and the code is still
+	 * not marked as RO, text_poke_early() can be used; Checking that
+	 * system_state is SYSTEM_BOOTING guarantees it.
+	 */
+	if (system_state == SYSTEM_BOOTING)
 		poker = text_poke_early;
 
 	if (type == JUMP_LABEL_JMP) {
