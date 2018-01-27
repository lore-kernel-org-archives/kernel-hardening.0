From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:55:18 -0800
Message-ID: <151703971882.26578.14987326469880344294.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 01/12] Documentation: document array_idx
To: tglx@linutronix.de
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, gregkh@linuxfoundation.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Mark Rutland <mark.rutland@arm.com>

Document the rationale and usage of the new array_idx() helper.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/speculation.txt |   87 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/speculation.txt

diff --git a/Documentation/speculation.txt b/Documentation/speculation.txt
new file mode 100644
index 000000000000..308177cab617
--- /dev/null
+++ b/Documentation/speculation.txt
@@ -0,0 +1,87 @@
+This document explains potential effects of speculation, and how undesirable
+effects can be mitigated portably using common APIs.
+
+===========
+Speculation
+===========
+
+To improve performance and minimize average latencies, many contemporary CPUs
+employ speculative execution techniques such as branch prediction, performing
+work which may be discarded at a later stage.
+
+Typically speculative execution cannot be observed from architectural state,
+such as the contents of registers. However, in some cases it is possible to
+observe its impact on microarchitectural state, such as the presence or
+absence of data in caches. Such state may form side-channels which can be
+observed to extract secret information.
+
+For example, in the presence of branch prediction, it is possible for bounds
+checks to be ignored by code which is speculatively executed. Consider the
+following code:
+
+	int load_array(int *array, unsigned int idx)
+	{
+		if (idx >= MAX_ARRAY_ELEMS)
+			return 0;
+		else
+			return array[idx];
+	}
+
+Which, on arm64, may be compiled to an assembly sequence such as:
+
+	CMP	<idx>, #MAX_ARRAY_ELEMS
+	B.LT	less
+	MOV	<returnval>, #0
+	RET
+  less:
+	LDR	<returnval>, [<array>, <idx>]
+	RET
+
+It is possible that a CPU mis-predicts the conditional branch, and
+speculatively loads array[idx], even if idx >= MAX_ARRAY_ELEMS. This value
+will subsequently be discarded, but the speculated load may affect
+microarchitectural state which can be subsequently measured.
+
+More complex sequences involving multiple dependent memory accesses may result
+in sensitive information being leaked. Consider the following code, building
+on the prior example:
+
+	int load_dependent_arrays(int *arr1, int *arr2, int idx)
+	{
+		int val1, val2,
+
+		val1 = load_array(arr1, idx);
+		val2 = load_array(arr2, val1);
+
+		return val2;
+	}
+
+Under speculation, the first call to load_array() may return the value of an
+out-of-bounds address, while the second call will influence microarchitectural
+state dependent on this value. This may provide an arbitrary read primitive.
+
+====================================
+Mitigating speculation side-channels
+====================================
+
+The kernel provides a generic API to ensure that bounds checks are respected
+even under speculation. Architectures which are affected by speculation-based
+side-channels are expected to implement these primitives.
+
+The array_idx() helper in <linux/nospec.h> can be used to prevent
+information from being leaked via side-channels.
+
+A call to array_idx(idx, sz) returns a sanitized index value that is
+bounded to [0, sz) even under cpu speculation conditions.
+
+This can be used to protect the earlier load_array() example:
+
+	int load_array(int *array, unsigned int idx)
+	{
+		if (idx >= MAX_ARRAY_ELEMS)
+			return 0;
+		else {
+			idx = array_idx(idx, MAX_ARRAY_ELEMS);
+			return array[idx];
+		}
+	}
