Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:33 +0200
Message-Id: <1484730707-29313-5-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 04/18] kref: Use kref_get_unless_zero() more
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Peter Zijlstra <peterz@infradead.org>

For some obscure reason apparmor thinks its needs to locally implement
kref primitives that already exist. Stop doing this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/apparmor/include/apparmor.h | 6 ------
 security/apparmor/include/policy.h   | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 5d721e9..f067be8 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -78,12 +78,6 @@ static inline void *kvzalloc(size_t size)
 	return __aa_kvmalloc(size, __GFP_ZERO);
 }
 
-/* returns 0 if kref not incremented */
-static inline int kref_get_not0(struct kref *kref)
-{
-	return atomic_inc_not_zero(&kref->refcount);
-}
-
 /**
  * aa_strneq - compare null terminated @str to a non null terminated substring
  * @str: a null terminated string
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 52275f0..46467aa 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -287,7 +287,7 @@ static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
  */
 static inline struct aa_profile *aa_get_profile_not0(struct aa_profile *p)
 {
-	if (p && kref_get_not0(&p->count))
+	if (p && kref_get_unless_zero(&p->count))
 		return p;
 
 	return NULL;
@@ -307,7 +307,7 @@ static inline struct aa_profile *aa_get_profile_rcu(struct aa_profile __rcu **p)
 	rcu_read_lock();
 	do {
 		c = rcu_dereference(*p);
-	} while (c && !kref_get_not0(&c->count));
+	} while (c && !kref_get_unless_zero(&c->count));
 	rcu_read_unlock();
 
 	return c;
-- 
2.7.4
