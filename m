Return-Path: <SRS0=uRpo=5J=lists.openwall.com=kernel-hardening-return-18157-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C457C2BAEE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A42492073E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXl+2del"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A42492073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18157-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23710 invoked by uid 550); 24 Mar 2020 15:37:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23676 invoked from network); 24 Mar 2020 15:37:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064211;
	bh=PQBCNK5u0Tz/ipbsg/rBJzFbSbYoaE8ltgf057ICY3M=;
	h=From:To:Cc:Subject:Date:From;
	b=XXl+2delVg7QkDsUmxDyWmOv7DGIXqCUDbo+tGZsMqB5X5KJwyvdCbcrsd56n/oj4
	 kMTo36y/4ERclVGYhIP0mLLfQqaT/0bvIpCXFYh+WyCRtBBoNvzUgDRF2psshOZMm5
	 Or2WN+OI1r+5xLuHM9dCMgfwHf8FRrjASPI7eKqM=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 00/21] Improve list integrity checking
Date: Tue, 24 Mar 2020 15:36:22 +0000
Message-Id: <20200324153643.15527-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Linked lists appear extensively across the kernel tree in some form or
another because they are simple to use and offer efficient addition and
removal routines. Unfortunately, they are also an attractive target for
people exploiting memory corruption bugs since not only are linked lists
susceptible to use-after-free (UAF) issues when used with non-counted
references to objects [1], but the APIs can also be abused as powerful
stepping stones towards obtaining arbitrary read/write of kernel memory.

A concrete example with an excellent write-up is the exploitation of
CVE-2019-2215 ("Bad Binder"):

https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html

Some other examples are CVE-2015-3636 ("pingpongroot") and a variant of
CVE-2019-2025 ("waterdrop").

Before you go and throw away all your computers: fear not! It is common for
distributions to enable CONFIG_DEBUG_LIST, which prevents many of these
attacks with very little runtime overhead by sanity checking node pointers
during add() and del() operations.

Anyway, that's some background. Initially, I just set out to rename
CONFIG_DEBUG_LIST to something less "debuggy", a bit like we did for
CONFIG_DEBUG_{RODATA,MODULE_RONX} in 0f5bf6d0afe4. However, I quickly ran
into some other issues:


  1. The KCSAN work has led to some unusual WRITE_ONCE() additions to
     the list code. These make it difficult to reason about which list
     functions can run concurrently with one another, which in turn makes
     it difficult to write sanity checks without locks.

     Patches 1-9 try to sort this out.

  2. 'hlist' is missing checks, despite being the structure targetted
     by the "pingpongroot" attack mentioned earlier on. The same goes
     for 'hlist_nulls'.

     Patches 11-13 add these checks.

  3. 'list_bl' performs some partial inline checking.

     Patches 16, 18 and 19 extend this checking and move it out-of-line
     to be consistent with the other list checking operations.

  4. The LKDTM list tests are fairly limited.

     Patch 21 adds tests for all of the new checks.


The other patches do the rename and generally tidy things up to keep the
different list implementations consistent with each other. Due to issue (1),
this series is based on tip/locking/kcsan [2]

Jann previously made a comment that renaming the CONFIG options could have
unexpected results for people using an old config. In fact, building the
'oldconfig' target will prompt you about the new options, so I don't think
this is a huge concern. I did try to find a way to leave the old options as
dummy symbols, but it just cluttered the Kconfig (a bit like the approach
taken by NETFILTER_XT_MATCH_CONNMARK).

Cheers,

Will

[1] https://lore.kernel.org/lkml/?q=%28%22KASAN%3A+use-after-free+in+__list_add_valid%22+OR+%22KASAN%3A+use-after-free+in+__list_del_entry_valid%22%29+-s%3A%22Re%3A%22+-s%3A%22%5BPATCH%22
[2] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=locking/kcsan

Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Maddie Stone <maddiestone@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-team@android.com
Cc: kernel-hardening@lists.openwall.com 

--->8

Will Deacon (21):
  list: Remove hlist_unhashed_lockless()
  list: Remove hlist_nulls_unhashed_lockless()
  list: Annotate lockless list primitives with data_race()
  timers: Use hlist_unhashed() instead of open-coding in timer_pending()
  list: Comment missing WRITE_ONCE() in __list_del()
  list: Remove superfluous WRITE_ONCE() from hlist_nulls implementation
  Revert "list: Use WRITE_ONCE() when adding to lists and hlists"
  Revert "list: Use WRITE_ONCE() when initializing list_head structures"
  list: Remove unnecessary WRITE_ONCE() from hlist_bl_add_before()
  kernel-hacking: Make DEBUG_{LIST,PLIST,SG,NOTIFIERS} non-debug options
  list: Add integrity checking to hlist implementation
  list: Poison ->next pointer for non-RCU deletion of 'hlist_nulls_node'
  list: Add integrity checking to hlist_nulls implementation
  plist: Use CHECK_DATA_CORRUPTION instead of explicit {BUG,WARN}_ON()
  list_bl: Use CHECK_DATA_CORRUPTION instead of custom BUG_ON() wrapper
  list_bl: Extend integrity checking in deletion routines
  linux/bit_spinlock.h: Include linux/processor.h
  list_bl: Move integrity checking out of line
  list_bl: Extend integrity checking to cover the same cases as 'hlist'
  list: Format CHECK_DATA_CORRUPTION error messages consistently
  lkdtm: Extend list corruption checks

 arch/arm/configs/tegra_defconfig              |   2 +-
 arch/mips/configs/bigsur_defconfig            |   2 +-
 arch/powerpc/configs/ppc6xx_defconfig         |   4 +-
 arch/powerpc/configs/ps3_defconfig            |   2 +-
 arch/powerpc/configs/skiroot_defconfig        |   4 +-
 arch/riscv/configs/defconfig                  |   6 +-
 arch/riscv/configs/rv32_defconfig             |   6 +-
 arch/s390/configs/debug_defconfig             |   4 +-
 arch/sh/configs/polaris_defconfig             |   2 +-
 arch/sh/configs/rsk7203_defconfig             |   4 +-
 arch/sh/configs/se7206_defconfig              |   2 +-
 drivers/gpu/drm/radeon/mkregtable.c           |   2 +-
 drivers/misc/lkdtm/Makefile                   |   1 +
 drivers/misc/lkdtm/bugs.c                     |  68 ---
 drivers/misc/lkdtm/core.c                     |  31 +-
 drivers/misc/lkdtm/list.c                     | 489 ++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h                    |  33 +-
 drivers/staging/wfx/fwio.c                    |   2 +-
 drivers/staging/wfx/hwio.c                    |   2 +-
 include/linux/bit_spinlock.h                  |   1 +
 include/linux/list.h                          |  95 ++--
 include/linux/list_bl.h                       |  52 +-
 include/linux/list_nulls.h                    |  50 +-
 include/linux/llist.h                         |   2 +-
 include/linux/plist.h                         |   4 +-
 include/linux/rculist.h                       |  80 +--
 include/linux/rculist_bl.h                    |  17 +-
 include/linux/scatterlist.h                   |   6 +-
 include/linux/timer.h                         |   5 +-
 kernel/notifier.c                             |   2 +-
 kernel/time/timer.c                           |   1 +
 lib/Kconfig.debug                             |  24 +-
 lib/Makefile                                  |   2 +-
 lib/list_debug.c                              | 200 ++++++-
 lib/plist.c                                   |  67 ++-
 tools/include/linux/list.h                    |   4 +-
 tools/testing/selftests/lkdtm/tests.txt       |  31 +-
 .../selftests/wireguard/qemu/debug.config     |   6 +-
 tools/virtio/linux/scatterlist.h              |   4 +-
 39 files changed, 1034 insertions(+), 285 deletions(-)
 create mode 100644 drivers/misc/lkdtm/list.c

-- 
2.20.1
