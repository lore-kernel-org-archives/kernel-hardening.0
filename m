Date: Mon, 27 Aug 2018 20:56:31 +0200
In-Reply-To: <20180827185631.163506-1-jannh@google.com>
Message-Id: <20180827185631.163506-8-jannh@google.com>
Mime-Version: 1.0
References: <20180827185631.163506-1-jannh@google.com>
Subject: [PATCH v2 7/7] lkdtm: test copy_to_user() on bad kernel pointer under KERNEL_DS
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Test whether the kernel WARN()s when, under KERNEL_DS, a bad kernel pointer
is used as "userspace" pointer. Should normally be used in "DIRECT" mode.

Signed-off-by: Jann Horn <jannh@google.com>
---
 drivers/misc/lkdtm/core.c     |  1 +
 drivers/misc/lkdtm/lkdtm.h    |  1 +
 drivers/misc/lkdtm/usercopy.c | 13 +++++++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 2154d1bfd18b..5a755590d3dc 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -183,6 +183,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	CRASHTYPE(USERCOPY_KERNEL_DS),
 };
 
 
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 9e513dcfd809..07db641d71d0 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -82,5 +82,6 @@ void lkdtm_USERCOPY_STACK_FRAME_TO(void);
 void lkdtm_USERCOPY_STACK_FRAME_FROM(void);
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
+void lkdtm_USERCOPY_KERNEL_DS(void);
 
 #endif
diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index 9725aed305bb..389475b25bb7 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -322,6 +322,19 @@ void lkdtm_USERCOPY_KERNEL(void)
 	vm_munmap(user_addr, PAGE_SIZE);
 }
 
+void lkdtm_USERCOPY_KERNEL_DS(void)
+{
+	char __user *user_ptr = (char __user *)ERR_PTR(-EINVAL);
+	mm_segment_t old_fs = get_fs();
+	char buf[10] = {0};
+
+	pr_info("attempting copy_to_user on unmapped kernel address\n");
+	set_fs(KERNEL_DS);
+	if (copy_to_user(user_ptr, buf, sizeof(buf)))
+		pr_info("copy_to_user un unmapped kernel address failed\n");
+	set_fs(old_fs);
+}
+
 void __init lkdtm_usercopy_init(void)
 {
 	/* Prepare cache that lacks SLAB_USERCOPY flag. */
-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
