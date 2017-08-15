From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 15 Aug 2017 13:50:39 +0100
Message-Id: <1502801449-29246-5-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 04/14] arm64: factor out PAGE_* and CONT_* definitions
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Some headers rely on PAGE_* definitions from <asm/page.h>, but cannot
include this due to potential circular includes. For example, a number
of definitions in <asm/memory.h> rely on PAGE_SHIFT, and <asm/page.h>
includes <asm/memory.h>.

This requires users of these definitions to include both headers, which
is fragile and error-prone.

This patch ameliorates matters by moving the basic definitions out to a
new header, <asm/page-def.h>. Both <asm/page.h> and <asm/memory.h> are
updated to include this, avoiding this fragility, and avoiding the
possibility of circular include dependencies.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/memory.h   |  1 +
 arch/arm64/include/asm/page-def.h | 34 ++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/page.h     | 12 +-----------
 3 files changed, 36 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm64/include/asm/page-def.h

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 32f827233..77d55dc 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -25,6 +25,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 #include <asm/bug.h>
+#include <asm/page-def.h>
 #include <asm/sizes.h>
 
 /*
diff --git a/arch/arm64/include/asm/page-def.h b/arch/arm64/include/asm/page-def.h
new file mode 100644
index 0000000..01591a2
--- /dev/null
+++ b/arch/arm64/include/asm/page-def.h
@@ -0,0 +1,34 @@
+/*
+ * Based on arch/arm/include/asm/page.h
+ *
+ * Copyright (C) 1995-2003 Russell King
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PAGE_DEF_H
+#define __ASM_PAGE_DEF_H
+
+#include <linux/const.h>
+
+/* PAGE_SHIFT determines the page size */
+/* CONT_SHIFT determines the number of pages which can be tracked together  */
+#define PAGE_SHIFT		CONFIG_ARM64_PAGE_SHIFT
+#define CONT_SHIFT		CONFIG_ARM64_CONT_SHIFT
+#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK		(~(PAGE_SIZE-1))
+
+#define CONT_SIZE		(_AC(1, UL) << (CONT_SHIFT + PAGE_SHIFT))
+#define CONT_MASK		(~(CONT_SIZE-1))
+
+#endif /* __ASM_PAGE_DEF_H */
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 8472c6d..60d02c8 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -19,17 +19,7 @@
 #ifndef __ASM_PAGE_H
 #define __ASM_PAGE_H
 
-#include <linux/const.h>
-
-/* PAGE_SHIFT determines the page size */
-/* CONT_SHIFT determines the number of pages which can be tracked together  */
-#define PAGE_SHIFT		CONFIG_ARM64_PAGE_SHIFT
-#define CONT_SHIFT		CONFIG_ARM64_CONT_SHIFT
-#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
-#define PAGE_MASK		(~(PAGE_SIZE-1))
-
-#define CONT_SIZE		(_AC(1, UL) << (CONT_SHIFT + PAGE_SHIFT))
-#define CONT_MASK		(~(CONT_SIZE-1))
+#include <asm/page-def.h>
 
 #ifndef __ASSEMBLY__
 
-- 
1.9.1
