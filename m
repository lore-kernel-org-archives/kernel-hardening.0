Date: Mon, 13 Feb 2017 11:28:30 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170213192830.GA3339@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] usercopy: Adjust tests to deal with SMAP/PAN
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Under SMAP/PAN/etc, we cannot write directly to userspace memory, so
this rearranges the test bytes to get written through copy_to_user().
Additionally fixes a small memory leak on user memory allocation failure,
and drops the bad copy_from_user() test that would trigger a memcpy()
against userspace on failure.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_user_copy.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index 54bd898e356f..ac3a60ba9331 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -49,8 +49,8 @@ static int __init test_user_copy_init(void)
 
 	zerokmem = kzalloc(PAGE_SIZE * 2, GFP_KERNEL);
 	if (!zerokmem) {
-		kfree(kmem);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_kmem;
 	}
 
 	user_addr = vm_mmap(NULL, 0, PAGE_SIZE * 2,
@@ -58,14 +58,16 @@ static int __init test_user_copy_init(void)
 			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
 	if (user_addr >= (unsigned long)(TASK_SIZE)) {
 		pr_warn("Failed to allocate user memory\n");
-		kfree(kmem);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_zerokmem;
 	}
 
 	usermem = (char __user *)user_addr;
 	bad_usermem = (char *)user_addr;
 
-	/* Legitimate usage: none of these should fail. */
+	/*
+	 * Legitimate usage: none of these copies should fail.
+	 */
 	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
 		    "legitimate copy_from_user failed");
 	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
@@ -75,36 +77,53 @@ static int __init test_user_copy_init(void)
 	ret |= test(put_user(value, (unsigned long __user *)usermem),
 		    "legitimate put_user failed");
 
-	/* Invalid usage: none of these should succeed. */
+	/*
+	 * Invalid usage: none of these copies should succeed.
+	 */
+
+	/* Prepare kernel memory with check values. */
 	memset(kmem, 0x5A, PAGE_SIZE);
+	memset(kmem + PAGE_SIZE, 0x5B, PAGE_SIZE);
+
+	/* Reject kernel-to-kernel copies through copy_from_user(). */
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
 				    PAGE_SIZE),
 		    "illegal all-kernel copy_from_user passed");
+
+	/* Destination half of buffer should have been zeroed. */
 	ret |= test(memcmp(zerokmem, kmem, PAGE_SIZE),
 		    "zeroing failure for illegal all-kernel copy_from_user");
-	memset(bad_usermem, 0x5A, PAGE_SIZE);
+
+#if 0
+	/*
+	 * When running with SMAP/PAN/etc, this will Oops the kernel
+	 * due to the zeroing of userspace memory on failure. This needs
+	 * to be tested in LKDTM instead, since this test module does not
+	 * expect to explode.
+	 */
 	ret |= test(!copy_from_user(bad_usermem, (char __user *)kmem,
 				    PAGE_SIZE),
 		    "illegal reversed copy_from_user passed");
-	ret |= test(memcmp(zerokmem, bad_usermem, PAGE_SIZE),
-		    "zeroing failure for illegal reversed copy_from_user");
+#endif
 	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				  PAGE_SIZE),
 		    "illegal all-kernel copy_to_user passed");
 	ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
-	memset(kmem, 0x5A, PAGE_SIZE);
+
+	value = 0x5A;
 	ret |= test(!get_user(value, (unsigned long __user *)kmem),
 		    "illegal get_user passed");
-	ret |= test(memcmp(zerokmem, kmem, sizeof(value)),
-		    "zeroing failure for illegal get_user");
+	ret |= test(value != 0, "zeroing failure for illegal get_user");
 	ret |= test(!put_user(value, (unsigned long __user *)kmem),
 		    "illegal put_user passed");
 
 	vm_munmap(user_addr, PAGE_SIZE * 2);
-	kfree(kmem);
+out_zerokmem:
 	kfree(zerokmem);
+out_kmem:
+	kfree(kmem);
 
 	if (ret == 0) {
 		pr_info("tests passed.\n");
-- 
2.7.4


-- 
Kees Cook
Pixel Security
