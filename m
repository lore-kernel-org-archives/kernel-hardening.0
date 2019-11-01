Return-Path: <SRS0=WtHC=YZ=lists.openwall.com=kernel-hardening-return-17238-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8194DCA9ED0
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC85F217D9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TUOCiu9g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC85F217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17238-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32137 invoked by uid 550); 1 Nov 2019 22:12:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32042 invoked from network); 1 Nov 2019 22:12:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bw/qAOzuJX7ixoBqz2PQ7jd7OYMX5ZXLMotdDh+Bihs=;
        b=TUOCiu9gLsLFy3Xp5OD9ee3T44RBZ9XBgIe7yt7CvNj98C6CBu9wAFiKO2vk8DcyhT
         Ji59uJo30gvV4E1Mc6+k9TAjV16C8IiKMXK7G0oVHeV/PAz2/fCEaRJcdINYSGhgESYR
         uoDTe09Jv1qncBGnVBU6OT6bb8ZxBNJKvMf1wcI0ooElnCm2FCe3Y7+zQ6a97/j39xPN
         Mu+yrOgb1hl2vY4VIkbI6qMmyB8qwY3HwJfeslpY+sqKd7Pkx4hNMy+qAjpsXmuINSXH
         Hbqb76hzhJWPhHLLM3oT+0GxKRDzWsCq1m6N3+XuHnyEuX9+4K1XJa7mKQznVdZHeHhv
         741g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bw/qAOzuJX7ixoBqz2PQ7jd7OYMX5ZXLMotdDh+Bihs=;
        b=m0TRamu/CCzpvJcq6jaYJGHNIFRXlaxNbvdcLKdO0zeiL9f9XOSf3JzcX44Yb54cYt
         6KB/YBoRXU+oA4ujsymPCFF+N+yftYYhEBUj234JUqI1cJbZgI+BynuarKbdsWhN5v8H
         yz1X+firHud+eGYW+SpP6tXNpMiC+aHSwIFzPh4K2tY7oB4PcU1gqYwaZMZ26kg6Np3g
         wb18WTnyCnjZSMeIHSA3+/BPo90tG/V4B0u/ilfhAtTQKMJ6oiOO5eYbNm4uh7iJgK01
         4JlYf0FopjXHx6Ff8fU0LHonzxRJrSPSDmtcx0YUVXNXchUz6eMXCRLEfhwhfGYd0UFQ
         vs5Q==
X-Gm-Message-State: APjAAAVmuPU9knw/cqGHgQjoTnRtA0GrgpxW0Z065palaiXisRvfr9AD
	KEWN2q4mKnO5nX2LPXaVPcfsWkQ4pEWgCvnASsA=
X-Google-Smtp-Source: APXvYqx5AqsiV5gsrjTxTPakMbZqpZkpOWKFfa4kZ0m+C6pXJ6/DO3wHTK1s5AzNd4GAvsVbgqAkyBlJLNLHZ9Ye4kg=
X-Received: by 2002:a63:5762:: with SMTP id h34mr16176849pgm.235.1572646333610;
 Fri, 01 Nov 2019 15:12:13 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:40 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 07/17] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks. When enabled,
also prints out the highest shadow stack usage per process.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 7780fc4e29ac..67c43af627d1 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -167,6 +167,44 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static inline unsigned long scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = __scs_base(tsk);
+	unsigned long *end = scs_magic(tsk);
+	uintptr_t s = (uintptr_t)p;
+
+	while (p < end && *p)
+		p++;
+
+	return (uintptr_t)p - s;
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
+		pr_info("%s: highest shadow stack usage %lu bytes\n",
+			__func__, used);
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
 	return *scs_magic(tsk) != SCS_END_MAGIC;
@@ -181,6 +219,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	task_set_scs(tsk, NULL);
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

