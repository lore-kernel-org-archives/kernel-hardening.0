Date: Tue, 30 Apr 2019 04:20:43 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-86a22057127d1c0462a18901421bf1ff89491392@git.kernel.org>
In-Reply-To: <20190426001143.4983-9-namit@vmware.com>
References: <20190426001143.4983-9-namit@vmware.com>
Subject: [tip:x86/mm] x86/kgdb: Avoid redundant comparison of patched code
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: linux_dti@icloud.com, kristen@linux.intel.com, bp@alien8.de, deneen.t.dock@intel.com, linux-kernel@vger.kernel.org, peterz@infradead.org, akpm@linux-foundation.org, riel@surriel.com, namit@vmware.com, mingo@kernel.org, rick.p.edgecombe@intel.com, tglx@linutronix.de, dave.hansen@linux.intel.com, ard.biesheuvel@linaro.org, hpa@zytor.com, torvalds@linux-foundation.org, luto@kernel.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  86a22057127d1c0462a18901421bf1ff89491392
Gitweb:     https://git.kernel.org/tip/86a22057127d1c0462a18901421bf1ff89491392
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:28 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:53 +0200

x86/kgdb: Avoid redundant comparison of patched code

text_poke() already ensures that the written value is the correct one
and fails if that is not the case. There is no need for an additional
comparison. Remove it.

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
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-9-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kgdb.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 2b203ee5b879..13b13311b792 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -747,7 +747,6 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
-	char opc[BREAK_INSTR_SIZE];
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
@@ -766,11 +765,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 		return -EBUSY;
 	text_poke_kgdb((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err)
-		return err;
-	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
-		return -EINVAL;
 	bpt->type = BP_POKE_BREAKPOINT;
 
 	return err;
@@ -778,9 +772,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 
 int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-	int err;
-	char opc[BREAK_INSTR_SIZE];
-
 	if (bpt->type != BP_POKE_BREAKPOINT)
 		goto knl_write;
 	/*
@@ -791,10 +782,7 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 		goto knl_write;
 	text_poke_kgdb((void *)bpt->bpt_addr, bpt->saved_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
-		goto knl_write;
-	return err;
+	return 0;
 
 knl_write:
 	return probe_kernel_write((char *)bpt->bpt_addr,
