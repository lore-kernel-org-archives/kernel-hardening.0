Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 28 Jun 2011 21:21:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110628172108.GA3156@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] PAX_USERCOPY
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is an initial version of PAX_USERCOPY port on Linux 3.0.

It lacks:

1) white list of allowed slabs (SLAB_USERCOPY).

2) current task termination and stack unrolling on a failed check.
   (I think it will be rejected in upstream anyway).

3) mem/kmem handling.  As they read/write into the raw memory, it should be
   copied to/from temporary buffer before userspace interaction.


The basic tests are passed.  BTW, a stack protector catches the smaller
overflows, however it is bypassable.

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99ddd14..e78057b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -10,6 +10,9 @@
 #include <asm/asm.h>
 #include <asm/page.h>
 
+extern bool slab_access_ok(const void *ptr, unsigned long len);
+extern bool stack_access_ok(const void *ptr, unsigned long len);
+
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
 
@@ -78,6 +81,55 @@
  */
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
+#if defined(CONFIG_FRAME_POINTER)
+/* MUST be always_inline to correctly count stack frame numbers */
+inline static __attribute__((always_inline))
+bool arch_check_object_on_stack_frame(const void *stack,
+	     const void *stackend, const void *obj, unsigned long len)
+{
+	const void *frame = NULL;
+	const void *oldframe;
+
+	/*
+	  low ----------------------------------------------> high
+	  [saved bp][saved ip][args][local vars][saved bp][saved ip]
+			      ^----------------^
+			  allow copies only within here
+	*/
+
+#if 0
+	oldframe = __builtin_frame_address(1);
+	if (oldframe)
+		frame = __builtin_frame_address(2);
+#endif
+
+	/*
+	 * Get the stack_access_ok() caller frame.
+	 * __builtin_frame_address(0) returns stack_access_ok() frame
+	 * as arch_ is inline and stack_ is noinline.
+	 */
+	oldframe = __builtin_frame_address(0);
+	frame = __builtin_frame_address(1);
+
+	/* if obj + len extends past the last frame, this
+	   check won't pass and the next frame will be 0,
+	   causing us to bail out and correctly report
+	   the copy as invalid
+	*/
+	while (stack <= frame && frame < stackend) {
+		if (obj + len <= frame) {
+			if (obj >= oldframe + 2 * sizeof(void *))
+				return true;
+			return false;
+		}
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return false;
+}
+#define arch_check_object_on_stack_frame arch_check_object_on_stack_frame
+#endif
+
 /*
  * The exception table consists of pairs of addresses: the first is the
  * address of an instruction that is allowed to fault, and the second is
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 566e803..9a9df71 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -61,6 +61,10 @@ __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 			return ret;
 		}
 	}
+
+	if (!slab_access_ok(from, n) || !stack_access_ok(from, n))
+		return n;
+
 	return __copy_to_user_ll(to, from, n);
 }
 
@@ -108,6 +112,10 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 			return ret;
 		}
 	}
+
+	if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+		return n;
+
 	return __copy_from_user_ll_nozero(to, from, n);
 }
 
@@ -152,6 +160,10 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 			return ret;
 		}
 	}
+
+	if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+		return n;
+
 	return __copy_from_user_ll(to, from, n);
 }
 
@@ -174,6 +186,10 @@ static __always_inline unsigned long __copy_from_user_nocache(void *to,
 			return ret;
 		}
 	}
+
+	if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+		return n;
+
 	return __copy_from_user_ll_nocache(to, from, n);
 }
 
@@ -181,7 +197,10 @@ static __always_inline unsigned long
 __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 				  unsigned long n)
 {
-       return __copy_from_user_ll_nocache_nozero(to, from, n);
+	if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+		return n;
+
+	return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
 
 unsigned long __must_check copy_to_user(void __user *to,
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 1c66d30..6753a24 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -50,8 +50,11 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	int sz = __compiletime_object_size(to);
 
 	might_fault();
-	if (likely(sz == -1 || sz >= n))
+	if (likely(sz == -1 || sz >= n)) {
+		if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+			return n;
 		n = _copy_from_user(to, from, n);
+	}
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
@@ -64,6 +67,9 @@ int copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	might_fault();
 
+	if (!slab_access_ok(src, size) || !stack_access_ok(src, size))
+		return size;
+	
 	return _copy_to_user(dst, src, size);
 }
 
@@ -73,6 +79,10 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+
+	if (!slab_access_ok(dst, size) || !stack_access_ok(dst, size))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -117,6 +127,10 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+
+	if (!slab_access_ok(src, size) || !stack_access_ok(src, size))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -221,12 +235,18 @@ __must_check unsigned long __clear_user(void __user *mem, unsigned long len);
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
+	if (!slab_access_ok(dst, size) || !stack_access_ok(dst, size))
+		return size;
+
 	return copy_user_generic(dst, (__force const void *)src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
+	if (!slab_access_ok(src, size) || !stack_access_ok(src, size))
+		return size;
+
 	return copy_user_generic((__force void *)dst, src, size);
 }
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b7c2849..699f45b 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -42,6 +42,10 @@ long
 __strncpy_from_user(char *dst, const char __user *src, long count)
 {
 	long res;
+
+	if (!slab_access_ok(dst, count) || !stack_access_ok(dst, count))
+		return count;
+
 	__do_strncpy_from_user(dst, src, count, res);
 	return res;
 }
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index ac68c99..7124db6 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -50,6 +50,15 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
 }
 #endif
 
+#ifndef arch_check_object_on_stack_frame
+static inline bool arch_check_object_on_stack_frame(const void *stack,
+	     const void *stackend, const void *obj, unsigned long len)
+{
+	return true;
+}
+#define arch_check_object_on_stack_frame arch_check_object_on_stack_frame
+#endif /* arch_check_object_on_stack_frame */
+
 /*
  * The exception table consists of pairs of addresses: the first is the
  * address of an instruction that is allowed to fault, and the second is
@@ -99,6 +108,9 @@ static inline __must_check long __copy_from_user(void *to,
 		}
 	}
 
+	if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
+		return n;
+
 	memcpy(to, (const void __force *)from, n);
 	return 0;
 }
@@ -129,6 +141,9 @@ static inline __must_check long __copy_to_user(void __user *to,
 		}
 	}
 
+	if (!slab_access_ok(from, n) || !stack_access_ok(from, n))
+		return n;
+
 	memcpy((void __force *)to, from, n);
 	return 0;
 }
@@ -268,6 +283,10 @@ static inline long
 __strncpy_from_user(char *dst, const char __user *src, long count)
 {
 	char *tmp;
+
+	if (!slab_access_ok(dst, count) || !stack_access_ok(dst, count))
+		return count;
+
 	strncpy(dst, (const char __force *)src, count);
 	for (tmp = dst; *tmp && count > 0; tmp++, count--)
 		;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad4dd1c..8e564bb 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -333,4 +333,13 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 
 void __init kmem_cache_init_late(void);
 
+/*
+ * slab_access_ok() checks whether ptr belongs to the slab cache and whether
+ * it fits in a single allocated area.
+ *
+ * Returns false only if ptr belongs to a slab cache and overflows allocated
+ * slab area.
+ */
+extern bool slab_access_ok(const void *ptr, unsigned long len);
+
 #endif	/* _LINUX_SLAB_H */
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5ca0951..336223b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -108,4 +108,5 @@ extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
+
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/mm/maccess.c b/mm/maccess.c
index 4cee182..0b8f3eb 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -3,6 +3,7 @@
  */
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 
 /**
@@ -60,3 +61,43 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
+
+/*
+ * stack_access_ok() checks whether object is on the stack and
+ * whether it fits in a single stack frame (in case arch allows
+ * to learn this information).
+ *
+ * Returns true in cases:
+ * a) object is not a stack object at all
+ * b) object is located on the stack and fits in a single frame
+ *
+ * MUST be noinline not to confuse arch_check_object_on_stack_frame.
+ */
+bool noinline stack_access_ok(const void *obj, unsigned long len)
+{
+	const void * const stack = task_stack_page(current);
+	const void * const stackend = stack + THREAD_SIZE;
+	bool rc = false;
+
+	/* Does obj+len overflow vm space? */
+	if (unlikely(obj + len < obj))
+		goto exit;
+
+	/* Does [obj; obj+len) at least touch our stack? */
+	if (unlikely(obj + len <= stack || stackend <= obj)) {
+		rc = true;
+		goto exit;
+	}
+
+	/* Does [obj; obj+len) overflow/underflow the stack? */
+	if (unlikely(obj < stack || stackend < obj + len))
+		goto exit;
+
+	rc = arch_check_object_on_stack_frame(stack, stackend, obj, len);
+
+exit:
+	if (!rc)
+		pr_err("stack_access_ok failed (ptr = %p, len = %lu)\n", obj, len);
+	return rc;
+}
+EXPORT_SYMBOL(stack_access_ok);
diff --git a/mm/slab.c b/mm/slab.c
index d96e223..a10ae39 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3843,6 +3843,35 @@ unsigned int kmem_cache_size(struct kmem_cache *cachep)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
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
+	offset = ptr - index_to_obj(cachep, slabp, objnr) - obj_offset(cachep);
+	if (offset <= obj_size(cachep) && len <= obj_size(cachep) - offset)
+		return true;
+
+	pr_err("slab_access_ok failed (addr %p, len %lu)\n", ptr, len);
+	return false;
+}
+EXPORT_SYMBOL(slab_access_ok);
+
 /*
  * This initializes kmem_list3 or resizes various caches for all nodes.
  */
diff --git a/mm/slob.c b/mm/slob.c
index 46e0aee..f02a43b 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -666,6 +666,64 @@ unsigned int kmem_cache_size(struct kmem_cache *c)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
+/*
+ * slab_access_ok() checks whether object is on the slab cache and whether
+ * it fits in a single allocated area.
+ *
+ * Returns true in cases:
+ * a) object is not a slab object
+ * b) object is located in the slab cache and fully fits into the allocated area
+ */
+bool slab_access_ok(const void *ptr, unsigned long len)
+{
+	struct slob_page *sp;
+	const slob_t *pfree;
+	const void *base;
+
+	if (!len)
+		return true;
+	if (!virt_addr_valid(ptr))
+		return true;
+	sp = slob_page(ptr);
+	if (!PageSlab((struct page *)sp))
+		return true;
+
+	if (sp->size) {
+		base = page_address(&sp->page);
+		if (base <= ptr && len <= sp->size - (ptr - base))
+			return true;
+		return false;
+	}
+
+	/* some tricky double walking to find the chunk */
+	base = (void *)((unsigned long)ptr & PAGE_MASK);
+	pfree = sp->free;
+
+	while (!slob_last(pfree) && (void *)free <= ptr) {
+		base = pfree + slob_units(free);
+		pfree = slob_next(free);
+	}
+
+	while (base < (void *)pfree) {
+		slobidx_t m = ((slob_t *)base)[0].units,
+			  align = ((slob_t *)base)[1].units;
+		int size = SLOB_UNIT * SLOB_UNITS(m + align);
+		int offset;
+
+		if (ptr < base + align)
+			return false;
+
+		offset = ptr - base - align;
+		if (offset < m) {
+			if (len <= m - offset)
+				return true;
+			return false;
+		}
+		base += size;
+	}
+}
+EXPORT_SYMBOL(slab_access_ok);
+
 int kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..78af08f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2623,6 +2623,38 @@ unsigned int kmem_cache_size(struct kmem_cache *s)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
+/*
+ * slab_access_ok() checks whether object is on the slab cache and whether
+ * it fits in a single allocated area.
+ *
+ * Returns true in cases:
+ * a) object is not a slab object
+ * b) object is located in the slab cache and fully fits into the allocated area
+ */
+bool slab_access_ok(const void *ptr, unsigned long n)
+{
+	struct page *page;
+	struct kmem_cache *s = NULL;
+	unsigned long offset;
+
+	if (!n)
+		return true;
+	if (!virt_addr_valid(ptr))
+		return true;
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return true;
+
+	s = page->slab;
+	offset = (ptr - page_address(page)) % s->size;
+	if (offset <= s->objsize && n <= s->objsize - offset)
+		return true;
+
+	pr_err("slab_access_ok failed (addr %p, len %lu)\n", ptr, n);
+	return false;
+}
+EXPORT_SYMBOL(slab_access_ok);
+
 static void list_slab_objects(struct kmem_cache *s, struct page *page,
 							const char *text)
 {
---
