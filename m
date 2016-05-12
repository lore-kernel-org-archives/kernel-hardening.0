Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 12 May 2016 09:08:57 -0700
Message-Id: <1463069340-117401-2-git-send-email-thgarnie@google.com>
In-Reply-To: <1463069340-117401-1-git-send-email-thgarnie@google.com>
References: <1463069340-117401-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 1/4] x86, boot: Refactor KASLR entropy functions
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Move the KASLR entropy functions in x86/libray to be used in early
kernel boot for KASLR memory randomization.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160511
---
 arch/x86/boot/compressed/kaslr.c | 77 +++-------------------------------
 arch/x86/include/asm/kaslr.h     |  6 +++
 arch/x86/lib/Makefile            |  1 +
 arch/x86/lib/kaslr.c             | 90 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 72 deletions(-)
 create mode 100644 arch/x86/include/asm/kaslr.h
 create mode 100644 arch/x86/lib/kaslr.c

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index cfeb025..2d8cbd9 100644
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
 
@@ -72,51 +48,6 @@ static unsigned long get_random_boot(void)
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
-
 struct mem_vector {
 	unsigned long start;
 	unsigned long size;
@@ -131,7 +62,6 @@ enum mem_avoid_index {
 };
 
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
-
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
 	/* Item at least partially before region. */
@@ -360,13 +290,16 @@ static void slots_append(unsigned long addr)
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
 
-	return slots[get_random_long("Physical") % slot_max];
+	return slots[kaslr_get_random_long("Physical") % slot_max];
 }
 
 static void process_e820_entry(struct e820entry *entry,
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
new file mode 100644
index 0000000..5547438
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
index 0000000..f7dfeda
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
2.8.0.rc3.226.g39d4020
