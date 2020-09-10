Return-Path: <SRS0=LtvH=CT=lists.openwall.com=kernel-hardening-return-19864-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCE8C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6448520829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IcAkD4z1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6448520829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19864-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20300 invoked by uid 550); 10 Sep 2020 20:21:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20142 invoked from network); 10 Sep 2020 20:21:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AfgkhWr5TvQdUsjIexLihHefc7s9wXFiV4jpjvqj+P4=;
        b=IcAkD4z1/2S2dWxK0asptEvpDVQMKoSNKpWAR+6zYzikYLiAPypGc6/bX5F0imPsE7
         MkE0O1TZK8LaTu5qFlEQkg4K5glh23k39a6UqEbwmlwKwof7KYPT/0hXh4MNToieMUdR
         JYV1fCi//9FyuuJt8WiHG8zeHG9pAxzJd/fSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AfgkhWr5TvQdUsjIexLihHefc7s9wXFiV4jpjvqj+P4=;
        b=ANh2UMiH4cmFUUAuE+y+kfVOpijyLTYVTxRcI7ssaInL0FNfYThpF2DMNl2922sF/9
         gsdzvAa2LsCq1rSpEdWqdI7ps2z6pKHGAa+an4BAQ/byzYnlsPxYKdbfd9z1p4+nfbZ/
         Adx+okLxXhtqNrvvFO3sFsEBBQ735F66s6Pa9PdpehtYIsklsdd1kpVj1iQqEfW7sm7/
         JDXKJwarS6eKx4MtfgwKOoXZikBke0AS8NKF660WnEEbtLWDY8FGQ/3QhYQax3+2R8BG
         MEP5ij2dGDNWlmHJU/YOlixBy/7NNhZpVwMDLdebAOaiHXZpSypYBUF5IwZLo0dyZiuy
         6jWw==
X-Gm-Message-State: AOAM532WESjIfZuXjqReYR/NB775I86IRDqKQsDFJ3MH+GqPvaf9B6nz
	q8R1moBXQkHIIFq4UqutpDH/RA==
X-Google-Smtp-Source: ABdhPJzB6YHe1rp5zg2xo+FQRvAQwCLx++qVkJQa5at9cU43jBjrpf+5y4Cf716aA6XzEhbVIBp+Zw==
X-Received: by 2002:a17:90a:cc0e:: with SMTP id b14mr1520840pju.166.1599769283338;
        Thu, 10 Sep 2020 13:21:23 -0700 (PDT)
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
Subject: [RFC PATCH 6/6] security/fbfam: Mitigate a fork brute force attack
Date: Thu, 10 Sep 2020 13:21:07 -0700
Message-Id: <20200910202107.3799376-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

In order to mitigate a fork brute force attack it is necessary to kill
all the offending tasks. This tasks are all the ones that share the
statistical data with the current task (the task that has crashed).

Since the attack detection is done in the function fbfam_handle_attack()
that is called every time a core dump is triggered, only is needed to
kill the others tasks that share the same statistical data, not the
current one as this is in the path to be killed.

When the SIGKILL signal is sent to the offending tasks from the function
fbfam_kill_tasks(), this one will be called again during the core dump
due to the shared statistical data shows a quickly crashing rate. So, to
avoid kill again the same tasks due to a recursive call of this
function, it is necessary to disable the attack detection.

To disable this attack detection, add a condition in the function
fbfam_handle_attack() to not compute the crashing rate when the jiffies
stored in the statistical data are set to zero.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 security/fbfam/fbfam.c | 76 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/security/fbfam/fbfam.c b/security/fbfam/fbfam.c
index 3aa669e4ea51..173a6122390f 100644
--- a/security/fbfam/fbfam.c
+++ b/security/fbfam/fbfam.c
@@ -4,8 +4,11 @@
 #include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/jiffies.h>
+#include <linux/pid.h>
 #include <linux/printk.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
+#include <linux/sched/signal.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
 
@@ -24,7 +27,8 @@ unsigned long sysctl_crashing_rate_threshold = 30000;
  * struct fbfam_stats - Fork brute force attack mitigation statistics.
  * @refc: Reference counter.
  * @faults: Number of crashes since jiffies.
- * @jiffies: First fork or execve timestamp.
+ * @jiffies: First fork or execve timestamp. If zero, the attack detection is
+ *           disabled.
  *
  * The purpose of this structure is to manage all the necessary information to
  * compute the crashing rate of an application. So, it holds a first fork or
@@ -175,13 +179,69 @@ int fbfam_exit(void)
 }
 
 /**
- * fbfam_handle_attack() - Fork brute force attack detection.
+ * fbfam_kill_tasks() - Kill the offending tasks
+ *
+ * When a fork brute force attack is detected it is necessary to kill all the
+ * offending tasks. Since this function is called from fbfam_handle_attack(),
+ * and so, every time a core dump is triggered, only is needed to kill the
+ * others tasks that share the same statistical data, not the current one as
+ * this is in the path to be killed.
+ *
+ * When the SIGKILL signal is sent to the offending tasks, this function will be
+ * called again during the core dump due to the shared statistical data shows a
+ * quickly crashing rate. So, to avoid kill again the same tasks due to a
+ * recursive call of this function, it is necessary to disable the attack
+ * detection setting the jiffies to zero.
+ *
+ * To improve the for_each_process loop it is possible to end it when all the
+ * tasks that shared the same statistics are found.
+ *
+ * Return: -EFAULT if the current task doesn't have statistical data. Zero
+ *         otherwise.
+ */
+static int fbfam_kill_tasks(void)
+{
+	struct fbfam_stats *stats = current->fbfam_stats;
+	struct task_struct *p;
+	unsigned int to_kill, killed = 0;
+
+	if (!stats)
+		return -EFAULT;
+
+	to_kill = refcount_read(&stats->refc) - 1;
+	if (!to_kill)
+		return 0;
+
+	/* Disable the attack detection */
+	stats->jiffies = 0;
+	rcu_read_lock();
+
+	for_each_process(p) {
+		if (p == current || p->fbfam_stats != stats)
+			continue;
+
+		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
+		pr_warn("fbfam: Offending process with PID %d killed\n",
+			p->pid);
+
+		killed += 1;
+		if (killed >= to_kill)
+			break;
+	}
+
+	rcu_read_unlock();
+	return 0;
+}
+
+/**
+ * fbfam_handle_attack() - Fork brute force attack detection and mitigation.
  * @signal: Signal number that causes the core dump.
  *
  * The crashing rate of an application is computed in milliseconds per fault in
  * each crash. So, if this rate goes under a certain threshold there is a clear
  * signal that the application is crashing quickly. At this moment, a fork brute
- * force attack is happening.
+ * force attack is happening. Under this scenario it is necessary to kill all
+ * the offending tasks in order to mitigate the attack.
  *
  * Return: -EFAULT if the current task doesn't have statistical data. Zero
  *         otherwise.
@@ -195,6 +255,10 @@ int fbfam_handle_attack(int signal)
 	if (!stats)
 		return -EFAULT;
 
+	/* The attack detection is disabled */
+	if (!stats->jiffies)
+		return 0;
+
 	if (!(signal == SIGILL || signal == SIGBUS || signal == SIGKILL ||
 	      signal == SIGSEGV || signal == SIGSYS))
 		return 0;
@@ -205,9 +269,11 @@ int fbfam_handle_attack(int signal)
 	delta_time = jiffies64_to_msecs(delta_jiffies);
 	crashing_rate = delta_time / (u64)stats->faults;
 
-	if (crashing_rate < (u64)sysctl_crashing_rate_threshold)
-		pr_warn("fbfam: Fork brute force attack detected\n");
+	if (crashing_rate >= (u64)sysctl_crashing_rate_threshold)
+		return 0;
 
+	pr_warn("fbfam: Fork brute force attack detected\n");
+	fbfam_kill_tasks();
 	return 0;
 }
 
-- 
2.25.1

