Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 Apr 2013 14:54:18 -0700
Message-Id: <1366926860-26776-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-1-git-send-email-keescook@chromium.org>
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/6] x86: kaslr: select random base offset
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Select a random location when CONFIG_RANDOMIZE_BASE is used, bounded
by CONFIG_RANDOMIZE_BASE_MAX_OFFSET. Sources of randomness currently
include RDRAND and RDTSC.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                |   29 +++++++++++++--
 arch/x86/boot/compressed/aslr.c |   75 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6f59afe..78db42d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1700,9 +1700,34 @@ config RELOCATABLE
 	  (CONFIG_PHYSICAL_START) is ignored.
 
 config RANDOMIZE_BASE
-	bool "Enable 64-bit relocation support (for KASLR)"
+	bool "Randomize the address of the kernel image"
 	depends on RELOCATABLE
+	depends on !HIBERNATION
 	default n
+	---help---
+	   Randomizes the physical and virtual address at which the
+	   kernel image is decompressed, as a security feature that
+	   deters exploit attempts relying on knowledge of the location
+	   of kernel internals.
+
+	   Entropy is generated using the RDRAND instruction if it
+	   is supported.  If not, then RDTSC is used, if supported. If
+	   neither RDRAND nor RDTSC are supported, then no randomness
+	   is introduced.
+
+	   The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
+	   and aligned according to PHYSICAL_ALIGN.
+
+config RANDOMIZE_BASE_MAX_OFFSET
+	hex "Maximum ASLR offset allowed"
+	depends on RANDOMIZE_BASE
+	default "0x10000000"
+	range 0x0 0x10000000
+	---help---
+	 Determines the maximal offset in bytes that will be applied to the
+	 kernel when Address Space Layout Randomization (ASLR) is active.
+	 Must be less than or equal to the actual physical memory on the
+	 system. This must be a power of two.
 
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
@@ -1711,7 +1736,7 @@ config X86_NEED_RELOCS
 
 config PHYSICAL_ALIGN
 	hex "Alignment value to which kernel should be aligned"
-	default "0x1000000"
+	default "0x200000"
 	range 0x2000 0x1000000
 	---help---
 	  This value puts the alignment restrictions on physical address
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index d5331ee..11a91c6 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -2,18 +2,89 @@
 
 #ifdef CONFIG_RANDOMIZE_BASE
 
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
+static inline uint32_t rdtsc(void)
+{
+	uint32_t timer;
+
+	asm volatile("rdtsc\n" : "=a" (timer));
+
+	return timer;
+}
+
+static unsigned long get_random_long(void)
+{
+	if (has_cpuflag(X86_FEATURE_RDRAND)) {
+		unsigned long random;
+
+		debug_putstr("KASLR using RDRAND...\n");
+		if (rdrand(&random))
+			return random;
+	}
+
+	if (has_cpuflag(X86_FEATURE_TSC)) {
+		uint32_t raw;
+		unsigned long timer;
+
+		debug_putstr("KASLR using RDTSC...\n");
+		raw = rdtsc();
+
+		/* Repeat the low bits of rdtsc. */
+		timer = raw & 0xffff;
+		timer |= (timer << 16);
+#ifdef CONFIG_X86_64
+		timer |= (timer << 32) | (timer << 48);
+#endif
+
+		return timer;
+	}
+
+	debug_putstr("KASLR found no entropy source...\n");
+	return 0;
+}
+
 unsigned char *choose_kernel_location(unsigned char *hint, unsigned long size)
 {
 	unsigned char *choice = hint;
-	unsigned long random;
+	unsigned long random, mask;
 
 	if (cmdline_find_option_bool("noaslr")) {
 		debug_putstr("KASLR disabled...\n");
 		goto out;
 	}
 
-	/* XXX: choose random location. */
+	random = get_random_long();
+
+	/* Clip off top of the range. */
+	mask = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1;
+	random &= mask;
+
+	/* XXX: Find an appropriate E820 hole, instead of adding hint. */
+	random += (unsigned long)hint;
+
+	/* XXX: Clip to E820 hole, instead of just using hint. */
+	mask = (unsigned long)hint + CONFIG_RANDOMIZE_BASE_MAX_OFFSET;
+	while (random + size > mask)
+		random >>= 1;
+
+	/* Clip off bottom of range (via alignment). */
+	mask = CONFIG_PHYSICAL_ALIGN - 1;
+	random &= ~mask;
 
+	choice = (unsigned char *)random;
 out:
 	return choice;
 }
-- 
1.7.9.5
