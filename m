Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:40 -0500
Message-Id: <1450364270-12687-3-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 02/12] percpu_ref: decrease per-CPU refcount bias
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

This change is necessary to prevent overflows from occuring in
percpu_switch_to_atomic_rcu during init on x86.

Signed-off-by: David Windsor <dave@progbits.org>
---
 lib/percpu-refcount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 6111bcb..02e816b 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -31,7 +31,7 @@
  * atomic_long_t can't hit 0 before we've added up all the percpu refs.
  */
 
-#define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
+#define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 2))
 
 static DECLARE_WAIT_QUEUE_HEAD(percpu_ref_switch_waitq);
 
-- 
2.5.0
