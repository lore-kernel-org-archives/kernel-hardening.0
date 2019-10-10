Return-Path: <SRS0=JPrR=YD=lists.openwall.com=kernel-hardening-return-17000-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F9DC4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 10:32:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 696FF2190F
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 10:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMxQ4i0I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 696FF2190F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17000-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5798 invoked by uid 550); 10 Oct 2019 10:32:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5766 invoked from network); 10 Oct 2019 10:32:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSjz+SbNpmgCV+3FzbFoV2yt94hm0wG2AzV6rp22O6g=;
        b=HMxQ4i0Im6LYKIthqzBBSfaCgngtd704sC6sFGRxR3exF0/CgK20vro0YnSgI73vzm
         jjUzTQcTte0R7WLQ+Bsc3CKoO8To576CWjQKuNbEiO5FN0ezV2OTLVFbcs8xd6hm6h0+
         Dk2JwmhdOxq9mh7OjuYL3g/L5NhnLzbiO4s6fwU5C1+Sq5IEtlcKCHUY45LzTLXdyuHJ
         L7ouUE8eSLwxXx5fq74AAHdB/Sd0hKjzRM1Cey0ZSOfQRT1tKHrub32GSWmzRPn1fK+T
         RHYVOjWhv6D9QAMRN5/K/0/x3NKH/2lkzapHzJSVisDPnjmMRaCeUTyyloY77mrGZ0Wa
         hU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSjz+SbNpmgCV+3FzbFoV2yt94hm0wG2AzV6rp22O6g=;
        b=cf3O8dyiqDhhDkxPU0mppvYFXVnMpWAmPJJ0Yc3nq7WO2Cu/vleOUaZvTtsl43Tdno
         6zGIkA3D204Xnt/CCM5j7K4jQl04sRrMkfLMeOg7SeDbvzLiAhzXkIYQmOnaduVSPZ5Z
         rMxTOWShjxUZzEOqnMAjc5zowv0Jkp4NN8UlQLaiJq6WfDrpUF7wk5PuXZDORkz7BhCe
         vzIXEBFr5NI7/CiXmgdOUCSSFyEac2NsPP2riIA5m5oqVaJE0hZUUg3MEr+KUmdpPDw/
         4VLbeH0LCoKrbqIWoUdxD1/FvgeYkgd2mnJkqESFZ60a3perWc/qc9sxyl0rvWgMikQy
         nPsA==
X-Gm-Message-State: APjAAAUi32sqiUMFZcFnlc34qA3s4+aoGkU4xyI8cv0Ubbrrky+z76+G
	r1f/qUzDuHp9EMCFMus0pGY=
X-Google-Smtp-Source: APXvYqy3V9I1kVy5NtClOiZV3gl2KQC9Uu45Nw4MfeY2ZcGVohcZRtX5s99wQJtTQrrMmva1qdfvQQ==
X-Received: by 2002:a63:e750:: with SMTP id j16mr10628926pgk.30.1570703536762;
        Thu, 10 Oct 2019 03:32:16 -0700 (PDT)
From: Shyam Saini <mayhs11saini@gmail.com>
To: linux-mm@kvack.org
Cc: kernel-hardening@lists.openwall.com,
	Shyam Saini <mayhs11saini@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christopher Lameter <cl@linux.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
Date: Thu, 10 Oct 2019 16:01:51 +0530
Message-Id: <20191010103151.7708-1-mayhs11saini@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently kfree does not accept ERR_PTR range so redefine ZERO_SIZE_PTR
to include this and also change ZERO_OR_NULL_PTR macro to check this new
range. With this change kfree will skip and behave as no-ops when ERR_PTR
is passed.

This will help error related to ERR_PTR stand out better.

After this, we don't need to reset any ERR_PTR variable to NULL before
being passed to any kfree or related wrappers calls, as everything would
be handled by ZERO_SIZE_PTR itself.

This patch is verbatim from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on my understanding of the code.
Changes or omissions from the original code are mine and don't reflect the
original grsecurity/PaX code.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 include/linux/slab.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 877a95c6a2d2..8ffdabd218f8 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -127,11 +127,16 @@
  *
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
+ * Note: ZERO_SIZE_PTR also cover ERR_PTR Range.
  */
-#define ZERO_SIZE_PTR ((void *)16)
-
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
+#define ZERO_SIZE_PTR				\
+({						\
+	BUILD_BUG_ON(!(MAX_ERRNO & ~PAGE_MASK));\
+	(void *)(-MAX_ERRNO-1L);		\
+})
+
+#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) - 1 >= \
+		(unsigned long)ZERO_SIZE_PTR - 1)
 
 #include <linux/kasan.h>
 
-- 
2.20.1

