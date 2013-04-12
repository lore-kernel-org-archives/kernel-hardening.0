Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 Apr 2013 13:13:45 -0700
Message-Id: <1365797627-20874-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-1-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/6] x86: relocs: build separate 32/64-bit tools
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since the ELF structures and access macros change size based on 32 vs
64 bits, build a separate 32-bit relocs tool (for handling realmode
and 32-bit relocations), and a 64-bit relocs tool (for handling 64-bit
kernel relocations).

Signed-off-by: Kees Cook <keescook@chromium.org>
--
This is ugly with the "cp". Is there some other cleaner way to trigger
two builds with different defines from the same source file?
---
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/realmode/rm/Makefile     |    2 +-
 arch/x86/tools/.gitignore         |    3 ++-
 arch/x86/tools/Makefile           |   20 ++++++++++++++++++--
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 5ef205c..0dac175 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -44,7 +44,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
-CMD_RELOCS = arch/x86/tools/relocs
+CMD_RELOCS = arch/x86/tools/relocs_$(BITS)
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 8869287..2b1e429 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -56,7 +56,7 @@ $(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
+      cmd_relocs = arch/x86/tools/relocs_32 --realmode $< > $@
 
 targets += realmode.relocs
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
index be0ed06..2b45d5f 100644
--- a/arch/x86/tools/.gitignore
+++ b/arch/x86/tools/.gitignore
@@ -1 +1,2 @@
-relocs
+relocs_32*
+relocs_64*
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index bae601f..a8cb70c 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -37,6 +37,22 @@ $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/in
 
 $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
+HOSTCFLAGS_relocs_32.o += -DELF_BITS=32
+HOSTCFLAGS_relocs_64.o += -DELF_BITS=64
+
+quiet_cmd_cp_reloc = GEN     $@
+      cmd_cp_reloc = cp $< $@
+
+$(obj)/relocs_%.c: $(srctree)/arch/x86/tools/relocs.c
+	$(call cmd,cp_reloc)
+
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
-hostprogs-y	+= relocs
-relocs: $(obj)/relocs
+hostprogs-y    += relocs_$(BITS)
+relocs_binaries = relocs_$(BITS)
+ifeq ($(CONFIG_64BIT),y)
+	hostprogs-y  += relocs_32
+	relocs_binaries += relocs_32
+endif
+relocs: $(relocs_binaries)
+relocs_32: $(obj)/relocs_32
+relocs_64: $(obj)/relocs_64
-- 
1.7.9.5
