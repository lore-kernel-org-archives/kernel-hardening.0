Return-Path: <SRS0=fVUQ=VF=lists.openwall.com=kernel-hardening-return-16386-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE35C606BD
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A32452189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kX90Ll+0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A32452189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16386-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27688 invoked by uid 550); 8 Jul 2019 17:49:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26567 invoked from network); 8 Jul 2019 17:49:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0L49s/tWIr71dLFXxs4rfeHHocb58NImeCdr+Rzo5s4=;
        b=kX90Ll+0cRk6+cX3z7g100Lvynrw4C5hMo5BnzRzRtlwGM1SCgzPgr8cWLjxOwF/BH
         B3ujW2/jzYFPNZVRkZ9z+ArIVfQTIDSQ5sOGukWTuGC+K8GbG9wRsTQHtuuUpJTWWNBc
         l/tmk51wikJRccwc1UT3lvcAgVY397QRbxcpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0L49s/tWIr71dLFXxs4rfeHHocb58NImeCdr+Rzo5s4=;
        b=lrbuGNnHYyT/iigSvgaCrKOMHjfyeV5XGGwsI+qXhjiLXZMEicZHKDSNOfc40oHXp9
         jlMUVwJOxYioFhtdwZq2NtzcvEjSV3JDl9epIhxgNew/lQ1CUuE4lCR/HmXBibyQ7WPD
         nH9tGpTVJY4LJY0LkQGdLjVqV9+FQwVPvlyJrbga0ReaZneGokf8raGx22Ll8yE+Dm/m
         op1UVUIjq1S6dX5qXBjhrL4IntaZ4zHg8oXE8E4cEENWOskDen5hkge8z1PFe/pZwnKL
         mMQ4oob3s1zZPv++TMTy2tLuPdXreigkjLqZgwbMhUb0uCMHTXC2tNHas/02ywe9ViX9
         yo4w==
X-Gm-Message-State: APjAAAVztjQQYg6DUb/GQdhjNv3SHE4mBDUN+yzXkDRLb+ImQV3Ogy03
	SC/0CxxYrSeontUtgckHGh2nOTwVor4=
X-Google-Smtp-Source: APXvYqz/KlBgj7sxPbh2laDw0LEqUS36n2xByyCuU9PYhQLrDTew/w1U79e8dcnArD+lta4tuhReaA==
X-Received: by 2002:a17:90a:2430:: with SMTP id h45mr28211684pje.14.1562608168271;
        Mon, 08 Jul 2019 10:49:28 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Jann Horn <jannh@google.com>,
	Nadav Amit <namit@vmware.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 02/11] x86: Add macro to get symbol address for PIE support
Date: Mon,  8 Jul 2019 10:48:55 -0700
Message-Id: <20190708174913.123308-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
compatible with PIE.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 3ff577c0b102..3a686057e882 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -30,6 +30,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.22.0.410.gd8fdbe21b5-goog

