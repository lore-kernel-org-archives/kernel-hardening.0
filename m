Return-Path: <SRS0=9oIe=Y5=lists.openwall.com=kernel-hardening-return-17307-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BE9C47E49
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:57:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8784F2178F
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TKd2so4t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8784F2178F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17307-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24525 invoked by uid 550); 5 Nov 2019 23:56:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24420 invoked from network); 5 Nov 2019 23:56:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rtGYhrlT+v4glRCgBr5KwA8OmlbDFJXwY4ztX1r8N4Y=;
        b=TKd2so4t7KdR/7IGrMM7dl1XICyaB7Ep2xb2K+L1YFpFhAdGCuA+QVKoOX+2nBhRS1
         PbhJFwrDkZsuR4g7Ll5jibhYYSoSbj6Qsk2MbBrD3K/3RVFYn3Ze4sq2kV7P6t82dOWN
         zANq01dIUJjLIJAHUFq7xMVXaYxiN41idA7UoNEeJpkXFp/ZWlp+zSbMC4BIJqBb48KR
         4Yz6i7rx8RTibsrTijP0CrOXXl43bw03Swi1hDDM7ENVWaU1ch5tyPwrarZdzghv3p22
         6EIfdhBRrf+kmU4AHHY+5aG/aq0yLasD+4SyCQWE2lPdStxSTwo8liAyHr/FcLSygxFM
         ArVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rtGYhrlT+v4glRCgBr5KwA8OmlbDFJXwY4ztX1r8N4Y=;
        b=jFdOehIYh4XJGB76NxWzQ5f5dJ+P/VQ+jLWSSxTlqAFBg33iBDPJNnrV6ciRmT0MlF
         Orm4lUzUgJEQaYQEoqciN/KA4pvQF62P8Wq9P5R9bpen1D4yzR34T7ZTDJMEOVTu5FyX
         wn/ZGBo9pO+oqEre1J9nb4grwNn6YOXA3277NvICiHaJkV/ckd4MilKFHWvx2D/OW/bs
         8tshXNzPuee9sAl6+WybgP2sKIjhLgUiqifUg1Yh97rWiohQUQdpJWNMA3pXoF+xs+e9
         chlMrriNt8yuUjjWDTeiN8+M9t0lITr2grgXZBfajL+VUPcvtrwLcdLvucsWV2DAf22K
         SGVA==
X-Gm-Message-State: APjAAAW1VJUFEXDwawqiI4BtbpVOg0PCwxZgi2tfrJ72Jl2Gk9LhYobA
	+GTehniLANJkM1pfchVDS/IGRvlmxcGfh6a3Ogw=
X-Google-Smtp-Source: APXvYqyeiXNhg0SMmYGCzlPE1MJNPVlZmSKCnBjsXssOcDuiJaeCfp0JdeBqZLhwpNQMgciNZVJzMgpXUPeRRsEDFOQ=
X-Received: by 2002:a65:6149:: with SMTP id o9mr5335991pgv.228.1572998195111;
 Tue, 05 Nov 2019 15:56:35 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:01 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 07/14] scs: add support for stack usage debugging
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
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 4f5774b6f27d..a47fae33efdc 100644
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
2.24.0.rc1.363.gb1bccd3e3d-goog

