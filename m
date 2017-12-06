Date: Wed, 6 Dec 2017 19:23:15 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171206102315.GA7012@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH v4 0/3] arm: Makes ptdump resuable and add
 WX page checking
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

v2 :
Fix a sender name of mail header, there was an mistake.
(from "jinb.park" to Jinbum Park)
Contents of patch-set are perfectly same.

v3 :
Take advantage of the existing pg_level and bits arrays
to check ro, nx prot.

v4 :
Add boolean for ro_bit, nx_bit into prot_bits
to point ro_bit, nx_bit in pg_level.
This change is suggested by Laura Abbott.

jinb.park (3):
  arm: mm: dump: make page table dumping reusable
  arm: mm: dump: make the page table dumping seq_file optional
  arm: mm: dump: add checking for writable and executable pages

 arch/arm/Kconfig.debug        |  33 ++++++++-
 arch/arm/include/asm/ptdump.h |  56 ++++++++++++++++
 arch/arm/mm/Makefile          |   3 +-
 arch/arm/mm/dump.c            | 151 +++++++++++++++++++++++++++++-------------
 arch/arm/mm/init.c            |   2 +
 arch/arm/mm/ptdump_debugfs.c  |  34 ++++++++++
 6 files changed, 232 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm/include/asm/ptdump.h
 create mode 100644 arch/arm/mm/ptdump_debugfs.c

-- 
1.9.1
