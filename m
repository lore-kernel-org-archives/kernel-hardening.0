From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 02/27] x86: Use symbol name in jump table for PIE support
Date: Thu, 31 Jan 2019 11:24:09 -0800
Message-Id: <20190131192533.34130-3-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Garnier <thgarnie@google.com>, Nadav Amit <namit@vmware.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Replace the %c constraint with %P. The %c is incompatible with PIE
because it implies an immediate value whereas %P reference a symbol.
Change the _ASM_PTR reference to .long for expected relocation size and
add a long padding to ensure entry alignment.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/jump_label.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 65191ce8e1cf..e47fad8ee632 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -25,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%c0 + %c1 - .\n\t"
+		_ASM_PTR "%P0 - .\n\t"
 		".popsection \n\t"
-		: :  "i" (key), "i" (branch) : : l_yes);
+		: :  "X" (&((char *)key)[branch]) : : l_yes);
 
 	return false;
 l_yes:
@@ -42,9 +42,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		".long 1b - ., %l[l_yes] - . \n\t"
-		_ASM_PTR "%c0 + %c1 - .\n\t"
+		_ASM_PTR "%P0 - .\n\t"
 		".popsection \n\t"
-		: :  "i" (key), "i" (branch) : : l_yes);
+		: : "X" (&((char *)key)[branch]) : : l_yes);
 
 	return false;
 l_yes:
-- 
2.20.1.495.gaa96b0ce6b-goog
