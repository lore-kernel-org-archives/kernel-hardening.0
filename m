From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 13:06:09 -0800
Message-ID: <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4.1 02/10] asm/nospec,
 array_ptr: sanitize speculative array de-references
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'array_ptr' is proposed as a generic mechanism to mitigate against
Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
via speculative execution). The 'array_ptr' implementation is expected
to be safe for current generation cpus across multiple architectures
(ARM, x86).

Based on an original implementation by Linus Torvalds, tweaked to remove
speculative flows by Alexei Starovoitov, and tweaked again by Linus to
introduce an x86 assembly implementation for the mask generation.

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Co-developed-by: Alexei Starovoitov <ast@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/nospec.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 include/linux/nospec.h

diff --git a/include/linux/nospec.h b/include/linux/nospec.h
new file mode 100644
index 000000000000..dd3aa05fab87
--- /dev/null
+++ b/include/linux/nospec.h
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#ifndef __NOSPEC_H__
+#define __NOSPEC_H__
+
+#include <linux/jump_label.h>
+#include <asm/barrier.h>
+
+/*
+ * If idx is negative or if idx > size then bit 63 is set in the mask,
+ * and the value of ~(-1L) is zero. When the mask is zero, bounds check
+ * failed, array_ptr will return NULL.
+ */
+#ifndef array_ptr_mask
+static inline unsigned long array_ptr_mask(unsigned long idx, unsigned long sz)
+{
+	return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);
+}
+#endif
+
+/**
+ * array_ptr - Generate a pointer to an array element, ensuring
+ * the pointer is bounded under speculation to NULL.
+ *
+ * @base: the base of the array
+ * @idx: the index of the element, must be less than LONG_MAX
+ * @sz: the number of elements in the array, must be less than LONG_MAX
+ *
+ * If @idx falls in the interval [0, @sz), returns the pointer to
+ * @arr[@idx], otherwise returns NULL.
+ */
+#define array_ptr(base, idx, sz)					\
+({									\
+	union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;	\
+	typeof(*(base)) *_arr = (base);					\
+	unsigned long _i = (idx);					\
+	unsigned long _mask = array_ptr_mask(_i, (sz));			\
+									\
+	__u._ptr = _arr + _i;						\
+	__u._bit &= _mask;						\
+	__u._ptr;							\
+})
+#endif /* __NOSPEC_H__ */
