From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v4 04/27] x86: Add macro to get symbol address for PIE support
Date: Tue, 29 May 2018 15:15:05 -0700
Message-Id: <20180529221625.33541-5-thgarnie@google.com>
In-Reply-To: <20180529221625.33541-1-thgarnie@google.com>
References: <20180529221625.33541-1-thgarnie@google.com>
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Skip Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
to replace "_ASM_MOV $<symbol>, %dst" code construct that are not compatible
with PIE.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 219faaec51df..4492a35fad69 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -30,6 +30,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.17.0.921.gf22659ad46-goog
