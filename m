Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 16:20:35 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160308002035.GA13606@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC][PATCH] s390, postinit-readonly: implement post-init RO
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@kernel.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since s390 already sets its .rodata section RO from the start, the generic
.data..ro_after_init section is already RO before init runs. For s390,
split the post-init read-only section off separately and handle that
when the call to mark_rodata_ro() is made.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is totally untested...
---
 arch/s390/Kconfig                |  3 +++
 arch/s390/include/asm/cache.h    |  2 ++
 arch/s390/include/asm/sections.h |  2 +-
 arch/s390/kernel/vmlinux.lds.S   |  6 ++++++
 arch/s390/mm/init.c              | 10 ++++++++++
 5 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3be9c832dec1..3f8b96f2cd2d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -59,6 +59,9 @@ config PCI_QUIRKS
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
+config DEBUG_RODATA
+	def_bool y
+
 config S390
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
index 4d7ccac5fd1d..816c2964bbee 100644
--- a/arch/s390/include/asm/cache.h
+++ b/arch/s390/include/asm/cache.h
@@ -15,4 +15,6 @@
 
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
+#define __ro_after_init __attribute__((__section__(".arch_ro_after_init")))
+
 #endif
diff --git a/arch/s390/include/asm/sections.h b/arch/s390/include/asm/sections.h
index fbd9116eb17b..6cc6acf87416 100644
--- a/arch/s390/include/asm/sections.h
+++ b/arch/s390/include/asm/sections.h
@@ -3,6 +3,6 @@
 
 #include <asm-generic/sections.h>
 
-extern char _eshared[], _ehead[];
+extern char _eshared[], _ehead[], __ro_after_init[];
 
 #endif
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 445657fe658c..39a2c7e4cdd2 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -52,6 +52,12 @@ SECTIONS
 
 	RW_DATA_SECTION(0x100, PAGE_SIZE, THREAD_SIZE)
 
+	. = ALIGN(PAGE_SIZE)
+	__ro_after_init = .;
+	.arch_ro_after_init : {
+		*(.arch_ro_after_init)	/* Read only after init */
+	}
+
 	_edata = .;		/* End of data section */
 
 	/* will be freed after init */
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 73e290337092..6033d396b96c 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -136,6 +136,16 @@ void free_initmem(void)
 	free_initmem_default(POISON_FREE_INITMEM);
 }
 
+void mark_rodata_ro(void)
+{
+	unsigned long start = (unsigned long) &__ro_after_init;
+	unsigned long end = (unsigned long) &_edata;
+
+	printk(KERN_INFO "Write protecting post-init read-only data: %luk\n",
+	       (end - start) >> 10);
+	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
+}
+
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
