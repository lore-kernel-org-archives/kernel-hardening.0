Reply-To: kernel-hardening@lists.openwall.com
From: casey.schaufler@intel.com
Date: Thu, 19 May 2016 09:14:12 -0700
Message-Id: <1463674452-13956-1-git-send-email-casey.schaufler@intel.com>
Subject: [kernel-hardening] [PATCH] Subject: [RFC PATCH] mm: Hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: Casey Schaufler <casey.schaufler@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Casey Schaufler <casey.schaufler@intel.com>

This is a work in progress, first stage of porting
the PAX_USERCOPY feature for upstream consumption.
The work isn't complete, but this should provide the
basic structure and initial range checking. There
are known gaps:

	- The SLOB memory allocator does not work
	  on x86, however the grsecurity version does
	  not work there either
	- This is relative to the 4.3.3 kernel, same
	  as the publicly released version of
	  grsecurity that serves as its model.
	- I don't have a good set of test cases.
	  Any pointers would be greatly appreciated.
	  I am not myself especially clever, and the
	  sort of things you have to do to generate
	  exploits do not come naturally to me.

Further, there are questions about the way I've done
the port.

	- The hard usercopy implementation is fully
	  ifdefed, whereas the grsecurity version makes
	  wholesale changes to the base code. I'm open
	  to opinions regarding which would be preferred
	  upstream.
	- In part because of the above, it's possible
	  that I've missed important bits. Reports of
	  glaring ommissions (or sins of commission)
	  are always welcome.
	- Attestation. How best to ensure the the original
	  authors get what they deserve.

This is definitely RFC territory. Please C away.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 arch/arm/include/asm/uaccess.h      |   6 ++
 arch/ia64/include/asm/uaccess.h     |  25 +++++++
 arch/powerpc/include/asm/uaccess.h  |  35 ++++++++++
 arch/sparc/include/asm/uaccess_32.h |  20 ++++++
 arch/sparc/include/asm/uaccess_64.h |  19 ++++++
 arch/x86/include/asm/uaccess_32.h   |   6 ++
 arch/x86/include/asm/uaccess_64.h   |   3 +
 fs/cifs/cifsfs.c                    |  13 ++++
 fs/dcache.c                         |   5 ++
 fs/exec.c                           | 125 +++++++++++++++++++++++++++++++++++
 fs/jfs/super.c                      |   7 ++
 fs/seq_file.c                       |   5 ++
 include/linux/gfp.h                 |  15 +++++
 include/linux/sched.h               |   3 +
 include/linux/slab.h                |  11 ++++
 include/linux/thread_info.h         |  11 ++++
 ipc/msgutil.c                       |   8 +++
 kernel/fork.c                       |   5 ++
 mm/slab.c                           |  39 +++++++++++
 mm/slab.h                           |   6 ++
 mm/slab_common.c                    |  42 ++++++++++++
 mm/slob.c                           | 126 ++++++++++++++++++++++++++++++++++++
 mm/slub.c                           |  42 ++++++++++++
 net/decnet/af_decnet.c              |   3 +
 security/Kconfig                    |  15 +++++
 virt/kvm/kvm_main.c                 |   5 ++
 26 files changed, 600 insertions(+)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 8cc85a4..dcb71c4 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -497,6 +497,9 @@ static inline unsigned long __must_check
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned int __ua_flags = uaccess_save_and_enable();
+#ifdef CONFIG_HARDUSERCOPY
+	check_object_size(to, n, false);
+#endif
 	n = arm_copy_from_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
@@ -511,6 +514,9 @@ static inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	unsigned int __ua_flags = uaccess_save_and_enable();
+#ifdef CONFIG_HARDUSERCOPY
+	check_object_size(to, n, false);
+#endif
 	n = arm_copy_to_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 4f3fb6cc..e5ddd11 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -241,12 +241,21 @@ extern unsigned long __must_check __copy_user (void __user *to, const void __use
 static inline unsigned long
 __copy_to_user (void __user *to, const void *from, unsigned long count)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(count))
+		check_object_size(from, count, true);
+#endif
+
 	return __copy_user(to, (__force void __user *) from, count);
 }
 
 static inline unsigned long
 __copy_from_user (void *to, const void __user *from, unsigned long count)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(count))
+		check_object_size(from, count, true);
+#endif
 	return __copy_user((__force void __user *) to, from, count);
 }
 
@@ -258,8 +267,16 @@ __copy_from_user (void *to, const void __user *from, unsigned long count)
 	const void *__cu_from = (from);							\
 	long __cu_len = (n);								\
 											\
+#ifdef CONFIG_HARDUSERCOPY								\
+	if (__access_ok(__cu_from, __cu_len, get_fs())) {				\
+		if (!__builtin_constant_p(n))						\
+			check_object_size(__cu_from, __cu_len, true);			\
+		__cu_len = __copy_user((__force void __user *) __cu_to, __cu_from, __cu_len);	\
+	}										\
+#else											\
 	if (__access_ok(__cu_to, __cu_len, get_fs()))					\
 		__cu_len = __copy_user(__cu_to, (__force void __user *) __cu_from, __cu_len);	\
+#endif											\
 	__cu_len;									\
 })
 
@@ -270,8 +287,16 @@ __copy_from_user (void *to, const void __user *from, unsigned long count)
 	long __cu_len = (n);								\
 											\
 	__chk_user_ptr(__cu_from);							\
+#ifdef CONFIG_HARDUSERCOPY								\
+	if (__access_ok(__cu_from, __cu_len, get_fs())) {				\
+		if (!__builtin_constant_p(n))						\
+			check_object_size(__cu_to, __cu_len, false);			\
+		__cu_len = __copy_user((__force void __user *) __cu_to, __cu_from, __cu_len);	\
+	}										\
+#else											\
 	if (__access_ok(__cu_from, __cu_len, get_fs()))					\
 		__cu_len = __copy_user((__force void __user *) __cu_to, __cu_from, __cu_len);	\
+#endif											\
 	__cu_len;									\
 })
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 2a8ebae..08f83c9 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -325,10 +325,22 @@ static inline unsigned long copy_from_user(void *to,
 {
 	unsigned long over;
 
+#ifdef CONFIG_HARDUSERCOPY
+	if (access_ok(VERIFY_READ, from, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(to, n, false);
+		return __copy_tofrom_user((__force void __user *)to, from, n);
+	}
+#else
 	if (access_ok(VERIFY_READ, from, n))
 		return __copy_tofrom_user((__force void __user *)to, from, n);
+#endif
 	if ((unsigned long)from < TASK_SIZE) {
 		over = (unsigned long)from + n - TASK_SIZE;
+#ifdef CONFIG_HARDUSERCOPY
+		if (!__builtin_constant_p(n - over))
+			check_object_size(to, n - over, false);
+#endif
 		return __copy_tofrom_user((__force void __user *)to, from,
 				n - over) + over;
 	}
@@ -340,10 +352,22 @@ static inline unsigned long copy_to_user(void __user *to,
 {
 	unsigned long over;
 
+#ifdef CONFIG_HARDUSERCOPY
+	if (access_ok(VERIFY_WRITE, to, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n, true);
+		return __copy_tofrom_user(to, (__force void __user *)from, n);
+	}
+#else
 	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_tofrom_user(to, (__force void __user *)from, n);
+#endif
 	if ((unsigned long)to < TASK_SIZE) {
 		over = (unsigned long)to + n - TASK_SIZE;
+#ifdef CONFIG_HARDUSERCOPY
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n - over, true);
+#endif
 		return __copy_tofrom_user(to, (__force void __user *)from,
 				n - over) + over;
 	}
@@ -387,6 +411,12 @@ static inline unsigned long __copy_from_user_inatomic(void *to,
 		if (ret == 0)
 			return 0;
 	}
+
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(n))
+		check_object_size(to, n, false);
+#endif
+
 	return __copy_tofrom_user((__force void __user *)to, from, n);
 }
 
@@ -413,6 +443,11 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
 		if (ret == 0)
 			return 0;
 	}
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(n))
+		check_object_size(from, n, true);
+#endif
+
 	return __copy_tofrom_user(to, (__force const void __user *)from, n);
 }
 
diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index 64ee103..a8c10ad 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -313,22 +313,42 @@ unsigned long __copy_user(void __user *to, const void __user *from, unsigned lon
 
 static inline unsigned long copy_to_user(void __user *to, const void *from, unsigned long n)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	if (n && __access_ok((unsigned long) to, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(from, n, true);
+		return __copy_user(to, (__force void __user *) from, n);
+	} else
+#else
 	if (n && __access_ok((unsigned long) to, n))
 		return __copy_user(to, (__force void __user *) from, n);
 	else
+#endif
 		return n;
 }
 
 static inline unsigned long __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(n))
+		check_object_size(from, n, true);
+#endif
 	return __copy_user(to, (__force void __user *) from, n);
 }
 
 static inline unsigned long copy_from_user(void *to, const void __user *from, unsigned long n)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	if (n && __access_ok((unsigned long) from, n)) {
+		if (!__builtin_constant_p(n))
+			check_object_size(to, n, false);
+		return __copy_user((__force void __user *) to, from, n);
+	} else
+#else
 	if (n && __access_ok((unsigned long) from, n))
 		return __copy_user((__force void __user *) to, from, n);
 	else
+#endif
 		return n;
 }
 
diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index ea6e9a2..58d5e0a 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -250,8 +250,18 @@ unsigned long copy_from_user_fixup(void *to, const void __user *from,
 static inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long size)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	unsigned long ret;
+#else
 	unsigned long ret = ___copy_from_user(to, from, size);
+#endif
+
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(size))
+		check_object_size(to, size, false);
 
+	ret = ___copy_from_user(to, from, size);
+#endif
 	if (unlikely(ret))
 		ret = copy_from_user_fixup(to, from, size);
 
@@ -267,8 +277,17 @@ unsigned long copy_to_user_fixup(void __user *to, const void *from,
 static inline unsigned long __must_check
 copy_to_user(void __user *to, const void *from, unsigned long size)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	unsigned long ret;
+#else
 	unsigned long ret = ___copy_to_user(to, from, size);
+#endif
 
+#ifdef CONFIG_HARDUSERCOPY
+	if (!__builtin_constant_p(size))
+		check_object_size(from, size, true);
+	ret = ___copy_to_user(to, from, size);
+#endif
 	if (unlikely(ret))
 		ret = copy_to_user_fixup(to, from, size);
 	return ret;
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index f5dcb52..8b6a3b6 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -43,6 +43,9 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
 static __always_inline unsigned long __must_check
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+#ifdef CONFIG_HARDUSERCOPY
+	check_object_size(from, n, true);
+#endif
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -143,6 +146,9 @@ static __always_inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	might_fault();
+#ifdef CONFIG_HARDUSERCOPY
+	check_object_size(to, n, false);
+#endif
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index f2f9b39..673dcef 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -53,6 +53,9 @@ int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
+#ifdef CONFIG_HARDUSERCOPY
+	check_object_size(dst, size, false);
+#endif
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e739950..cf3133e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1083,9 +1083,16 @@ cifs_init_request_bufs(void)
 	cifs_dbg(VFS, "CIFSMaxBufSize %d 0x%x\n",
 		 CIFSMaxBufSize, CIFSMaxBufSize);
 */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	cifs_req_cachep = kmem_cache_create("cifs_request",
+					    CIFSMaxBufSize + max_hdr_size, 0,
+					    SLAB_HWCACHE_ALIGN|SLAB_USERCOPY,
+					    NULL);
+#else
 	cifs_req_cachep = kmem_cache_create("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
+#endif
 	if (cifs_req_cachep == NULL)
 		return -ENOMEM;
 
@@ -1111,9 +1118,15 @@ cifs_init_request_bufs(void)
 	more SMBs to use small buffer alloc and is still much more
 	efficient to alloc 1 per page off the slab compared to 17K (5page)
 	alloc of large cifs buffers even when page debugging is on */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	cifs_sm_req_cachep = kmem_cache_create("cifs_small_rq",
+			MAX_CIFS_SMALL_BUFFER_SIZE, 0,
+			SLAB_USERCOPY | SLAB_HWCACHE_ALIGN, NULL);
+#else
 	cifs_sm_req_cachep = kmem_cache_create("cifs_small_rq",
 			MAX_CIFS_SMALL_BUFFER_SIZE, 0, SLAB_HWCACHE_ALIGN,
 			NULL);
+#endif
 	if (cifs_sm_req_cachep == NULL) {
 		mempool_destroy(cifs_req_poolp);
 		kmem_cache_destroy(cifs_req_cachep);
diff --git a/fs/dcache.c b/fs/dcache.c
index 5c33aeb..f6e0f58 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3450,8 +3450,13 @@ void __init vfs_caches_init_early(void)
 
 void __init vfs_caches_init(void)
 {
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_USERCOPY, NULL);
+#else /* CONFIG_HARDUSERCOPY_SLABS */
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 
 	dcache_init();
 	inode_init();
diff --git a/fs/exec.c b/fs/exec.c
index b06623a..0e67eb2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1749,3 +1749,128 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 				  argv, envp, flags);
 }
 #endif
+
+#ifdef CONFIG_HARDUSERCOPY
+/*
+ *	0: not at all,
+ *	1: fully,
+ *	2: fully inside frame,
+ *	-1: partially (implies an error)
+ */
+static noinline int check_stack_object(const void *obj, unsigned long len)
+{
+	const void * const stack = task_stack_page(current);
+	const void * const stackend = stack + THREAD_SIZE;
+
+#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
+	const void *frame = NULL;
+	const void *oldframe;
+#endif
+
+	if (obj + len < obj)
+		return -1;
+
+	if (obj + len <= stack || stackend <= obj)
+		return 0;
+
+	if (obj < stack || stackend < obj + len)
+		return -1;
+
+#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
+	oldframe = __builtin_frame_address(1);
+	if (oldframe)
+		frame = __builtin_frame_address(2);
+	/*
+	  low ----------------------------------------------> high
+	  [saved bp][saved ip][args][local vars][saved bp][saved ip]
+			      ^----------------^
+			  allow copies only within here
+	*/
+	while (stack <= frame && frame < stackend) {
+		/* if obj + len extends past the last frame, this
+		   check won't pass and the next frame will be 0,
+		   causing us to bail out and correctly report
+		   the copy as invalid
+		*/
+		if (obj + len <= frame)
+			return obj >= oldframe + 2 * sizeof(void *) ? 2 : -1;
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return -1;
+#else
+	return 1;
+#endif
+}
+
+static inline void gr_handle_kernel_exploit(void) {}
+
+static __noreturn void report_hardusercopy(const void *ptr, unsigned long len,
+						bool to_user, const char *type)
+{
+	if (current->signal->curr_ip)
+		printk(KERN_EMERG "Hard user copy: From %pI4: kernel memory %s attempt detected %s %p (%s) (%lu bytes)\n",
+			&current->signal->curr_ip, to_user ? "leak" : "overwrite", to_user ? "from" : "to", ptr, type ? : "unknown", len);
+	else
+		printk(KERN_EMERG "Hard user copy: kernel memory %s attempt detected %s %p (%s) (%lu bytes)\n",
+			to_user ? "leak" : "overwrite", to_user ? "from" : "to", ptr, type ? : "unknown", len);
+	dump_stack();
+	gr_handle_kernel_exploit();
+	do_group_exit(SIGKILL);
+}
+
+static inline bool check_kernel_text_object(unsigned long low,
+						unsigned long high)
+{
+	unsigned long textlow = (unsigned long)_stext;
+	unsigned long texthigh = (unsigned long)_etext;
+
+#ifdef CONFIG_X86_64
+	/* check against linear mapping as well */
+	if (high > (unsigned long)__va(__pa(textlow)) &&
+	    low < (unsigned long)__va(__pa(texthigh)))
+		return true;
+#endif
+
+	if (high <= textlow || low >= texthigh)
+		return false;
+	else
+		return true;
+}
+
+void __check_object_size(const void *ptr, unsigned long n, bool to_user,
+				bool const_size)
+{
+	const char *type;
+
+#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_X86_64)
+	unsigned long stackstart = (unsigned long)task_stack_page(current);
+	unsigned long currentsp = (unsigned long)&stackstart;
+	if (unlikely((currentsp < stackstart + 512 ||
+		     currentsp >= stackstart + THREAD_SIZE) && !in_interrupt()))
+		BUG();
+#endif
+
+	if (!n)
+		return;
+
+	type = check_heap_object(ptr, n);
+	if (!type) {
+		int ret = check_stack_object(ptr, n);
+		if (ret == 1 || ret == 2)
+			return;
+		if (ret == 0) {
+			if (check_kernel_text_object((unsigned long)ptr,
+						(unsigned long)ptr + n))
+				type = "<kernel text>";
+			else
+				return;
+		} else
+			type = "<process stack>";
+	}
+
+	report_hardusercopy(ptr, n, to_user, type);
+
+}
+EXPORT_SYMBOL(__check_object_size);
+#endif /* CONFIG_HARDUSERCOPY */
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 4cd9798..493668e 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -899,10 +899,17 @@ static int __init init_jfs_fs(void)
 	int i;
 	int rc;
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	jfs_inode_cachep =
+	    kmem_cache_create("jfs_ip", sizeof(struct jfs_inode_info), 0,
+			    SLAB_USERCOPY|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			    init_once);
+#else
 	jfs_inode_cachep =
 	    kmem_cache_create("jfs_ip", sizeof(struct jfs_inode_info), 0,
 			    SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
 			    init_once);
+#endif
 	if (jfs_inode_cachep == NULL)
 		return -ENOMEM;
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 225586e..a468a16 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -30,7 +30,12 @@ static void *seq_buf_alloc(unsigned long size)
 	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
 	 * it's better to fall back to vmalloc() than to kill things.
 	 */
+#ifdef CONFIG_HARDUSERCOPY
+	buf = kmalloc(size, GFP_KERNEL | GFP_USERCOPY | __GFP_NORETRY |
+				__GFP_NOWARN);
+#else
 	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+#endif
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
 	return buf;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f92cbd2..5807645 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -35,6 +35,10 @@ struct vm_area_struct;
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define ___GFP_USERCOPY         0x2000000u
+#endif
+
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -97,6 +101,9 @@ struct vm_area_struct;
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define __GFP_USERCOPY	((__force gfp_t)___GFP_USERCOPY)/* Allocator intends to copy page to/from userland */
+#endif
 
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
@@ -104,7 +111,11 @@ struct vm_area_struct;
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
+#else
 #define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
+#endif
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
@@ -149,6 +160,10 @@ struct vm_area_struct;
 /* 4GB DMA on some platforms */
 #define GFP_DMA32	__GFP_DMA32
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define GFP_USERCOPY         __GFP_USERCOPY
+#endif
+
 /* Convert GFP flags to their corresponding migrate type */
 static inline int gfpflags_to_migratetype(const gfp_t gfp_flags)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b7b9501..048eea8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -757,6 +757,9 @@ struct signal_struct {
 #ifdef CONFIG_TASKSTATS
 	struct taskstats *stats;
 #endif
+#ifdef CONFIG_HARDUSERCOPY
+	u32 curr_ip;
+#endif
 #ifdef CONFIG_AUDIT
 	unsigned audit_tty;
 	unsigned audit_tty_log_passwd;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7e37d44..b6d311c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -21,6 +21,9 @@
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define SLAB_USERCOPY           0x00000200UL    /* HARD: Allow copying objs to/from userland */
+#endif
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
@@ -144,6 +147,10 @@ void kfree(const void *);
 void kzfree(const void *);
 size_t ksize(const void *);
 
+#ifdef CONFIG_HARDUSERCOPY
+const char *check_heap_object(const void *ptr, unsigned long n);
+#endif
+
 /*
  * Some archs want to perform DMA into kmalloc caches and need a guaranteed
  * alignment larger than the alignment of a 64-bit integer.
@@ -235,6 +242,10 @@ extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+extern struct kmem_cache *kmalloc_usercopy_caches[KMALLOC_SHIFT_HIGH + 1];
+#endif
+
 /*
  * Figure out which kmalloc slab an allocation of a certain size
  * belongs to.
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index ff307b5..3449364 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -145,6 +145,17 @@ static inline bool test_and_clear_restore_sigmask(void)
 #error "no set_restore_sigmask() provided and default one won't work"
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY
+extern void __check_object_size(const void *ptr, unsigned long n,
+					bool to_user, bool const_size);
+
+static inline void check_object_size(const void *ptr, unsigned long n,
+					bool to_user)
+{
+	__check_object_size(ptr, n, to_user, __builtin_constant_p(n));
+}
+#endif /* CONFIG_HARDUSERCOPY */
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 71f448e..818bdd3 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -55,7 +55,11 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
+#ifdef CONFIG_HARDUSERCOPY
+	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL|GFP_USERCOPY);
+#else
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
+#endif
 	if (msg == NULL)
 		return NULL;
 
@@ -67,7 +71,11 @@ static struct msg_msg *alloc_msg(size_t len)
 	while (len > 0) {
 		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
+#ifdef CONFIG_HARDUSERCOPY
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL|GFP_USERCOPY);
+#else
 		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+#endif
 		if (seg == NULL)
 			goto out_err;
 		*pseg = seg;
diff --git a/kernel/fork.c b/kernel/fork.c
index 2845623..519d6b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -187,8 +187,13 @@ static void free_thread_info(struct thread_info *ti)
 
 void thread_info_cache_init(void)
 {
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
+					      THREAD_SIZE, SLAB_USERCOPY, NULL);
+#else /* CONFIG_HARDUSERCOPY_SLABS */
 	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
 					      THREAD_SIZE, 0, NULL);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 	BUG_ON(thread_info_cache == NULL);
 }
 # endif
diff --git a/mm/slab.c b/mm/slab.c
index 4fcc5dd..4207a19 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1451,8 +1451,14 @@ void __init kmem_cache_init(void)
 	 * Initialize the caches that provide memory for the  kmem_cache_node
 	 * structures first.  Without this, further allocations will bug.
 	 */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
+				kmalloc_size(INDEX_NODE),
+				SLAB_USERCOPY | ARCH_KMALLOC_FLAGS);
+#else /* CONFIG_HARDUSERCOPY_SLABS */
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
@@ -4238,6 +4244,39 @@ static int __init slab_proc_init(void)
 module_init(slab_proc_init);
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY
+const char *check_heap_object(const void *ptr, unsigned long n)
+{
+	struct page *page;
+	struct kmem_cache *cachep;
+	unsigned int objnr;
+	unsigned long offset;
+
+	if (ZERO_OR_NULL_PTR(ptr))
+		return "<null>";
+
+	if (!virt_addr_valid(ptr))
+		return NULL;
+
+	page = virt_to_head_page(ptr);
+
+	if (!PageSlab(page))
+		return NULL;
+
+	cachep = page->slab_cache;
+	if (!(cachep->flags & SLAB_USERCOPY))
+		return cachep->name;
+
+	objnr = obj_to_index(cachep, page, ptr);
+	BUG_ON(objnr >= cachep->num);
+	offset = ptr - index_to_obj(cachep, page, objnr) - obj_offset(cachep);
+	if (offset <= cachep->object_size && n <= cachep->object_size - offset)
+		return NULL;
+
+	return cachep->name;
+}
+#endif /* CONFIG_HARDUSERCOPY */
+
 /**
  * ksize - get the actual amount of memory allocated for a given object
  * @objp: Pointer to the object
diff --git a/mm/slab.h b/mm/slab.h
index a3a967d..d5307a8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -114,8 +114,14 @@ static inline unsigned long kmem_cache_flags(unsigned long object_size,
 
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+#define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
+			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS | \
+			 SLAB_USERCOPY)
+#else
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
+#endif
 
 #if defined(CONFIG_DEBUG_SLAB)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5ce4fae..655cc17d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -43,7 +43,11 @@ struct kmem_cache *kmem_cache;
  * Merge control. If this is set then no merging of slab caches will occur.
  * (Could be removed. This was introduced to pacify the merge skeptics.)
  */
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+static int slab_nomerge = 1;
+#else
 static int slab_nomerge;
+#endif
 
 static int __init setup_slab_nomerge(char *str)
 {
@@ -741,6 +745,11 @@ struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
 EXPORT_SYMBOL(kmalloc_dma_caches);
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+struct kmem_cache *kmalloc_usercopy_caches[KMALLOC_SHIFT_HIGH + 1];
+EXPORT_SYMBOL(kmalloc_usercopy_caches);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
+
 /*
  * Conversion table for small slabs sizes / 8 to the index in the
  * kmalloc array. This is necessary for slabs < 192 since we have non power
@@ -805,6 +814,11 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 		return kmalloc_dma_caches[index];
 
 #endif
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	if (unlikely((flags & GFP_USERCOPY)))
+		return kmalloc_usercopy_caches[index];
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
+
 	return kmalloc_caches[index];
 }
 
@@ -897,7 +911,11 @@ void __init create_kmalloc_caches(unsigned long flags)
 
 	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		if (!kmalloc_caches[i])
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+			new_kmalloc_cache(i, SLAB_USERCOPY | flags);
+#else
 			new_kmalloc_cache(i, flags);
+#endif
 
 		/*
 		 * Caches that are not of the two-to-the-power-of size.
@@ -905,9 +923,17 @@ void __init create_kmalloc_caches(unsigned long flags)
 		 * earlier power of two caches
 		 */
 		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+			new_kmalloc_cache(1, SLAB_USERCOPY | flags);
+#else
 			new_kmalloc_cache(1, flags);
+#endif
 		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+			new_kmalloc_cache(2, SLAB_USERCOPY | flags);
+#else
 			new_kmalloc_cache(2, flags);
+#endif
 	}
 
 	/* Kmalloc array is now usable */
@@ -928,6 +954,22 @@ void __init create_kmalloc_caches(unsigned long flags)
 		}
 	}
 #endif
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
+		struct kmem_cache *s = kmalloc_caches[i];
+
+		if (s) {
+			int size = kmalloc_size(i);
+			char *n = kasprintf(GFP_NOWAIT,
+				 "usercopy-kmalloc-%d", size);
+
+			BUG_ON(!n);
+			kmalloc_usercopy_caches[i] = create_kmalloc_cache(n,
+				size, SLAB_USERCOPY | flags);
+		}
+        }
+#endif /* CONFIG_HARDUSERCOPY_SLABS*/
+
 }
 #endif /* !CONFIG_SLOB */
 
diff --git a/mm/slob.c b/mm/slob.c
index 0d7e5df..554cc69 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -501,6 +501,67 @@ void kfree(const void *block)
 }
 EXPORT_SYMBOL(kfree);
 
+#ifdef CONFIG_HARDUSERCOPY
+const char *check_heap_object(const void *ptr, unsigned long n)
+{
+	struct page *page;
+	const slob_t *free;
+	const void *base;
+	unsigned long flags;
+
+	if (ZERO_OR_NULL_PTR(ptr))
+		return "<null>";
+
+	if (!virt_addr_valid(ptr))
+		return NULL;
+
+	page = virt_to_head_page(ptr);
+	if (!PageSlab(page))
+		return NULL;
+
+	if (page->private) {
+		base = page;
+		if (base <= ptr && n <= page->private - (ptr - base))
+			return NULL;
+		return "<slob>";
+	}
+
+	/* some tricky double walking to find the chunk */
+	spin_lock_irqsave(&slob_lock, flags);
+	base = (void *)((unsigned long)ptr & PAGE_MASK);
+	free = page->freelist;
+
+	while (!slob_last(free) && (void *)free <= ptr) {
+		base = free + slob_units(free);
+		free = slob_next(free);
+	}
+
+	while (base < (void *)free) {
+		slobidx_t m = ((slob_t *)base)[0].units, align = ((slob_t *)base)[1].units;
+		int size = SLOB_UNIT * SLOB_UNITS(m + align);
+		int offset;
+
+		if (ptr < base + align)
+			break;
+
+		offset = ptr - base - align;
+		if (offset >= m) {
+			base += size;
+			continue;
+		}
+
+		if (n > m - offset)
+			break;
+
+		spin_unlock_irqrestore(&slob_lock, flags);
+		return NULL;
+	}
+
+	spin_unlock_irqrestore(&slob_lock, flags);
+	return "<slob>";
+}
+#endif /* CONFIG_HARDUSERCOPY */
+
 /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t ksize(const void *block)
 {
@@ -532,6 +593,53 @@ int __kmem_cache_create(struct kmem_cache *c, unsigned long flags)
 	return 0;
 }
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+static __always_inline void *
+__do_kmalloc_node_align(size_t size, gfp_t gfp, int node, unsigned long caller, int align)
+{
+	slob_t *m;
+	void *ret = NULL;
+
+	gfp &= gfp_allowed_mask;
+
+	lockdep_trace_alloc(gfp);
+
+	if (size < PAGE_SIZE - align) {
+		if (!size)
+			return ZERO_SIZE_PTR;
+
+		m = slob_alloc(size + align, gfp, align, node);
+
+		if (!m)
+			return NULL;
+		BUILD_BUG_ON(ARCH_KMALLOC_MINALIGN < 2 * SLOB_UNIT);
+		BUILD_BUG_ON(ARCH_SLAB_MINALIGN < 2 * SLOB_UNIT);
+		m[0].units = size;
+		m[1].units = align;
+		ret = (void *)m + align;
+
+		trace_kmalloc_node(caller, ret,
+				   size, size + align, gfp, node);
+	} else {
+		unsigned int order = get_order(size);
+		struct page *page;
+
+		if (likely(order))
+			gfp |= __GFP_COMP;
+		page = slob_new_pages(gfp, order, node);
+		if (page) {
+			ret = page_address(page);
+			page->private = size;
+		}
+
+		trace_kmalloc_node(caller, ret,
+				   size, PAGE_SIZE << order, gfp, node);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
+
 static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
@@ -540,6 +648,10 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	lockdep_trace_alloc(flags);
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	b = __do_kmalloc_node_align(c->size, flags, node, _RET_IP_, c->align);
+#else /* CONFIG_HARDUSERCOPY_SLABS */
+
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
 		trace_kmem_cache_alloc_node(_RET_IP_, b, c->object_size,
@@ -551,6 +663,7 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 					    PAGE_SIZE << get_order(c->size),
 					    flags, node);
 	}
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 
 	if (b && c->ctor)
 		c->ctor(b);
@@ -597,6 +710,15 @@ static void kmem_rcu_free(struct rcu_head *head)
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	int size = c->size;
+
+	if (size + c->align < PAGE_SIZE) {
+		size += c->align;
+		b -= c->align;
+	}
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
+
 	kmemleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
@@ -607,7 +729,11 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	trace_kfree(_RET_IP_, b);
+#else /* CONFIG_HARDUSERCOPY_SLABS */
 	trace_kmem_cache_free(_RET_IP_, b);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index f614b5d..4ed0635 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3475,6 +3475,36 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY
+const char *check_heap_object(const void *ptr, unsigned long n)
+{
+	struct page *page;
+	struct kmem_cache *s;
+	unsigned long offset;
+
+	if (ZERO_OR_NULL_PTR(ptr))
+		return "<null>";
+
+	if (!virt_addr_valid(ptr))
+		return NULL;
+
+	page = virt_to_head_page(ptr);
+
+	if (!PageSlab(page))
+		return NULL;
+
+	s = page->slab_cache;
+	if (!(s->flags & SLAB_USERCOPY))
+		return s->name;
+
+	offset = (ptr - page_address(page)) % s->size;
+	if (offset <= s->object_size && n <= s->object_size - offset)
+		return NULL;
+
+	return s->name;
+}
+#endif /* CONFIG_HARDUSERCOPY */
+
 static size_t __ksize(const void *object)
 {
 	struct page *page;
@@ -4677,6 +4707,14 @@ static ssize_t cache_dma_show(struct kmem_cache *s, char *buf)
 SLAB_ATTR_RO(cache_dma);
 #endif
 
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+static ssize_t usercopy_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_USERCOPY));
+}
+SLAB_ATTR_RO(usercopy);
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
+
 static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DESTROY_BY_RCU));
@@ -5019,6 +5057,9 @@ static struct attribute *slab_attrs[] = {
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	&usercopy_attr.attr,
+#endif /* CONFIG_HARDUSERCOPY_SLABS */
 #ifdef CONFIG_NUMA
 	&remote_node_defrag_ratio_attr.attr,
 #endif
@@ -5284,6 +5325,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
+
 	if (err)
 		goto out;
 
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 675cf94..f8d2803 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -466,6 +466,9 @@ static struct proto dn_proto = {
 	.sysctl_rmem		= sysctl_decnet_rmem,
 	.max_header		= DN_MAX_NSP_DATA_HEADER + 64,
 	.obj_size		= sizeof(struct dn_sock),
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	.slab_flags		= SLAB_USERCOPY,
+#endif
 };
 
 static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gfp, int kern)
diff --git a/security/Kconfig b/security/Kconfig
index e452378..476f203 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -118,6 +118,21 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config HARDUSERCOPY_SLABS
+	bool "Memory set correctly for harden user copy"
+	default n
+	help
+	  Just for debug now.
+	  If you are unsure as to whether this is required, answer N.
+
+config HARDUSERCOPY
+	bool "Harden user copy"
+	select HARDUSERCOPY_SLABS
+	default n
+	help
+	  Just for debug now.
+	  If you are unsure as to whether this is required, answer N.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8db1d93..6d479c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3560,8 +3560,13 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
+#ifdef CONFIG_HARDUSERCOPY_SLABS
+	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
+					   SLAB_USERCOPY, NULL);
+#else
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
 					   0, NULL);
+#endif
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_3;
-- 
2.1.4
