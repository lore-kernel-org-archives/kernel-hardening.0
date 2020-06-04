Return-Path: <SRS0=NS1O=7R=lists.openwall.com=kernel-hardening-return-18919-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41E9C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:50:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2AE8A20772
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AE8A20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18919-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5606 invoked by uid 550); 4 Jun 2020 13:50:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5573 invoked from network); 4 Jun 2020 13:50:49 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/mS/crSG/SbKgPicMind4lrkGlCDOUOSlUrNN+bfdo=;
        b=m4dFs8h9vUDwBr7qouzwEdcOVbrn/9YtmUoTcoDGi9P/7Nf7DCQstiPyfCyJBJ6bhf
         zmFCEO4F6uKkx5bCKM8rsxalF0sBD1ExKUlkXHna/SonyD3IX/wsfwf1ePGpMwDMbI0H
         4aB/4t5GLCHx2VCHzrhGLvxZN2f744W35Mc+p8ILEyAyt5j28x4KywDq7AbLNyclaVRU
         tyjfklQzSepfhKxJ5BU/GS9FwEwGNixBUDC+PgtBRa9cWFl8LtCn86VH8BCFQhXl7WaN
         ZHYcZCEk7RVt8PTakAFXHLj9UUDoXGfc0XIf61zkypp8iZBfrVay4NNuIN0ccBdRH0hx
         dBXQ==
X-Gm-Message-State: AOAM5303Nlo/nckn+r+Ux4SSyCMlj6GWXywAM9vKpzDqA9uV35xMjNtC
	qQuV742HJZcZFiYyUUr2wEo=
X-Google-Smtp-Source: ABdhPJwrdWT6y2CL2LWAPgdgslvxxxcX+HXve/twLqm1KvVhxEovjWNPGDhPf/+ZcjY/tapJBcnulg==
X-Received: by 2002:a05:6512:20d:: with SMTP id a13mr2649191lfo.36.1591278637579;
        Thu, 04 Jun 2020 06:50:37 -0700 (PDT)
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
Subject: [PATCH 0/5] Improvements of the stackleak gcc plugin
Date: Thu,  4 Jun 2020 16:49:52 +0300
Message-Id: <20200604134957.505389-1-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In this patch series I collected various improvements of the stackleak
gcc plugin.

The first patch excludes alloca() from the stackleak instrumentation logic
to make it simpler.

The second patch is the main improvement. It eliminates an unwanted
side-effect of kernel code instrumentation. This patch is a deep
reengineering of the idea described on grsecurity blog:
  https://grsecurity.net/resolving_an_unfortunate_stackleak_interaction

The third patch adds 'verbose' plugin parameter for printing additional
info about the kernel code instrumentation.

Two other patches disable unneeded stackleak instrumentation for some
files.

I would like to thank Alexander Monakov <amonakov@ispras.ru> for his
advisory on gcc internals.

This patch series was tested for gcc version 4.8, 5, 6, 7, 8, 9, and 10
on x86_64, i386 and arm64.
That was done using the project 'kernel-build-containers':
  https://github.com/a13xp0p0v/kernel-build-containers


Alexander Popov (5):
  gcc-plugins/stackleak: Exclude alloca() from the instrumentation logic
  gcc-plugins/stackleak: Use asm instrumentation to avoid useless
    register saving
  gcc-plugins/stackleak: Add 'verbose' plugin parameter
  gcc-plugins/stackleak: Don't instrument itself
  gcc-plugins/stackleak: Don't instrument vgettimeofday.c in arm64 VDSO

 arch/arm64/kernel/vdso/Makefile        |   3 +-
 include/linux/compiler_attributes.h    |  13 ++
 kernel/Makefile                        |   1 +
 kernel/stackleak.c                     |  16 +-
 scripts/Makefile.gcc-plugins           |   2 +
 scripts/gcc-plugins/stackleak_plugin.c | 260 ++++++++++++++++++++-----
 6 files changed, 232 insertions(+), 63 deletions(-)

-- 
2.25.2

