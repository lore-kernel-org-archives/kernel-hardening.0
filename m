Return-Path: <SRS0=AXwL=4N=lists.openwall.com=kernel-hardening-return-17900-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9BDC35DF5
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:13:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6121E24682
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 05:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LFrOdVRm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6121E24682
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17900-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7500 invoked by uid 550); 25 Feb 2020 05:13:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7360 invoked from network); 25 Feb 2020 05:13:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQB4rWAgQlshK2jar7JtwK95ipRQeMQdrfjF9c60b3Q=;
        b=LFrOdVRmnVadjqGd8oJrAQjMoolYjWN9vYwc3EwXw87IXTST26Jz+ZUqqf3Cwz9CoS
         8nvpcKutc2DDmK9larltPBH0crdkmid8hDBB1a3PpJF4ipvEpIkrP1nwnZd6QtbZKUqw
         THv95WvZqUUgZ2hYd5vk1iRfZrXdVhQeyUBzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQB4rWAgQlshK2jar7JtwK95ipRQeMQdrfjF9c60b3Q=;
        b=d7eBVkZfRqZ9EInwh3OLHlmLZtMSSsJ/o42DIk8oZMxhnySsiAk/40BJKdER9eY3fe
         rli4eZ/QnaGBuYBU+IWXNVTB53qA7Vee9Bt/2HA1Km9R+b0nS04PZPg/MUwsDRYIqQ6y
         lK44GsmoduO1B9VR8gmks6/FyYk+U/Kt/3gElBj03urdU0302+D+36ZzCAuGzrFYGi6U
         PlYGOOgIFjF/5Zkz9I5jCXlEZ83f/w3q9tGsx8ClE/l8kw1Zr7lPM7Rxr7nKT3aombuT
         b5L/DzX+Ppt6RPMu7K2m52dsUevXjHGY96KQbaIuyKce8iPb/h28GmVp1XJTYHRq4m/f
         xglw==
X-Gm-Message-State: APjAAAXvwB0paMsMSotgI/SEj8YsND45vVwL52xiByxLuElEOXPWqTAi
	j9hGYkFEztfvbY65cpEqMhlyWg==
X-Google-Smtp-Source: APXvYqyEp2DduArcsAfDzCxBtvCjTHJyL0Kka4MDfFR/IyZ8Q21kRRLDuvjt0qN6ORbpfkkeenKrsA==
X-Received: by 2002:a17:90a:da03:: with SMTP id e3mr3139897pjv.57.1582607592644;
        Mon, 24 Feb 2020 21:13:12 -0800 (PST)
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
Subject: [PATCH v4 0/6] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Date: Mon, 24 Feb 2020 21:13:01 -0800
Message-Id: <20200225051307.6401-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is a refresh of my earlier attempt to fix READ_IMPLIES_EXEC. I
think it incorporates the feedback from v2 (there are no code changes
between v3 and v4; I've just added Reviews/Acks and directed at Boris,
as it seems Ingo is busy). The selftest from v3 has been remove from v4,
as I will land it separately via Shuah's selftest tree.

This series is for x86, arm, and arm64; I'd like it to go via -tip,
though, just to keep this change together with the selftest. To
that end, I'd like to collect Acks from the respective architecture
maintainers. (Note that most other architectures don't suffer from this
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


-Kees


v4:
 - split selftest into separate series to go via Shuah's tree
 - add Reviews/Acks
v3: https://lore.kernel.org/lkml/20200210193049.64362-1-keescook@chromium.org
v2: https://lore.kernel.org/lkml/20190424203408.GA11386@beast/
v1: https://lore.kernel.org/lkml/20190423181210.GA2443@beast/

Kees Cook (6):
  x86/elf: Add table to document READ_IMPLIES_EXEC
  x86/elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
  x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
  arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
  arm32/64, elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
  arm64, elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address
    spaces

 arch/arm/kernel/elf.c        | 27 +++++++++++++++++++++++----
 arch/arm64/include/asm/elf.h | 23 ++++++++++++++++++++++-
 arch/x86/include/asm/elf.h   | 22 +++++++++++++++++++++-
 fs/compat_binfmt_elf.c       |  5 +++++
 4 files changed, 71 insertions(+), 6 deletions(-)

-- 
2.20.1

