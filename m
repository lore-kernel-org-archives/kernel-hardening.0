Return-Path: <SRS0=lJMG=I4=lists.openwall.com=kernel-hardening-return-21084-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8FAC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B7576199A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7576199A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21084-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5186 invoked by uid 550); 30 Mar 2021 20:58:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5153 invoked from network); 30 Mar 2021 20:58:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7CDuN0kcTG5E4rLGLoBOZMdEpNX3hnRAZy+axf+Z2Y=;
        b=EpxdDbKBd+kExY3AERQ4rSbWmke5d1dCIniTON3YHk0ZMTIFDZ1vR8v0LqOzMXp+ip
         TdsvXQ1R/Izppj9SR1d9FJ7E3AUWsZBfmXYOPMRqpaLVRbXnLINoXPZNi+B+5K7QCc9k
         F56KDBOdVK30V1mKz6jtKX3d5PFiZYcFrth+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7CDuN0kcTG5E4rLGLoBOZMdEpNX3hnRAZy+axf+Z2Y=;
        b=lkyh5pp0gmY374cYuPul+VyiqRCyMpdqqs7McCg2LDhqC4TGfHFtF9M67Fy78zz3ak
         Le8fFG05GZ63S3QVJdBLv4SrsxAM+t9IH4YcKeOtlOSJGk9wf8o3oofZzQRIfYSIJpES
         ytJJNeiO37AlIfuEMB43bVY0WF00UFvJPUbO4WPZfDQ97LeI1tOcU7qS1Ey6ICgI1HLa
         NJHyo7lwacpN4gxeAo+iBCfam8KfgzCLvpxWnQ4dDPpVWNhX4IifhYppoQJmWT0WBY6c
         T/WKFahTbJQmurhC/mye13orP++D0yfuMfmkhNlW5qr7XLrB6ExEWwTSKbNrFwu3JGKX
         MG8w==
X-Gm-Message-State: AOAM531SbbM6A+eQ0/psXiuBABuUjDHZowZEpBu+2QlRjlXHJBE2JAiD
	kmRPvyo1uTqlF4CFNx6VgH2+7g==
X-Google-Smtp-Source: ABdhPJysGbXLhUI2OgRSxc4W5Ox+SEoMSRBLI61WnQnGp2mzR8IKvbq9d8ziJEjFtVvsv6YNKgNa3g==
X-Received: by 2002:a63:2bc4:: with SMTP id r187mr29953pgr.131.1617137873803;
        Tue, 30 Mar 2021 13:57:53 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/6] Optionally randomize kernel stack offset each syscall
Date: Tue, 30 Mar 2021 13:57:44 -0700
Message-Id: <20210330205750.428816-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


v8:
- switch to __this_cpu_*() (tglx)
- improve commit log details, comments, and masking (ingo, tglx)
v7: https://lore.kernel.org/lkml/20210319212835.3928492-1-keescook@chromium.org/
v6: https://lore.kernel.org/lkml/20210315180229.1224655-1-keescook@chromium.org/
v5: https://lore.kernel.org/lkml/20210309214301.678739-1-keescook@chromium.org/
v4: https://lore.kernel.org/lkml/20200622193146.2985288-1-keescook@chromium.org/
v3: https://lore.kernel.org/lkml/20200406231606.37619-1-keescook@chromium.org/
v2: https://lore.kernel.org/lkml/20200324203231.64324-1-keescook@chromium.org/
rfc: https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/

Hi,

This is a continuation and refactoring of Elena's earlier effort to add
kernel stack base offset randomization. In the time since the earlier
discussions, two attacks[1][2] were made public that depended on stack
determinism, so we're no longer in the position of "this is a good idea
but we have no examples of attacks". :)

Earlier discussions also devolved into debates on entropy sources, which
is mostly a red herring, given the already low entropy available due
to stack size. Regardless, entropy can be changed/improved separately
from this series as needed.

Earlier discussions also got stuck debating how much syscall overhead
was too much, but this is also a red herring since the feature itself
needs to be selectable at boot with no cost for those that don't want it:
this is solved here with static branches.

So, here is the latest improved version, made as arch-agnostic as
possible, with usage added for x86 and arm64. It also includes some small
static branch clean ups, and addresses some surprise performance issues
due to the stack canary[3].

At the very least, the first two patches can land separately (already
Acked and Reviewed), since they're kind of "separate", but introduce
macros that are used in the core stack changes.

If I can get an Ack from an arm64 maintainer, I think this could all
land via -tip to make merging easiest.

Thanks!

-Kees

[1] https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
[2] https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
[3] https://lore.kernel.org/lkml/202003281520.A9BFF461@keescook/


Kees Cook (6):
  jump_label: Provide CONFIG-driven build state defaults
  init_on_alloc: Optimize static branches
  stack: Optionally randomize kernel stack offset each syscall
  x86/entry: Enable random_kstack_offset support
  arm64: entry: Enable random_kstack_offset support
  lkdtm: Add REPORT_STACK for checking stack offsets

 .../admin-guide/kernel-parameters.txt         | 11 ++++
 Makefile                                      |  4 ++
 arch/Kconfig                                  | 23 ++++++++
 arch/arm64/Kconfig                            |  1 +
 arch/arm64/kernel/Makefile                    |  5 ++
 arch/arm64/kernel/syscall.c                   | 16 ++++++
 arch/x86/Kconfig                              |  1 +
 arch/x86/entry/common.c                       |  3 +
 arch/x86/include/asm/entry-common.h           | 16 ++++++
 drivers/misc/lkdtm/bugs.c                     | 17 ++++++
 drivers/misc/lkdtm/core.c                     |  1 +
 drivers/misc/lkdtm/lkdtm.h                    |  1 +
 include/linux/jump_label.h                    | 19 +++++++
 include/linux/mm.h                            | 10 ++--
 include/linux/randomize_kstack.h              | 55 +++++++++++++++++++
 init/main.c                                   | 23 ++++++++
 mm/page_alloc.c                               |  4 +-
 mm/slab.h                                     |  6 +-
 18 files changed, 208 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/randomize_kstack.h

-- 
2.25.1

