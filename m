Reply-To: kernel-hardening@lists.openwall.com
From: Matt Redfearn <matt.redfearn@imgtec.com>
Date: Thu, 31 Mar 2016 10:05:42 +0100
Message-ID: <1459415142-3412-12-git-send-email-matt.redfearn@imgtec.com>
In-Reply-To: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH v2 11/11] MIPS: KASLR: Print relocation Information on boot
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, kernel-hardening@lists.openwall.com, Matt
 Redfearn <matt.redfearn@imgtec.com>, Aaro Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, linux-kernel@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>, Jonas Gorski <jogo@openwrt.org>, Paul Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

When debugging a relocated kernel, the addresses of the relocated
symbols and the offset applied is essential information. If the kernel
is compiled with debugging information, then print this information
during bootup using the same function as the panic notifer.

Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
---

Changes in v2: None

 arch/mips/kernel/setup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index d8376d7b3345..ae71f8d9b555 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -477,9 +477,18 @@ static void __init bootmem_init(void)
 	 */
 	if (__pa_symbol(_text) > __pa_symbol(VMLINUX_LOAD_ADDRESS)) {
 		unsigned long offset;
+		extern void show_kernel_relocation(const char *level);
 
 		offset = __pa_symbol(_text) - __pa_symbol(VMLINUX_LOAD_ADDRESS);
 		free_bootmem(__pa_symbol(VMLINUX_LOAD_ADDRESS), offset);
+
+#if (defined CONFIG_DEBUG_KERNEL) && (defined CONFIG_DEBUG_INFO)
+		/*
+		 * This information is necessary when debugging the kernel
+		 * But is a security vulnerability otherwise!
+		 */
+		show_kernel_relocation(KERN_INFO);
+#endif
 	}
 #endif
 
-- 
2.5.0
