Return-Path: <SRS0=soGu=7R=lists.openwall.com=kernel-hardening-return-18924-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F05DC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B354D20772
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B354D20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18924-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11431 invoked by uid 550); 4 Jun 2020 13:51:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11378 invoked from network); 4 Jun 2020 13:51:24 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b54SpJMSTOd6h+DBnk1Lku3f1oWBTa5w9a5vkJqB3fA=;
        b=YshXXe+fxWo4APPkrDVywSroRNbLLfT04UvRmD+l3UVKrbRO68KkcWpqgzqXtK0ZyE
         TWeXY0MC4+IoJ0O0xt8s+GcowBIqvr+w9P7rf5IZ36R33ASFxVQ1I1Sl/UIqW8s/Y/jb
         GDJIvp0gJ13yoo4uSz9V5JFgZ3XgPWGl86ciaw7xd8t2FwUfz8cBYjcJufseyyUzuxhb
         aCobmH2/rzv6i3yLoi+4AJIBFEy5MDrHKMXZcrKPGnoF8/3PzRoV1l2riC640yk5YNgJ
         q6WnZeCINJmzTYbE/D8A/DNXIFC7rzEJUk93Vqv468wRQCv9eYJM58pIPvmmf1/RlDIf
         unQQ==
X-Gm-Message-State: AOAM533PWzGabnsDOCNVWQo1+I3Y+3xKLafmYBdiwQBEe0C/ayYMbev6
	uPWIqhNa+B0f+Xnb5NUzg4E=
X-Google-Smtp-Source: ABdhPJwJN+QU/v5qwJyKhHL0R8cAYtbe3PO9Gpb/m6COOlcWqK5m8q5guhRTY5qY7edIDaq2chb7lg==
X-Received: by 2002:a2e:9dd8:: with SMTP id x24mr2410838ljj.304.1591278673307;
        Thu, 04 Jun 2020 06:51:13 -0700 (PDT)
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
Subject: [PATCH 5/5] gcc-plugins/stackleak: Don't instrument vgettimeofday.c in arm64 VDSO
Date: Thu,  4 Jun 2020 16:49:57 +0300
Message-Id: <20200604134957.505389-6-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>
References: <20200604134957.505389-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't try instrumenting functions in arch/arm64/kernel/vdso/vgettimeofday.c.
Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
is disabled.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 arch/arm64/kernel/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 3862cad2410c..9b84cafbd2da 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -32,7 +32,8 @@ UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 KCOV_INSTRUMENT			:= n
 
-CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables
+CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables \
+		$(DISABLE_STACKLEAK_PLUGIN)
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
-- 
2.25.2

