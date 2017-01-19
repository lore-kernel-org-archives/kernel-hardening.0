Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Wed, 18 Jan 2017 17:29:04 -0800
Message-Id: <1484789346-21012-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [RFC][PATCH 0/2] Better hardening names
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

It's come up previously that CONFIG_DEBUG_SET_MODULE_RONX and
CONFIG_DEBUG_RODATA are not accurate names, mostly they should not have the
word 'debug' in them. This series attempts to change the names to something
a bit more descriptive and indicative of what they are actually used for these
days.

I marked this RFC for
- Bike shedding purposes.
- A discussion of what defaults should be. The way I did the refactoring, both
  options are default y. I'd appreciate comments if there is a better approach.
- Approach to split this up into more sub patches to make review/merging easier?
  Or maybe it's fine.

Quickly tested on arm/arm64/x86.

Thanks,
Laura

Laura Abbott (2):
  security: Change name of CONFIG_DEBUG_RODATA
  security: Change name of CONFIG_DEBUG_SET_MODULE_RONX

 Documentation/DocBook/kgdb.tmpl            |  8 ++++----
 Documentation/security/self-protection.txt |  4 ++--
 arch/arm/Kconfig                           |  2 ++
 arch/arm/Kconfig.debug                     | 11 ----------
 arch/arm/configs/aspeed_g4_defconfig       |  4 ++--
 arch/arm/configs/aspeed_g5_defconfig       |  4 ++--
 arch/arm/include/asm/cacheflush.h          |  2 +-
 arch/arm/kernel/patch.c                    |  4 ++--
 arch/arm/kernel/vmlinux.lds.S              |  8 ++++----
 arch/arm/mm/Kconfig                        | 14 +------------
 arch/arm/mm/init.c                         |  4 ++--
 arch/arm64/Kconfig                         |  5 ++---
 arch/arm64/Kconfig.debug                   | 13 +-----------
 arch/arm64/kernel/insn.c                   |  2 +-
 arch/parisc/Kconfig                        |  1 +
 arch/parisc/Kconfig.debug                  | 11 ----------
 arch/parisc/configs/712_defconfig          |  2 +-
 arch/parisc/configs/c3000_defconfig        |  2 +-
 arch/parisc/mm/init.c                      |  2 +-
 arch/s390/Kconfig                          |  5 ++---
 arch/s390/Kconfig.debug                    |  3 ---
 arch/x86/Kconfig                           |  5 ++---
 arch/x86/Kconfig.debug                     | 11 ----------
 include/linux/filter.h                     |  4 ++--
 include/linux/init.h                       |  4 ++--
 include/linux/module.h                     |  2 +-
 init/main.c                                |  4 ++--
 kernel/configs/android-recommended.config  |  2 +-
 kernel/module.c                            |  6 +++---
 kernel/power/hibernate.c                   |  2 +-
 kernel/power/power.h                       |  4 ++--
 kernel/power/snapshot.c                    |  4 ++--
 security/Kconfig                           | 32 ++++++++++++++++++++++++++++++
 33 files changed, 82 insertions(+), 109 deletions(-)

-- 
2.7.4
