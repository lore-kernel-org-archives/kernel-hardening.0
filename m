From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:55:24 -0800
Message-ID: <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 02/12] array_idx: sanitize speculative array de-references
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, Cyril Novikov <cnovikov@lynx.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'array_idx' is proposed as a generic mechanism to mitigate against
Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
via speculative execution). The 'array_idx' implementation is expected
to be safe for current generation cpus across multiple architectures
(ARM, x86).

Based on an original implementation by Linus Torvalds, tweaked to remove
speculative flows by Alexei Starovoitov, and tweaked again by Linus to
introduce an x86 assembly implementation for the mask generation.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Co-developed-by: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Cyril Novikov <cnovikov@lynx.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/nospec.h |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 include/linux/nospec.h

diff --git a/include/linux/nospec.h b/include/linux/nospec.h
new file mode 100644
index 000000000000..f59f81889ba3
--- /dev/null
+++ b/include/linux/nospec.h
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#ifndef __NOSPEC_H__
+#define __NOSPEC_H__
+
+/*
+ * When idx is out of bounds (idx >= sz), the sign bit will be set.
+ * Extend the sign bit to all bits and invert, giving a result of zero
+ * for an out of bounds idx, or ~0UL if within bounds [0, sz).
+ */
+#ifndef array_idx_mask
+static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)
+{
+	/*
+	 * Warn developers about inappropriate array_idx usage.
+	 *
+	 * Even if the cpu speculates past the WARN_ONCE branch, the
+	 * sign bit of idx is taken into account when generating the
+	 * mask.
+	 *
+	 * This warning is compiled out when the compiler can infer that
+	 * idx and sz are less than LONG_MAX.
+	 */
+	if (WARN_ONCE(idx > LONG_MAX || sz > LONG_MAX,
+			"array_idx limited to range of [0, LONG_MAX]\n"))
+		return 0;
+
+	/*
+	 * Always calculate and emit the mask even if the compiler
+	 * thinks the mask is not needed. The compiler does not take
+	 * into account the value of idx under speculation.
+	 */
+	OPTIMIZER_HIDE_VAR(idx);
+	return ~(long)(idx | (sz - 1UL - idx)) >> (BITS_PER_LONG - 1);
+}
+#endif
+
+/*
+ * array_idx - sanitize an array index after a bounds check
+ *
+ * For a code sequence like:
+ *
+ *     if (idx < sz) {
+ *         idx = array_idx(idx, sz);
+ *         val = array[idx];
+ *     }
+ *
+ * ...if the cpu speculates past the bounds check then array_idx() will
+ * clamp the index within the range of [0, sz).
+ */
+#define array_idx(idx, sz)						\
+({									\
+	typeof(idx) _i = (idx);						\
+	typeof(sz) _s = (sz);						\
+	unsigned long _mask = array_idx_mask(_i, _s);			\
+									\
+	BUILD_BUG_ON(sizeof(_i) > sizeof(long));			\
+	BUILD_BUG_ON(sizeof(_s) > sizeof(long));			\
+									\
+	_i &= _mask;							\
+	_i;								\
+})
+#endif /* __NOSPEC_H__ */
