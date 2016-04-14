Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:02 -0700
Message-Id: <1460672954-32567-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 09/21] x86, KASLR: Correctly bounds-check relocations
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Yinghai Lu <yinghai@kernel.org>

Relocation handling performs bounds checking on the resulting calculated
addresses. The existing code uses output_len (VO size plus relocs size) as
the max address. This is not right since the max_addr check should stop at
the end of VO and exclude bss, brk, etc, which follows.  The valid range
should be VO [_text, __bss_start] in the loaded physical address space.

This patch adds an export for __bss_start in voffset.h and uses it to
get the correct max_addr.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/Makefile | 2 +-
 arch/x86/boot/compressed/misc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 81a8d0fd34eb..aa421126556d 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -45,7 +45,7 @@ LDFLAGS_vmlinux := -T
 hostprogs-y	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|__bss_start\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
 
 quiet_cmd_voffset = VOFFSET $@
       cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 6adb5b827aca..562d647289ac 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -259,7 +259,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 	int *reloc;
 	unsigned long delta, map, ptr;
 	unsigned long min_addr = (unsigned long)output;
-	unsigned long max_addr = min_addr + output_len;
+	unsigned long max_addr = min_addr + (VO___bss_start - VO__text);
 
 	/*
 	 * Calculate the delta between where vmlinux was linked to load
-- 
2.6.3
