Return-Path: <SRS0=lmAP=7R=lists.openwall.com=kernel-hardening-return-18923-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B107C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6433420772
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6433420772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18923-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9971 invoked by uid 550); 4 Jun 2020 13:51:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9905 invoked from network); 4 Jun 2020 13:51:18 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQF4gusMMse1t+P2Qqr0GcfguvDdOuRmX3WacGaJBcQ=;
        b=N4xFZgSpgAOjFJlGdEAmMQ9Ik989nxh4ExKKQLdtUa3p28xocE0WAhAj1sYbDbq5nZ
         I+nKdTAYPRzV1F8Etid3i2DuWu1fSYL8scyKVPH+i3Je5TXTg5hQJKIluxqGP3ou7zKo
         rzybmKInCWYqEAKwckcKV5MUs413ys1yUTna3BxDsR/AlNUOzGS+IUgNXKzHfUKe140d
         kmizL6rG9IBXnajJGYRC/+myU8r8sJZkzVLOIpGf67/7/HujFQRNWcNQQmio/cd4HS9/
         iMy32Ks9bubPMxACg/oQySQ08Pv8oIOsGxrugEjBVszhZrqM17WOcxRrP4MXFa7+56yN
         TFyg==
X-Gm-Message-State: AOAM5303P9SeIdefsRhRXEN3iGbHhuxINEiz4+fo4yppD7W6fjegGlsr
	WSZOLHhWyip0g1OgvtxIn00=
X-Google-Smtp-Source: ABdhPJxGDD5ukdedXoxuQ27N5jKq1fSsreuCe9q3nAgk5mstTvN2pJQfkeE/l29dSTZfbBg2leMMKA==
X-Received: by 2002:a05:6512:3214:: with SMTP id d20mr2637853lfe.203.1591278666991;
        Thu, 04 Jun 2020 06:51:06 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
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
Subject: [PATCH 4/5] gcc-plugins/stackleak: Don't instrument itself
Date: Thu,  4 Jun 2020 16:49:56 +0300
Message-Id: <20200604134957.505389-5-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>
References: <20200604134957.505389-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to try instrumenting functions in kernel/stackleak.c.
Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
is disabled.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4cb4130ced32..d372134ac9ec 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_RSEQ) += rseq.o
 
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
 KASAN_SANITIZE_stackleak.o := n
 KCOV_INSTRUMENT_stackleak.o := n
-- 
2.25.2

