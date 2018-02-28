Date: Wed, 28 Feb 2018 23:29:09 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [kernel-hardening] [PATCH 0/2] arm: Add ARCH_HAS_FORTIFY_SOURCE
Message-ID: <20180228142909.GA3113@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: pombredanne@nexb.co, gregkh@linuxfoundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, luto@amacapital.net, dsafonov@virtuozzo.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, danielmicay@gmail.com, arnd@arndb.de, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This patch series are to select ARCH_HAS_FORTIFY_SOUCE on arm.
A lot of architectures already select ARCH_HAS_FORTIFY_SOURCE
to support CONFIG_FORTIFY_SOURCE that detects overflows at compile-time.
(6974f0c4555e ("include/linux/string.h:
add the option of fortified string.h functions)
ARM can be built and run with CONFIG_FORTIFY_SOURCE.

Additionally, modify vdso.c to remove compile-error that happens
when built arm kernel with CONFIG_FORTIFY_SOURCE.

Jinbum Park (2):
  arm: mm: Define vdso_start, vdso_end as array
  arm: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE

 arch/arm/Kconfig            |  1 +
 arch/arm/include/asm/vdso.h |  2 --
 arch/arm/kernel/vdso.c      | 12 +++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

-- 
1.9.1
