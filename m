Return-Path: <SRS0=32+O=CM=lists.openwall.com=kernel-hardening-return-19723-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2DDC2D0E3
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:31:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2144820897
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ppe0VpEZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2144820897
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19723-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17986 invoked by uid 550); 3 Sep 2020 20:31:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17884 invoked from network); 3 Sep 2020 20:31:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wTbIhLiuyTm+XoSeGxmt2GAAo+IvKYWaIE8cYk7ZU44=;
        b=ppe0VpEZBeDfsEU5ITwny6NkcdkxKAFIdZQ3UQnzTBxYV1ctHU67inW4vW137h4gBv
         nWXa8buMLxkA1rBskFYK1Eq0jsE+Qw/6BSGfBW65fCge+eKI/kv4A55AD2s+47ypACRJ
         cVE0+4wdwaCT6SrkHGr9ymZTLU8/wNLASZe7MqnKgh8hB4+OUomA4eJmR7t0BZXrjJW/
         LOvoQCoshN1779crEt6wAJjVHKmUtlw45dC2cFZP8uDI0DaAgpfMMNr88O/e/upP1nRo
         CSOVQI7ODlZsWF9jyXFOiYjx8Wwf0ptZxrDsx86udsnr+hYtU3KnXTgcc4ezeQUCHDis
         66oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wTbIhLiuyTm+XoSeGxmt2GAAo+IvKYWaIE8cYk7ZU44=;
        b=B4OC8gqMZVhuaZ8odlLytwTgnopcTZBHQThd8lfvRL7ApaZumwqojI/B+6z/D2wwsj
         4dNAug7zwryVWu80I8HLd5ykt5fSpg3biKt2sal/83XDDTK9c82/rhAtQLZtT71P6eBz
         w7GQNfenF0cwsYDyCWAgCNtW0W39/2e5TBEIyDcvgNMgHC93d4bG6awWqwljNVyP8k+8
         Ds4HYrnmLcbMxQuqV1PjMrpii3+ew4Je+K6AI8i/dx6ZtLoke5Oh9XRAKrQioXtIH7an
         5hs1aZgnyq2/wQhYdHOoaqO8wSo7sNhHHfM0FmXiajXUGY35BrMjak/KvCLuEd3Zly9h
         w5gA==
X-Gm-Message-State: AOAM532QGYOp5J4HoLg0HieqFXP4SC6HP1WZCWmG4lraTAVItPLZRy04
	FNuFIMn9rUe2sKmZjaM7l/t5O8U3YCeDb1VEjmA=
X-Google-Smtp-Source: ABdhPJyv9bEdV3xRGJWnQr7fgcxwXMprdZ7rQuE4G3j1pIhhWyO6nI10INeeai4ZhUeY9OF61z4g8Dh58X2KMzWpmUw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:a342:: with SMTP id
 u60mr3554884qvu.2.1599165062979; Thu, 03 Sep 2020 13:31:02 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:29 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 04/28] RAS/CEC: Fix cec_init() prototype
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Luca Stefani <luca.stefani.ge1@gmail.com>, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Luca Stefani <luca.stefani.ge1@gmail.com>

late_initcall() expects a function that returns an integer. Update the
function signature to match.

 [ bp: Massage commit message into proper sentences. ]

Fixes: 9554bfe403nd ("x86/mce: Convert the CEC to use the MCE notifier")
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lkml.kernel.org/r/20200805095708.83939-1-luca.stefani.ge1@gmail.com
---
 drivers/ras/cec.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index 569d9ad2c594..6939aa5b3dc7 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -553,20 +553,20 @@ static struct notifier_block cec_nb = {
 	.priority	= MCE_PRIO_CEC,
 };
 
-static void __init cec_init(void)
+static int __init cec_init(void)
 {
 	if (ce_arr.disabled)
-		return;
+		return -ENODEV;
 
 	ce_arr.array = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!ce_arr.array) {
 		pr_err("Error allocating CE array page!\n");
-		return;
+		return -ENOMEM;
 	}
 
 	if (create_debugfs_nodes()) {
 		free_page((unsigned long)ce_arr.array);
-		return;
+		return -ENOMEM;
 	}
 
 	INIT_DELAYED_WORK(&cec_work, cec_work_fn);
@@ -575,6 +575,7 @@ static void __init cec_init(void)
 	mce_register_decode_chain(&cec_nb);
 
 	pr_info("Correctable Errors collector initialized.\n");
+	return 0;
 }
 late_initcall(cec_init);
 
-- 
2.28.0.402.g5ffc5be6b7-goog

