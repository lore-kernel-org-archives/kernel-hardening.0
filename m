Return-Path: <SRS0=/m0O=AF=lists.openwall.com=kernel-hardening-return-19092-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF6BC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B69DC20E65
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B69DC20E65
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19092-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7880 invoked by uid 550); 24 Jun 2020 12:34:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7848 invoked from network); 24 Jun 2020 12:34:38 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dd/x9rNY52s67dtxhdU+GLjXuLmi+ISuyjz/CGrFIjM=;
        b=Tl1VRqbtt+F8eZuzCLpN3k4P4bjBbiByE50q0EMR4Jgh293zmGbBG0lk4optu26wvb
         Hd4b2a5bQZIXMgDsOkRq+YXftsKHghgLKkvfk9c/IIoisaMw7bTX0ICpOZecsUr5lvsf
         ipc8mim1ro6cvZi0uEypwko0MSigah/0kSPmU6eGn46XF4zTCVIvIMQDzHPKkb+qw6WI
         gjbr1cgRb9uDciKAsqtRhP4Uoiayj+ITkBxY6FjeXcTbr0hQzR0x5T1zGEkTFm6GQ8Sk
         LZm4scV3e62bGQkHSg/RHiC4/FHfjU8wdsp+UK1tehdmaRYMdGhbV8V2+vmgRuV+hpEW
         wS6A==
X-Gm-Message-State: AOAM530Aw4vGRYU/BNL0eohXRP/RbfomS/wR/IvAEb4R2yfMSMkJb2QW
	mlhBQCJqyiWRqnZ6i7bcoe8=
X-Google-Smtp-Source: ABdhPJyKNg/sgqLpXlRp5nWSXUg5BbFE6D7yhTpokmqzn6cNtEQ6n5ShWMctUFdRI9VD2lwP79MMMA==
X-Received: by 2002:ac8:5486:: with SMTP id h6mr6019451qtq.255.1593002066620;
        Wed, 24 Jun 2020 05:34:26 -0700 (PDT)
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
Subject: [PATCH v2 3/5] arm64: vdso: Don't use gcc plugins for building vgettimeofday.c
Date: Wed, 24 Jun 2020 15:33:28 +0300
Message-Id: <20200624123330.83226-4-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200624123330.83226-1-alex.popov@linux.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't use gcc plugins for building arch/arm64/kernel/vdso/vgettimeofday.c
to avoid unneeded instrumentation.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 556d424c6f52..0f1ad63b3326 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -29,7 +29,7 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv \
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) $(GCC_PLUGINS_CFLAGS)
 KBUILD_CFLAGS			+= $(DISABLE_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.25.4

