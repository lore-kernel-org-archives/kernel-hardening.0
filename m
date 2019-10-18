Return-Path: <SRS0=z6gW=YL=lists.openwall.com=kernel-hardening-return-17028-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA459CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 132F621D7C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uErhWC3l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 132F621D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17028-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18385 invoked by uid 550); 18 Oct 2019 16:14:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9956 invoked from network); 18 Oct 2019 16:11:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+oBtFp6IQZ5946CFExp5BXllfwypP5AUtOYhvu+6eDg=;
        b=uErhWC3lFP8THQ9YjycpXkAl85COCd6lh+RqxQAfdCNUSVTiEfspc2alvbCgArV2fu
         ls4p2vGwJ3M8+8dC+pxUbBcocxnmbIOx1oZI7haycpR/idqzr0yRfNB9QU0r3L0Ad+LB
         AODIdu+bBRBco2jvuX999sV5JPTfKSeK6DQgqagm1V48qwgIQ9QQo3kPVBNgSxrwUzDc
         J7z1g1ZIddJjuwZ9NXT+KTuZuEnEru2YIfSdVRPO6N1MNFiWgJDAJs9A6AicwQY5z5mf
         Ozj1xQ9RCTG/l6zakh/4DEHsBfg5zP3zC8lFWduaZXJzlKOfJV8siLAxWkKPzGoNNYpY
         BIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+oBtFp6IQZ5946CFExp5BXllfwypP5AUtOYhvu+6eDg=;
        b=XoRABYusdRVQESPC/oOLNKmM7b15trDvk7bxhsgcBCsrnC7/VSnOKFUeQ7Lk1eEy9+
         E9K5g0HU+tWwDJy2nqpn4rKZpQAep/UOqy/CgsjCzezAb13wKW+ym4mJAzlKPqUJ/02y
         DVNw2Paklh8j/PPmcmh2iSnonUgwgtb7RLcMdOxxVaIs3koO1Veb3cq373DO+ux6HcJg
         3fMnCLr+7QeO6ynZ03Uog5OtLkhsMjE+DUdsS3n5Lbig+VF7tWWnJPpacnNh1Rv5c0t9
         zdAqlUVP44edNU5oCt4Z9zSRtG1hhn3QlI3IJl1iwUNqMZ2otckED2O/WLOzZe4PPHPk
         pTpg==
X-Gm-Message-State: APjAAAUVJ7fSbpGXA7++sJXokV644XkOU/Kh4DvgNzP4p7uqYTbIeHqN
	x9c4B9QqILxRlv8GVLoGM8RLTsL+5RRXGPvto5M=
X-Google-Smtp-Source: APXvYqxHqmmpD11MJRO6yuoyBvltYKFWJkQq7UxJVT4qvc6swUR9mDIPTvziXaDvcDGhe+mECq8Qr7PX0sGP/3daZE0=
X-Received: by 2002:a63:7845:: with SMTP id t66mr10836733pgc.31.1571415070584;
 Fri, 18 Oct 2019 09:11:10 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:23 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 08/18] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 0e3cba49ea1a..1ec5c5a8dfae 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -161,6 +161,44 @@ int scs_prepare(struct task_struct *tsk, int node)
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
@@ -175,6 +213,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	scs_task_init(tsk);
-- 
2.23.0.866.gb869b98d4c-goog

