From: James Morse <james.morse@arm.com>
Date: Thu, 16 Feb 2017 18:29:17 +0000
Message-Id: <20170216182917.19637-4-james.morse@arm.com>
In-Reply-To: <20170216182917.19637-1-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com>
Subject: [kernel-hardening] [PATCH v4 3/3] arm64/uaccess: Add hardened usercopy check for bad stack accesses
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

lkdtm tests copy_{to,from}_user() by trying to copy an address range
on the stack that isn't yet part of a stack frame.

By the time the stack walker is invoked to check that the object being
copied doesn't overlap stack frame, the invalid range is part of a valid
stack frame. Discarding a constant number of frames is fragile as different
compiler versions may make different inline choices.

Instead, add a check that the object isn't between the current stack
pointer and the end of the stack. Add this early enough that it should
be inlined into the caller.

CC: Sahara <keun-o.park@darkmatter.ae>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/uaccess.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 46da3ea638bb..d3494840a61c 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -356,6 +356,22 @@ do {									\
 		-EFAULT;						\
 })
 
+static inline void check_obj_in_unused_stack(const void *obj, unsigned long len)
+{
+	unsigned long stack = (unsigned long)task_stack_page(current);
+
+	if (__builtin_constant_p(len) || !IS_ENABLED(CONFIG_HARDENED_USERCOPY) || !len)
+		return;
+
+	/*
+	 * If current_stack_pointer is on the task stack, obj must not lie
+	 * between current_stack_pointer and the last stack address.
+	 */
+	if ((current_stack_pointer & ~(THREAD_SIZE-1)) == stack)
+		BUG_ON(stack <= (unsigned long)obj &&
+		       (unsigned long)obj < current_stack_pointer);
+}
+
 extern unsigned long __must_check __arch_copy_from_user(void *to, const void __user *from, unsigned long n);
 extern unsigned long __must_check __arch_copy_to_user(void __user *to, const void *from, unsigned long n);
 extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
@@ -364,6 +380,7 @@ extern unsigned long __must_check __clear_user(void __user *addr, unsigned long
 static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	kasan_check_write(to, n);
+	check_obj_in_unused_stack(to, n);
 	check_object_size(to, n, false);
 	return __arch_copy_from_user(to, from, n);
 }
@@ -371,6 +388,7 @@ static inline unsigned long __must_check __copy_from_user(void *to, const void _
 static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	kasan_check_read(from, n);
+	check_obj_in_unused_stack(from, n);
 	check_object_size(from, n, true);
 	return __arch_copy_to_user(to, from, n);
 }
@@ -381,6 +399,7 @@ static inline unsigned long __must_check copy_from_user(void *to, const void __u
 	kasan_check_write(to, n);
 
 	if (access_ok(VERIFY_READ, from, n)) {
+		check_obj_in_unused_stack(to, n);
 		check_object_size(to, n, false);
 		res = __arch_copy_from_user(to, from, n);
 	}
@@ -394,6 +413,7 @@ static inline unsigned long __must_check copy_to_user(void __user *to, const voi
 	kasan_check_read(from, n);
 
 	if (access_ok(VERIFY_WRITE, to, n)) {
+		check_obj_in_unused_stack(from, n);
 		check_object_size(from, n, true);
 		n = __arch_copy_to_user(to, from, n);
 	}
-- 
2.10.1
