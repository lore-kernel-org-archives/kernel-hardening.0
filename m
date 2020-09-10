Return-Path: <SRS0=nd22=CT=lists.openwall.com=kernel-hardening-return-19861-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CA4C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3678C20829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WSKxrRh1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3678C20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19861-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19970 invoked by uid 550); 10 Sep 2020 20:21:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19906 invoked from network); 10 Sep 2020 20:21:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7r1rfre30aGq4hYAj5mMZd9aKhfhtSFtGbHwMdeYlE0=;
        b=WSKxrRh1zgAfDwGMo9L1sYHyOSqjXp+wb+YwpqiJT/Zb3NKDCzaVVT0HbYRYHs8jtw
         syDcuriSzwueAxNmNoSgZJ3aO/+dNCwSIlBAmgYX5A9wHlOOfBJPa/yeELcCY0MiEm+v
         nylpABXf8ROfraF5ukN6PNGINg1dckKo/9qxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7r1rfre30aGq4hYAj5mMZd9aKhfhtSFtGbHwMdeYlE0=;
        b=RZwC4Xh/8bCeXEpbnQDolZTZZZ+eYLl9f4V/28HrAPzWaFnlMijyLVuoD97HvQZ+YS
         LFBNMi4r891gTjS1slTBYaskqc45yWZu2C/1hsmmQ2fWbmZykfhTSwq3xU/zrWh7OR7A
         djz4gyFVnZwwpWRAPx5NPYD6yr3NtoUfD+H3xJs5kdV+TCpALZwxrU36yVYHoZ8DPj9h
         A0wulU4tqpzb6PiMitI7lIQTDIFA/QuQHXDl/Ixlod8CKV1lQ8jKz4237XAieIxaAsD3
         Fjcj+dJLg89PJWBgDjQbakuFkJ5MGa/0CZGjfhku6k6+T/9NKcPpsOM378d2NuTDZNxZ
         nenQ==
X-Gm-Message-State: AOAM531BYu2nAwc5myrH79c5nWI/xcDkULCb259CmZrg5JD28K7jxdSK
	IzJJbgMOzWHLO199YqFHAXXzsg==
X-Google-Smtp-Source: ABdhPJzItNXJVhR75anYSdIs4NQSDmbgQALJfcnBGhftyYgbxgDuvZlpz5suFQW/PoYrnFwTWnHvYQ==
X-Received: by 2002:a62:7809:: with SMTP id t9mr6934123pfc.105.1599769280337;
        Thu, 10 Sep 2020 13:21:20 -0700 (PDT)
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
Subject: [RFC PATCH 4/6] security/fbfam: Add a new sysctl to control the crashing rate threshold
Date: Thu, 10 Sep 2020 13:21:05 -0700
Message-Id: <20200910202107.3799376-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

This is a previous step to add the detection feature.

A fork brute force attack will be detected when an application crashes
quickly. Since, a rate can be defined as a time per fault, add a new
sysctl to control the crashing rate threshold.

This way, each system can tune the detection's sensibility adjusting the
milliseconds per fault. So, if the application's crashing rate falls
under this threshold an attack will be detected. So, the higher this
value, the faster an attack will be detected.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 include/fbfam/fbfam.h   |  4 ++++
 kernel/sysctl.c         |  9 +++++++++
 security/fbfam/Makefile |  1 +
 security/fbfam/fbfam.c  | 11 +++++++++++
 security/fbfam/sysctl.c | 20 ++++++++++++++++++++
 5 files changed, 45 insertions(+)
 create mode 100644 security/fbfam/sysctl.c

diff --git a/include/fbfam/fbfam.h b/include/fbfam/fbfam.h
index b5b7d1127a52..2cfe51d2b0d5 100644
--- a/include/fbfam/fbfam.h
+++ b/include/fbfam/fbfam.h
@@ -3,8 +3,12 @@
 #define _FBFAM_H_
 
 #include <linux/sched.h>
+#include <linux/sysctl.h>
 
 #ifdef CONFIG_FBFAM
+#ifdef CONFIG_SYSCTL
+extern struct ctl_table fbfam_sysctls[];
+#endif
 int fbfam_fork(struct task_struct *child);
 int fbfam_execve(void);
 int fbfam_exit(void);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 09e70ee2332e..c3b4d737bef3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -77,6 +77,8 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 
+#include <fbfam/fbfam.h>
+
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
@@ -2660,6 +2662,13 @@ static struct ctl_table kern_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#endif
+#ifdef CONFIG_FBFAM
+	{
+		.procname	= "fbfam",
+		.mode		= 0555,
+		.child		= fbfam_sysctls,
+	},
 #endif
 	{ }
 };
diff --git a/security/fbfam/Makefile b/security/fbfam/Makefile
index f4b9f0b19c44..b8d5751ecea4 100644
--- a/security/fbfam/Makefile
+++ b/security/fbfam/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_FBFAM) += fbfam.o
+obj-$(CONFIG_SYSCTL) += sysctl.o
diff --git a/security/fbfam/fbfam.c b/security/fbfam/fbfam.c
index 0387f95f6408..9be4639b72eb 100644
--- a/security/fbfam/fbfam.c
+++ b/security/fbfam/fbfam.c
@@ -7,6 +7,17 @@
 #include <linux/refcount.h>
 #include <linux/slab.h>
 
+/**
+ * sysctl_crashing_rate_threshold - Crashing rate threshold.
+ *
+ * The rate's units are in milliseconds per fault.
+ *
+ * A fork brute force attack will be detected if the application's crashing rate
+ * falls under this threshold. So, the higher this value, the faster an attack
+ * will be detected.
+ */
+unsigned long sysctl_crashing_rate_threshold = 30000;
+
 /**
  * struct fbfam_stats - Fork brute force attack mitigation statistics.
  * @refc: Reference counter.
diff --git a/security/fbfam/sysctl.c b/security/fbfam/sysctl.c
new file mode 100644
index 000000000000..430323ad8e9f
--- /dev/null
+++ b/security/fbfam/sysctl.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/sysctl.h>
+
+extern unsigned long sysctl_crashing_rate_threshold;
+static unsigned long ulong_one = 1;
+static unsigned long ulong_max = ULONG_MAX;
+
+struct ctl_table fbfam_sysctls[] = {
+	{
+		.procname	= "crashing_rate_threshold",
+		.data		= &sysctl_crashing_rate_threshold,
+		.maxlen		= sizeof(sysctl_crashing_rate_threshold),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &ulong_one,
+		.extra2		= &ulong_max,
+	},
+	{ }
+};
+
-- 
2.25.1

