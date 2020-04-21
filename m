Return-Path: <SRS0=R+s/=6F=lists.openwall.com=kernel-hardening-return-18586-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D89CC38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:15:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9ED7C2082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsWMsy0t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ED7C2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18586-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17769 invoked by uid 550); 21 Apr 2020 02:15:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17659 invoked from network); 21 Apr 2020 02:15:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xI7CPVWDT3QMUi6LNO2ihZsKVC6mOuE8D9NTHDoSwRg=;
        b=NsWMsy0tc64m0JGczaV7LdhsLlL0muqBD3WWfrrfmgnLPP65xuxkorBExS9/txu1L5
         Q2FJmS/0GsmmQwHFFjgD0hHMN3SkL6X6n/bRzCTBpT4oi51norYdtt3JUCFXVOjTMdTU
         zX8qkKvs2OaLrSgua66YBsJS5dPG7c4gwq9VOIKkM0/eRtYaRNYKG9cyZ+LyS4DClEmY
         pzaQabeig0ncHcCbBfaRPkwq2fH/qcg3/pcn9c8yO0GtAogCHIQRoSTaV4t4e26dPKt2
         J+40ix1dhL7f8bY+j+WCwuKnG8V6/Z8OrBwNRE8fUqsNlBYUL0T0J2gmXjjCrX5qDTjh
         JDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xI7CPVWDT3QMUi6LNO2ihZsKVC6mOuE8D9NTHDoSwRg=;
        b=kpuzxa0JGp9s658Bdjqz/qtXFT7G1MXwwZ7Kx/+Pc69ywPLGGlJIbNufQeXsjGQkqX
         uL7v0aJ1QVd5Ei+Kp89Y7yEwiWYTRTfxKRiuxBA3s7KgCC7OqCrIvx0X0DI0xRFocIob
         ybLeUUBHS3aKrsOL6lnM6gTr6w6lv7Mme/lVyjlC0USyjmP/naF9rfY8cbE4OcavtjAI
         nGAgfFycju5BlpSMYS2dhIvADIIZT2nqHtJv5VS/PBGfZ2cl/aNUNQfuMxx/Q6DKz1U1
         sTrBjLTPdHLcH/CkoYHBUdGKGJevTzAis34QT1MMI7UcIQDwqmD6qzBaX79VygJyQp+E
         mOBQ==
X-Gm-Message-State: AGi0PuZk/aA6WWfdyOWx+aGAsRV+8oo3Rx2pV0+1P4r3Lt5c/lsP7HoC
	kNfWpSo3gJxEuMv6RXTonaW+U6Z5YzpclqFwqTc=
X-Google-Smtp-Source: APiQypJjnJg3+R91MxtHFmJsG6lvv1/O5kXjFyDygKT9qrQWp/wDoIt6jjVQ8Gq3+RwTYIGrFi4A9oqrPtVBx7q8Lmw=
X-Received: by 2002:a17:90a:1f4b:: with SMTP id y11mr2841747pjy.136.1587435304444;
 Mon, 20 Apr 2020 19:15:04 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:44 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 03/12] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks. When enabled,
also prints out the highest shadow stack usage per process.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/scs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 7eea2d97bd2d..147917e31adf 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -68,6 +68,43 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static unsigned long __scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = __scs_base(tsk);
+	unsigned long *end = __scs_magic(p);
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
+	static unsigned long highest;
+	unsigned long used = __scs_used(tsk);
+	unsigned long prev;
+	unsigned long curr = highest;
+
+	while (used > curr) {
+		prev = cmpxchg(&highest, curr, used);
+
+		if (prev == curr) {
+			pr_info("%s (%d): highest shadow stack usage: "
+				"%lu bytes\n",
+				tsk->comm, task_pid_nr(tsk), used);
+			break;
+		}
+
+		curr = prev;
+	}
+}
+#else
+static inline void scs_check_usage(struct task_struct *tsk) {}
+#endif
+
 void scs_release(struct task_struct *tsk)
 {
 	void *s;
@@ -77,6 +114,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	scs_free(s);
-- 
2.26.1.301.g55bc3eb7cb9-goog

