Return-Path: <SRS0=yZKP=DG=lists.openwall.com=kernel-hardening-return-20053-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42CEC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 009FB2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VQOoXlSc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 009FB2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20053-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1902 invoked by uid 550); 29 Sep 2020 21:47:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1760 invoked from network); 29 Sep 2020 21:47:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dEqcNX1Djl0IV1+V4O1jZ3zX0CSjG7hkO+H8f2GKot0=;
        b=VQOoXlScak0WysBr/W0lMAFEgBmf32Hfw3oXYJ6KFr0fKBu3y13ZA46qQn/qdgZK8G
         i7ux8V3oo0qTphW/9JBrWhu78R0GtF1wBcMFmXjLpLEc7GSsvPNid7x6lav1uJEis2a7
         9W/iGpPEQWtZ88Ylf6C8QNA3xu3tblmY6b/lZ2G2WdHJgfBPHmhOTR1ICCMpX+ICACEs
         gkyzgzySrJUDgSqaEtM3K6Q4WXigD1N/jiQrFgmXGoYkLUA/xKM7BuINs/wO+fWF4DHc
         JWaw9z1iMdO3i+MVSCqHWvgzTM8qRNCbnWvbhhOBb0dwF6b5pI+bPyepJLJRhfWXJMhQ
         QkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dEqcNX1Djl0IV1+V4O1jZ3zX0CSjG7hkO+H8f2GKot0=;
        b=E4oLfvvmTXdl6YgMiWVjrB5g4dESVatrBKvDxA4dk0MSzI7vysmqzhgSeGHitUvESh
         ygyRAFMWcI8yWc4chadQ+zYYEU3hN3h5S8s3v3I8IFZqKBKCy9vd/AIsJgDGqAifYT1D
         JzN8HZn2nS/SivQyq+9fac7/oTRFKClaMo3Zr3G7brGyzBZVg1x970p8KkB2x3jDmeTN
         NBJzAhHeEmLU7ajjIp00R3EERiu3cUjN23ZqyyRrF6dScX2ANU9Pd0jdRJqvlDd6JDgJ
         d47BjTiJCwfnFIOS1QEfxPBENJZ/1NxOH/G0zA4kb1isGfq4kUmF29u/ys10+O+wMXcc
         GAFA==
X-Gm-Message-State: AOAM533IWK1a9W/MKEyr0jUz1M1IMRdb4Gk88NDaTpd1wiTXU+LhkvLF
	x5NRR/gu87ZSgFAFZXKR6yfp3JSqEaifJFd//jo=
X-Google-Smtp-Source: ABdhPJx3IHLlEpEE6lKzgLbRoH8pUHS5aZ5bMzeasJnHs8u5b0ZHEbgeZKYJBmfQeDJ5khZeV7Cye7dg816GPppPI2c=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:abc7:: with SMTP id
 k7mr6181365qvb.45.1601416045978; Tue, 29 Sep 2020 14:47:25 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:25 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-24-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 23/29] drivers/misc/lkdtm: disable LTO for rodata.o
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable LTO for rodata.o to allow objcopy to be used to
manipulate sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..dd4c936d4d73 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,6 +13,7 @@ lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
+CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-- 
2.28.0.709.gb0816b6eb0-goog

