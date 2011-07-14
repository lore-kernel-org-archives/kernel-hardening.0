Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 14 Jul 2011 20:13:09 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110714161309.GA30371@albatros>
References: <20110628172108.GA3156@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628172108.GA3156@albatros>
Subject: [kernel-hardening] PAX_USERCOPY testing
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a version of PAX_USERCOPY I want to send to LKML.  However, the
patch without performance testing would be incomplete.  I have some
syscalls measurements, the worst case is gethostname() with 6-7% penalty
on x86-64 (Intel Core 2 Duo 2Ghz).

If someone is able to test and measure the penalty, especially on x86-32
(I have no such machine available for testing now, unfortunately), it
would be great.  Any comments about what workloads would suffer
more/less than others are appreciated.

BTW, Tested-by: tag is a Good Thing (tm) when proposing a patch ;)

Changes since v1:
* moved all checks to CONFIG_DEBUG_RUNTIME_USER_COPY_CHECKS,
* added fast check if length and/or object length is known at the
  compile time, 
* renamed _nocheck -> _unchecked as there is already put_user_nocheck
  stuff,
* removed some odd tests in rare pathes or when an overflow is unlikely.

The patch is rebased against 3.0-rc7.

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99ddd14..96bad6c 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 #include <asm/asm.h>
 #include <asm/page.h>
+#include <linux/uaccess-check.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -78,6 +79,54 @@
  */
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
+#if defined(CONFIG_FRAME_POINTER)
+/*
+ * MUST be always_inline to correctly count stack frame numbers.
+ *
+ * low ----------------------------------------------> high
+ * [saved bp][saved ip][args][local vars][saved bp][saved ip]
+ *		       ^----------------^
+ *		  allow copies only within here
+*/
+#undef arch_check_object_on_stack_frame
+inline static __attribute__((always_inline))
+bool arch_check_object_on_stack_frame(const void *stack,
+	     const void *stackend, const void *obj, unsigned long len)
+{
+	const void *frame = NULL;
+	const void *oldframe;
+
+	/*
+	 * Get the kernel_access_ok() caller frame.
+	 * __builtin_frame_address(0) returns kernel_access_ok() frame
+	 * as arch_ and stack_ are inline and kernel_ is noinline.
+	 */
+	oldframe = __builtin_frame_address(0);
+	if (oldframe)
+		frame = __builtin_frame_address(1);
+
+	while (stack <= frame && frame < stackend) {
+		/*
+		 * If obj + len extends past the last frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (obj + len <= frame) {
+			/* EBP + EIP */
+			int protected_regs_size = 2*sizeof(void *);
+
+			if (obj >= oldframe + protected_regs_size)
+				return true;
+			return false;
+		}
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return false;
+}
+#endif
+
 /*
  * The exception table consists of pairs of addresses: the first is the
  * address of an instruction that is allowed to fault, and the second is
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 566e803..d48fa9c 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -82,6 +82,8 @@ static __always_inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (!kernel_access_ok(from, n))
+		return n;
 	return __copy_to_user_inatomic(to, from, n);
 }
 
@@ -152,6 +154,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 			return ret;
 		}
 	}
+	if (!kernel_access_ok(to, n))
+		return n;
 	return __copy_from_user_ll(to, from, n);
 }
 
@@ -205,11 +209,30 @@ static inline unsigned long __must_check copy_from_user(void *to,
 {
 	int sz = __compiletime_object_size(to);
 
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
-	else
+	if (likely(sz == -1 || sz >= n)) {
+		if (kernel_access_ok(to, n))
+			n = _copy_from_user(to, from, n);
+	} else {
 		copy_from_user_overflow();
+	}
+
+	return n;
+}
+
+#undef copy_from_user_uncheched
+static inline unsigned long __must_check copy_from_user_uncheched(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	return _copy_from_user(to, from, n);
+}
 
+#undef copy_to_user_uncheched
+static inline unsigned long copy_to_user_unchecked(void __user *to,
+     const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __copy_to_user(to, from, n);
 	return n;
 }
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 1c66d30..10c5a0a 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -50,8 +50,10 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	int sz = __compiletime_object_size(to);
 
 	might_fault();
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
+	if (likely(sz == -1 || sz >= n)) {
+		if (kernel_access_ok(to, n))
+			n = _copy_from_user(to, from, n);
+	}
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
@@ -59,11 +61,33 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	return n;
 }
 
+#undef copy_from_user_unchecked
+static inline unsigned long __must_check copy_from_user_unchecked(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	might_fault();
+
+	return _copy_from_user(to, from, n);
+}
+
 static __always_inline __must_check
 int copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	might_fault();
 
+	if (!kernel_access_ok(src, size))
+		return size;
+
+	return _copy_to_user(dst, src, size);
+}
+
+#undef copy_to_user_unchecked
+static __always_inline __must_check
+int copy_to_user_unchecked(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+
 	return _copy_to_user(dst, src, size);
 }
 
@@ -73,8 +97,12 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+	if (!kernel_access_ok(dst, size))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
+
 	switch (size) {
 	case 1:__get_user_asm(*(u8 *)dst, (u8 __user *)src,
 			      ret, "b", "b", "=q", 1);
@@ -117,8 +145,12 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+	if (!kernel_access_ok(dst, size))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
+
 	switch (size) {
 	case 1:__put_user_asm(*(u8 *)src, (u8 __user *)dst,
 			      ret, "b", "b", "iq", 1);
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e218d5d..e136309 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
 unsigned long
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	if (access_ok(VERIFY_WRITE, to, n))
+	if (access_ok(VERIFY_WRITE, to, n) && kernel_access_ok(from, n))
 		n = __copy_to_user(to, from, n);
 	return n;
 }
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8fc04b4..77c93d4 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -132,7 +132,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 		if (!ptr)
 			return -EFAULT;
 
-		remaining = copy_to_user(buf, ptr, sz);
+		remaining = copy_to_user_unchecked(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
 		if (remaining)
 			return -EFAULT;
@@ -190,7 +190,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 			return -EFAULT;
 		}
 
-		copied = copy_from_user(ptr, buf, sz);
+		copied = copy_from_user_unchecked(ptr, buf, sz);
 		unxlate_dev_mem_ptr(p, ptr);
 		if (copied) {
 			written += sz - copied;
@@ -428,7 +428,7 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			 */
 			kbuf = xlate_dev_kmem_ptr((char *)p);
 
-			if (copy_to_user(buf, kbuf, sz))
+			if (copy_to_user_unchecked(buf, kbuf, sz))
 				return -EFAULT;
 			buf += sz;
 			p += sz;
@@ -498,7 +498,7 @@ static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
 		 */
 		ptr = xlate_dev_kmem_ptr((char *)p);
 
-		copied = copy_from_user(ptr, buf, sz);
+		copied = copy_from_user_unchecked(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
 			if (written)
diff --git a/include/linux/uaccess-check.h b/include/linux/uaccess-check.h
new file mode 100644
index 0000000..5592a3e
--- /dev/null
+++ b/include/linux/uaccess-check.h
@@ -0,0 +1,37 @@
+#ifndef __LINUX_UACCESS_CHECK_H__
+#define __LINUX_UACCESS_CHECK_H__
+
+#ifdef CONFIG_DEBUG_RUNTIME_USER_COPY_CHECKS
+extern bool __kernel_access_ok(const void *ptr, unsigned long len);
+static inline bool kernel_access_ok(const void *ptr, unsigned long len)
+{
+	size_t sz = __compiletime_object_size(ptr);
+
+	if (sz != (size_t)-1) {
+		if (sz >= len)
+			return true;
+		pr_err("kernel_access_ok(static) failed, ptr = %p, length = %lu\n",
+			ptr, len);
+		dump_stack();
+		return false;
+	}
+
+	/* We care about "len" overflows only. */
+	if (__builtin_constant_p(len))
+		return true;
+
+	return __kernel_access_ok(ptr, len);
+}
+#else
+static inline bool kernel_access_ok(const void *ptr, unsigned long len)
+{
+	return true;
+}
+#endif /* CONFIG_DEBUG_RUNTIME_USER_COPY_CHECKS */
+
+#define copy_to_user_unchecked copy_to_user
+#define copy_from_user_unchecked copy_from_user
+
+#define arch_check_object_on_stack_frame(s,se,o,len) true
+
+#endif		/* __LINUX_UACCESS_CHECK_H__ */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..cb4a62a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -679,6 +679,27 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
+config DEBUG_RUNTIME_USER_COPY_CHECKS
+	bool "Runtime copy size checks"
+	default n
+	depends on DEBUG_KERNEL && X86
+	---help---
+	  Enabling this option adds additional runtime checks into copy_from_user()
+	  and similar functions.
+
+	  Specifically, this checking prevents information leaking from the kernel
+	  heap/stack during kernel to userland copies (if the kernel object is
+	  otherwise fully initialized, including padding bytes) and prevents kernel
+	  heap/stack overflows during userland to kernel copies.
+
+          If frame pointers are enabled on x86, this option will also restrict
+          copies into and out of the kernel stack to local variables within a
+          single frame.
+
+	  The option has a performance drawback (up to 7% on small syscalls like
+	  gethostname), so don't turn it on unless you care enough about possible
+	  exploitation of buffer overflows.
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
diff --git a/mm/maccess.c b/mm/maccess.c
index 4cee182..af450b8 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -3,8 +3,11 @@
  */
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 
+extern bool slab_access_ok(const void *ptr, unsigned long len);
+
 /**
  * probe_kernel_read(): safely attempt to read from a location
  * @dst: pointer to the buffer that shall take the data
@@ -60,3 +63,56 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
+
+#ifdef CONFIG_DEBUG_RUNTIME_USER_COPY_CHECKS
+/*
+ * stack_access_ok() checks whether object is on the stack and
+ * whether it fits in a single stack frame (in case arch allows
+ * to learn this information).
+ *
+ * Returns true in cases:
+ * a) object is not a stack object at all
+ * b) object is located on the stack and fits in a single frame
+ *
+ * MUST be inline not to confuse arch_check_object_on_stack_frame.
+ */
+inline static bool __attribute__((always_inline))
+stack_access_ok(const void *obj, unsigned long len)
+{
+	const void * const stack = task_stack_page(current);
+	const void * const stackend = stack + THREAD_SIZE;
+
+	/* Does obj+len overflow vm space? */
+	if (unlikely(obj + len < obj))
+		return false;
+
+	/* Does [obj; obj+len) at least touch our stack? */
+	if (unlikely(obj + len <= stack || stackend <= obj))
+		return true;
+
+	/* Does [obj; obj+len) overflow/underflow the stack? */
+	if (unlikely(obj < stack || stackend < obj + len))
+		return false;
+
+	return arch_check_object_on_stack_frame(stack, stackend, obj, len);
+}
+
+noinline bool __kernel_access_ok(const void *ptr, unsigned long len)
+{
+	if (!slab_access_ok(ptr, len)) {
+		pr_err("slab_access_ok failed, ptr = %p, length = %lu\n",
+			ptr, len);
+		dump_stack();
+		return false;
+	}
+	if (!stack_access_ok(ptr, len)) {
+		pr_err("stack_access_ok failed, ptr = %p, length = %lu\n",
+			ptr, len);
+		dump_stack();
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__kernel_access_ok);
+#endif /* CONFIG_DEBUG_RUNTIME_USER_COPY_CHECKS */
diff --git a/mm/slab.c b/mm/slab.c
index d96e223..60e062c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3844,6 +3844,40 @@ unsigned int kmem_cache_size(struct kmem_cache *cachep)
 EXPORT_SYMBOL(kmem_cache_size);
 
 /*
+ * Returns false if and only if [ptr; ptr+len) touches the slab,
+ * but breaks objects boundaries.  It doesn't check whether the
+ * accessed object is actually allocated.
+ */
+bool slab_access_ok(const void *ptr, unsigned long len)
+{
+	struct page *page;
+	struct kmem_cache *cachep = NULL;
+	struct slab *slabp;
+	unsigned int objnr;
+	unsigned long offset;
+
+	if (!len)
+		return true;
+	if (!virt_addr_valid(ptr))
+		return true;
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return true;
+
+	cachep = page_get_cache(page);
+	slabp = page_get_slab(page);
+	objnr = obj_to_index(cachep, slabp, (void *)ptr);
+	BUG_ON(objnr >= cachep->num);
+	offset = (const char *)ptr - obj_offset(cachep) -
+	    (const char *)index_to_obj(cachep, slabp, objnr);
+	if (offset <= obj_size(cachep) && len <= obj_size(cachep) - offset)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(slab_access_ok);
+
+/*
  * This initializes kmem_list3 or resizes various caches for all nodes.
  */
 static int alloc_kmemlist(struct kmem_cache *cachep, gfp_t gfp)
diff --git a/mm/slob.c b/mm/slob.c
index 46e0aee..2d9bb2b 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -666,6 +666,16 @@ unsigned int kmem_cache_size(struct kmem_cache *c)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
+bool slab_access_ok(const void *ptr, unsigned long len)
+{
+	/*
+	 * TODO: is it worth checking?  We have to gain a lock and
+	 * walk through all chunks.
+	 */
+	return true;
+}
+EXPORT_SYMBOL(slab_access_ok);
+
 int kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..be64e77 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2623,6 +2623,34 @@ unsigned int kmem_cache_size(struct kmem_cache *s)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
+/*
+ * Returns false if and only if [ptr; ptr+len) touches the slab,
+ * but breaks objects boundaries.  It doesn't check whether the
+ * accessed object is actually allocated.
+ */
+bool slab_access_ok(const void *ptr, unsigned long len)
+{
+	struct page *page;
+	struct kmem_cache *s = NULL;
+	unsigned long offset;
+
+	if (len == 0)
+		return true;
+	if (!virt_addr_valid(ptr))
+		return true;
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return true;
+
+	s = page->slab;
+	offset = ((const char *)ptr - (const char *)page_address(page)) % s->size;
+	if (offset <= s->objsize && len <= s->objsize - offset)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(slab_access_ok);
+
 static void list_slab_objects(struct kmem_cache *s, struct page *page,
 							const char *text)
 {
-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
