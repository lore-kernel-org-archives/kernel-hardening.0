Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 12:19:54 -0400
Message-Id: <1477757996-22468-4-git-send-email-dwindsor@gmail.com>
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening][RFC PATCH 3/5] tty: add overflow protection to struct tty_ldisc_ops.refcount
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com, takahiro.akashi@linaro.org, colin@cvidal.org, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Change type of struct tty_ldisc_ops.refcount to atomic_t.  This enables
overflow protection: when CONFIG_HARDENED_ATOMIC is enabled, atomic_t
variables cannot be overflowed.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>
---
 drivers/tty/n_tty.c       | 3 ++-
 drivers/tty/tty_ldisc.c   | 8 ++++----
 include/linux/tty_ldisc.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index bdf0e6e..a640ce5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2465,7 +2465,8 @@ void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
 {
 	*ops = n_tty_ops;
 	ops->owner = NULL;
-	ops->refcount = ops->flags = 0;
+	atomic_set(&ops->refcount, 0);
+	ops->flags = 0;
 }
 EXPORT_SYMBOL_GPL(n_tty_inherit_ops);
 
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 68947f6..1f85fef2 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -68,7 +68,7 @@ int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	tty_ldiscs[disc] = new_ldisc;
 	new_ldisc->num = disc;
-	new_ldisc->refcount = 0;
+	atomic_set(&new_ldisc->refcount, 0);
 	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	return ret;
@@ -96,7 +96,7 @@ int tty_unregister_ldisc(int disc)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
-	if (tty_ldiscs[disc]->refcount)
+	if (atomic_read(&tty_ldiscs[disc]->refcount))
 		ret = -EBUSY;
 	else
 		tty_ldiscs[disc] = NULL;
@@ -117,7 +117,7 @@ static struct tty_ldisc_ops *get_ldops(int disc)
 	if (ldops) {
 		ret = ERR_PTR(-EAGAIN);
 		if (try_module_get(ldops->owner)) {
-			ldops->refcount++;
+			atomic_inc(&ldops->refcount);
 			ret = ldops;
 		}
 	}
@@ -130,7 +130,7 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
-	ldops->refcount--;
+	atomic_dec(&ldops->refcount);
 	module_put(ldops->owner);
 	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 }
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 3971cf0..7704c48 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -202,7 +202,7 @@ struct tty_ldisc_ops {
 
 	struct  module *owner;
 
-	int refcount;
+	atomic_t refcount;
 };
 
 struct tty_ldisc {
-- 
2.7.4
