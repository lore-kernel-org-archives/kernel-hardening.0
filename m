Return-Path: <SRS0=lBBr=AF=lists.openwall.com=kernel-hardening-return-19089-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734ABC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D185920CC7
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D185920CC7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19089-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3625 invoked by uid 550); 24 Jun 2020 12:34:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3598 invoked from network); 24 Jun 2020 12:34:05 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sHQzOYVDYH3ZNMAFgn6qFPgIIglqtoHHBWYdYcv8aA=;
        b=Whx+fyl8Yyn7L2pC9JY/VqqOb1EyjQ+ZY+fV2nHsuH7hWSZ3ScSfmEKy5HXqwMbyRG
         RopYG6XpSOX05jt8mh40pCODQn43ZcfwrWR3G3HBFUQjOiIhosgVJWJgAi5KMkoH2hs7
         oAkSiv7wnDvcZ2OIBzbWAYdLtdRsp8DhKADog54CYuzEipm8hvTTxHapnZ6ZSWt6aWm6
         c/lAmvjQ44enwrakhuwLsdotb9cIskp4EMGQPjZUX9L25T9gTS0fD8b5OwgIFsleljTw
         GlQtvY9SFpddkVXkkKr6arGgy+7/6L8PQm6AEvdN7LnMlz8lBf61rzuIUliI/tC93/ox
         AHuA==
X-Gm-Message-State: AOAM530l+hf4oyePhJ2ripUe6qlNwCu5Ub3uMzbIKq1KH2PwSJVsdslt
	BJtc+9ji9wEHg1Na+ohlBp8=
X-Google-Smtp-Source: ABdhPJxblUCjOrDANsgZy0tfdbktunxAZXJLdRpPPWkvHCUo+/qzdIkUPYVzbM2mylESz5Zexu9MIA==
X-Received: by 2002:ac8:22e5:: with SMTP id g34mr27227271qta.227.1593002033880;
        Wed, 24 Jun 2020 05:33:53 -0700 (PDT)
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
Subject: [PATCH v2 0/5] Improvements of the stackleak gcc plugin
Date: Wed, 24 Jun 2020 15:33:25 +0300
Message-Id: <20200624123330.83226-1-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v2 of the patch series with various improvements of the
stackleak gcc plugin.

The first three patches disable unneeded gcc plugin instrumentation for
some files.

The fourth patch is the main improvement. It eliminates an unwanted
side-effect of kernel code instrumentation performed by stackleak gcc
plugin. This patch is a deep reengineering of the idea described on
grsecurity blog:
  https://grsecurity.net/resolving_an_unfortunate_stackleak_interaction

The final patch adds 'verbose' stackleak parameter for printing additional
info about the kernel code instrumentation during kernel building.

I would like to thank Alexander Monakov <amonakov@ispras.ru> for his
advisory on gcc internals.

This patch series was tested for gcc version 4.8, 5, 6, 7, 8, 9, and 10
on x86_64, i386 and arm64.
That was done using the project 'kernel-build-containers':
  https://github.com/a13xp0p0v/kernel-build-containers

Changes from v1:
 - rebase onto 5.8.0-rc2;
 - don't exclude alloca() from the instrumentation logic, because it
   will be used in kernel stack offset randomization;
 - reorder patches in the series;
 - don't use gcc plugins for building vgettimeofday.c in arm and
   arm64 vDSO;
 - follow alphabetic order in include/linux/compiler_attributes.h.

Link to v1:
 https://lore.kernel.org/lkml/20200604134957.505389-1-alex.popov@linux.com/


Alexander Popov (5):
  gcc-plugins/stackleak: Don't instrument itself
  ARM: vdso: Don't use gcc plugins for building vgettimeofday.c
  arm64: vdso: Don't use gcc plugins for building vgettimeofday.c
  gcc-plugins/stackleak: Use asm instrumentation to avoid useless
    register saving
  gcc-plugins/stackleak: Add 'verbose' plugin parameter

 arch/arm/vdso/Makefile                 |   2 +-
 arch/arm64/kernel/vdso/Makefile        |   2 +-
 include/linux/compiler_attributes.h    |  13 ++
 kernel/Makefile                        |   1 +
 kernel/stackleak.c                     |  16 +-
 scripts/Makefile.gcc-plugins           |   2 +
 scripts/gcc-plugins/stackleak_plugin.c | 248 +++++++++++++++++++++----
 7 files changed, 239 insertions(+), 45 deletions(-)

-- 
2.25.4

