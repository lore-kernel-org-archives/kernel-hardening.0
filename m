Date: Tue, 27 Nov 2018 14:32:00 +0100
Message-Id: <20181127133200.38322-1-jannh@google.com>
Mime-Version: 1.0
Subject: [PATCH v2] x86/fpu: XRSTOR is expected to raise #GP
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, jannh@google.com
Cc: Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

commit 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess
fixups") incorrectly replaced the fixup entry for XSTATE_OP with a
user-#PF-only fixup. XRSTOR can also raise #GP if the xstate content is
invalid, and _ASM_EXTABLE_UA doesn't expect that.
Change this fixup back to _ASM_EXTABLE so that #GP gets fixed up.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess fixups")
Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/x86/include/asm/fpu/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 5f7290e6e954..69dcdf195b61 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -226,7 +226,7 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		     "3: movl $-2,%[err]\n\t"				\
 		     "jmp 2b\n\t"					\
 		     ".popsection\n\t"					\
-		     _ASM_EXTABLE_UA(1b, 3b)				\
+		     _ASM_EXTABLE(1b, 3b)				\
 		     : [err] "=r" (err)					\
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
