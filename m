Return-Path: <SRS0=f+Yj=4U=lists.openwall.com=kernel-hardening-return-18049-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A59C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 10:55:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E9E7F2080C
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 10:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5Mi9+vx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9E7F2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18049-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13573 invoked by uid 550); 3 Mar 2020 10:54:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13538 invoked from network); 3 Mar 2020 10:54:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/fUO4e7b7II/MsvOBnOdt5EEHTfTyNf7SrxUHQx+fwc=;
        b=l5Mi9+vx+ZJO9M1WC5+61AAmmM3bp8Hw0a0CsKTUOo4/BhrrHMMpdnTDGd35WOIoej
         QpsWGl9aw9tJsYgQOw04/Z9bnNHkovUELDhttcfPFhGBvC6iBJalLhqVyJFkeKs45xWa
         3T0T/pVrmZEqKz4kuSpy7pxarGbGaIT3TgD53WaL0tIn070kmeYO2yjtsb/BGtlydCKk
         g6IC5WEYKKSYPk0BKt7qEn+lW4ID+9e35uIm8TelABBEzMveIDgaw+4LQaG41s0uFWQA
         6YOxiMOEVtVjmJIKCq8O8T9Lb4Z+veIEj1KiEeuUno3g8jueaMa63c2hnLOtxTbZSGtu
         548A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/fUO4e7b7II/MsvOBnOdt5EEHTfTyNf7SrxUHQx+fwc=;
        b=qV4LzXwX4XOebxa8KDfGNrwY12NvF1a4yXBNaC7IF+aaCk8SURtGQYgj1PWUpZYTDS
         m3nU0HgwPOKvFUnG1p0O3ySWPUgnCNanrJkezUUMJJlLEv7Ew8x7HmaTRRUIznzHKoZ2
         AQd7HTLfH3L2inwpH1qhjPF45Rpk3ZbzuHNE6apxzd+fUzQLop/X2QftMT2+JY56tJrk
         WzvcbhF7lz8m3QjMBnlHRe/FIvIJwUNdeuCjOmqGzeQs0UQcXVb6u6+mqOwld3K8Goi8
         4Jlx2ELhQ19TGeUDOQxf6yO9bUvG5eWHBTa7jU6vLnxEDOgV4Ycvkw97T7FuXUu8TSw6
         LFPw==
X-Gm-Message-State: ANhLgQ07LtMcCPJ9IlnXnUbIjsbQE3XOp4XCQUcFvrZOIHv9Cfe9XiNW
	oAQfeWUK1PpomooUHuDDE6qEKmDlsg==
X-Google-Smtp-Source: ADFU+vvIpWaP146aRYIyU9FS4IRKrhW9VgsfBVun9hsWpgp12WBLpb9FBbP5XWgwahVSg+rt0tJYayCPeQ==
X-Received: by 2002:a1f:a286:: with SMTP id l128mr2460260vke.31.1583232882861;
 Tue, 03 Mar 2020 02:54:42 -0800 (PST)
Date: Tue,  3 Mar 2020 11:54:27 +0100
Message-Id: <20200303105427.260620-1-jannh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v2] lib/refcount: Document interaction with PID_MAX_LIMIT
From: Jann Horn <jannh@google.com>
To: Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Jan Glauber <jglauber@marvell.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Document the circumstances under which refcount_t's saturation mechanism
works deterministically.

Signed-off-by: Jann Horn <jannh@google.com>
---

Notes:
    v2:
     - write down the math (Kees)

 include/linux/refcount.h | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 0ac50cf62d062..0e3ee25eb156a 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -38,11 +38,24 @@
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
+ * refcount to nest in the context of a single task:
+ *
+ *     (UINT_MAX+1-REFCOUNT_SATURATED) / PID_MAX_LIMIT =
+ *     0x40000000 / 0x400000 = 0x100 = 256
+ *
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

