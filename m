Return-Path: <SRS0=RDOV=DG=lists.openwall.com=kernel-hardening-return-20031-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E018C4727D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:47:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7127C2145D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+2S/PVg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7127C2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20031-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25826 invoked by uid 550); 29 Sep 2020 21:46:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25638 invoked from network); 29 Sep 2020 21:46:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ldzGNGDZyBtUZ+HZEhFsle3HftCI7jj5VijuIes3XjE=;
        b=A+2S/PVgCIFIgqA1Y+x6xPf02q9T8t5ybB0PjXezPYyVniPZlLdcnNuT2gDH8pQxqt
         4DLm3YscI15WD0HXcWi6zP7QdgI6QCeIg3Wwy7DNEd8iL5lAZ8voCtgTv/8Ph33fQX5R
         cCWSLAJg2dq3VlRuefEs9TYNxSH4LM7WAVyGPxSW12MYXC5swunyjdO/MTHwRwXmOpj6
         zrw6Qc/V5h8ue6BziUtDKZMjN6MdmLK0e7IVaBoAq4UiLgXu2BjcDgz4VCICGb5V+2pt
         D7KNuJtao0SSq+uSZ5vw6TziaUeYi9eaMBYeiVf3XjvW5Jnms1loYQA94qhYeykro9EM
         +7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ldzGNGDZyBtUZ+HZEhFsle3HftCI7jj5VijuIes3XjE=;
        b=kTxG+egikWesrcs1LLQzyZeOCYEP7tEgGROoH2CNt+fg3olawerzGQ9O77NWlJHMgr
         8aO4z0k3J1lSuKK9PwnsDbucSaJOpqeHfhXPJS7hCm7WUzR7gk3wZi9GsuJeWv6C6OX8
         9s7nPGyNZsgI7Gf6GTFzhj9SjpMCzHgYvLkGOaaGedUebkjp9DesTuLXtt1GVVxxpSR5
         TAdHRv2BzIcPtlL+NFCRXXarVu9qDjZtnIAce0WD/rSgyiYKmpA+Ly1E058PWeIRxNkq
         SM+0M2ER7I7RTcK3TsDyyXcXUz8lBBMB1Yl86w1JSdIxYWYSncXQOcxMHERrlVnhqB2f
         zB9w==
X-Gm-Message-State: AOAM533Na3qUQBhRb+Jp5e4+qMcgD1/RwYvA4QsompWgIe0xpO5+antW
	OdeAbqqLWwmFVeDliUSQ2cJZAqsAGf7PALN3QXo=
X-Google-Smtp-Source: ABdhPJwwEUCuweR6zj+0aeaCy64VBGtyJJkwMN8XaaF4F/cSzy8beYdpFYYtw+WqPq9+tyjoVdIS0xOGdLfzbpSZCEs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:ad43:: with SMTP id
 l3mr8526653ybe.157.1601415995012; Tue, 29 Sep 2020 14:46:35 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:03 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-2-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 01/29] RAS/CEC: Fix cec_init() prototype
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
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
2.28.0.709.gb0816b6eb0-goog

