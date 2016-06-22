Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:46:58 -0700
Message-Id: <1466556426-32664-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 1/9] x86/mm: Refactor KASLR entropy functions
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Move the KASLR entropy functions into arch/x86/lib to be used in early
kernel boot for KASLR memory randomization.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 76 +++------------------------------
 arch/x86/include/asm/kaslr.h     |  6 +++
 arch/x86/lib/Makefile            |  1 +
 arch/x86/lib/kaslr.c             | 90 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 71 deletions(-)
 create mode 100644 arch/x86/include/asm/kaslr.h
 create mode 100644 arch/x86/lib/kaslr.c

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 749c9e00c674..1781a8dbae46 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -12,10 +12,6 @@
 #include "misc.h"
 #include "error.h"
 
-#include <asm/msr.h>
-#include <asm/archrandom.h>
-#include <asm/e820.h>
-
 #include <generated/compile.h>
 #include <linux/module.h>
 #include <linux/uts.h>
@@ -26,26 +22,6 @@
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
-#define I8254_PORT_CONTROL	0x43
-#define I8254_PORT_COUNTER0	0x40
-#define I8254_CMD_READBACK	0xC0
-#define I8254_SELECT_COUNTER0	0x02
-#define I8254_STATUS_NOTREADY	0x40
-static inline u16 i8254(void)
-{
-	u16 status, timer;
-
-	do {
-		outb(I8254_PORT_CONTROL,
-		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
-		status = inb(I8254_PORT_COUNTER0);
-		timer  = inb(I8254_PORT_COUNTER0);
-		timer |= inb(I8254_PORT_COUNTER0) << 8;
-	} while (status & I8254_STATUS_NOTREADY);
-
-	return timer;
-}
-
 static unsigned long rotate_xor(unsigned long hash, const void *area,
 				size_t size)
 {
@@ -62,7 +38,7 @@ static unsigned long rotate_xor(unsigned long hash, const void *area,
 }
 
 /* Attempt to create a simple but unpredictable starting entropy. */
-static unsigned long get_random_boot(void)
+static unsigned long get_boot_seed(void)
 {
 	unsigned long hash = 0;
 
@@ -72,50 +48,8 @@ static unsigned long get_random_boot(void)
 	return hash;
 }
 
-static unsigned long get_random_long(const char *purpose)
-{
-#ifdef CONFIG_X86_64
-	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
-#else
-	const unsigned long mix_const = 0x3f39e593UL;
-#endif
-	unsigned long raw, random = get_random_boot();
-	bool use_i8254 = true;
-
-	debug_putstr(purpose);
-	debug_putstr(" KASLR using");
-
-	if (has_cpuflag(X86_FEATURE_RDRAND)) {
-		debug_putstr(" RDRAND");
-		if (rdrand_long(&raw)) {
-			random ^= raw;
-			use_i8254 = false;
-		}
-	}
-
-	if (has_cpuflag(X86_FEATURE_TSC)) {
-		debug_putstr(" RDTSC");
-		raw = rdtsc();
-
-		random ^= raw;
-		use_i8254 = false;
-	}
-
-	if (use_i8254) {
-		debug_putstr(" i8254");
-		random ^= i8254();
-	}
-
-	/* Circular multiply for better bit diffusion */
-	asm("mul %3"
-	    : "=a" (random), "=d" (raw)
-	    : "a" (random), "rm" (mix_const));
-	random += raw;
-
-	debug_putstr("...\n");
-
-	return random;
-}
+#define KASLR_COMPRESSED_BOOT
+#include "../../lib/kaslr.c"
 
 struct mem_vector {
 	unsigned long start;
@@ -347,7 +281,7 @@ static unsigned long slots_fetch_random(void)
 	if (slot_max == 0)
 		return 0;
 
-	slot = get_random_long("Physical") % slot_max;
+	slot = kaslr_get_random_long("Physical") % slot_max;
 
 	for (i = 0; i < slot_area_index; i++) {
 		if (slot >= slot_areas[i].num) {
@@ -477,7 +411,7 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
 	slots = (KERNEL_IMAGE_SIZE - minimum - image_size) /
 		 CONFIG_PHYSICAL_ALIGN + 1;
 
-	random_addr = get_random_long("Virtual") % slots;
+	random_addr = kaslr_get_random_long("Virtual") % slots;
 
 	return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
 }
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
new file mode 100644
index 000000000000..5547438db5ea
--- /dev/null
+++ b/arch/x86/include/asm/kaslr.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_KASLR_H_
+#define _ASM_KASLR_H_
+
+unsigned long kaslr_get_random_long(const char *purpose);
+
+#endif
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 72a576752a7e..cfa6d076f4f2 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -24,6 +24,7 @@ lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
+lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
 
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
new file mode 100644
index 000000000000..f7dfeda83e5c
--- /dev/null
+++ b/arch/x86/lib/kaslr.c
@@ -0,0 +1,90 @@
+/*
+ * Entropy functions used on early boot for KASLR base and memory
+ * randomization. The base randomization is done in the compressed
+ * kernel and memory randomization is done early when the regular
+ * kernel starts. This file is included in the compressed kernel and
+ * normally linked in the regular.
+ */
+#include <asm/kaslr.h>
+#include <asm/msr.h>
+#include <asm/archrandom.h>
+#include <asm/e820.h>
+#include <asm/io.h>
+
+/*
+ * When built for the regular kernel, several functions need to be stubbed out
+ * or changed to their regular kernel equivalent.
+ */
+#ifndef KASLR_COMPRESSED_BOOT
+#include <asm/cpufeature.h>
+#include <asm/setup.h>
+
+#define debug_putstr(v) early_printk(v)
+#define has_cpuflag(f) boot_cpu_has(f)
+#define get_boot_seed() kaslr_offset()
+#endif
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
+unsigned long kaslr_get_random_long(const char *purpose)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
+	unsigned long raw, random = get_boot_seed();
+	bool use_i8254 = true;
+
+	debug_putstr(purpose);
+	debug_putstr(" KASLR using");
+
+	if (has_cpuflag(X86_FEATURE_RDRAND)) {
+		debug_putstr(" RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
+	}
+
+	if (has_cpuflag(X86_FEATURE_TSC)) {
+		debug_putstr(" RDTSC");
+		raw = rdtsc();
+
+		random ^= raw;
+		use_i8254 = false;
+	}
+
+	if (use_i8254) {
+		debug_putstr(" i8254");
+		random ^= i8254();
+	}
+
+	/* Circular multiply for better bit diffusion */
+	asm("mul %3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
+	debug_putstr("...\n");
+
+	return random;
+}
-- 
2.7.4
