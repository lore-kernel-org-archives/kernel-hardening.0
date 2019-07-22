Return-Path: <SRS0=idXw=VT=lists.openwall.com=kernel-hardening-return-16519-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B603AC76188
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 13:45:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B8972166E
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 13:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B8972166E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16519-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9305 invoked by uid 550); 22 Jul 2019 13:45:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24098 invoked from network); 22 Jul 2019 13:21:25 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xdFD26pzy0BMDeFjS2w4OeuE3vbxUzI4nJ0HnGm5ug=;
        b=lt86FTgM1hUDMPbTxRnLkrNFRySeOIjfVJo9b9roiAtYlW6EKf/V67JpR9ffJB6uJe
         pp3K/xj0EGaX8qRbo7gP4Vy+PdijnM5w+Lem/5U9J6lJd3P3vhOAcpFWUeAdpyU06bP5
         evP0uOAJPKWE4xy2IglYtpRVI8iqhFbl2dica27wXDl1wvnmK5ZufGUplGq+TLslp6So
         Ccz1L0fSMV7VMFfjssuoe0l4h2HeL+5T7o5X46oRKHv54lwC3yqM68y1Vi6nHjzO8/pO
         f3SWWEaH+SCL/26Sqh0KBgZHM+c5v71hLJodfnsl7O+sTSOxFPlbzGKx7C+V9kY2EVxD
         0U9w==
X-Gm-Message-State: APjAAAV3FpsMaB4jQNu3Z0dmq0/16fNl+j/Umjx4YCQ8YKNVmNBSWvWe
	FohUe6NOukRuRxuFgYXtu3U49A==
X-Google-Smtp-Source: APXvYqwMNDPSQy9ey7HxRTb4UR6sXwjdyOcJy6lL3Od55VZGCNZO1lT9/D6hKg/gJFNitDWBaLbjEw==
X-Received: by 2002:adf:e843:: with SMTP id d3mr26317115wrn.249.1563801674266;
        Mon, 22 Jul 2019 06:21:14 -0700 (PDT)
From: Ondrej Mosnacek <omosnace@redhat.com>
To: selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Cc: NitinGote <nitin.r.gote@intel.com>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] selinux: check sidtab limit before adding a new entry
Date: Mon, 22 Jul 2019 15:21:11 +0200
Message-Id: <20190722132111.25743-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to error out when trying to add an entry above SIDTAB_MAX in
sidtab_reverse_lookup() to avoid overflow on the odd chance that this
happens.

Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 security/selinux/ss/sidtab.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index e63a90ff2728..54c1ba1e79ab 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
 		++count;
 	}
 
+	/* bail out if we already reached max entries */
+	rc = -ENOMEM;
+	if (count == SIDTAB_MAX)
+		goto out_unlock;
+
 	/* insert context into new entry */
 	rc = -ENOMEM;
 	dst = sidtab_do_lookup(s, count, 1);
-- 
2.21.0

