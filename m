Return-Path: <SRS0=fwWG=I5=lists.openwall.com=kernel-hardening-return-21099-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D011C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 20:55:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4C26661073
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 20:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C26661073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21099-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11295 invoked by uid 550); 31 Mar 2021 20:55:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10237 invoked from network); 31 Mar 2021 20:55:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bZ3bzKOfhPGnPGG60VssYCADe64CpCvkm0duGoaMAA=;
        b=iK6Dd1WzfTgZlYmEbgnA8JsN6ev91O3XgM9qgKS6kJCpEDzjxzvzwCL7RPAIIEpMPO
         m6g+Zrkan6Wwii54JTWoNBmrYZfJ1o2xcdda5yUzNDrzCoTAdDL5oMoveSYaiu0rppz9
         QW6uvmXPJPJYn+Oeme3ufD9LvkkfwQLu9XavI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bZ3bzKOfhPGnPGG60VssYCADe64CpCvkm0duGoaMAA=;
        b=TsWTWmPOXSdYEWITQIiHwCAN0xVEMF8kiz9ev69IV0U87FU6KANzc8R1RuOX6Si2m4
         XSr10O85lKur6yP1c8MqTgbIDt+VVjjohYaFFvh9j/hRj6+JK9a0T8ozly/csuIpaZbJ
         dk2cEHFRKIV65ytza6RNv7USBES40tqbTzlNQCyK/+zcdw46GFJL7tr+RBG5j2IwaQfh
         Z6Uc9MRZ+y+dJBmU0+8dc4Dy/GKvAuhfaCw8Pd8TALR8eJhhYl16Zc8YAVzg1JIN7sHQ
         H0vYf2a35fFMhL4D/y35HGnSJFqHLupKr6kmwY4eae/rELxnuuwIUO5MgKTmbQ5gApVR
         6T4A==
X-Gm-Message-State: AOAM531N3H4x3jBIGTrPc3C2ZrS6VZasGfJmK4R03enRRTkClc8je8Xa
	upVkjPiARu31aMnyvhwV2ksSDg==
X-Google-Smtp-Source: ABdhPJzUF8uhkl0raN0ODpiCdyJAh9H7iGlPFlGsUGF89srEBkCnpo3FL1QwTdlnzj6Suocxnxa0yg==
X-Received: by 2002:a63:af51:: with SMTP id s17mr4640944pgo.405.1617224103801;
        Wed, 31 Mar 2021 13:55:03 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
Subject: [PATCH v9 0/6] Optionally randomize kernel stack offset each syscall
Date: Wed, 31 Mar 2021 13:54:52 -0700
Message-Id: <20210331205458.1871746-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Will (and Mark and Catalin),

Can you take this via the arm64 tree for v5.13 please? Thomas has added
his Reviewed-by, so it only leaves arm64's. :)


v9:
- comment position nit (tglx)
- Added tglx's Reviewed-by
v8: https://lore.kernel.org/lkml/20210330205750.428816-1-keescook@chromium.org/
v7: https://lore.kernel.org/lkml/20210319212835.3928492-1-keescook@chromium.org/
v6: https://lore.kernel.org/lkml/20210315180229.1224655-1-keescook@chromium.org/
v5: https://lore.kernel.org/lkml/20210309214301.678739-1-keescook@chromium.org/
v4: https://lore.kernel.org/lkml/20200622193146.2985288-1-keescook@chromium.org/
v3: https://lore.kernel.org/lkml/20200406231606.37619-1-keescook@chromium.org/
v2: https://lore.kernel.org/lkml/20200324203231.64324-1-keescook@chromium.org/
rfc: https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/

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
 arch/x86/entry/common.c                       |  3 ++
 arch/x86/include/asm/entry-common.h           | 16 ++++++
 drivers/misc/lkdtm/bugs.c                     | 17 ++++++
 drivers/misc/lkdtm/core.c                     |  1 +
 drivers/misc/lkdtm/lkdtm.h                    |  1 +
 include/linux/jump_label.h                    | 19 +++++++
 include/linux/mm.h                            | 10 ++--
 include/linux/randomize_kstack.h              | 54 +++++++++++++++++++
 init/main.c                                   | 23 ++++++++
 mm/page_alloc.c                               |  4 +-
 mm/slab.h                                     |  6 ++-
 18 files changed, 207 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/randomize_kstack.h

-- 
2.25.1

