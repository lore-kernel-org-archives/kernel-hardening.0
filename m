Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  1 Oct 2013 12:37:22 -0700
Message-Id: <1380656245-29975-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-1-git-send-email-keescook@chromium.org>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/7] x86, kaslr: select random base offset
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Select a random location when CONFIG_RANDOMIZE_BASE is used, bounded
by CONFIG_RANDOMIZE_BASE_MAX_OFFSET. Sources of randomness currently
include RDRAND, RDTSC, or the i8254.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c |   83 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/boot/compressed/misc.h |    2 +
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index ed7e9f0..2f63f9f 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,6 +1,72 @@
 #include "misc.h"
 
 #ifdef CONFIG_RANDOMIZE_BASE
+#include <asm/msr.h>
+
+#include <asm/archrandom.h>
+static inline int rdrand(unsigned long *v)
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
+		if (rdrand(&random))
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
+	random |= (random << 32) | (random << 48);
+#endif
+	return random;
+}
 
 static unsigned long find_minimum_location(unsigned long input,
 					   unsigned long input_size,
@@ -55,6 +121,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long output_size)
 {
 	unsigned long choice = (unsigned long)output;
+	unsigned long random;
 
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled...\n");
@@ -64,8 +131,22 @@ unsigned char *choose_kernel_location(unsigned char *input,
 	choice = find_minimum_location((unsigned long)input, input_size,
 				       (unsigned long)output, output_size);
 
-	/* XXX: choose random location. */
+	/* XXX: Find an appropriate E820 hole, instead of adding offset. */
+	random = get_random_long();
+
+	/* Clip off top of the range. */
+	random &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
+	while (random + output_size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		random >>= 1;
+
+	/* Clip off bottom of range. */
+	random &= ~(choice - 1);
+
+	/* Always enforce the minimum. */
+	if (random < choice)
+		goto out;
 
+	choice = random;
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 42f71bb..24e3e56 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -60,6 +60,8 @@ unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size);
+/* cpuflags.c */
+bool has_cpuflag(int flag);
 #else
 static inline
 unsigned char *choose_kernel_location(unsigned char *input,
-- 
1.7.9.5
