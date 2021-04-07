Return-Path: <SRS0=H9O0=JE=lists.openwall.com=kernel-hardening-return-21165-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C54C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 17:09:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4225E611C0
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 17:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4225E611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21165-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22363 invoked by uid 550); 7 Apr 2021 17:08:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22207 invoked from network); 7 Apr 2021 17:08:46 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org
Cc: Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v10 3/9] Use atomic_t for ucounts reference counting
Date: Wed,  7 Apr 2021 19:08:08 +0200
Message-Id: <5205476b7d2db3c22a33f42c70e5551e0987f640.1617814298.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <cover.1617814298.git.gladkov.alexey@gmail.com>
References: <cover.1617814298.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (raptor.unsafe.ru [5.9.43.93]); Wed, 07 Apr 2021 17:08:34 +0000 (UTC)

The current implementation of the ucounts reference counter requires the
use of spin_lock. We're going to use get_ucounts() in more performance
critical areas like a handling of RLIMIT_SIGPENDING.

Now we need to use spin_lock only if we want to change the hashtable.

v10:
* Always try to put ucounts in case we cannot increase ucounts->count.
  This will allow to cover the case when all consumers will return
  ucounts at once.

v9:
* Use a negative value to check that the ucounts->count is close to
  overflow.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/user_namespace.h |  4 +--
 kernel/ucount.c                | 53 ++++++++++++----------------------
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index f71b5a4a3e74..d84cc2c0b443 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -92,7 +92,7 @@ struct ucounts {
 	struct hlist_node node;
 	struct user_namespace *ns;
 	kuid_t uid;
-	int count;
+	atomic_t count;
 	atomic_long_t ucount[UCOUNT_COUNTS];
 };
 
@@ -104,7 +104,7 @@ void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
-struct ucounts *get_ucounts(struct ucounts *ucounts);
+struct ucounts * __must_check get_ucounts(struct ucounts *ucounts);
 void put_ucounts(struct ucounts *ucounts);
 
 #ifdef CONFIG_USER_NS
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 50cc1dfb7d28..365865f368ec 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -11,7 +11,7 @@
 struct ucounts init_ucounts = {
 	.ns    = &init_user_ns,
 	.uid   = GLOBAL_ROOT_UID,
-	.count = 1,
+	.count = ATOMIC_INIT(1),
 };
 
 #define UCOUNTS_HASHTABLE_BITS 10
@@ -139,6 +139,15 @@ static void hlist_add_ucounts(struct ucounts *ucounts)
 	spin_unlock_irq(&ucounts_lock);
 }
 
+struct ucounts *get_ucounts(struct ucounts *ucounts)
+{
+	if (ucounts && atomic_add_negative(1, &ucounts->count)) {
+		put_ucounts(ucounts);
+		ucounts = NULL;
+	}
+	return ucounts;
+}
+
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
@@ -155,7 +164,7 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 
 		new->ns = ns;
 		new->uid = uid;
-		new->count = 0;
+		atomic_set(&new->count, 1);
 
 		spin_lock_irq(&ucounts_lock);
 		ucounts = find_ucounts(ns, uid, hashent);
@@ -163,33 +172,12 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 			kfree(new);
 		} else {
 			hlist_add_head(&new->node, hashent);
-			ucounts = new;
+			spin_unlock_irq(&ucounts_lock);
+			return new;
 		}
 	}
-	if (ucounts->count == INT_MAX)
-		ucounts = NULL;
-	else
-		ucounts->count += 1;
 	spin_unlock_irq(&ucounts_lock);
-	return ucounts;
-}
-
-struct ucounts *get_ucounts(struct ucounts *ucounts)
-{
-	unsigned long flags;
-
-	if (!ucounts)
-		return NULL;
-
-	spin_lock_irqsave(&ucounts_lock, flags);
-	if (ucounts->count == INT_MAX) {
-		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
-		ucounts = NULL;
-	} else {
-		ucounts->count += 1;
-	}
-	spin_unlock_irqrestore(&ucounts_lock, flags);
-
+	ucounts = get_ucounts(ucounts);
 	return ucounts;
 }
 
@@ -197,15 +185,12 @@ void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ucounts_lock, flags);
-	ucounts->count -= 1;
-	if (!ucounts->count)
+	if (atomic_dec_and_test(&ucounts->count)) {
+		spin_lock_irqsave(&ucounts_lock, flags);
 		hlist_del_init(&ucounts->node);
-	else
-		ucounts = NULL;
-	spin_unlock_irqrestore(&ucounts_lock, flags);
-
-	kfree(ucounts);
+		spin_unlock_irqrestore(&ucounts_lock, flags);
+		kfree(ucounts);
+	}
 }
 
 static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
-- 
2.29.3

