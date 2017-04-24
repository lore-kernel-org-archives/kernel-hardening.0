From: Matt Brown <matt@nmatt.com>
Date: Mon, 24 Apr 2017 01:15:11 -0400
Message-Id: <20170424051512.20420-2-matt@nmatt.com>
In-Reply-To: <20170424051512.20420-1-matt@nmatt.com>
References: <20170424051512.20420-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH v4 1/2] tiocsti-restrict : Add owner user namespace to tty_struct
To: serge@hallyn.com, jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, corbet@lwn.net, keescook@chromium.org
Cc: akpm@linux-foundation.org, jannh@google.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds struct user_namespace *owner_user_ns to the tty_struct.
Then it is set to current_user_ns() in the alloc_tty_struct function.

This is done to facilitate capability checks against the original user
namespace that allocated the tty.

E.g. ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)

This combined with the use of user namespace's will allow hardening
protections to be built to mitigate container escapes that utilize TTY
ioctls such as TIOCSTI.

See: https://bugzilla.redhat.com/show_bug.cgi?id=1411256

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 drivers/tty/tty_io.c | 2 ++
 include/linux/tty.h  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e6d1a65..c276814 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -171,6 +171,7 @@ static void free_tty_struct(struct tty_struct *tty)
 	put_device(tty->dev);
 	kfree(tty->write_buf);
 	tty->magic = 0xDEADDEAD;
+	put_user_ns(tty->owner_user_ns);
 	kfree(tty);
 }
 
@@ -3191,6 +3192,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
 	tty->dev = tty_get_device(tty);
+	tty->owner_user_ns = get_user_ns(current_user_ns());
 
 	return tty;
 }
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1017e904..d902d42 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -12,6 +12,7 @@
 #include <uapi/linux/tty.h>
 #include <linux/rwsem.h>
 #include <linux/llist.h>
+#include <linux/user_namespace.h>
 
 
 /*
@@ -333,6 +334,7 @@ struct tty_struct {
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
+	struct user_namespace *owner_user_ns;
 };
 
 /* Each of a tty's open files has private_data pointing to tty_file_private */
-- 
2.10.2
