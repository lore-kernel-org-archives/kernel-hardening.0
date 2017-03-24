From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 24 Mar 2017 13:24:06 +0000
Message-Id: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 0/4] efi: libstub enhancements for cmdline parsing and kaslr
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, leif.lindholm@linaro.org, rfranz@cavium.com, mingo@kernel.org, bp@alien8.de, mark.rutland@arm.com, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds support for the 'quiet' kernel command line parameter, so
that meaningless debug prints can be prevented from corrupting the
boot splash (#3)

Secondly, it enables randomization of the UEFI runtime services region when
KASLR is in effect (#4)

Patches #1 and #2 are preparatory cleanup patches. Patch #4 trivially depends
on #2 which is why they are part of the same series.

Ard Biesheuvel (4):
  efi/libstub: fix harmless command line parsing bug
  efi/libstub: unify command line param parsing
  efi/libstub: arm/arm64: disable debug prints on 'quiet' cmdline arg
  ef/libstub: arm/arm64: randomize the base of the UEFI rt services
    region

 drivers/firmware/efi/libstub/arm-stub.c        | 68 +++++++++++---------
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 +
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 36 ++++++++---
 drivers/firmware/efi/libstub/efistub.h         |  9 +++
 drivers/firmware/efi/libstub/secureboot.c      |  2 +
 include/linux/efi.h                            |  5 +-
 7 files changed, 79 insertions(+), 47 deletions(-)

-- 
2.9.3
