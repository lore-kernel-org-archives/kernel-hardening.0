Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:00 -0700
Message-Id: <1460672954-32567-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 07/21] x86, boot: Fix run_size calculation
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Junjie Mao <eternal.n08@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Currently, the kernel run_size (size of code plus brk and bss) is
calculated via the shell script arch/x86/tools/calc_run_size.sh. It gets
the file offset and mem size of for the .bss and .brk sections in vmlinux,
and adds them as follows:

run_size=$(( $offsetA + $sizeA + $sizeB ))

However, this is not correct (it is too large). To illustrate, here's
a walk-through of the script's calculation, compared to the correct way
to find it.

First, offsetA is found as the starting address of the first .bss or
.brk section seen in the ELF file. The sizeA and sizeB values are the
respective section sizes.

[bhe@x1 linux]$ objdump -h vmlinux

vmlinux:     file format elf64-x86-64

Sections:
Idx Name    Size      VMA               LMA               File off  Algn
 27 .bss    00170000  ffffffff81ec8000  0000000001ec8000  012c8000  2**12
            ALLOC
 28 .brk    00027000  ffffffff82038000  0000000002038000  012c8000  2**0
            ALLOC

Here, offsetA is 0x012c8000, with sizeA at 0x00170000 and sizeB at
0x00027000. The resulting run_size is 0x145f000:

0x012c8000 + 0x00170000 + 0x00027000 = 0x145f000

However, if we instead examine the ELF LOAD program headers, we see a
different picture.

[bhe@x1 linux]$ readelf -l vmlinux

Elf file type is EXEC (Executable file)
Entry point 0x1000000
There are 5 program headers, starting at offset 64

Program Headers:
  Type        Offset             VirtAddr           PhysAddr
              FileSiz            MemSiz              Flags  Align
  LOAD        0x0000000000200000 0xffffffff81000000 0x0000000001000000
              0x0000000000b5e000 0x0000000000b5e000  R E    200000
  LOAD        0x0000000000e00000 0xffffffff81c00000 0x0000000001c00000
              0x0000000000145000 0x0000000000145000  RW     200000
  LOAD        0x0000000001000000 0x0000000000000000 0x0000000001d45000
              0x0000000000018158 0x0000000000018158  RW     200000
  LOAD        0x000000000115e000 0xffffffff81d5e000 0x0000000001d5e000
              0x000000000016a000 0x0000000000301000  RWE    200000
  NOTE        0x000000000099bcac 0xffffffff8179bcac 0x000000000179bcac
              0x00000000000001bc 0x00000000000001bc         4

 Section to Segment mapping:
  Segment Sections...
   00     .text .notes __ex_table .rodata __bug_table .pci_fixup .tracedata
          __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata __param
          __modver
   01     .data .vvar
   02     .data..percpu
   03     .init.text .init.data .x86_cpu_dev.init .parainstructions
          .altinstructions .altinstr_replacement .iommu_table .apicdrivers
          .exit.text .smp_locks .bss .brk
   04     .notes

As mentioned, run_size needs to be the size of the running kernel
including .bss and .brk. We can see from the Section/Segment mapping
above that .bss and .brk are included in segment 03 (which corresponds
to the final LOAD program header). To find the run_size, we calculate
the end of the LOAD segment from its PhysAddr start (0x0000000001d5e000)
and its MemSiz (0x0000000000301000), minus the physical load address of
the kernel (the first LOAD segment's PhysAddr: 0x0000000001000000). The
resulting run_size is 0x105f000:

0x0000000001d5e000 + 0x0000000000301000 - 0x0000000001000000 = 0x105f000

So, from this we can see that the existing run_size calculation is
0x400000 too high. And, as it turns out, the correct run_size is
actually equal to VO_end - VO_text, which is certainly easier to calculate.
_end: 0xffffffff8205f000
_text:0xffffffff81000000

0xffffffff8205f000 - 0xffffffff81000000 = 0x105f000

As a result, run_size is a simple constant, so we don't need to pass it
around; we already have voffset.h such things. We can share voffset.h
between misc.c and header.S instead of getting run_size in other ways.
This patch moves voffset.h creation code to boot/compressed/Makefile,
and switches misc.c to use the VO_end - VO_text calculation.

Dependence before:
boot/header.S ==> boot/voffset.h ==> vmlinux
boot/header.S ==> compressed/vmlinux ==> compressed/misc.c

Dependence after:
boot/header.S ==> compressed/vmlinux ==> compressed/misc.c ==>
                  boot/voffset.h ==> vmlinux

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/Makefile            | 11 +----------
 arch/x86/boot/compressed/Makefile | 12 ++++++++++++
 arch/x86/boot/compressed/misc.c   |  3 +++
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 942f7dabfb1e..700a9c6e6159 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,15 +86,6 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
-
-quiet_cmd_voffset = VOFFSET $@
-      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
-
-targets += voffset.h
-$(obj)/voffset.h: vmlinux FORCE
-	$(call if_changed,voffset)
-
 sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
@@ -106,7 +97,7 @@ $(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
 
 
 AFLAGS_header.o += -I$(obj)
-$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
+$(obj)/header.o: $(obj)/zoffset.h
 
 LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 6915ff2bd996..323674a9d6db 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -45,6 +45,18 @@ LDFLAGS_vmlinux := -T
 hostprogs-y	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
+
+quiet_cmd_voffset = VOFFSET $@
+      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
+
+targets += ../voffset.h
+
+$(obj)/../voffset.h: vmlinux FORCE
+	$(call if_changed,voffset)
+
+$(obj)/misc.o: $(obj)/../voffset.h
+
 vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o \
 	$(obj)/piggy.o $(obj)/cpuflags.o
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 31e2d6155643..4d878a7b9fab 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -11,6 +11,7 @@
 
 #include "misc.h"
 #include "../string.h"
+#include "../voffset.h"
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -415,6 +416,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	run_size = VO__end - VO__text;
+
 	console_init();
 	debug_putstr("early console in decompress_kernel\n");
 
-- 
2.6.3
