Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 10:50:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214185028.GA4939@kroah.com>
References: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185000.GA3930@kroah.com>
Subject: [kernel-hardening] [PATCH 1/4] kmod: make usermodehelper path a const string
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is in preparation for making it so that usermode helper programs
can't be changed, if desired, by userspace.  We will tackle the mess of
cleaning up the write-ability of argv and env later, that's going to
take more work, for much less gain...

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kmod.h | 7 ++++---
 kernel/kmod.c        | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index fcfd2bf14d3f..c4e441e00db5 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -56,7 +56,7 @@ struct file;
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
-	char *path;
+	const char *path;
 	char **argv;
 	char **envp;
 	int wait;
@@ -67,10 +67,11 @@ struct subprocess_info {
 };
 
 extern int
-call_usermodehelper(char *path, char **argv, char **envp, int wait);
+call_usermodehelper(const char *path, char **argv, char **envp, int wait);
 
 extern struct subprocess_info *
-call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
+call_usermodehelper_setup(const char *path, char **argv, char **envp,
+			  gfp_t gfp_mask,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
 			  void (*cleanup)(struct subprocess_info *), void *data);
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 0277d1216f80..0c216b76afca 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -516,7 +516,7 @@ static void helper_unlock(void)
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
-struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
+struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
 		char **envp, gfp_t gfp_mask,
 		int (*init)(struct subprocess_info *info, struct cred *new),
 		void (*cleanup)(struct subprocess_info *info),
@@ -613,7 +613,7 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
  * This function is the equivalent to use call_usermodehelper_setup() and
  * call_usermodehelper_exec().
  */
-int call_usermodehelper(char *path, char **argv, char **envp, int wait)
+int call_usermodehelper(const char *path, char **argv, char **envp, int wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-- 
2.10.2
