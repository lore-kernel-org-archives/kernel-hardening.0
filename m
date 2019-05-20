From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v7 11/12] x86/paravirt: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:36 -0700
Message-Id: <20190520231948.49693-12-thgarnie@chromium.org>
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

if PIE is enabled, switch the paravirt assembly constraints to be
compatible. The %c/i constrains generate smaller code so is kept by
default.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/paravirt_types.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 2474e434a6f7..93be18bdb63e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -343,9 +343,17 @@ extern struct paravirt_patch_template pv_ops;
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
 
+#ifdef CONFIG_X86_PIE
+#define paravirt_opptr_call "a"
+#define paravirt_opptr_type "p"
+#else
+#define paravirt_opptr_call "c"
+#define paravirt_opptr_type "i"
+#endif
+
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "i" (&(pv_ops.op))
+	[paravirt_opptr] paravirt_opptr_type (&(pv_ops.op))
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
@@ -393,7 +401,7 @@ int paravirt_disable_iospace(void);
  */
 #define PARAVIRT_CALL					\
 	ANNOTATE_RETPOLINE_SAFE				\
-	"call *%c[paravirt_opptr];"
+	"call *%" paravirt_opptr_call "[paravirt_opptr];"
 
 /*
  * These macros are intended to wrap calls through one of the paravirt
-- 
2.21.0.1020.gf2820cf01a-goog
