Return-Path: <SRS0=Sqvt=4N=lists.openwall.com=kernel-hardening-return-17908-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CABDC35E04
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91EF420CC7
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EyPcT46l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91EF420CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17908-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1080 invoked by uid 550); 25 Feb 2020 17:40:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1028 invoked from network); 25 Feb 2020 17:40:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0f/RzoyEatytyatThC+F3eOfN2v+QCCQ4NfkPjtyieo=;
        b=EyPcT46lQh9aSHtmCQLytlqbk6ZyOPPLjYX5wx5scKW+7DdNTGkOrtr8WuC5C5A+kK
         M2BFBAAJx6JVs3WDRKsHQLLRO9BpOo3t8S+EeXvYD98qVLGaIk4n8lhxVg48BDxFZjs5
         Nc6k34FDhn5xt3oOYDagP97Jkr+plBtRe7++kD55djqzKodwN+PGU4IxKwvZGNmFBXDd
         8QcN5Mdz8zndha20IVl5BB1PTfJZ9LIAOFGvbOHNSUOX3dDBBKVjDDteDI9+2tlyB8v+
         Ocw5Df3CWfNU1rJlsPH4eLU/NoQ8/uHEpJR3GieaNAhgxd6/Vv7NFoxf5lF0teYb4qv/
         fWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0f/RzoyEatytyatThC+F3eOfN2v+QCCQ4NfkPjtyieo=;
        b=dUg6pv5J+s36hLMybeRu9yly1JpAJnoXWAEpkwRSmw9oxQKkVRmQHZmZCbgLbVzZk2
         kijUyFh0q5zi83HniMvJX3fO8jUZ226gntbNcEe5OqVsD5a3iBESjJYEv9Tnsmw3fCcH
         Y+Eoc5S2meNNrMIA6N2Seserr0G6QziNYp5/ZtWnSG0k45xjAKcX7bVMS2dF31XB/Atz
         6dNv5TOJbE048cUwz9hQV25Zu+POUDx3SKA7QIv2L93IZ4Lo1phqb9RCcQJwClnjhS3H
         RMmP+Uae0dPfeF5MfIXO6AsRbFTEEctOBGK1HGmdubScZpbN7cDXmbamMQWwBy5kkD1V
         qAlQ==
X-Gm-Message-State: APjAAAVpnUuOGrTgFYHqPqslEKceunfWB+UMrRlQRjeHOMtk3tyfcK6z
	qq5qChFvmBfg9WbM11SOOsJ5VvYgve0/l8mduRU=
X-Google-Smtp-Source: APXvYqx4xojoNdX1jmjAi/7s33/U+0mXVBajNtGJvXPQGE5mjpgdpP3ETPZQPfufHi2tnyRoYGFEBUq0dG+s+BS43pM=
X-Received: by 2002:a05:6214:1874:: with SMTP id eh20mr53245231qvb.122.1582652393129;
 Tue, 25 Feb 2020 09:39:53 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:24 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 03/12] scs: add support for stack usage debugging
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
2.25.0.265.gbab2e86ba0-goog

