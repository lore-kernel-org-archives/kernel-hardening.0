MIME-Version: 1.0
In-Reply-To: <20170216182917.19637-4-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com> <20170216182917.19637-4-james.morse@arm.com>
From: Keun-O Park <kpark3469@gmail.com>
Date: Fri, 17 Feb 2017 22:09:08 +0400
Message-ID: <CA+KhAHavP2eg4Ci-ZMWo_6-0X9UFoyz2j+tmvxMqyyBwUu9=yQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v4 3/3] arm64/uaccess: Add hardened
 usercopy check for bad stack accesses
To: James Morse <james.morse@arm.com>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

Hello James,

> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index 46da3ea638bb..d3494840a61c 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -356,6 +356,22 @@ do {                                                                       \
>                 -EFAULT;                                                \
>  })
>
> +static inline void check_obj_in_unused_stack(const void *obj, unsigned long len)
> +{
> +       unsigned long stack = (unsigned long)task_stack_page(current);
> +
> +       if (__builtin_constant_p(len) || !IS_ENABLED(CONFIG_HARDENED_USERCOPY) || !len)
> +               return;
> +
> +       /*
> +        * If current_stack_pointer is on the task stack, obj must not lie
> +        * between current_stack_pointer and the last stack address.
> +        */
> +       if ((current_stack_pointer & ~(THREAD_SIZE-1)) == stack)
> +               BUG_ON(stack <= (unsigned long)obj &&
> +                      (unsigned long)obj < current_stack_pointer);
> +}
> +

It looks to me that this function is just doing the similar check that
check_stack_object() may do.
Probably I guess you had a problem in checking the correct fp of
caller's function while you tried to use walk_stackframe().
Anyway, your patch works fine for me.
But, I can not find any reason to create check_obj_in_unused_stack().
Instead of creating check_obj_in_unused_stack(), how about handing
over current_stack_pointer to check_stack_object();
Even though Akashi's case happens, since we hand over correct stack
pointer, it can check if the obj is within the correct stack boundary.

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index d349484..0c21a0d 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -356,22 +356,6 @@ do {
                         \
                -EFAULT;                                                \
 })

-static inline void check_obj_in_unused_stack(const void *obj,
unsigned long len)
-{
-       unsigned long stack = (unsigned long)task_stack_page(current);
-
-       if (__builtin_constant_p(len) ||
!IS_ENABLED(CONFIG_HARDENED_USERCOPY) || !len)
-               return;
-
-       /*
-        * If current_stack_pointer is on the task stack, obj must not lie
-        * between current_stack_pointer and the last stack address.
-        */
-       if ((current_stack_pointer & ~(THREAD_SIZE-1)) == stack)
-               BUG_ON(stack <= (unsigned long)obj &&
-                      (unsigned long)obj < current_stack_pointer);
-}
-
 extern unsigned long __must_check __arch_copy_from_user(void *to,
const void __user *from, unsigned long n);
 extern unsigned long __must_check __arch_copy_to_user(void __user
*to, const void *from, unsigned long n);
 extern unsigned long __must_check __copy_in_user(void __user *to,
const void __user *from, unsigned long n);
@@ -380,16 +364,14 @@ extern unsigned long __must_check
__clear_user(void __user *addr, unsigned long
 static inline unsigned long __must_check __copy_from_user(void *to,
const void __user *from, unsigned long n)
 {
        kasan_check_write(to, n);
-       check_obj_in_unused_stack(to, n);
-       check_object_size(to, n, false);
+       check_object_size(to, n, current_stack_pointer, false);
        return __arch_copy_from_user(to, from, n);
 }

 static inline unsigned long __must_check __copy_to_user(void __user
*to, const void *from, unsigned long n)
 {
        kasan_check_read(from, n);
-       check_obj_in_unused_stack(from, n);
-       check_object_size(from, n, true);
+       check_object_size(from, n, current_stack_pointer, true);
        return __arch_copy_to_user(to, from, n);
 }

@@ -399,8 +381,7 @@ static inline unsigned long __must_check
copy_from_user(void *to, const void __u
        kasan_check_write(to, n);

        if (access_ok(VERIFY_READ, from, n)) {
-               check_obj_in_unused_stack(to, n);
-               check_object_size(to, n, false);
+               check_object_size(to, n, current_stack_pointer, false);
                res = __arch_copy_from_user(to, from, n);
        }
        if (unlikely(res))
@@ -413,8 +394,7 @@ static inline unsigned long __must_check
copy_to_user(void __user *to, const voi
        kasan_check_read(from, n);

        if (access_ok(VERIFY_WRITE, to, n)) {
-               check_obj_in_unused_stack(from, n);
-               check_object_size(from, n, true);
+               check_object_size(from, n, current_stack_pointer, true);
                n = __arch_copy_to_user(to, from, n);
        }
        return n;
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a38b3be..5c676bc 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -94,17 +94,17 @@ static inline enum stack_type
arch_within_stack_frames(const void * const stack,

 #ifdef CONFIG_HARDENED_USERCOPY
 extern void __check_object_size(const void *ptr, unsigned long n,
-                                       bool to_user);
+                               unsigned long sp, bool to_user);

 static __always_inline void check_object_size(const void *ptr, unsigned long n,
-                                             bool to_user)
+                                             unsigned long sp, bool to_user)
 {
        if (!__builtin_constant_p(n))
-               __check_object_size(ptr, n, to_user);
+               __check_object_size(ptr, n, sp, to_user);
 }
 #else
 static inline void check_object_size(const void *ptr, unsigned long n,
-                                    bool to_user)
+                                    unsigned long sp, bool to_user)
 { }
 #endif /* CONFIG_HARDENED_USERCOPY */

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 7e35fc4..4118da4 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -112,7 +112,7 @@ long strncpy_from_user(char *dst, const char
__user *src, long count)
                long retval;

                kasan_check_write(dst, count);
-               check_object_size(dst, count, false);
+               check_object_size(dst, count, current_stack_pointer, false);
                user_access_begin();
                retval = do_strncpy_from_user(dst, src, count, max);
                user_access_end();
diff --git a/mm/usercopy.c b/mm/usercopy.c
index 3531ae7..3739022 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -29,7 +29,8 @@
  *     GOOD_STACK: fully on the stack (when can't do frame-checking)
  *     BAD_STACK: error condition (invalid stack position or bad stack frame)
  */
-static noinline int check_stack_object(const void *obj, unsigned long len)
+static noinline int check_stack_object(const void *obj, unsigned long len,
+                                      unsigned long usercopy_sp)
 {
        const void * const stack = task_stack_page(current);
        const void * const stackend = stack + THREAD_SIZE;
@@ -44,7 +45,7 @@ static noinline int check_stack_object(const void
*obj, unsigned long len)
         * the check above means at least one end is within the stack,
         * so if this check fails, the other end is outside the stack).
         */
-       if (obj < stack || stackend < obj + len)
+       if (obj < usercopy_sp || stackend < obj + len)
                return BAD_STACK;

        /* Check if object is safely within a valid frame. */
@@ -227,7 +229,8 @@ static inline const char *check_heap_object(const
void *ptr, unsigned long n,
  * - known-safe heap or stack object
  * - not in kernel text
  */
-void __check_object_size(const void *ptr, unsigned long n, bool to_user)
+void __check_object_size(const void *ptr, unsigned long n,
+                        unsigned long sp, bool to_user)
 {
        const char *err;

@@ -246,7 +249,7 @@ void __check_object_size(const void *ptr, unsigned
long n, bool to_user)
                goto report;

        /* Check for bad stack object. */
-       switch (check_stack_object(ptr, n)) {
+       switch (check_stack_object(ptr, n, sp)) {
        case NOT_STACK:
                /* Object is not touching the current process stack. */
                break;


Thanks so much for your patches.

BR
Sahara
