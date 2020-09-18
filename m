Return-Path: <SRS0=whKQ=C3=lists.openwall.com=kernel-hardening-return-19918-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959E1C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F8FB235FD
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SAoKEt/G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F8FB235FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19918-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13468 invoked by uid 550); 18 Sep 2020 20:14:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13388 invoked from network); 18 Sep 2020 20:14:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TqwpwA2qY0+meoCfIpHLXgNZtzIUgg9/FYqaJr/lHNY=;
        b=SAoKEt/G+wtGaNCEiPqBIUWaja1A3a5xAaghJ/k2HKUAWFgeK1QtV+lm2abWhnX5JD
         Lf1hWpMt0A3jqpXruVqakGZ4N4PzL5bDWgBRoB39cxdPpeOzfkkXXse9Da7EBLH6QszX
         yIQ4ps5QStAHLhzkW1GWCkPJtNZSS8s/HOHVJHh3mI37xrZXjV6JN7t2as4vjgpWd97H
         CN/1JCl9Z9jsIQ1IBYZGN/6gvrn4jzLfqwLse2ncX3sbW59FHzHrRf8VneE+RDy4N63e
         UjVJEfryi+4JjkhY1SGeecgO1nkIBXlZAGQENtM5mKEq9sThtpYLPTQWmgxN7MxHsXfh
         pLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TqwpwA2qY0+meoCfIpHLXgNZtzIUgg9/FYqaJr/lHNY=;
        b=AhLT+74/TSLKXeUwCJGDA2AxXQqBBjyNYQePLqVa3hP2aMDPBNXOJg6kaHcAJ2ItG7
         /iJq1EsRJy+eNP1Mjq3LNJ2HjkAfylKo+Rr/sXCXEBgauHpH4CZBkK27Djqc7i9PN7H8
         cCxxOEYmugcPMABeyU3rNc9a5fQaUQYJlNxOxxQ9NgOv5AVjDM/uNTXXOH8/B3bYtR3u
         aejQxWBblwIABnevI9vvRQNi4fyqZnXNpo6WTPdPVc5nK8m/9NnDzuUir5GKRaxFGA+K
         XuHsoCtO3LQfnEVaEmawhqZ4YBobBQbVrQZr/SWR/GURqzENJpbwRod4LAqrRwFwfc+Y
         k9cQ==
X-Gm-Message-State: AOAM532sKkN1agaiypX7HVLlPd+4BPvsWqoazU9ggPOv8TL2diBsLun0
	Ti1Iq/43PC0fVtOBdClSUMoV+B4M9KJgC504aXI=
X-Google-Smtp-Source: ABdhPJzOup8sE7kVTU78SL83JQa8xb+w2NlpY7pFS1w2EC6IHmBL07qIyuYvXqVu343S5bZmQVA9R2tZ1tsrCw5cNVQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:73ca:: with SMTP id
 o193mr30862020ybc.224.1600460083214; Fri, 18 Sep 2020 13:14:43 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:08 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 02/30] RAS/CEC: Fix cec_init() prototype
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
2.28.0.681.g6f77f65b4e-goog

