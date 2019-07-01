Return-Path: <SRS0=Ak5/=U6=lists.openwall.com=kernel-hardening-return-16331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD0CC0650E
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:38:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D297F21721
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hiX5G4NW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D297F21721
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9805 invoked by uid 550); 1 Jul 2019 18:38:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9748 invoked from network); 1 Jul 2019 18:38:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09Ktx8SRlDlib2xj7zk4KAYeMpzwO1i+IOtw940mWQQ=;
        b=hiX5G4NW2/x8ybGy2xJKQ9H59kChFfsCqJbe5RmbN67UXqRYX5J5Zjs8ZsMmpflmeh
         2PEqHpR4FCHXvdxGn8gtkk55OJSno9oibIi8YgUSE5imbaPmOf0jfnqZMP6EeOSKvaMA
         ABh5C7UUxa8/Lc0TvYyxcdqdV/sfhOjuYNwPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09Ktx8SRlDlib2xj7zk4KAYeMpzwO1i+IOtw940mWQQ=;
        b=JvlCgHbIcGdgVLNDhFMF3DA8AQga3OD/d7bgy4Jqap+39Uac8nEK9gG0HMLdxYXd19
         PDaRYDBZcXafSjybZmtpVBNx1UVh7+3P4SU2MpamzjxTRoJjNdnuZBHacVUGHiWUVD+E
         jZffLVJj7/WXweIP8bRU/4RAWB0LNxd0bKADkebZ293cZAGP2tIXiorqNLZMS5Jhz+u2
         t1kDEJIFTPC0zOLPKeItEwxFWS7Ij6B7lViPqsLWSrAlnhm3ef1mUWIl6iIWG9lna1tc
         aWZYvFKl8GS1lVkLECeJb1VflEQmMdfYgz/77MXbp+lLAuwTN7Yj+1gqqDXV8vTIUPyc
         ZeAw==
X-Gm-Message-State: APjAAAWcU+rJx87ns5otp5K1+HFV2IbpuwFuOOy8SOSL+EeN6D3pkow/
	HvnvqesA0Q3sYJlLxJAgRNTuBOIyxZ0=
X-Google-Smtp-Source: APXvYqxDzHanhaPJoMYxc4oZsdGYSeKoPsg6AidbrkQIg+4OHXqZq9ag+h0i+3wU4qHU3muUOcxzdw==
X-Received: by 2002:a65:51c8:: with SMTP id i8mr2839745pgq.116.1562006311732;
        Mon, 01 Jul 2019 11:38:31 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	mathieu.desnoyers@efficios.com,
	willy@infradead.org,
	peterz@infradead.org,
	will.deacon@arm.com,
	paulmck@linux.vnet.ibm.com,
	elena.reshetova@intel.com,
	keescook@chromium.org,
	Andrea Parri <andrea.parri@amarulasolutions.com>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com,
	jannh@google.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	KJ Tsanaktsidis <ktsanaktsidis@zendesk.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3] Convert struct pid count to refcount_t
Date: Mon,  1 Jul 2019 14:38:26 -0400
Message-Id: <20190701183826.191936-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct pid's count is an atomic_t field used as a refcount. Use
refcount_t for it which is basically atomic_t but does additional
checking to prevent use-after-free bugs.

For memory ordering, the only change is with the following:
 -	if ((atomic_read(&pid->count) == 1) ||
 -	     atomic_dec_and_test(&pid->count)) {
 +	if (refcount_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);

Here the change is from:
Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
This ACQUIRE should take care of making sure the free happens after the
refcount_dec_and_test().

The above hunk also removes atomic_read() since it is not needed for the
code to work and it is unclear how beneficial it is. The removal lets
refcount_dec_and_test() check for cases where get_pid() happened before
the object was freed.

Cc: mathieu.desnoyers@efficios.com
Cc: willy@infradead.org
Cc: peterz@infradead.org
Cc: will.deacon@arm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: elena.reshetova@intel.com
Cc: keescook@chromium.org
Cc: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: kernel-team@android.com
Cc: kernel-hardening@lists.openwall.com
Cc: jannh@google.com
Reviewed-by: keescook@chromium.org
Reviewed-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

---
v1->v2 is to get rid of the atomic_read().
v2->v3 replaces ATOMIC_INIT with REFCOUNT_INIT

 include/linux/pid.h | 5 +++--
 kernel/pid.c        | 9 ++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 14a9a39da9c7..8cb86d377ff5 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -3,6 +3,7 @@
 #define _LINUX_PID_H
 
 #include <linux/rculist.h>
+#include <linux/refcount.h>
 
 enum pid_type
 {
@@ -56,7 +57,7 @@ struct upid {
 
 struct pid
 {
-	atomic_t count;
+	refcount_t count;
 	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
@@ -69,7 +70,7 @@ extern struct pid init_struct_pid;
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
-		atomic_inc(&pid->count);
+		refcount_inc(&pid->count);
 	return pid;
 }
 
diff --git a/kernel/pid.c b/kernel/pid.c
index 20881598bdfa..86b526bd59e1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -37,12 +37,12 @@
 #include <linux/init_task.h>
 #include <linux/syscalls.h>
 #include <linux/proc_ns.h>
-#include <linux/proc_fs.h>
+#include <linux/refcount.h>
 #include <linux/sched/task.h>
 #include <linux/idr.h>
 
 struct pid init_struct_pid = {
-	.count 		= ATOMIC_INIT(1),
+	.count		= REFCOUNT_INIT(1),
 	.tasks		= {
 		{ .first = NULL },
 		{ .first = NULL },
@@ -106,8 +106,7 @@ void put_pid(struct pid *pid)
 		return;
 
 	ns = pid->numbers[pid->level].ns;
-	if ((atomic_read(&pid->count) == 1) ||
-	     atomic_dec_and_test(&pid->count)) {
+	if (refcount_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}
@@ -210,7 +209,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	}
 
 	get_pid_ns(ns);
-	atomic_set(&pid->count, 1);
+	refcount_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
-- 
2.22.0.410.gd8fdbe21b5-goog
