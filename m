Return-Path: <SRS0=99b0=3R=lists.openwall.com=kernel-hardening-return-17624-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DED7C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C0D87207FD
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFhtOIbc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0D87207FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17624-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10080 invoked by uid 550); 28 Jan 2020 18:49:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10002 invoked from network); 28 Jan 2020 18:49:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FRYMM1qoPJhfGiG5OWEbx13i+2jzqMbf4H5LKO69CQU=;
        b=bFhtOIbcQrF6W7S50FwloXQv+gTL5Dc0/6XP56oKBenHYm98Yng2U+I5p+qfHPMNP7
         mXKjOy2wZeSKsZJWMowesjW4wlTddLLx2SWrJGP1ociyoc0epkZJ195SG9At2F1opp+V
         URf8CAqfz0aQ5kqzv3bn8idQIQzoYDL09b3SPw8hvTei18qiFg8BWL2mg+W23NxWD4Dn
         BM/ESuqDVdaUzuu5N78ZRANcwg3lkwkudz/DtF5we2gTsj2TLlVF6wIGzuFOmBhEVKFz
         OYg50S5qLuXvI5upqlHvIYXnxRCpTwSCa4SRI1VNfKjWKA80nVrA1G8NvIVhrLHLfAOP
         y+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FRYMM1qoPJhfGiG5OWEbx13i+2jzqMbf4H5LKO69CQU=;
        b=R7yA9KgO/dChADJqIT8FVID2CLzwsS4gMklqsJSHQkdxJVvjSBnfMcGL5ohYguoizU
         l7k+qAw2PW0MYb/UYLPHud0fbEiu9TmedEIZDAkl6Pw2nYqPbQ/czT5tn9H7sbNYlm6I
         Kv7EtTQLY3snoUgI69xhjBi7Y/P52/gEOuArMqUeVnI5lYHOAkjNiOVNFcgoQxjYd7ZS
         44ig9HCgy8tDDleKt6OHWODF9TPGnehDRM8vGkvs7DLsa+zLeAyly2BScFex068wAOh9
         iCFxIFdKx27qTQuOdO8uIaJ+VoBV8gVrESXgs8Lldszn74AtMTjBUlDK/83n/bCap94Y
         WD+g==
X-Gm-Message-State: APjAAAXJhX9p5CJGY6qhxdFmqAGtHd67nZlGCN6h7HI2KpqwTZX027NO
	YDCsGNdEJxO+EGpAMRQitl2nyvGvpob9uzMzWt4=
X-Google-Smtp-Source: APXvYqyk3gN+DHe7EMl7P65uc0diXH3phSSCxxDmawR0hdhYLtL89vUyklWkmNMJY3GUoAEL69pRLvjhdLmm1fCjGgg=
X-Received: by 2002:a0c:fac1:: with SMTP id p1mr24192377qvo.231.1580237386265;
 Tue, 28 Jan 2020 10:49:46 -0800 (PST)
Date: Tue, 28 Jan 2020 10:49:26 -0800
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Message-Id: <20200128184934.77625-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200128184934.77625-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v7 03/11] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks. When enabled,
also prints out the highest shadow stack usage per process.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 5245e992c692..ad74d13f2c0f 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -184,6 +184,44 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static inline unsigned long scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = __scs_base(tsk);
+	unsigned long *end = scs_magic(p);
+	unsigned long s = (unsigned long)p;
+
+	while (p < end && READ_ONCE_NOCHECK(*p))
+		p++;
+
+	return (unsigned long)p - s;
+}
+
+static void scs_check_usage(struct task_struct *tsk)
+{
+	static DEFINE_SPINLOCK(lock);
+	static unsigned long highest;
+	unsigned long used = scs_used(tsk);
+
+	if (used <= highest)
+		return;
+
+	spin_lock(&lock);
+
+	if (used > highest) {
+		pr_info("%s (%d): highest shadow stack usage: %lu bytes\n",
+			tsk->comm, task_pid_nr(tsk), used);
+		highest = used;
+	}
+
+	spin_unlock(&lock);
+}
+#else
+static inline void scs_check_usage(struct task_struct *tsk)
+{
+}
+#endif
+
 bool scs_corrupted(struct task_struct *tsk)
 {
 	unsigned long *magic = scs_magic(__scs_base(tsk));
@@ -200,6 +238,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	task_set_scs(tsk, NULL);
-- 
2.25.0.341.g760bfbb309-goog

