Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:40 +0200
Message-Id: <1484730707-29313-12-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 11/18] security: convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/key.h              |  5 +++--
 security/keys/gc.c               |  2 +-
 security/keys/internal.h         |  3 ++-
 security/keys/key.c              | 12 ++++++------
 security/keys/keyring.c          |  8 ++++----
 security/keys/proc.c             |  4 ++--
 security/keys/process_keys.c     |  2 +-
 security/keys/request_key_auth.c |  2 +-
 security/selinux/hooks.c         |  9 +++++----
 security/selinux/include/xfrm.h  |  5 +++--
 security/selinux/xfrm.c          | 11 ++++++-----
 security/tomoyo/common.c         | 11 ++++++-----
 12 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 7229147..43d468e 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -23,6 +23,7 @@
 #include <linux/rwsem.h>
 #include <linux/atomic.h>
 #include <linux/assoc_array.h>
+#include <linux/refcount.h>
 
 #ifdef __KERNEL__
 #include <linux/uidgid.h>
@@ -135,7 +136,7 @@ static inline bool is_key_possessed(const key_ref_t key_ref)
  *   - Kerberos TGTs and tickets
  */
 struct key {
-	atomic_t		usage;		/* number of references */
+	refcount_t		usage;		/* number of references */
 	key_serial_t		serial;		/* key serial number */
 	union {
 		struct list_head graveyard_link;
@@ -242,7 +243,7 @@ extern void key_put(struct key *key);
 
 static inline struct key *__key_get(struct key *key)
 {
-	atomic_inc(&key->usage);
+	refcount_inc(&key->usage);
 	return key;
 }
 
diff --git a/security/keys/gc.c b/security/keys/gc.c
index addf060..4478925 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -220,7 +220,7 @@ static void key_garbage_collector(struct work_struct *work)
 		key = rb_entry(cursor, struct key, serial_node);
 		cursor = rb_next(cursor);
 
-		if (atomic_read(&key->usage) == 0)
+		if (refcount_read(&key->usage) == 0)
 			goto found_unreferenced_key;
 
 		if (unlikely(gc_state & KEY_GC_REAPING_DEAD_1)) {
diff --git a/security/keys/internal.h b/security/keys/internal.h
index a705a7d..110d661 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,7 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 #include <linux/keyctl.h>
+#include <linux/refcount.h>
 
 struct iovec;
 
@@ -52,7 +53,7 @@ struct key_user {
 	struct rb_node		node;
 	struct mutex		cons_lock;	/* construction initiation lock */
 	spinlock_t		lock;
-	atomic_t		usage;		/* for accessing qnkeys & qnbytes */
+	refcount_t		usage;		/* for accessing qnkeys & qnbytes */
 	atomic_t		nkeys;		/* number of keys */
 	atomic_t		nikeys;		/* number of instantiated keys */
 	kuid_t			uid;
diff --git a/security/keys/key.c b/security/keys/key.c
index 346fbf2..b4958b3 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -93,7 +93,7 @@ struct key_user *key_user_lookup(kuid_t uid)
 
 	/* if we get here, then the user record still hadn't appeared on the
 	 * second pass - so we use the candidate record */
-	atomic_set(&candidate->usage, 1);
+	refcount_set(&candidate->usage, 1);
 	atomic_set(&candidate->nkeys, 0);
 	atomic_set(&candidate->nikeys, 0);
 	candidate->uid = uid;
@@ -110,7 +110,7 @@ struct key_user *key_user_lookup(kuid_t uid)
 
 	/* okay - we found a user record for this UID */
 found:
-	atomic_inc(&user->usage);
+	refcount_inc(&user->usage);
 	spin_unlock(&key_user_lock);
 	kfree(candidate);
 out:
@@ -122,7 +122,7 @@ struct key_user *key_user_lookup(kuid_t uid)
  */
 void key_user_put(struct key_user *user)
 {
-	if (atomic_dec_and_lock(&user->usage, &key_user_lock)) {
+	if (refcount_dec_and_lock(&user->usage, &key_user_lock)) {
 		rb_erase(&user->node, &key_user_tree);
 		spin_unlock(&key_user_lock);
 
@@ -285,7 +285,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	if (!key->index_key.description)
 		goto no_memory_3;
 
-	atomic_set(&key->usage, 1);
+	refcount_set(&key->usage, 1);
 	init_rwsem(&key->sem);
 	lockdep_set_class(&key->sem, &type->lock_class);
 	key->index_key.type = type;
@@ -621,7 +621,7 @@ void key_put(struct key *key)
 	if (key) {
 		key_check(key);
 
-		if (atomic_dec_and_test(&key->usage))
+		if (refcount_dec_and_test(&key->usage))
 			schedule_work(&key_gc_work);
 	}
 }
@@ -656,7 +656,7 @@ struct key *key_lookup(key_serial_t id)
 
 found:
 	/* pretend it doesn't exist if it is awaiting deletion */
-	if (atomic_read(&key->usage) == 0)
+	if (refcount_read(&key->usage) == 0)
 		goto not_found;
 
 	/* this races with key_put(), but that doesn't matter since key_put()
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index c91e4e0..3d95f7d 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1033,7 +1033,7 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 			/* we've got a match but we might end up racing with
 			 * key_cleanup() if the keyring is currently 'dead'
 			 * (ie. it has a zero usage count) */
-			if (!atomic_inc_not_zero(&keyring->usage))
+			if (!refcount_inc_not_zero(&keyring->usage))
 				continue;
 			keyring->last_used_at = current_kernel_time().tv_sec;
 			goto out;
@@ -1250,14 +1250,14 @@ int key_link(struct key *keyring, struct key *key)
 	struct assoc_array_edit *edit;
 	int ret;
 
-	kenter("{%d,%d}", keyring->serial, atomic_read(&keyring->usage));
+	kenter("{%d,%d}", keyring->serial, refcount_read(&keyring->usage));
 
 	key_check(keyring);
 	key_check(key);
 
 	ret = __key_link_begin(keyring, &key->index_key, &edit);
 	if (ret == 0) {
-		kdebug("begun {%d,%d}", keyring->serial, atomic_read(&keyring->usage));
+		kdebug("begun {%d,%d}", keyring->serial, refcount_read(&keyring->usage));
 		ret = __key_link_check_restriction(keyring, key);
 		if (ret == 0)
 			ret = __key_link_check_live_key(keyring, key);
@@ -1266,7 +1266,7 @@ int key_link(struct key *keyring, struct key *key)
 		__key_link_end(keyring, &key->index_key, edit);
 	}
 
-	kleave(" = %d {%d,%d}", ret, keyring->serial, atomic_read(&keyring->usage));
+	kleave(" = %d {%d,%d}", ret, keyring->serial, refcount_read(&keyring->usage));
 	return ret;
 }
 EXPORT_SYMBOL(key_link);
diff --git a/security/keys/proc.c b/security/keys/proc.c
index b9f531c..bf08d02 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -252,7 +252,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 		   showflag(key, 'U', KEY_FLAG_USER_CONSTRUCT),
 		   showflag(key, 'N', KEY_FLAG_NEGATIVE),
 		   showflag(key, 'i', KEY_FLAG_INVALIDATED),
-		   atomic_read(&key->usage),
+		   refcount_read(&key->usage),
 		   xbuf,
 		   key->perm,
 		   from_kuid_munged(seq_user_ns(m), key->uid),
@@ -340,7 +340,7 @@ static int proc_key_users_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%5u: %5d %d/%d %d/%d %d/%d\n",
 		   from_kuid_munged(seq_user_ns(m), user->uid),
-		   atomic_read(&user->usage),
+		   refcount_read(&user->usage),
 		   atomic_read(&user->nkeys),
 		   atomic_read(&user->nikeys),
 		   user->qnkeys,
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 918cddc..16877c5 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -29,7 +29,7 @@ static DEFINE_MUTEX(key_user_keyring_mutex);
 
 /* The root user's tracking struct */
 struct key_user root_key_user = {
-	.usage		= ATOMIC_INIT(3),
+	.usage		= REFCOUNT_INIT(3),
 	.cons_lock	= __MUTEX_INITIALIZER(root_key_user.cons_lock),
 	.lock		= __SPIN_LOCK_UNLOCKED(root_key_user.lock),
 	.nkeys		= ATOMIC_INIT(2),
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 6bbe2f5..0f06215 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -213,7 +213,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	if (ret < 0)
 		goto error_inst;
 
-	kleave(" = {%d,%d}", authkey->serial, atomic_read(&authkey->usage));
+	kleave(" = {%d,%d}", authkey->serial, refcount_read(&authkey->usage));
 	return authkey;
 
 auth_key_revoked:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c7c6619..1241b07 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -83,6 +83,7 @@
 #include <linux/export.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
+#include <linux/refcount.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -95,7 +96,7 @@
 #include "avc_ss.h"
 
 /* SECMARK reference count */
-static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
+static refcount_t selinux_secmark_refcount = REFCOUNT_INIT(0);
 
 #ifdef CONFIG_SECURITY_SELINUX_DEVELOP
 int selinux_enforcing;
@@ -141,7 +142,7 @@ static struct kmem_cache *file_security_cache;
  */
 static int selinux_secmark_enabled(void)
 {
-	return (selinux_policycap_alwaysnetwork || atomic_read(&selinux_secmark_refcount));
+	return (selinux_policycap_alwaysnetwork || refcount_read(&selinux_secmark_refcount));
 }
 
 /**
@@ -4915,12 +4916,12 @@ static int selinux_secmark_relabel_packet(u32 sid)
 
 static void selinux_secmark_refcount_inc(void)
 {
-	atomic_inc(&selinux_secmark_refcount);
+	refcount_inc(&selinux_secmark_refcount);
 }
 
 static void selinux_secmark_refcount_dec(void)
 {
-	atomic_dec(&selinux_secmark_refcount);
+	refcount_dec(&selinux_secmark_refcount);
 }
 
 static void selinux_req_classify_flow(const struct request_sock *req,
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 1450f85..182dc95 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -8,6 +8,7 @@
 #define _SELINUX_XFRM_H_
 
 #include <net/flow.h>
+#include <linux/refcount.h>
 
 int selinux_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
 			      struct xfrm_user_sec_ctx *uctx,
@@ -28,11 +29,11 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      const struct flowi *fl);
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
-extern atomic_t selinux_xfrm_refcount;
+extern refcount_t selinux_xfrm_refcount;
 
 static inline int selinux_xfrm_enabled(void)
 {
-	return (atomic_read(&selinux_xfrm_refcount) > 0);
+	return (refcount_read(&selinux_xfrm_refcount) > 0);
 }
 
 int selinux_xfrm_sock_rcv_skb(u32 sk_sid, struct sk_buff *skb,
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 56e354f..f485965 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -44,13 +44,14 @@
 #include <net/checksum.h>
 #include <net/udp.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include "avc.h"
 #include "objsec.h"
 #include "xfrm.h"
 
 /* Labeled XFRM instance counter */
-atomic_t selinux_xfrm_refcount = ATOMIC_INIT(0);
+refcount_t selinux_xfrm_refcount = REFCOUNT_INIT(0);
 
 /*
  * Returns true if the context is an LSM/SELinux context.
@@ -111,7 +112,7 @@ static int selinux_xfrm_alloc_user(struct xfrm_sec_ctx **ctxp,
 		goto err;
 
 	*ctxp = ctx;
-	atomic_inc(&selinux_xfrm_refcount);
+	refcount_inc(&selinux_xfrm_refcount);
 	return 0;
 
 err:
@@ -127,7 +128,7 @@ static void selinux_xfrm_free(struct xfrm_sec_ctx *ctx)
 	if (!ctx)
 		return;
 
-	atomic_dec(&selinux_xfrm_refcount);
+	refcount_dec(&selinux_xfrm_refcount);
 	kfree(ctx);
 }
 
@@ -302,7 +303,7 @@ int selinux_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
 			  GFP_ATOMIC);
 	if (!new_ctx)
 		return -ENOMEM;
-	atomic_inc(&selinux_xfrm_refcount);
+	refcount_inc(&selinux_xfrm_refcount);
 	*new_ctxp = new_ctx;
 
 	return 0;
@@ -369,7 +370,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	memcpy(ctx->ctx_str, ctx_str, str_len);
 
 	x->security = ctx;
-	atomic_inc(&selinux_xfrm_refcount);
+	refcount_inc(&selinux_xfrm_refcount);
 out:
 	kfree(ctx_str);
 	return rc;
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index e0fb750..9a7605a 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -7,6 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <linux/refcount.h>
 #include "common.h"
 
 /* String table for operation mode. */
@@ -1907,7 +1908,7 @@ static DEFINE_SPINLOCK(tomoyo_query_list_lock);
  * Number of "struct file" referring /sys/kernel/security/tomoyo/query
  * interface.
  */
-static atomic_t tomoyo_query_observers = ATOMIC_INIT(0);
+static refcount_t tomoyo_query_observers = REFCOUNT_INIT(0);
 
 /**
  * tomoyo_truncate - Truncate a line.
@@ -2015,7 +2016,7 @@ int tomoyo_supervisor(struct tomoyo_request_info *r, const char *fmt, ...)
 	switch (r->mode) {
 	case TOMOYO_CONFIG_ENFORCING:
 		error = -EPERM;
-		if (atomic_read(&tomoyo_query_observers))
+		if (refcount_read(&tomoyo_query_observers))
 			break;
 		goto out;
 	case TOMOYO_CONFIG_LEARNING:
@@ -2059,7 +2060,7 @@ int tomoyo_supervisor(struct tomoyo_request_info *r, const char *fmt, ...)
 		wake_up_all(&tomoyo_query_wait);
 		if (wait_event_interruptible_timeout
 		    (tomoyo_answer_wait, entry.answer ||
-		     !atomic_read(&tomoyo_query_observers), HZ))
+		     !refcount_read(&tomoyo_query_observers), HZ))
 			break;
 		else
 			entry.timer++;
@@ -2437,7 +2438,7 @@ int tomoyo_open_control(const u8 type, struct file *file)
 	 * there is some process monitoring /sys/kernel/security/tomoyo/query.
 	 */
 	if (type == TOMOYO_QUERY)
-		atomic_inc(&tomoyo_query_observers);
+		refcount_inc(&tomoyo_query_observers);
 	file->private_data = head;
 	tomoyo_notify_gc(head, true);
 	return 0;
@@ -2687,7 +2688,7 @@ void tomoyo_close_control(struct tomoyo_io_buffer *head)
 	 * observer counter.
 	 */
 	if (head->type == TOMOYO_QUERY &&
-	    atomic_dec_and_test(&tomoyo_query_observers))
+	    refcount_dec_and_test(&tomoyo_query_observers))
 		wake_up_all(&tomoyo_answer_wait);
 	tomoyo_notify_gc(head, false);
 }
-- 
2.7.4
