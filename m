Reply-To: kernel-hardening@lists.openwall.com
From: Matt Redfearn <matt.redfearn@imgtec.com>
Date: Thu, 31 Mar 2016 10:05:35 +0100
Message-ID: <1459415142-3412-5-git-send-email-matt.redfearn@imgtec.com>
In-Reply-To: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH v2 04/11] MIPS: Generate relocation table when CONFIG_RELOCATABLE
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, kernel-hardening@lists.openwall.com, Matt
 Redfearn <matt.redfearn@imgtec.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

When CONFIG_RELOCATABLE is enabled (added in later patch) add
--emit-relocs to vmlinux LDFLAGS so that fully linked vmlinux contains
relocation information.

Run the previously added relocs tool to fill in the .data.relocs section
of vmlinux with a table of relocations. The relocs tool will also remove
(mark as 0 length) the relocation sections added to vmlinux.

When vmlinux is passed to the boot makefile for conversion into a boot
image the now empty relocation sections will be removed and the
populated relocation table will be included in the binary image.

Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
---

Changes in v2: None

 arch/mips/Makefile | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index fa25d60bc717..8388ef6a0044 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -96,6 +96,10 @@ LDFLAGS_vmlinux			+= -G 0 -static -n -nostdlib
 KBUILD_AFLAGS_MODULE		+= -mlong-calls
 KBUILD_CFLAGS_MODULE		+= -mlong-calls
 
+ifeq ($(CONFIG_RELOCATABLE),y)
+LDFLAGS_vmlinux			+= --emit-relocs
+endif
+
 #
 # pass -msoft-float to GAS if it supports it.  However on newer binutils
 # (specifically newer than 2.24.51.20140728) we then also need to explicitly
@@ -313,6 +317,10 @@ rom.bin rom.sw: vmlinux
 		$(bootvars-y) $@
 endif
 
+CMD_RELOCS = arch/mips/boot/tools/relocs
+quiet_cmd_relocs = RELOCS  $<
+      cmd_relocs = $(CMD_RELOCS) $<
+
 #
 # Some machines like the Indy need 32-bit ELF binaries for booting purposes.
 # Other need ECOFF, so we build a 32-bit ELF binary for them which we then
@@ -321,6 +329,11 @@ endif
 quiet_cmd_32 = OBJCOPY $@
 	cmd_32 = $(OBJCOPY) -O $(32bit-bfd) $(OBJCOPYFLAGS) $< $@
 vmlinux.32: vmlinux
+ifeq ($(CONFIG_RELOCATABLE)$(CONFIG_64BIT),yy)
+# Currently, objcopy fails to handle the relocations in the elf64
+# So the relocs tool must be run here to remove them first
+	$(call cmd,relocs)
+endif
 	$(call cmd,32)
 
 #
@@ -336,6 +349,9 @@ all:	$(all-y)
 
 # boot
 $(boot-y): $(vmlinux-32) FORCE
+ifeq ($(CONFIG_RELOCATABLE)$(CONFIG_32BIT),yy)
+	$(call cmd,relocs)
+endif
 	$(Q)$(MAKE) $(build)=arch/mips/boot VMLINUX=$(vmlinux-32) \
 		$(bootvars-y) arch/mips/boot/$@
 
-- 
2.5.0
