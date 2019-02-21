From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 6/7] powerpc/lib: Refactor __patch_instruction() to use __put_user_asm()
Date: Thu, 21 Feb 2019 20:36:00 +1100
Message-Id: <20190221093601.27920-7-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

__patch_instruction() is called in early boot, and uses
__put_user_size(), which includes the locks and unlocks for KUAP,
which could either be called too early, or in the Radix case, forced to
use "early_" versions of functions just to safely handle this one case.

__put_user_asm() does not do this, and thus is safe to use both in early
boot, and later on since in this case it should only ever be touching
kernel memory.

__patch_instruction() was previously refactored to use __put_user_size()
in order to be able to return -EFAULT, which would allow the kernel to
patch instructions in userspace, which should never happen.  This has
the functional change of causing faults on userspace addresses if KUAP
is turned on, which should never happen in practice.

A future enhancement could be to double check the patch address is
definitely allowed to be tampered with by the kernel.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/lib/code-patching.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 506413a2c25e..42fdadac6587 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -26,9 +26,9 @@
 static int __patch_instruction(unsigned int *exec_addr, unsigned int instr,
 			       unsigned int *patch_addr)
 {
-	int err;
+	int err = 0;
 
-	__put_user_size(instr, patch_addr, 4, err);
+	__put_user_asm(instr, patch_addr, err, "stw");
 	if (err)
 		return err;
 
-- 
2.20.1
