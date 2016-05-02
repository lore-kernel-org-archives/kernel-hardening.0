Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon,  2 May 2016 14:41:13 -0700
Message-Id: <1462225276-106993-2-git-send-email-thgarnie@google.com>
In-Reply-To: <1462225276-106993-1-git-send-email-thgarnie@google.com>
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v2 1/4] x86, boot: Refactor KASLR entropy functions
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Move the KASLR entropy functions in x86/libray to be used in early
kernel boot for KASLR memory randomization.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160502
---
 arch/x86/boot/compressed/kaslr.c | 76 +++-----------------------------------
 arch/x86/include/asm/kaslr.h     |  6 +++
 arch/x86/lib/Makefile            |  1 +
 arch/x86/lib/kaslr.c             | 79 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 71 deletions(-)
 create mode 100644 arch/x86/include/asm/kaslr.h
 create mode 100644 arch/x86/lib/kaslr.c

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 8741a6d..0bdee23 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -11,10 +11,6 @@
  */
 #include "misc.h"
 
-#include <asm/msr.h>
-#include <asm/archrandom.h>
-#include <asm/e820.h>
-
 #include <generated/compile.h>
 #include <linux/module.h>
 #include <linux/uts.h>
@@ -25,26 +21,6 @@
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
@@ -61,7 +37,7 @@ static unsigned long rotate_xor(unsigned long hash, const void *area,
 }
 
 /* Attempt to create a simple but unpredictable starting entropy. */
-static unsigned long get_random_boot(void)
+static unsigned long get_boot_seed(void)
 {
 	unsigned long hash = 0;
 
@@ -71,50 +47,6 @@ static unsigned long get_random_boot(void)
 	return hash;
 }
 
-static unsigned long get_random_long(void)
-{
-#ifdef CONFIG_X86_64
-	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
-#else
-	const unsigned long mix_const = 0x3f39e593UL;
-#endif
-	unsigned long raw, random = get_random_boot();
-	bool use_i8254 = true;
-
-	debug_putstr("KASLR using");
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
-
 struct mem_vector {
 	unsigned long start;
 	unsigned long size;
@@ -122,7 +54,6 @@ struct mem_vector {
 
 #define MEM_AVOID_MAX 5
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
-
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
 	/* Item at least partially before region. */
@@ -229,13 +160,16 @@ static void slots_append(unsigned long addr)
 	slots[slot_max++] = addr;
 }
 
+#define KASLR_COMPRESSED_BOOT
+#include "../../lib/kaslr.c"
+
 static unsigned long slots_fetch_random(void)
 {
 	/* Handle case of no slots stored. */
 	if (slot_max == 0)
 		return 0;
 
-	return slots[get_random_long() % slot_max];
+	return slots[kaslr_get_random_boot_long() % slot_max];
 }
 
 static void process_e820_entry(struct e820entry *entry,
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
new file mode 100644
index 0000000..2ae1429
--- /dev/null
+++ b/arch/x86/include/asm/kaslr.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_KASLR_H_
+#define _ASM_KASLR_H_
+
+unsigned long kaslr_get_random_boot_long(void);
+
+#endif
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 72a5767..cfa6d07 100644
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
index 0000000..ffb22ba
--- /dev/null
+++ b/arch/x86/lib/kaslr.c
@@ -0,0 +1,79 @@
+#include <asm/kaslr.h>
+#include <asm/msr.h>
+#include <asm/archrandom.h>
+#include <asm/e820.h>
+#include <asm/io.h>
+
+/* Replace boot functions on library build */
+#ifndef KASLR_COMPRESSED_BOOT
+#include <asm/cpufeature.h>
+#include <asm/setup.h>
+
+#define debug_putstr(v)
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
+unsigned long kaslr_get_random_boot_long(void)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
+	unsigned long raw, random = get_boot_seed();
+	bool use_i8254 = true;
+
+	debug_putstr("KASLR using");
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
2.8.0.rc3.226.g39d4020
