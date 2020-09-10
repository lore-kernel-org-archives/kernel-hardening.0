Return-Path: <SRS0=Oulw=CT=lists.openwall.com=kernel-hardening-return-19860-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC702C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDE4920829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="N4ZcvLio"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDE4920829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19860-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19926 invoked by uid 550); 10 Sep 2020 20:21:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19646 invoked from network); 10 Sep 2020 20:21:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i8Xslrycj3wZ0DMCYzlf3YsQvnbbwZR8oamVvMIeqd8=;
        b=N4ZcvLionYWpbEK4gXbRvbCv+cTM7NTQkjTbl0t2d2YCT5Z4d+Pb1z8TvbVJH3NLQu
         pGdG+OrRpe7FlA0k0vXQGINZGk4uSXR4KYfpS8yuHC0joRvBUjoVnIeUFSsCA/gsUHG4
         bFvqJk8qJ7J0u2QmvU3MrRgUt8CMZ24ZyDXQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i8Xslrycj3wZ0DMCYzlf3YsQvnbbwZR8oamVvMIeqd8=;
        b=f7Uw1F0T1v9r2mg6EHM6SU3oykaFYOPVd+OypwnSFwxE+LwLr1QbS6NRJqfqaqAA9+
         oaQ9x5zQD37zwhlN/UiOsP5SUyNPqMFTLsfEzKhWgN03wxgihJpnexoEq1HypJGFlny3
         qAkwrQzcJac9A8MJpfYePch06iRq20yp76eUQnw0iOj/yEqP1BGXFlCdNwDIxGiz+gYr
         KjcVPWJyJc3qc7V82YfXNWRYNG+A9NlMoPqXGy3kT+ElPY7VTc816LBK4mStY3XL/TBQ
         uLG5dcUNrLPeykLEEeurvNX9jp9AplPdvPDucQy74NOmmF5LACoGoF6XYjGAOsgI7/mS
         3GPA==
X-Gm-Message-State: AOAM530T74mjoomAye+ky4rfIfKmCwVfticXM8alVJLc8gvfSl2gJphD
	uLTeg3vuVHLEPM+pakhnuuv5cg==
X-Google-Smtp-Source: ABdhPJxSVZUjjKCu/Z5pQSZqImDe/VdPv6+D1mXG7RzqnqfYRqC3IutbHGDwngQP/fzV/pFV1UOO8w==
X-Received: by 2002:a62:5f02:0:b029:13c:1611:6536 with SMTP id t2-20020a625f020000b029013c16116536mr6870569pfb.8.1599769278853;
        Thu, 10 Sep 2020 13:21:18 -0700 (PDT)
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
Subject: [RFC PATCH 3/6] security/fbfam: Use the api to manage statistics
Date: Thu, 10 Sep 2020 13:21:04 -0700
Message-Id: <20200910202107.3799376-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

Use the previous defined api to manage statistics calling it accordingly
when a task forks, calls execve or exits.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 fs/exec.c     | 2 ++
 kernel/exit.c | 2 ++
 kernel/fork.c | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index a91003e28eaa..b30118674d32 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -71,6 +71,7 @@
 #include "internal.h"
 
 #include <trace/events/sched.h>
+#include <fbfam/fbfam.h>
 
 static int bprm_creds_from_file(struct linux_binprm *bprm);
 
@@ -1940,6 +1941,7 @@ static int bprm_execve(struct linux_binprm *bprm,
 	task_numa_free(current, false);
 	if (displaced)
 		put_files_struct(displaced);
+	fbfam_execve();
 	return retval;
 
 out:
diff --git a/kernel/exit.c b/kernel/exit.c
index 733e80f334e7..39a6139dcf31 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -67,6 +67,7 @@
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/mmu_context.h>
+#include <fbfam/fbfam.h>
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
@@ -852,6 +853,7 @@ void __noreturn do_exit(long code)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
 	exit_tasks_rcu_finish();
+	fbfam_exit();
 
 	lockdep_free_task(tsk);
 	do_task_dead();
diff --git a/kernel/fork.c b/kernel/fork.c
index 49677d668de4..c933838450a8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -107,6 +107,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/task.h>
 
+#include <fbfam/fbfam.h>
+
 /*
  * Minimum number of threads to boot the kernel
  */
@@ -941,6 +943,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
 #endif
+
+	fbfam_fork(tsk);
 	return tsk;
 
 free_stack:
-- 
2.25.1

