From: Kees Cook <keescook@chromium.org>
Date: Mon,  2 Oct 2017 12:20:05 -0700
Message-Id: <1506972007-80614-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1506972007-80614-1-git-send-email-keescook@chromium.org>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/3] sh/boot: Add static stack-protector to pre-kernel
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Laura Abbott <labbott@redhat.com>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The sh decompressor code triggers stack-protector code generation when
using CONFIG_CC_STACKPROTECTOR_STRONG. As done for arm and mips, add a
simple static stack-protector canary. As this wasn't protected before, the
risk of using a weak canary is minimized. Once the kernel is actually up,
a better canary is chosen.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/sh/boot/compressed/misc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index ae1dfdb0013b..f4bdc5d00c04 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -103,6 +103,18 @@ static void error(char *x)
 	while(1);	/* Halt */
 }
 
+unsigned long __stack_chk_guard;
+
+void __stack_chk_guard_setup(void)
+{
+	__stack_chk_guard = 0x000a0dff;
+}
+
+void __stack_chk_fail(void)
+{
+	error("stack-protector: Kernel stack is corrupted\n");
+}
+
 #ifdef CONFIG_SUPERH64
 #define stackalign	8
 #else
@@ -117,6 +129,8 @@ void decompress_kernel(void)
 {
 	unsigned long output_addr;
 
+	__stack_chk_guard_setup();
+
 #ifdef CONFIG_SUPERH64
 	output_addr = (CONFIG_MEMORY_START + 0x2000);
 #else
-- 
2.7.4
