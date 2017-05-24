From: riel@redhat.com
Date: Wed, 24 May 2017 11:57:47 -0400
Message-Id: <20170524155751.424-2-riel@redhat.com>
In-Reply-To: <20170524155751.424-1-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 1/5] random,stackprotect: introduce get_random_canary function
To: linux-kernel@vger.kernel.org
Cc: danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

Introduce the get_random_canary function, which provides a random
unsigned long canary value with the first byte zeroed out on 64
bit architectures, in order to mitigate non-terminated C string
overflows.

The null byte both prevents C string functions from reading the
canary, and from writing it if the canary value were guessed or
obtained through some other means.

Reducing the entropy by 8 bits is acceptable on 64-bit systems,
which will still have 56 bits of entropy left, but not on 32
bit systems, so the "ascii armor" canary is only implemented on
64-bit systems.

Inspired by the "ascii armor" code in the old execshield patches,
and Daniel Micay's linux-hardened tree.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/random.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/random.h b/include/linux/random.h
index ed5c3838780d..1fa0dc880bd7 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -57,6 +57,27 @@ static inline unsigned long get_random_long(void)
 #endif
 }
 
+/*
+ * On 64-bit architectures, protect against non-terminated C string overflows
+ * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
+ */
+#ifdef CONFIG_64BIT
+# ifdef __LITTLE_ENDIAN
+#  define CANARY_MASK 0xffffffffffffff00UL
+# else /* big endian, 64 bits: */
+#  define CANARY_MASK 0x00ffffffffffffffUL
+# endif
+#else /* 32 bits: */
+# define CANARY_MASK 0xffffffffUL
+#endif
+
+static inline unsigned long get_random_canary(void)
+{
+	unsigned long val = get_random_long();
+
+	return val & CANARY_MASK;
+}
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
-- 
2.9.3
