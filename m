Return-Path: <SRS0=UEGN=36=lists.openwall.com=kernel-hardening-return-17761-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A5DC35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AAF5120661
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BH7Ud+6o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAF5120661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17761-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11810 invoked by uid 550); 10 Feb 2020 19:31:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11772 invoked from network); 10 Feb 2020 19:31:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BxkgltGo3ZM9ZY7Grbu2bcNcn+pz+GDYrC11ZXD2ME=;
        b=BH7Ud+6oFq+7OoIlLBbbMvTBHC4x6G8tRrT4wZScXP2/0BYU5O8AgFFlezKTTpQYMV
         fmiGPa9peDfUrdZdj+9xqS9t7Ua491OZzp4RIZLg3Giw7fhPm1FvIbwzaS9NqQojoCMv
         95B0WHndyisDS9V4XA1xkVEyzq6091EvwvmT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BxkgltGo3ZM9ZY7Grbu2bcNcn+pz+GDYrC11ZXD2ME=;
        b=CbNYhsABHV/WrJzIeea0P19VXfgQ9I1J938WhraA/9Y05Bqkq3pBDe5Is5NvaCvlqq
         bfdD5ir8NyzgGSQ5MImWyRierqj05cPuXTkbR1Dl5trw2k6HlOlNgEH9En0W6kY1IFWk
         YeHs02nC9ayRHsmnytxRqlhYcKmZSEMs7dunAF4xZVtYCF6E6tlSxfFVIAJQ7h53exRN
         VeVj6kI+5hXVXwkQHHzUI1kAFEfsGs9hJGJWn7zeoaBwwFGRlP/45+aZZvWop9Enb280
         RPTVMwSKxFp/XgGMHduYlpPx00FA31hr7jHcJRbtpo4yU4h1slY7ixsLFXBd+Ik6jfEy
         5CDQ==
X-Gm-Message-State: APjAAAUR/UmkGgMu+eBYFHCBM7ye1SRcecBp9OuvScL1nhJSfE2Pc+hG
	N6oGDyR8xm7h3oyFajwU+Cl2QQ==
X-Google-Smtp-Source: APXvYqzUOzBqZYnuPC5ne0YCYJNkucq+pHiY9zdgP+OtGzcaHv4jX1sC238odS+TkQrM/uoVlWRNEA==
X-Received: by 2002:aca:5a04:: with SMTP id o4mr405786oib.71.1581363059273;
        Mon, 10 Feb 2020 11:30:59 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>,
	x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 0/7] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Date: Mon, 10 Feb 2020 11:30:42 -0800
Message-Id: <20200210193049.64362-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is a refresh of my earlier attempt to fix READ_IMPLIES_EXEC. I think
it incorporates the feedback from v2, and I've now added a selftest. This
series is for x86, arm, and arm64; I'd like it to go via -tip, though,
just to keep this change together with the selftest. To that end, I'd like
to collect Acks from the respective architecture maintainers. (Note that
most other architectures don't suffer from this problem. e.g. powerpc's
behavior appears to already be correct. MIPS may need adjusting but the
history of CPU features and toolchain behavior is very unclear to me.)

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


v3:
 - split steps in to distinct patches
 - include arm32 and arm64/compat
 - add selftests to validate behavior
v2: https://lore.kernel.org/lkml/20190424203408.GA11386@beast/
v1: https://lore.kernel.org/lkml/20190423181210.GA2443@beast/

Kees Cook (7):
  x86/elf: Add table to document READ_IMPLIES_EXEC
  x86/elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
  x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
  arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
  arm32/64, elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
  arm64, elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address
    spaces
  selftests/exec: Add READ_IMPLIES_EXEC tests

 arch/arm/kernel/elf.c                         |  27 +++-
 arch/arm64/include/asm/elf.h                  |  23 +++-
 arch/x86/include/asm/elf.h                    |  22 +++-
 fs/compat_binfmt_elf.c                        |   5 +
 tools/testing/selftests/exec/Makefile         |  42 +++++-
 .../selftests/exec/read_implies_exec.c        | 121 ++++++++++++++++++
 .../selftests/exec/strip-gnu-stack-bits.c     |  34 +++++
 .../testing/selftests/exec/strip-gnu-stack.c  |  69 ++++++++++
 8 files changed, 336 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/exec/read_implies_exec.c
 create mode 100644 tools/testing/selftests/exec/strip-gnu-stack-bits.c
 create mode 100644 tools/testing/selftests/exec/strip-gnu-stack.c

-- 
2.20.1

