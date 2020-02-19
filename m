Return-Path: <SRS0=vNf2=4H=lists.openwall.com=kernel-hardening-return-17829-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B1AC34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 640CE22B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cu/THgoI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 640CE22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17829-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29974 invoked by uid 550); 19 Feb 2020 00:08:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29877 invoked from network); 19 Feb 2020 00:08:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0f/RzoyEatytyatThC+F3eOfN2v+QCCQ4NfkPjtyieo=;
        b=cu/THgoI4tMw6Hv/cnWQTiNWXWXUr6AKTVvfgPfzSMLj0kWYcpifZKdSq6w1+DteE0
         kXx8mLdQVe2X1IQWWOSR6Mh+Qa+NPbQfhsSgJqX39vvszx480CLksDEmmIFQd2vxoqY3
         1dP0HJ2lDnH66hEZo0ZFi1oE3hkU0IZ8oCsB7mmk/3IFcSboHkCVWkxpT1HW+h7VC1n7
         yOmJd+ZtmnwfszU5a6Kt86Lcv2GGAwqezGTfzkaF0JiBJgiasqm6vEx4C8j7oNaglBnU
         JfJ9UsRRTrbO7JD+RSG6YqwZQYiUQK+KI9Aw/1esMS/y9pSezRReN3CDnTr6Mdf4Z3gi
         lu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0f/RzoyEatytyatThC+F3eOfN2v+QCCQ4NfkPjtyieo=;
        b=DKjryUIsTgNq2khP1e4Sal6iAn0zn68Tpz4soOciPaug3sCp6ooIU9Buj+VZsIc1zr
         Ev/aDqokGzO+x+FwvnsAJmwvmPUGne+tDxbCCio6j+R10/6+oid/E6cXOjE/mfTAvTGp
         YrdI3++F7KPvxAoaN8ivdc/T8ZloVILi2cRapGkCSltlSWll+IDC7jNfQJalO1x6LWgd
         j/+XZGeCOhMx4AXyMdpxBRqEWIhs1D2O6z/R8nzTxKQf7oCtogW3I4RdQRKd3LvbSdDg
         Uqt0AKYC8ZimB8dcwsztpgjcklx4Wm3Fu+Gwh2bMTBLWD5eZIkalouiOtQ1zpAavtcA1
         z7MA==
X-Gm-Message-State: APjAAAWKVl7gxyz8mfjO5JAxfthCweYiGYNlUVtwZh9Bn8SE1YxLin6P
	fK8y5zQrBfeQq4aL3gLjzwh+3BzBEvB7Fn7zWK4=
X-Google-Smtp-Source: APXvYqw4ER8WovKBYQVVrHd0oyLZvkEq3WR7WVWTpyENeUeptJ25rnbegEbU6hsEORKa9iiI1OoS973GsI/tCw23qS4=
X-Received: by 2002:a37:4e89:: with SMTP id c131mr22333834qkb.5.1582070915273;
 Tue, 18 Feb 2020 16:08:35 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:08 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 03/12] scs: add support for stack usage debugging
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
2.25.0.265.gbab2e86ba0-goog

