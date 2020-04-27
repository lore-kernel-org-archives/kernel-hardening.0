Return-Path: <SRS0=s5my=6L=lists.openwall.com=kernel-hardening-return-18639-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4468C54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:01:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3E2F2205C9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LKPo6Bc/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E2F2205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18639-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11715 invoked by uid 550); 27 Apr 2020 16:00:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11643 invoked from network); 27 Apr 2020 16:00:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kikYfFSTfca/HkjJiT4VwZFMKgohIqKorfyIql1wDNc=;
        b=LKPo6Bc/Q5MtQzUK3oQa6NKadNaC15z3lO/zjdaounxLr3Yr/P6IlUdUGblL+xU5k4
         spAtU8NF5ubk32gUq0m5VXjp6kv3GAFhZ4b47WHO1jV9Re1P0wgxqNnIy78PYlqK6iHg
         Lz7JdX7MXdIx+DHcDceIZRSq68+3ppbTa32fDBBMVQUsXCdSeZ2Rk0+iayOXLcIpH0mh
         1y8jfaqoFffOSgqi3glfbRygtn76YwRgqeTcaTsWT5Ma8vEPSbQu5Sf1lQXSpiWIQ5jH
         osRX2DeCrw1RtV2JiczAkw6ANMNeNCpzDPw4w/B5fxj55cgpesof+s+eghyxXIYIpJqz
         Cp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kikYfFSTfca/HkjJiT4VwZFMKgohIqKorfyIql1wDNc=;
        b=Y+UkuGAZLnOe8kFVGhmYyl+6FdRlLISv6+xxjWajW6T2E5oB9zCphloR53GJ25vlVA
         NW83fj8QJPye/egyWQEnEBHpav2tLF0SQ35f9mC8Z4C+cTZ+Wyc9Gwl9PxpEgLCsgXo7
         HgRmgItBbaeF7ZU3aK2KVFvZ3o5Qn+cW4FoVbBVO98SLifZgX33GO5MkzC12bmlcWFv+
         Fr4MC+7+8M10sYs7Ls7g6DyW5mtOjGEpc/mlT6sO5D39vc56lPFbdtcuT0d+eu9h5Fj1
         R3H/L2uQ6LJMELVCvJdwOpe8ZK4IfoWd0fVevB/W0a8BR7euCVMj2uoDM6qqcHwvCoF8
         zIlA==
X-Gm-Message-State: AGi0PuaAgqaPGoI7msxJeRMh158ccDn4paAq9lWe7IvI5vvaYbbZ/26S
	ndGsN/GPyd9lILRwcoqZTv0E1mPrXKilu68+VdE=
X-Google-Smtp-Source: APiQypIgO4clcO6Z7kvhUaBuvYACtL+F9hDoKmeBmaTp5Edf0BzJT+qKnh+MwC69KhaGLcQ8wc5C0JEBbMo44i2AOQM=
X-Received: by 2002:a25:ddc3:: with SMTP id u186mr36888616ybg.383.1588003232559;
 Mon, 27 Apr 2020 09:00:32 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:09 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 03/12] scs: add support for stack usage debugging
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
Acked-by: Will Deacon <will@kernel.org>
---
 kernel/scs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 8769016c714c..2a96573f2b1b 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -68,6 +68,43 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static unsigned long __scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = task_scs(tsk);
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
+		prev = cmpxchg_relaxed(&highest, curr, used);
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
2.26.2.303.gf8c07b1a785-goog

