Return-Path: <SRS0=GlGU=AF=lists.openwall.com=kernel-hardening-return-19091-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C797CC433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30FA520E65
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30FA520E65
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19091-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6133 invoked by uid 550); 24 Jun 2020 12:34:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6110 invoked from network); 24 Jun 2020 12:34:27 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NYlBDYPOP+i+Z8CCPoWHLzBw8cVCy1kOHLCJDYgloi0=;
        b=Mxe3FX/8MJJFJrHLCJQEj3eHhwc6SWNIlNVrGrAdYWg0DE9RiPeb8G7DGXM8DFEQiI
         JmSTkxySI8vS6P1KjMQkNRXRSsy0ZG1yY6RHOlVs+f+vneN9T10fFnfSGflFROmr6QPw
         fuIXn3MvCoFcNQM4YTzgedsZf73BgT6/AtOSPPrLUVkd+5+Vw+/jpWXLd1PFPyOybg5j
         VryA2S6+4Ad9S3ch5abFf9Rsw7rqzeyG7WON2caS5Bj5K7HwADvmW99sysDcgsEwonGn
         g/2O2NqJ5F4QX/duhs0fuClARQMXEYfVGK+n+wgG/Ep+/CEJsJIRmf+CdnTguf3hzxVu
         sOMg==
X-Gm-Message-State: AOAM533GjULQ2aRDfOSLw5i+H/3Cc8jVYZOnukgyAoBrIw/0T5C8dEs9
	7hZXhlEqPZgmnNntGXaaDbE=
X-Google-Smtp-Source: ABdhPJxG56K9PcyzErynBCq8WXO4GdEN7iVHSozkebRt9XKZi/zlbyDg2T5l/cdnA0We9Seu6jAYtg==
X-Received: by 2002:a37:a785:: with SMTP id q127mr10507259qke.452.1593002055490;
        Wed, 24 Jun 2020 05:34:15 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	Alexander Popov <alex.popov@linux.com>,
	kernel-hardening@lists.openwall.com,
	linux-kbuild@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
Cc: notify@kernel.org
Subject: [PATCH v2 2/5] ARM: vdso: Don't use gcc plugins for building vgettimeofday.c
Date: Wed, 24 Jun 2020 15:33:27 +0300
Message-Id: <20200624123330.83226-3-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200624123330.83226-1-alex.popov@linux.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't use gcc plugins for building arch/arm/vdso/vgettimeofday.c to
avoid unneeded instrumentation.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/arm/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index d3c9f03e7e79..a54f70731d9f 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -29,7 +29,7 @@ CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 CFLAGS_REMOVE_vdso.o = -pg
 
 # Force -O2 to avoid libgcc dependencies
-CFLAGS_REMOVE_vgettimeofday.o = -pg -Os
+CFLAGS_REMOVE_vgettimeofday.o = -pg -Os $(GCC_PLUGINS_CFLAGS)
 ifeq ($(c-gettimeofday-y),)
 CFLAGS_vgettimeofday.o = -O2
 else
-- 
2.25.4

