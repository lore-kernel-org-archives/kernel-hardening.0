Return-Path: <SRS0=IwS2=5W=lists.openwall.com=kernel-hardening-return-18433-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4DDC2BA17
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:42:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BBEE42496E
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IPPdkNAe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBEE42496E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18433-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23966 invoked by uid 550); 6 Apr 2020 16:41:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23904 invoked from network); 6 Apr 2020 16:41:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ummeb//L4UGzSQ9YmLkDAY3kIJvHpvVlDZif3GsciVU=;
        b=IPPdkNAeCJXNHbsXe/mGa5z+wBWOy0VNpPvPMMCuc5EwpOHxDZY3dzEwp7Z9q8+A+6
         mhsuX7BenNoOfFBKR2vXW+Llg8rWZeo4jTI1ptL1eGZE/asnMxQpJUAUfYi3BJXd7MG4
         h0qQK+DY9jclc+sAdLOTRMBATVdbAqN5NRIHqlyT0D1+Fo0Gd445yIwHfWRAfFnusS77
         HUjqk5/F1uJieIRQySJq4jsWcZe28h1QPbCvmrKMLo14OqtT0N2cLzM8APA7TdFwMXtN
         WPwc7ygpjmZ2rzLIeLKsG3/w6/yH4WdpnZJ/ARDydbD7hwXi5d+x4Y6UIpOR8Ph3Q2J4
         kjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ummeb//L4UGzSQ9YmLkDAY3kIJvHpvVlDZif3GsciVU=;
        b=goi2p3pDDrafhM+Suy83VqFXtmdSGi90lLoCJ3kk7UsgdbumpMZQ0XZipph6VCY1Di
         yaSXOFMJ7JEnVcUov8llj0DY94bzwK6U2jc2j7ngyUQeEG8h2FqQuVFWUSI4fwEIKRhZ
         kaE7ieuVomk0p9cUVfe/hkm0Mgji0Z5Uug3c9diiRQrECgleMoVCAatV2AikH1iSXaCA
         FpDdno43Bb8ZQzqfkVsq/mOBUoztOhGoRND5Qp62Kk/2f1BxEuNcE0qLUtcnnBU/oP9c
         BdCamD8+yAgRYwFAuozwcEk4US6D0YSwFdDwxzIa3pz/+PM9Ca/hKigce2IEcG6VdX/z
         J2nQ==
X-Gm-Message-State: AGi0PuZua7a1qJeM8O288zvqBuZqZ4a4XJuOEbEe/ukfyf/153d0ZtvR
	FMP4hedB7imTClRGGS05hHHKDO34lNwTALttM2c=
X-Google-Smtp-Source: APiQypLfMllChVStp0nVVJRc46ooIEmPC5lxhHr5UbQWQtwRSJW5jYCIR/c33rb1nlAjMKVaAFGW/fG0jdBYpJoZ1PU=
X-Received: by 2002:a17:90a:20f0:: with SMTP id f103mr196700pjg.88.1586191297993;
 Mon, 06 Apr 2020 09:41:37 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:12 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 03/12] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
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
2.26.0.292.g33ef6b2f38-goog

