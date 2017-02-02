From: kpark3469@gmail.com
Date: Thu,  2 Feb 2017 16:50:24 +0400
Message-Id: <1486039824-8470-3-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1486039824-8470-2-git-send-email-kpark3469@gmail.com>
References: <1486039824-8470-1-git-send-email-kpark3469@gmail.com>
 <1486039824-8470-2-git-send-email-kpark3469@gmail.com>
Subject: [kernel-hardening] [PATCH v2 3/3] lkdtm: add tests for dynamic array in local stack
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This seems an unusual case in kernel. But, when an array is
dynamically created, this variable can be placed ahead of
current frame pointer. This patch tests this dynamic array case.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Suggested-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm_usercopy.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
index 1dd6114..898a323 100644
--- a/drivers/misc/lkdtm_usercopy.c
+++ b/drivers/misc/lkdtm_usercopy.c
@@ -7,6 +7,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mman.h>
 #include <linux/uaccess.h>
+#include <linux/random.h>
 #include <asm/cacheflush.h>
 
 /*
@@ -33,7 +34,14 @@ static noinline unsigned char *trick_compiler(unsigned char *stack)
 
 static noinline unsigned char *do_usercopy_stack_callee(int value)
 {
-	unsigned char buf[32];
+	/*
+	 * buf[128] is big enough to put it in the position ahead of
+	 * check_stack_object()'s frame pointer. Because dynamically allocated
+	 * array can be placed between check_stack_object()'s frame pointer and
+	 * do_usercopy_stack()'s frame pointer, we need an object which exists
+	 * ahead of check_stack_object()'s frame pointer.
+	 */
+	unsigned char buf[128];
 	int i;
 
 	/* Exercise stack to avoid everything living in registers. */
@@ -49,6 +57,7 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 	unsigned long user_addr;
 	unsigned char good_stack[32];
 	unsigned char *bad_stack;
+	unsigned int array_size;
 	int i;
 
 	/* Exercise stack to avoid everything living in registers. */
@@ -72,7 +81,9 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 		return;
 	}
 
+	array_size = get_random_int() & 0x0f;
 	if (to_user) {
+		unsigned char array[array_size];
 		pr_info("attempting good copy_to_user of local stack\n");
 		if (copy_to_user((void __user *)user_addr, good_stack,
 				 unconst + sizeof(good_stack))) {
@@ -80,6 +91,13 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 			goto free_user;
 		}
 
+		pr_info("attempting good copy_to_user of callee stack\n");
+		if (copy_to_user((void __user *)user_addr, array,
+				 unconst + sizeof(array))) {
+			pr_warn("copy_to_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
 		pr_info("attempting bad copy_to_user of distant stack\n");
 		if (copy_to_user((void __user *)user_addr, bad_stack,
 				 unconst + sizeof(good_stack))) {
@@ -87,6 +105,7 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 			goto free_user;
 		}
 	} else {
+		unsigned char array[array_size];
 		/*
 		 * There isn't a safe way to not be protected by usercopy
 		 * if we're going to write to another thread's stack.
@@ -101,6 +120,13 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 			goto free_user;
 		}
 
+		pr_info("attempting good copy_from_user of callee stack\n");
+		if (copy_from_user(array, (void __user *)user_addr,
+				   unconst + sizeof(array))) {
+			pr_warn("copy_from_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
 		pr_info("attempting bad copy_from_user of distant stack\n");
 		if (copy_from_user(bad_stack, (void __user *)user_addr,
 				   unconst + sizeof(good_stack))) {
-- 
2.7.4
