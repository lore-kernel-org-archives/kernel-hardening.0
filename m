From: Laura Abbott <labbott@redhat.com>
Date: Fri,  3 Feb 2017 09:52:20 -0800
Message-Id: <1486144343-24998-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv2 0/2] Hardening configs refactor/rename
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a follow up to my proposal to rename/refactor CONFIG_DEBUG_RODATA
and CONFIG_DEBUG_SET_MODULE_RONX. Among other objections, there shouldn't
be 'debug' in the name since these provide necessary kernel protection.

v2 takes a slightly different approach to this per feedback. Patch #1 moves
CONFIG_DEBUG_RODATA and CONFIG_DEBUG_SET_MODULE_RONX to a common arch config.
These configs are def_bool y for every arch except !CPU_V7 for arm
CONFIG_DEBUG_RODATA. I think this also mitigates another concern about changing
the name since these are basically internal configs at this point and not end
user selectable. Patch #2 does the rename to something more descriptive.
Hopefully this should separate discussion more clearly into two parts (refactor
and rename)

Thanks,
Laura


Laura Abbott (2):
  arch: Move CONFIG_DEBUG_RODATA and CONFIG_SET_MODULE_RONX to be common
  arch: Rename CONFIG_DEBUG_RODATA and CONFIG_DEBUG_MODULE_RONX

 Documentation/DocBook/kgdb.tmpl            |  8 ++++----
 Documentation/security/self-protection.txt |  4 ++--
 arch/Kconfig                               | 28 ++++++++++++++++++++++++++++
 arch/arm/Kconfig                           |  3 +++
 arch/arm/Kconfig.debug                     | 11 -----------
 arch/arm/configs/aspeed_g4_defconfig       |  3 +--
 arch/arm/configs/aspeed_g5_defconfig       |  3 +--
 arch/arm/include/asm/cacheflush.h          |  2 +-
 arch/arm/kernel/patch.c                    |  4 ++--
 arch/arm/kernel/vmlinux.lds.S              |  8 ++++----
 arch/arm/mm/Kconfig                        | 14 +-------------
 arch/arm/mm/init.c                         |  4 ++--
 arch/arm64/Kconfig                         |  5 ++---
 arch/arm64/Kconfig.debug                   | 13 +------------
 arch/arm64/kernel/insn.c                   |  2 +-
 arch/parisc/Kconfig                        |  1 +
 arch/parisc/Kconfig.debug                  | 11 -----------
 arch/parisc/configs/712_defconfig          |  1 -
 arch/parisc/configs/c3000_defconfig        |  1 -
 arch/parisc/mm/init.c                      |  2 +-
 arch/s390/Kconfig                          |  5 ++---
 arch/s390/Kconfig.debug                    |  3 ---
 arch/x86/Kconfig                           |  5 ++---
 arch/x86/Kconfig.debug                     | 11 -----------
 include/linux/filter.h                     |  4 ++--
 include/linux/init.h                       |  4 ++--
 include/linux/module.h                     |  2 +-
 init/main.c                                |  4 ++--
 kernel/configs/android-recommended.config  |  2 +-
 kernel/module.c                            |  6 +++---
 kernel/power/hibernate.c                   |  2 +-
 kernel/power/power.h                       |  4 ++--
 kernel/power/snapshot.c                    |  4 ++--
 33 files changed, 75 insertions(+), 109 deletions(-)

-- 
2.7.4
