Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Feb 2016 14:41:18 -0800
Message-Id: <1455748879-21872-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1455748879-21872-1-git-send-email-keescook@chromium.org>
References: <1455748879-21872-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 7/7] ARM: vdso: Mark vDSO code as read-only
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Brown <david.brown@linaro.org>

Although the arm vDSO is cleanly separated by code/data with the code
being read-only in userspace mappings, the code page is still writable
from the kernel.  There have been exploits (such as
http://itszn.com/blog/?p=21) that take advantage of this on x86 to go
from a bad kernel write to full root.

Prevent this specific exploit on arm by putting the vDSO code page in
post-init read-only memory as well.

Before:
vdso: 1 text pages at base 80927000
root@Vexpress:/ cat /sys/kernel/debug/kernel_page_tables
---[ Modules ]---
---[ Kernel Mapping ]---
0x80000000-0x80100000           1M     RW NX SHD
0x80100000-0x80600000           5M     ro x  SHD
0x80600000-0x80800000           2M     ro NX SHD
0x80800000-0xbe000000         984M     RW NX SHD

After:
vdso: 1 text pages at base 8072b000
root@Vexpress:/ cat /sys/kernel/debug/kernel_page_tables
---[ Modules ]---
---[ Kernel Mapping ]---
0x80000000-0x80100000           1M     RW NX SHD
0x80100000-0x80600000           5M     ro x  SHD
0x80600000-0x80800000           2M     ro NX SHD
0x80800000-0xbe000000         984M     RW NX SHD

Inspired by https://lkml.org/lkml/2016/1/19/494 based on work by the
PaX Team, Brad Spengler, and Kees Cook.

Signed-off-by: David Brown <david.brown@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/vdso/vdso.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/vdso/vdso.S b/arch/arm/vdso/vdso.S
index b2b97e3e7bab..a62a7b64f49c 100644
--- a/arch/arm/vdso/vdso.S
+++ b/arch/arm/vdso/vdso.S
@@ -23,9 +23,8 @@
 #include <linux/const.h>
 #include <asm/page.h>
 
-	__PAGE_ALIGNED_DATA
-
 	.globl vdso_start, vdso_end
+	.section .data..ro_after_init
 	.balign PAGE_SIZE
 vdso_start:
 	.incbin "arch/arm/vdso/vdso.so"
-- 
2.6.3
