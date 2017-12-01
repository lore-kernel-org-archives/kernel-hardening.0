From: "jinb.park" <jinb.park7@gmail.com>
Date: Fri, 1 Dec 2017 19:38:49 +0900
Message-ID: <20171201103849.GA3817@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH 0/3] arm: Makes ptdump resuable and add WX
 page checking
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: afzal.mohd.ma@gmail.com, mark.rutland@arm.com, labbott@redhat.com, linux@armlinux.org.uk, gregkh@linuxfoundation.org, keescook@chromium.org, vladimir.murzin@arm.com, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Page table dumping code for arm64-x86 is reusable,
and they have function for WX page checking.
But arm doesn't have that.

This path series are to makes ptdump reusable,
and add WX page checking for arm.
This is heavily based on arm64 version.

Jinbum Park (3):
  arm: mm: dump: make page table dumping reusable
  arm: mm: dump: make the page table dumping seq_file optional
  arm: mm: dump: add checking for writable and executable pages

 arch/arm/Kconfig.debug        |  33 +++++++-
 arch/arm/include/asm/ptdump.h |  56 ++++++++++++++
 arch/arm/mm/Makefile          |   3 +-
 arch/arm/mm/dump.c            | 171 +++++++++++++++++++++++++++++++-----------
 arch/arm/mm/init.c            |   2 +
 arch/arm/mm/ptdump_debugfs.c  |  34 +++++++++
 6 files changed, 253 insertions(+), 46 deletions(-)
 create mode 100644 arch/arm/include/asm/ptdump.h
 create mode 100644 arch/arm/mm/ptdump_debugfs.c

-- 
1.9.1
