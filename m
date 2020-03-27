Return-Path: <SRS0=6aVF=5M=lists.openwall.com=kernel-hardening-return-18250-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489DBC2D0E7
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B2DA20717
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I5pLNO+f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B2DA20717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18250-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26312 invoked by uid 550); 27 Mar 2020 06:48:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26157 invoked from network); 27 Mar 2020 06:48:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e2pldkrhAni9nq8EyiG2WO78f/APBgebCGeZjhrmshQ=;
        b=I5pLNO+fPogPHiacztpG1HxVvtnTLCdqXJT+PYXFAYy2wxLIwXNdmFqAS1I1f0M/jk
         i7aiI8cdZcbouxeLQbQqZcLjULDiMw3oqCK7zfUVhtO0VEAHkOFMQ2tOJkveDwz0wuv6
         pOsphc56mqYDnuZStj5ScZg0AFgtI8LBlfI3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e2pldkrhAni9nq8EyiG2WO78f/APBgebCGeZjhrmshQ=;
        b=GxeKuVKqHysqGKcDrDKsthJWzam7HR5m8pbaRrXYCymAgnDn8W3Za/jGWkUm/V8X5o
         qcLCy+uOAFbYwe5xN4DF/1QM0SgMH9CMdL8eAoCzGCHPdeDhoVICgOAF/Z5lVS4r4Ptd
         XhkfqD1E+Z4+v1HweajoEwO80QCcc2COPWBCcwfwCdnbh49/NaOXnbNSEklg8Ek1pCoW
         qnW2HGeX3A1Ru9UOG/eN0xG+TXaek6XE7/VFS+4IlUbbX3Y2eYYkb07I3X9SeKup6TZT
         kPlYxXuufdJ8I/ppFG79LG0sXYlHnNZvknCX8hZSaqGXOu3frPUmA4P5JO70jLQLLKQv
         Wyvw==
X-Gm-Message-State: ANhLgQ0GGljeg/yVY9oWvhzxuKIXRzCqcawcna1mCuPd+pWKwzSa4NdP
	tWLPkscS+QlgwjD1HQpvfuuieQ==
X-Google-Smtp-Source: ADFU+vu33/tER7UbAE9saaXS5jjv8U5NDlXNrJgfePpmE/SLJRv4FbdKQSggX0D5kcr6Hk9V6uB9jw==
X-Received: by 2002:a17:90a:bf18:: with SMTP id c24mr4158631pjs.125.1585291706174;
        Thu, 26 Mar 2020 23:48:26 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/6] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Date: Thu, 26 Mar 2020 23:48:14 -0700
Message-Id: <20200327064820.12602-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This continues my attempt to fix READ_IMPLIES_EXEC. :)

This series is for x86, arm, and arm64; I'd like it to go via
-tip, though, just to keep these changes together, as they're
related. (Note that most other architectures don't suffer from this
problem. e.g. powerpc's behavior appears to already be correct. MIPS may
need adjusting but the history of CPU features and toolchain behavior
is very unclear to me.)

Repeating the commit log from later in the series:


The READ_IMPLIES_EXEC work-around was designed for old toolchains that
lacked the ELF PT_GNU_STACK marking under the assumption that toolchains
that couldn't specify executable permission flags for the stack may not
know how to do it correctly for any memory region.

This logic is sensible for having ancient binaries coexist in a system
with possibly NX memory, but was implemented in a way that equated having
a PT_GNU_STACK marked executable as being as "broken" as lacking the
PT_GNU_STACK marking entirely. Things like unmarked assembly and stack
trampolines may cause PT_GNU_STACK to need an executable bit, but they
do not imply all mappings must be executable.

This confusion has led to situations where modern programs with explicitly
marked executable stack are forced into the READ_IMPLIES_EXEC state when
no such thing is needed. (And leads to unexpected failures when mmap()ing
regions of device driver memory that wish to disallow VM_EXEC[1].)

In looking for other reasons for the READ_IMPLIES_EXEC behavior, Jann
Horn noted that glibc thread stacks have always been marked RWX (until
2003 when they started tracking the PT_GNU_STACK flag instead[2]). And
musl doesn't support executable stacks at all[3]. As such, no breakage
for multithreaded applications is expected from this change.

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
[2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=54ee14b3882
[3] https://lkml.kernel.org/r/20190423192534.GN23599@brightrain.aerifal.cx


Thanks!

-Kees

v5:
 - re-align tables and use full name of PT_GNU_STACK (bp)
v4: https://lore.kernel.org/lkml/20200225051307.6401-1-keescook@chromium.org
v3: https://lore.kernel.org/lkml/20200210193049.64362-1-keescook@chromium.org
v2: https://lore.kernel.org/lkml/20190424203408.GA11386@beast/
v1: https://lore.kernel.org/lkml/20190423181210.GA2443@beast/

Kees Cook (6):
  x86/elf: Add table to document READ_IMPLIES_EXEC
  x86/elf: Split READ_IMPLIES_EXEC from executable PT_GNU_STACK
  x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
  arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
  arm32/64, elf: Split READ_IMPLIES_EXEC from executable PT_GNU_STACK
  arm64, elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address
    spaces

 arch/arm/kernel/elf.c        | 27 +++++++++++++++++++++++----
 arch/arm64/include/asm/elf.h | 23 ++++++++++++++++++++++-
 arch/x86/include/asm/elf.h   | 22 +++++++++++++++++++++-
 fs/compat_binfmt_elf.c       |  5 +++++
 4 files changed, 71 insertions(+), 6 deletions(-)

-- 
2.20.1

