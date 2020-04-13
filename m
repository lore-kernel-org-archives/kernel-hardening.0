Return-Path: <SRS0=GwwG=55=lists.openwall.com=kernel-hardening-return-18498-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD77C2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:33:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7EF482072C
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGZiP7ff"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EF482072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18498-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18371 invoked by uid 550); 13 Apr 2020 15:32:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18266 invoked from network); 13 Apr 2020 15:32:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gf5VcvYy1cAH0Ap0D/jUeM82cMgA0P1gzgm89jB85q8=;
        b=dGZiP7ff6CjhSOUNmubSekzlbirdtPmp6jfkcy4nrV72SAa9ILWpPwLMLtFGd83ODp
         v4WQcZVDpZ8kyw2p251cOlfYRHQZFxWuYt5ZcrTTMmJJEl5igPM/sb5ztvHuK+6SHwMs
         lFYQrMZNvqTS4vAF4mbk3Di9fK2NlSydEm4zWcJIotr1GEA9IYYoyN7g3mUjXl+PJknb
         L201fdhpz8gutXwxBP6Ax+GgAuK4HD4YiAQgvqZ/i/8C5CvR/IdDp6TXn3kLQtPj3qLN
         GDSYjFP0TkQ8eE9r9hlcQc0e3m/7fXDyT0/Mj+lO7NX0RLz8NGUr8w8Wh14lTzUK4wyv
         I+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gf5VcvYy1cAH0Ap0D/jUeM82cMgA0P1gzgm89jB85q8=;
        b=FVdqDoc223PqD4Xfi7okFEHzhfpo/J3PHhs1O1Mv6yWVeQkMSCfO9bXaY48ElohYT+
         F3jCh7J2XA8fpst3SXOBbrv57EDR3U74ajm7IZh6zLRb8PYI6QPhV3vTw9PSKGcefWDC
         mf00ZmXktVomVbY/zOUi1pKYRIXFQ4s+q2UkChLrKYdGaWu9uyFlvZFZvsxbb8K1FQrb
         Q6yB6UAXiGlcERt4tq4C9Vv/g6ES9x5/T64EiiypuTgICqig7Rme1Py6h+NN2NfZLyw+
         42Me2jaBcEnk34BNNefO13hb09KXn7f2F3NehjhdUk87Q0UehV9I77Qkub8rFDPWzx+J
         n0Jw==
X-Gm-Message-State: AGi0PuaWjsiep47GJDgVmG5OyO84Wu8mk2et+alftgAW86caSEEliLUr
	GA9f5tBZQnnjqSgWPZHlWBs=
X-Google-Smtp-Source: APiQypLspRYJ334Zp+TMObREH5yu2fgWHgS+Q4xdiPFeqFAJyg8Y1soASPosBZnYff60EXOG2LWuBQ==
X-Received: by 2002:a7b:cf25:: with SMTP id m5mr20355266wmg.65.1586791952157;
        Mon, 13 Apr 2020 08:32:32 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 3/5] Hardening um: Forbid writes to read-only memory pages of a process
Date: Mon, 13 Apr 2020 18:32:09 +0300
Message-Id: <20200413153211.29876-4-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>
References: <20200413153211.29876-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/um/include/asm/mmu_context.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 3dcee05f950f..b4deb1bfbb68 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -8,7 +8,6 @@
 
 #include <linux/sched.h>
 #include <linux/mm_types.h>
-#include <linux/mm.h>
 
 #include <asm/mmu.h>
 
@@ -30,12 +29,7 @@ static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
 	/* by default, allow everything */
-	if (likely(vma_write_allowed(vma, write, execute, foreign)))
-		return true;
-
-	pr_err_once("Error : PID[%d] %s writes to read only memory\n",
-			current->tgid, current->comm);
-	return false;
+	return true;
 }
 
 /*
-- 
2.17.1

