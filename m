Return-Path: <SRS0=qoDG=4T=lists.openwall.com=kernel-hardening-return-18043-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CF3C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:54:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 782492467B
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q/AGgvBt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 782492467B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18043-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3915 invoked by uid 550); 2 Mar 2020 19:54:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3879 invoked from network); 2 Mar 2020 19:54:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=86LZFv4eZo53SSwyBwzfXdxODBVPa+iTavg97swv4R0=;
        b=Q/AGgvBt+xOk3jknddfoshOdwqoMXHa72ijlNLUSyAFI9TZp9avXFsIrqc2J9cp2oO
         tQyBy42R6/lBwYoaCl76Z8ii6SUmy6KPU8ZyUqIizvUi7bSKAiekIGJKQRlXvZUmdjat
         R4zIHASKUgWOuzrcUQWO3P7eKcIiZtbDbLoVo2CmqWdsS9QA2v6neBspKQtHroJQDkNJ
         m7BVZSaeE/M4sCXUeM37ugqNqyPmEc2Ozns3hyw+6WWLJkE7nUlTrBD8g72QrBOnEumc
         77Ll4R9QgGVPB78qmV+rUbrTFPQjTC73d9WvfTHfJs1LiBRhyFR0Jkn5Ns9vvs9OmijI
         GKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=86LZFv4eZo53SSwyBwzfXdxODBVPa+iTavg97swv4R0=;
        b=AJdRlSaLpmwFY8zyryi0HF4Lh/KtL76UfMRBg7McVpQhZrsXLatsRoAupwB54uhwvi
         f0i/eGxinUGifScxTaysBEo62vT/0UyhTVw/GCB5x0WhbynTpUUz/hXiJQWiFSUU88qW
         b2bFgw26YUy1BE6MVNaY8GMAiEO/ucywZv9NZX6ubHhAf9ij/Jey+f/DdPUtAvjudo5M
         2SUIp584JwHiz39k7+iicZU61Cy5oXuJk02dQGnejPXgzDACdlr0Bxxx9UHMBIpZvHlA
         HdxBewuJZMWzciLVhLdSfvb+PZsM7zjoq9H9LDb5WREPKIrJf1Mt87rIBbyDMY4mbIBS
         HKQQ==
X-Gm-Message-State: ANhLgQ0SEdY3hHfJXPaX8vmgdJDdQ1zJcLEAHpTImkSDNUKEfQD457Ev
	J0ZoenxtSgUNclyZeKyYtq6z+gJ3Xw==
X-Google-Smtp-Source: ADFU+vt/9SCyMTvBNmBtQ0AELHNBGv27CwG9g8XXMbI1ACGrYgB20YXt8HjBJ2lJhCFu/FwKfBa4nYBIig==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr1215093wrr.410.1583178846987;
 Mon, 02 Mar 2020 11:54:06 -0800 (PST)
Date: Mon,  2 Mar 2020 20:53:52 +0100
Message-Id: <20200302195352.226103-1-jannh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH] lib/refcount: Document interaction with PID_MAX_LIMIT
From: Jann Horn <jannh@google.com>
To: Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Jan Glauber <jglauber@marvell.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Document the circumstances under which refcount_t's saturation mechanism
works deterministically.

Signed-off-by: Jann Horn <jannh@google.com>
---
 include/linux/refcount.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 0ac50cf62d062..cf14db393d89d 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -38,11 +38,20 @@
  * atomic operations, then the count will continue to edge closer to 0. If it
  * reaches a value of 1 before /any/ of the threads reset it to the saturated
  * value, then a concurrent refcount_dec_and_test() may erroneously free the
- * underlying object. Given the precise timing details involved with the
- * round-robin scheduling of each thread manipulating the refcount and the need
- * to hit the race multiple times in succession, there doesn't appear to be a
- * practical avenue of attack even if using refcount_add() operations with
- * larger increments.
+ * underlying object.
+ * Linux limits the maximum number of tasks to PID_MAX_LIMIT, which is currently
+ * 0x400000 (and can't easily be raised in the future beyond FUTEX_TID_MASK).
+ * With the current PID limit, if no batched refcounting operations are used and
+ * the attacker can't repeatedly trigger kernel oopses in the middle of refcount
+ * operations, this makes it impossible for a saturated refcount to leave the
+ * saturation range, even if it is possible for multiple uses of the same
+ * refcount to nest in the context of a single task.
+ * If hundreds of references are added/removed with a single refcounting
+ * operation, it may potentially be possible to leave the saturation range; but
+ * given the precise timing details involved with the round-robin scheduling of
+ * each thread manipulating the refcount and the need to hit the race multiple
+ * times in succession, there doesn't appear to be a practical avenue of attack
+ * even if using refcount_add() operations with larger increments.
  *
  * Memory ordering
  * ===============

base-commit: 98d54f81e36ba3bf92172791eba5ca5bd813989b
-- 
2.25.0.265.gbab2e86ba0-goog

