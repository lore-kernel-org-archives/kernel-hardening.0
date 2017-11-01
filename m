From: Laura Abbott <labbott@redhat.com>
Date: Wed,  1 Nov 2017 14:36:58 -0700
Message-Id: <20171101213658.11267-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH] lkdtm: Add tests for put_user/get_user
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

{get,put}_user are designed to be 'safe' access and
verify the address passed in whereas __{get,put}_user are
supposed to be 'unsafe'. Add a test to verify this behavior.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
Inspired by the paranoid __{get,put}_user checks for arm64.
---
 drivers/misc/lkdtm.h          |   2 +
 drivers/misc/lkdtm_core.c     |   2 +
 drivers/misc/lkdtm_usercopy.c | 107 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index bfb6c45b6130..c80236198c96 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -81,5 +81,7 @@ void lkdtm_USERCOPY_STACK_FRAME_TO(void);
 void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
+void lkdtm_PUT_USER(void);
+void lkdtm_GET_USER(void);
 
 #endif
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 981b3ef71e47..f0a99ccc2a5a 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -251,6 +251,8 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	CRASHTYPE(PUT_USER),
+	CRASHTYPE(GET_USER),
 };
 
 
diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
index df6ac985fbb5..3a95a85cafdb 100644
--- a/drivers/misc/lkdtm_usercopy.c
+++ b/drivers/misc/lkdtm_usercopy.c
@@ -310,6 +310,113 @@ void lkdtm_USERCOPY_KERNEL(void)
 	vm_munmap(user_addr, PAGE_SIZE);
 }
 
+void lkdtm_PUT_USER(void)
+{
+	unsigned long user_addr;
+	void *kbuf;
+
+	kbuf = kmalloc(cache_size, GFP_KERNEL);
+	if (!kbuf) {
+		pr_warn("failed to allocate kernel buffer\n");
+		return;
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
+	pr_info("attempting valid put_user\n");
+	if (put_user(0x1234567, (unsigned long __user *)user_addr)) {
+		pr_warn("put_user failed unexpectedly?!\n");
+		goto free_user;
+	}
+
+
+	pr_info("attempting valid __put_user\n");
+	if (__put_user(0x1234567, (unsigned long __user *)user_addr)) {
+		pr_warn("__put_user failed unexpectedly?!\n");
+		goto free_user;
+	}
+
+	pr_info("attempting invalid put_user which should fail");
+	if (put_user(0x1234567, (unsigned long *)kbuf)) {
+		pr_warn("put_user failed correctly\n");
+	} else {
+		pr_warn("put_user succeeded unexpectedly\n");
+		goto free_user;
+	}
+
+
+	pr_info("attempting invalid __put_user which should succeed\n");
+	if (__put_user(0x1234567, (unsigned long *)kbuf)) {
+		pr_warn("__put_user failed unexpectedly\n");
+	} else {
+		pr_warn("__put_user succeeded\n");
+	}
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+free_kernel:
+	kfree(kbuf);
+}
+
+void lkdtm_GET_USER(void)
+{
+	unsigned long user_addr;
+	unsigned long a;
+	void *kbuf;
+
+	kbuf = kmalloc(cache_size, GFP_KERNEL);
+	if (!kbuf) {
+		pr_warn("failed to allocate kernel buffer\n");
+		return;
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
+	pr_info("attempting valid get_user\n");
+	if (get_user(a, (unsigned long __user *)user_addr)) {
+		pr_warn("get_user failed unexpectedly?!\n");
+		goto free_user;
+	}
+
+	pr_info("attempting valid __get_user\n");
+	if (__get_user(a, (unsigned long __user *)user_addr)) {
+		pr_warn("__get_user failed unexpectedly?!\n");
+		goto free_user;
+	}
+
+	pr_info("attempting an invalid get_user which should fail\n");
+	if (get_user(a, (unsigned long *)kbuf)) {
+		pr_warn("get_user failed correctly\n");
+	} else {
+		pr_warn("get_user succeeded unexpectedly\n");
+		goto free_user;
+	}
+
+	pr_info("attempting an invalid __get_user which should succeed\n");
+	if (__get_user(a, (unsigned long *)kbuf)) {
+		pr_warn("get_user failed unexpectedly\n");
+	} else {
+		pr_warn("get_user succeeded\n");
+	}
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+free_kernel:
+	kfree(kbuf);
+}
+
 void __init lkdtm_usercopy_init(void)
 {
 	/* Prepare cache that lacks SLAB_USERCOPY flag. */
-- 
2.13.5
