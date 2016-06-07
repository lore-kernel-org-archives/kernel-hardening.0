Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  7 Jun 2016 14:57:07 -0700
Message-Id: <1465336628-18219-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1465336628-18219-1-git-send-email-keescook@chromium.org>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/5] lkdtm: add usercopy tests
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds test to detect copy_to_user/copy_from_user problems that are
protected by PAX_USERCOPY (and will be protected by HARDENED_USERCOPY).
Explicitly tests both "to" and "from" directions of heap object size
problems, heap object markings and, stack frame misalignment.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm_core.c | 255 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 253 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 187cd9b63e9a..f212f865f9c6 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -111,7 +111,13 @@ enum ctype {
 	CT_WRITE_RO,
 	CT_WRITE_RO_AFTER_INIT,
 	CT_WRITE_KERN,
-	CT_WRAP_ATOMIC
+	CT_WRAP_ATOMIC,
+	CT_USERCOPY_HEAP_SIZE_TO,
+	CT_USERCOPY_HEAP_SIZE_FROM,
+	CT_USERCOPY_HEAP_FLAG_TO,
+	CT_USERCOPY_HEAP_FLAG_FROM,
+	CT_USERCOPY_STACK_FRAME_TO,
+	CT_USERCOPY_STACK_FRAME_FROM,
 };
 
 static char* cp_name[] = {
@@ -154,7 +160,13 @@ static char* cp_type[] = {
 	"WRITE_RO",
 	"WRITE_RO_AFTER_INIT",
 	"WRITE_KERN",
-	"WRAP_ATOMIC"
+	"WRAP_ATOMIC",
+	"USERCOPY_HEAP_SIZE_TO",
+	"USERCOPY_HEAP_SIZE_FROM",
+	"USERCOPY_HEAP_FLAG_TO",
+	"USERCOPY_HEAP_FLAG_FROM",
+	"USERCOPY_STACK_FRAME_TO",
+	"USERCOPY_STACK_FRAME_FROM",
 };
 
 static struct jprobe lkdtm;
@@ -166,6 +178,8 @@ static char* cpoint_name;
 static char* cpoint_type;
 static int cpoint_count = DEFAULT_COUNT;
 static int recur_count = REC_NUM_DEFAULT;
+static int alloc_size = 1024;
+static size_t cache_size;
 
 static enum cname cpoint = CN_INVALID;
 static enum ctype cptype = CT_NONE;
@@ -174,7 +188,9 @@ static DEFINE_SPINLOCK(count_lock);
 static DEFINE_SPINLOCK(lock_me_up);
 
 static u8 data_area[EXEC_SIZE];
+static struct kmem_cache *bad_cache;
 
+static const unsigned char test_text[] = "This is a test.\n";
 static const unsigned long rodata = 0xAA55AA55;
 static unsigned long ro_after_init __ro_after_init = 0x55AA5500;
 
@@ -188,6 +204,9 @@ MODULE_PARM_DESC(cpoint_type, " Crash Point Type, action to be taken on "\
 module_param(cpoint_count, int, 0644);
 MODULE_PARM_DESC(cpoint_count, " Crash Point Count, number of times the "\
 				"crash point is to be hit to trigger action");
+module_param(alloc_size, int, 0644);
+MODULE_PARM_DESC(alloc_size, " Size of allocation for user copy tests "\
+			     "(from 1 to PAGE_SIZE)");
 
 static unsigned int jp_do_irq(unsigned int irq)
 {
@@ -381,6 +400,213 @@ static void execute_user_location(void *dst)
 	func();
 }
 
+static noinline unsigned char *do_usercopy_stack_callee(int value)
+{
+	unsigned char buf[32];
+	unsigned char *ptr = NULL;
+	int i;
+
+	/* Exercise stack to avoid everything living in registers. */
+	for (i = 0; i < sizeof(buf); i++) {
+		/*
+		 * Hack to trick gcc into letting us return a reference
+		 * to a local stack frame.
+		 */
+		if (i == 0)
+			ptr = buf;
+		buf[i] = value & 0xff;
+	}
+
+	return ptr;
+}
+
+static noinline void do_usercopy_stack(bool to_user)
+{
+	unsigned long user_addr;
+	unsigned char good_stack[32];
+	unsigned char *bad_stack;
+	int i;
+
+	/* Exercise stack to avoid everything living in registers. */
+	for (i = 0; i < sizeof(good_stack); i++)
+		good_stack[i] = test_text[i % sizeof(test_text)];
+
+	/* This is a pointer to outside our current stack frame. */
+	bad_stack = do_usercopy_stack_callee(alloc_size);
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		return;
+	}
+
+	if (to_user) {
+		pr_info("attempting good copy_to_user of local stack\n");
+		if (copy_to_user((void __user *)user_addr, good_stack,
+				 sizeof(good_stack))) {
+			pr_warn("copy_to_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_to_user of distant stack\n");
+		if (copy_to_user((void __user *)user_addr, bad_stack,
+				 sizeof(good_stack))) {
+			pr_warn("copy_to_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	} else {
+		pr_info("attempting good copy_from_user of local stack\n");
+		if (copy_from_user(good_stack, (void __user *)user_addr,
+				   sizeof(good_stack))) {
+			pr_warn("copy_from_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_from_user of distant stack\n");
+		if (copy_from_user(bad_stack, (void __user *)user_addr,
+				   sizeof(good_stack))) {
+			pr_warn("copy_from_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	}
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+}
+
+static void do_usercopy_heap_size(bool to_user)
+{
+	unsigned long user_addr;
+	unsigned char *one, *two;
+	size_t size = clamp_t(int, alloc_size, 1, PAGE_SIZE);
+
+	one = kmalloc(size, GFP_KERNEL);
+	two = kmalloc(size, GFP_KERNEL);
+	if (!one || !two) {
+		pr_warn("Failed to allocate kernel memory\n");
+		goto free_kernel;
+	}
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		goto free_kernel;
+	}
+
+	memset(one, 'A', size);
+	memset(two, 'B', size);
+
+	if (to_user) {
+		pr_info("attempting good copy_to_user of correct size\n");
+		if (copy_to_user((void __user *)user_addr, one, size)) {
+			pr_warn("copy_to_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_to_user of too large size\n");
+		if (copy_to_user((void __user *)user_addr, one, 2 * size)) {
+			pr_warn("copy_to_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	} else {
+		pr_info("attempting good copy_from_user of correct size\n");
+		if (copy_from_user(one, (void __user *)user_addr,
+				   size)) {
+			pr_warn("copy_from_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_from_user of too large size\n");
+		if (copy_from_user(one, (void __user *)user_addr, 2 * size)) {
+			pr_warn("copy_from_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	}
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+free_kernel:
+	kfree(one);
+	kfree(two);
+}
+
+static void do_usercopy_heap_flag(bool to_user)
+{
+	unsigned long user_addr;
+	unsigned char *good_buf = NULL;
+	unsigned char *bad_buf = NULL;
+
+	/* Make sure cache was prepared. */
+	if (!bad_cache) {
+		pr_warn("Failed to allocate kernel cache\n");
+		return;
+	}
+
+	/*
+	 * Allocate one buffer from each cache (kmalloc will have the
+	 * SLAB_USERCOPY flag already, but "bad_cache" won't).
+	 */
+	good_buf = kmalloc(cache_size, GFP_KERNEL);
+	bad_buf = kmem_cache_alloc(bad_cache, GFP_KERNEL);
+	if (!good_buf || !bad_buf) {
+		pr_warn("Failed to allocate buffers from caches\n");
+		goto free_alloc;
+	}
+
+	/* Allocate user memory we'll poke at. */
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		goto free_alloc;
+	}
+
+	memset(good_buf, 'A', cache_size);
+	memset(bad_buf, 'B', cache_size);
+
+	if (to_user) {
+		pr_info("attempting good copy_to_user with SLAB_USERCOPY\n");
+		if (copy_to_user((void __user *)user_addr, good_buf,
+				 cache_size)) {
+			pr_warn("copy_to_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_to_user w/o SLAB_USERCOPY\n");
+		if (copy_to_user((void __user *)user_addr, bad_buf,
+				 cache_size)) {
+			pr_warn("copy_to_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	} else {
+		pr_info("attempting good copy_from_user with SLAB_USERCOPY\n");
+		if (copy_from_user(good_buf, (void __user *)user_addr,
+				   cache_size)) {
+			pr_warn("copy_from_user failed unexpectedly?!\n");
+			goto free_user;
+		}
+
+		pr_info("attempting bad copy_from_user w/o SLAB_USERCOPY\n");
+		if (copy_from_user(bad_buf, (void __user *)user_addr,
+				   cache_size)) {
+			pr_warn("copy_from_user failed, but lacked Oops\n");
+			goto free_user;
+		}
+	}
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+free_alloc:
+	if (bad_buf)
+		kmem_cache_free(bad_cache, bad_buf);
+	kfree(good_buf);
+}
+
 static void lkdtm_do_action(enum ctype which)
 {
 	switch (which) {
@@ -679,6 +905,24 @@ static void lkdtm_do_action(enum ctype which)
 
 		return;
 	}
+	case CT_USERCOPY_HEAP_SIZE_TO:
+		do_usercopy_heap_size(true);
+		break;
+	case CT_USERCOPY_HEAP_SIZE_FROM:
+		do_usercopy_heap_size(false);
+		break;
+	case CT_USERCOPY_HEAP_FLAG_TO:
+		do_usercopy_heap_flag(true);
+		break;
+	case CT_USERCOPY_HEAP_FLAG_FROM:
+		do_usercopy_heap_flag(false);
+		break;
+	case CT_USERCOPY_STACK_FRAME_TO:
+		do_usercopy_stack(true);
+		break;
+	case CT_USERCOPY_STACK_FRAME_FROM:
+		do_usercopy_stack(false);
+		break;
 	case CT_NONE:
 	default:
 		break;
@@ -971,6 +1215,11 @@ static int __init lkdtm_module_init(void)
 	/* Make sure we can write to __ro_after_init values during __init */
 	ro_after_init |= 0xAA;
 
+	/* Prepare cache that lacks SLAB_USERCOPY flag. */
+	cache_size = clamp_t(int, alloc_size, 1, PAGE_SIZE);
+	bad_cache = kmem_cache_create("lkdtm-no-usercopy", cache_size, 0,
+				      0, NULL);
+
 	/* Register debugfs interface */
 	lkdtm_debugfs_root = debugfs_create_dir("provoke-crash", NULL);
 	if (!lkdtm_debugfs_root) {
@@ -1022,6 +1271,8 @@ static void __exit lkdtm_module_exit(void)
 {
 	debugfs_remove_recursive(lkdtm_debugfs_root);
 
+	kmem_cache_destroy(bad_cache);
+
 	unregister_jprobe(&lkdtm);
 	pr_info("Crash point unregistered\n");
 }
-- 
2.7.4
