Return-Path: <SRS0=VWMG=CT=lists.openwall.com=kernel-hardening-return-19863-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F75C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 85D9320829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QqSA5OLv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85D9320829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19863-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20187 invoked by uid 550); 10 Sep 2020 20:21:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20023 invoked from network); 10 Sep 2020 20:21:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fekJawXuRCxGrjYQI8OQvxsZTGlCFbLJj9FaUGr/A7E=;
        b=QqSA5OLvk2Qdik/W7fOSu9hkPXdjQzGi3H6oVrZUyklZ+UzgX6HE9UM609d6dK+kyh
         54tXPlf8gvwGJYpP5jiKL4Mqt3GvS4R+0mJa2dhY7V+8gDdXSbCJ3tIl9uerrba1ObNl
         fq3FyNkenrkMAEkbOEdq32NFyGXYfubBxsfyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fekJawXuRCxGrjYQI8OQvxsZTGlCFbLJj9FaUGr/A7E=;
        b=gHm3j8kJGqo3fU65jFtNTNjzFPHOMMfR5JRvrgYg0Z1jZ2kWTCBGB5pwmiT4zcshbu
         ts/gAiukQ9zsy5B+ZR5OrqVJk2LtE6QXaJJm412UBn1Awgn0k3+wPhwn9t3QrVL7rWnc
         45mFIcFHZx+nNmLymT9xxNemM+vu9S5lfyZb65Oh4S2NiM6ykMEsxLkLOex91Ut2j/3F
         5eqtEAFR/dnqzNBus00fzBWco8rekhvrStw7M+nSxmi8ZdO4uU2dlGJmI/XWfGM4iLhY
         G6WU8V8bkK/PlWSVwReeMQB4KqHY8UyDNYcK+4TXhbVlHkfrSr6cyW2z4st+7oS79F0U
         Rl0w==
X-Gm-Message-State: AOAM532INAkUUE44X5ezoWpREO8jafY172oO40NBMGNGmt59j1sjVmbg
	X0adZgAPH/RXJz7Euo8XS99PIw==
X-Google-Smtp-Source: ABdhPJymFVJ+9HWBVHudVut19/nL7d3aLa8ZpMZHZNa4qlaiqrKo1FAhdiapRQw62yOFnHB/LJtf8A==
X-Received: by 2002:a17:90b:a51:: with SMTP id gw17mr1654063pjb.118.1599769282707;
        Thu, 10 Sep 2020 13:21:22 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	John Wood <john.wood@gmx.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [RFC PATCH 5/6] security/fbfam: Detect a fork brute force attack
Date: Thu, 10 Sep 2020 13:21:06 -0700
Message-Id: <20200910202107.3799376-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

To detect a fork brute force attack it is necessary to compute the
crashing rate of the application. This calculation is performed in each
fatal fail of a task, or in other words, when a core dump is triggered.
If this rate shows that the application is crashing quickly, there is a
clear signal that an attack is happening.

Since the crashing rate is computed in milliseconds per fault, if this
rate goes under a certain threshold a warning is triggered.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 fs/coredump.c          |  2 ++
 include/fbfam/fbfam.h  |  2 ++
 security/fbfam/fbfam.c | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 76e7c10edfc0..d4ba4e1828d5 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -51,6 +51,7 @@
 #include "internal.h"
 
 #include <trace/events/sched.h>
+#include <fbfam/fbfam.h>
 
 int core_uses_pid;
 unsigned int core_pipe_limit;
@@ -825,6 +826,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 fail_creds:
 	put_cred(cred);
 fail:
+	fbfam_handle_attack(siginfo->si_signo);
 	return;
 }
 
diff --git a/include/fbfam/fbfam.h b/include/fbfam/fbfam.h
index 2cfe51d2b0d5..9ac8e33d8291 100644
--- a/include/fbfam/fbfam.h
+++ b/include/fbfam/fbfam.h
@@ -12,10 +12,12 @@ extern struct ctl_table fbfam_sysctls[];
 int fbfam_fork(struct task_struct *child);
 int fbfam_execve(void);
 int fbfam_exit(void);
+int fbfam_handle_attack(int signal);
 #else
 static inline int fbfam_fork(struct task_struct *child) { return 0; }
 static inline int fbfam_execve(void) { return 0; }
 static inline int fbfam_exit(void) { return 0; }
+static inline int fbfam_handle_attack(int signal) { return 0; }
 #endif
 
 #endif /* _FBFAM_H_ */
diff --git a/security/fbfam/fbfam.c b/security/fbfam/fbfam.c
index 9be4639b72eb..3aa669e4ea51 100644
--- a/security/fbfam/fbfam.c
+++ b/security/fbfam/fbfam.c
@@ -4,7 +4,9 @@
 #include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/jiffies.h>
+#include <linux/printk.h>
 #include <linux/refcount.h>
+#include <linux/signal.h>
 #include <linux/slab.h>
 
 /**
@@ -172,3 +174,40 @@ int fbfam_exit(void)
 	return 0;
 }
 
+/**
+ * fbfam_handle_attack() - Fork brute force attack detection.
+ * @signal: Signal number that causes the core dump.
+ *
+ * The crashing rate of an application is computed in milliseconds per fault in
+ * each crash. So, if this rate goes under a certain threshold there is a clear
+ * signal that the application is crashing quickly. At this moment, a fork brute
+ * force attack is happening.
+ *
+ * Return: -EFAULT if the current task doesn't have statistical data. Zero
+ *         otherwise.
+ */
+int fbfam_handle_attack(int signal)
+{
+	struct fbfam_stats *stats = current->fbfam_stats;
+	u64 delta_jiffies, delta_time;
+	u64 crashing_rate;
+
+	if (!stats)
+		return -EFAULT;
+
+	if (!(signal == SIGILL || signal == SIGBUS || signal == SIGKILL ||
+	      signal == SIGSEGV || signal == SIGSYS))
+		return 0;
+
+	stats->faults += 1;
+
+	delta_jiffies = get_jiffies_64() - stats->jiffies;
+	delta_time = jiffies64_to_msecs(delta_jiffies);
+	crashing_rate = delta_time / (u64)stats->faults;
+
+	if (crashing_rate < (u64)sysctl_crashing_rate_threshold)
+		pr_warn("fbfam: Fork brute force attack detected\n");
+
+	return 0;
+}
+
-- 
2.25.1

