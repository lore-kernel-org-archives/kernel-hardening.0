Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Oct 2013 17:18:15 -0700
Message-Id: <1381450698-28710-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1381450698-28710-1-git-send-email-keescook@chromium.org>
References: <1381450698-28710-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v8 3/6] x86, kaslr: provide randomness functions
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Adds potential sources of randomness: RDRAND, RDTSC, or the i8254.

This moves the pre-alternatives inline rdrand function into the header so
both pieces of code can use it. Availability of RDRAND is then controlled
by CONFIG_ARCH_RANDOM, if someone wants to disable it even for kASLR.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v7:
 - move rdrand_long into header to avoid code duplication; HPA.
v3:
 - fall back to reading the i8254 when no TSC; HPA.
v2:
 - use rdtscl from msr.h; Mathias Krause.
---
 arch/x86/boot/compressed/aslr.c   |   53 +++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h   |    2 ++
 arch/x86/include/asm/archrandom.h |   21 +++++++++++++++
 arch/x86/kernel/cpu/rdrand.c      |   14 ----------
 4 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index b73cc66..14b24e0 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,6 +1,59 @@
 #include "misc.h"
 
 #ifdef CONFIG_RANDOMIZE_BASE
+#include <asm/msr.h>
+#include <asm/archrandom.h>
+
+#define I8254_PORT_CONTROL	0x43
+#define I8254_PORT_COUNTER0	0x40
+#define I8254_CMD_READBACK	0xC0
+#define I8254_SELECT_COUNTER0	0x02
+#define I8254_STATUS_NOTREADY	0x40
+static inline u16 i8254(void)
+{
+	u16 status, timer;
+
+	do {
+		outb(I8254_PORT_CONTROL,
+		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
+		status = inb(I8254_PORT_COUNTER0);
+		timer  = inb(I8254_PORT_COUNTER0);
+		timer |= inb(I8254_PORT_COUNTER0) << 8;
+	} while (status & I8254_STATUS_NOTREADY);
+
+	return timer;
+}
+
+static unsigned long get_random_long(void)
+{
+	unsigned long random;
+
+	if (has_cpuflag(X86_FEATURE_RDRAND)) {
+		debug_putstr("KASLR using RDRAND...\n");
+		if (rdrand_long(&random))
+			return random;
+	}
+
+	if (has_cpuflag(X86_FEATURE_TSC)) {
+		uint32_t raw;
+
+		debug_putstr("KASLR using RDTSC...\n");
+		rdtscl(raw);
+
+		/* Only use the low bits of rdtsc. */
+		random = raw & 0xffff;
+	} else {
+		debug_putstr("KASLR using i8254...\n");
+		random = i8254();
+	}
+
+	/* Extend timer bits poorly... */
+	random |= (random << 16);
+#ifdef CONFIG_X86_64
+	random |= (random << 32);
+#endif
+	return random;
+}
 
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 9077af7..0782eb0 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -52,6 +52,8 @@ unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size);
+/* cpuflags.c */
+bool has_cpuflag(int flag);
 #else
 static inline
 unsigned char *choose_kernel_location(unsigned char *input,
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 0d9ec77..e6a9245 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -39,6 +39,20 @@
 
 #ifdef CONFIG_ARCH_RANDOM
 
+/* Instead of arch_get_random_long() when alternatives haven't run. */
+static inline int rdrand_long(unsigned long *v)
+{
+	int ok;
+	asm volatile("1: " RDRAND_LONG "\n\t"
+		     "jc 2f\n\t"
+		     "decl %0\n\t"
+		     "jnz 1b\n\t"
+		     "2:"
+		     : "=r" (ok), "=a" (*v)
+		     : "0" (RDRAND_RETRY_LOOPS));
+	return ok;
+}
+
 #define GET_RANDOM(name, type, rdrand, nop)			\
 static inline int name(type *v)					\
 {								\
@@ -68,6 +82,13 @@ GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
 
 #endif /* CONFIG_X86_64 */
 
+#else
+
+static inline int rdrand_long(unsigned long *v)
+{
+	return 0;
+}
+
 #endif  /* CONFIG_ARCH_RANDOM */
 
 extern void x86_init_rdrand(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
index 88db010..384df51 100644
--- a/arch/x86/kernel/cpu/rdrand.c
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -31,20 +31,6 @@ static int __init x86_rdrand_setup(char *s)
 }
 __setup("nordrand", x86_rdrand_setup);
 
-/* We can't use arch_get_random_long() here since alternatives haven't run */
-static inline int rdrand_long(unsigned long *v)
-{
-	int ok;
-	asm volatile("1: " RDRAND_LONG "\n\t"
-		     "jc 2f\n\t"
-		     "decl %0\n\t"
-		     "jnz 1b\n\t"
-		     "2:"
-		     : "=r" (ok), "=a" (*v)
-		     : "0" (RDRAND_RETRY_LOOPS));
-	return ok;
-}
-
 /*
  * Force a reseed cycle; we are architecturally guaranteed a reseed
  * after no more than 512 128-bit chunks of random data.  This also
-- 
1.7.9.5
