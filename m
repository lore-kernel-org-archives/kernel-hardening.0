Return-Path: <SRS0=FRCT=Z4=lists.openwall.com=kernel-hardening-return-17479-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60FCC43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F17952245C
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXuPCZw5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F17952245C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17479-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20178 invoked by uid 550); 6 Dec 2019 22:14:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20031 invoked from network); 6 Dec 2019 22:14:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dSkqIg9MhTEqSRuUPD+wLwf3dmJwcSH5rhdG+lQGY0Y=;
        b=SXuPCZw5St6pvwTst8kmf5KElVFLKMFMp+CAkmkUaQLus5cyU/8kqr6V5JxAIwmDV8
         RWdDAn+WZ18vV4T9eqQoonAjHW3Rzl/rq+nVdoOiKpP2KO897WS7qgb0uHjTrgJkEo1F
         0w2fuPU7iE//Mhmc1AStldjXFL0gQujdjqFyhIQqo0PX3BYn+fe6w0aILNtXks9GiWbX
         y15Zqo4dF7akKdP8o3QHjsZgpRBi+Vh9QT2pwFLxPBRKjS+x9TmrUCopcszBpJQvv4wL
         EQLbAdHZz6TZ6uqyOto/Ft9UcaQoXc6w3u8Hni2mOOXu4O7zVJWi0IlEALO+ifSUBL0a
         F4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dSkqIg9MhTEqSRuUPD+wLwf3dmJwcSH5rhdG+lQGY0Y=;
        b=Ttw7LJXCfMpNwPK4N6uZE7yO0z68yt0i/MnXe886btWqsvO3AXYuOgbqsd/Hb9YKQ6
         P45XlTJ9t8LsWKBOYYIHRm5KvnY6ekT+BHnwsQaDSCdQorTgA0G2+FbrPi4xveY1Be7e
         T9A4qqTc0+kDr6L9PBGgW2FMlRQ1DQUxEyzreLYtY21pT0ivI4h2LSfPqKHhHSzVKDv/
         51zv4pshzjSOMyHiZ5Wvsu+FyZ6PjrwYMTyxzOP1Kq09eoP/qRA8O9RKc/z50WYbwNSh
         iMr4o0FoCW7J5xGWB2zcswDyyAlHQev16LjyjeGBZnIcz7NLYvV25MemTvTVJFHntq8N
         dqFA==
X-Gm-Message-State: APjAAAWg5N+/zLXGC/U9a6gUDtIqGM6wChrR7MSj+KdLbcGGrb8xfHTI
	BFH5aLqF7aEe+XDZx148TGp4haO/NStKS/9d4gM=
X-Google-Smtp-Source: APXvYqwr9gV3C2U9Vw8KNYzBqn9JcBiVcajDSJ2lm7uPyamXFOot36lh81Wh0+CfZKTc60xlWZW4gj6RW7XavjkgTmE=
X-Received: by 2002:a63:4b52:: with SMTP id k18mr5960727pgl.371.1575670454000;
 Fri, 06 Dec 2019 14:14:14 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:43 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 07/15] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
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
2.24.0.393.g34dc348eaf-goog

