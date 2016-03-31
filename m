Reply-To: kernel-hardening@lists.openwall.com
From: Matt Redfearn <matt.redfearn@imgtec.com>
Date: Thu, 31 Mar 2016 10:05:31 +0100
Message-ID: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH v2 00/11] MIPS relocatable kernel & KASLR
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, kernel-hardening@lists.openwall.com, Matt
 Redfearn <matt.redfearn@imgtec.com>, Aaro Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, David Daney <ddaney@caviumnetworks.com>, Jaedon Shin <jaedon.shin@gmail.com>, James Hogan <james.hogan@imgtec.com>, Jonas Gorski <jogo@openwrt.org>, Paul Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>


This series adds the ability for the MIPS kernel to relocate itself at
runtime, optionally to an address determined at random each boot. This
series is based on v4.4 and has been tested on the Malta, Boston and
SEAD3 platforms.

Here is a description of how relocation is achieved:
* Kernel is compiled & statically linked as normal, with no position
  independent code. MIPS before R6 only has limited relative jump
  instructions so the vast majority of jumps are absolute. To compile
  the kernel position independent would introduce a highly undesireable
  overhead. Relocating the static binary gives a small startup time
  penalty but the kernel otherwise perforns normally.
* The linker flag --emit-relocs is added to the linker command line,
  causing ld to include relocation sections in the output elf
* A tool derived from the x86 relocs tool is used to parse the
  relocation sections and create a binary table of relocations. Each
  entry in the table is 32bits, comprised of a 24bit offset (in words)
  from _text and an 8bit relocation type.
* The table is inserted into the vmlinux elf, into some space reserved
  for it in the linker script. Inserting the table into vmlinux means
  all boot targets will automatically include the relocation code and
  information.
* At boot, the kernel memcpy()s itself elsewhere in memory, then goes
  through the table performing each relocation on the new image.
* If all goes well, control is passed to the entry point of the new
  kernel.

Restrictions:
* The new kernel is not allowed to overlap the old kernel, such that
  the original kernel can still be booted if relocation fails.
* Relocation is supported only by multiples of 64k bytes. This
  eliminates the need to handle R_MIPS_LO16 relocations as the bottom
  16bits will remain the same at the relocated address.
* In 64 bit kernels, relocation is supported only within the same 4Gb
  memory segment as the kernel link address (CONFIG_PHYSICAL_START).
  This eliminates the need to handle R_MIPS_HIGHEST and R_MIPS_HIGHER
  relocations as the top 32bits will remain the same at the relocated
  address.

Changes in v2:
- Added support  for MIPSr6
- Accept the "nokaslr" command line option
- Add a kernel panic notifier to print the relocation information
- Accept entropy via the /chosen/kaslr-seed property in device tree
- Tested on MIPS Malta, Boston and SEAD3 platforms

Matt Redfearn (11):
  MIPS: tools: Add relocs tool
  MIPS: tools: Build relocs tool
  MIPS: Reserve space for relocation table
  MIPS: Generate relocation table when CONFIG_RELOCATABLE
  MIPS: Kernel: Add relocate.c
  MIPS: Call relocate_kernel if CONFIG_RELOCATABLE=y
  MIPS: bootmem: When relocatable, free memory below kernel
  MIPS: Add CONFIG_RELOCATABLE Kconfig option
  MIPS: Introduce plat_get_fdt a platform API to retrieve the FDT
  MIPS: Kernel: Implement KASLR using CONFIG_RELOCATABLE
  MIPS: KASLR: Print relocation Information on boot

 arch/mips/Kconfig                  |  64 ++++
 arch/mips/Makefile                 |  19 ++
 arch/mips/boot/tools/Makefile      |   8 +
 arch/mips/boot/tools/relocs.c      | 680 +++++++++++++++++++++++++++++++++++++
 arch/mips/boot/tools/relocs.h      |  45 +++
 arch/mips/boot/tools/relocs_32.c   |  17 +
 arch/mips/boot/tools/relocs_64.c   |  27 ++
 arch/mips/boot/tools/relocs_main.c |  84 +++++
 arch/mips/include/asm/bootinfo.h   |  18 +
 arch/mips/kernel/Makefile          |   2 +
 arch/mips/kernel/head.S            |  20 ++
 arch/mips/kernel/relocate.c        | 386 +++++++++++++++++++++
 arch/mips/kernel/setup.c           |  23 ++
 arch/mips/kernel/vmlinux.lds.S     |  21 ++
 arch/mips/mti-malta/malta-setup.c  |   7 +-
 arch/mips/mti-sead3/sead3-setup.c  |   5 +
 16 files changed, 1425 insertions(+), 1 deletion(-)
 create mode 100644 arch/mips/boot/tools/Makefile
 create mode 100644 arch/mips/boot/tools/relocs.c
 create mode 100644 arch/mips/boot/tools/relocs.h
 create mode 100644 arch/mips/boot/tools/relocs_32.c
 create mode 100644 arch/mips/boot/tools/relocs_64.c
 create mode 100644 arch/mips/boot/tools/relocs_main.c
 create mode 100644 arch/mips/kernel/relocate.c

-- 
2.5.0
