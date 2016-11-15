Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 15 Nov 2016 21:59:19 +1100
Message-Id: <1479207559-8510-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [PATCH] lkdtm: Add tests for LIST_POISON and ZERO_SIZE_PTR
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds two tests, to check that a read or write to LIST_POISON1 and
ZERO_SIZE_PTR are blocked.

The default values for both (256 and 16) typically fall in the range
of valid user space addresses. However in general mmap_min_addr is 64K,
which prevents user space from mapping anything at those addresses.

However it's feasible that an attacker will be able to find a way to
cause an access at an offset from either value, and if that offset is
greater than 64K then they can access user space again.

To simulate that case, in the test we create a user mapping at
mmap_min_addr, and offset the pointer by that amount. This gives the
test the greatest chance of failing (ie. an access succeeding).

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/misc/lkdtm.h      |  2 ++
 drivers/misc/lkdtm_bugs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm_core.c |  2 ++
 3 files changed, 48 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index fdf954c2107f..cc207f7824f9 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -21,6 +21,8 @@ void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
 void lkdtm_ATOMIC_UNDERFLOW(void);
 void lkdtm_ATOMIC_OVERFLOW(void);
+void lkdtm_ACCESS_LIST_POISON(void);
+void lkdtm_ACCESS_ZERO_SIZE_PTR(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index 182ae1894b32..35ce9c753b48 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -5,7 +5,10 @@
  * test source files.
  */
 #include "lkdtm.h"
+#include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/slab.h>
 
 /*
  * Make sure our attempts to over run the kernel stack doesn't trigger
@@ -146,3 +149,44 @@ void lkdtm_ATOMIC_OVERFLOW(void)
 	pr_info("attempting bad atomic overflow\n");
 	atomic_inc(&over);
 }
+
+static void test_poison_ptr(void *base, const char *desc)
+{
+	unsigned long *ptr, val, uaddr;
+
+	uaddr = vm_mmap(NULL, mmap_min_addr, PAGE_SIZE, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, 0);
+	if (uaddr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory, can't perform test.\n");
+		return;
+	}
+
+	/*
+	 * Creating a mapping and adding mmap_min_addr to the value is cheating
+	 * in a way. But it simulates the case where an attacker is able to
+	 * cause an access at a small offset from the base value, leading to a
+	 * user space access. If an arch doesn't define CONFIG_ILLEGAL_POINTER_VALUE
+	 * then it's likely this will work in the absence of other protections.
+	 */
+	ptr = mmap_min_addr + base;
+
+	pr_info("attempting read of %s %p\n", desc, ptr);
+	val = *ptr;
+	pr_info("FAIL: Was able to read %s! Got 0x%lx\n", desc, val);
+
+	pr_info("attempting write of %s %p\n", desc, ptr);
+	*ptr = 0xdeadbeefabcd1234;
+	pr_info("FAIL: Was able to write %s! Now = 0x%lx\n", desc, *ptr);
+
+	vm_munmap(uaddr, PAGE_SIZE);
+}
+
+void lkdtm_ACCESS_LIST_POISON(void)
+{
+	test_poison_ptr(LIST_POISON1, "LIST_POISON");
+}
+
+void lkdtm_ACCESS_ZERO_SIZE_PTR(void)
+{
+	test_poison_ptr(ZERO_SIZE_PTR, "ZERO_SIZE_PTR");
+}
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index f9154b8d67f6..025a0ee8d8ee 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -220,6 +220,8 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(WRITE_KERN),
 	CRASHTYPE(ATOMIC_UNDERFLOW),
 	CRASHTYPE(ATOMIC_OVERFLOW),
+	CRASHTYPE(ACCESS_LIST_POISON),
+	CRASHTYPE(ACCESS_ZERO_SIZE_PTR),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
 	CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
-- 
2.7.4
