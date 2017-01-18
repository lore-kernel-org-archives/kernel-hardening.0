Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:34 +0200
Message-Id: <1484730707-29313-6-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 05/18] kref: Implement kref_put_lock()
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Peter Zijlstra <peterz@infradead.org>

Because home-rolling your own is _awesome_, stop doing it. Provide
kref_put_lock(), just like kref_put_mutex() but for a spinlock.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/kref.h | 21 +++++++++++++++------
 net/sunrpc/svcauth.c | 15 ++++++++++-----
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 31c49a6..aef7e19 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -86,12 +86,21 @@ static inline int kref_put_mutex(struct kref *kref,
 				 struct mutex *lock)
 {
 	WARN_ON(release == NULL);
-	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
-		mutex_lock(lock);
-		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
-			mutex_unlock(lock);
-			return 0;
-		}
+
+	if (atomic_dec_and_mutex_lock(&kref->refcount, lock)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int kref_put_lock(struct kref *kref,
+				void (*release)(struct kref *kref),
+				spinlock_t *lock)
+{
+	WARN_ON(release == NULL);
+
+	if (atomic_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
 	}
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index e112da8..bb8db3c 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -126,13 +126,18 @@ EXPORT_SYMBOL_GPL(svc_auth_unregister);
 static struct hlist_head	auth_domain_table[DN_HASHMAX];
 static DEFINE_SPINLOCK(auth_domain_lock);
 
+static void auth_domain_release(struct kref *kref)
+{
+	struct auth_domain *dom = container_of(kref, struct auth_domain, ref);
+
+	hlist_del(&dom->hash);
+	dom->flavour->domain_release(dom);
+	spin_unlock(&auth_domain_lock);
+}
+
 void auth_domain_put(struct auth_domain *dom)
 {
-	if (atomic_dec_and_lock(&dom->ref.refcount, &auth_domain_lock)) {
-		hlist_del(&dom->hash);
-		dom->flavour->domain_release(dom);
-		spin_unlock(&auth_domain_lock);
-	}
+	kref_put_lock(&dom->ref, auth_domain_release, &auth_domain_lock);
 }
 EXPORT_SYMBOL_GPL(auth_domain_put);
 
-- 
2.7.4
