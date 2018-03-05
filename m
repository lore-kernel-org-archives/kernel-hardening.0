Date: Mon, 5 Mar 2018 20:18:24 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH v2 2/2] arm: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE
Message-ID: <20180305111824.GA4216@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, luto@amacapital.net, dsafonov@virtuozzo.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, danielmicay@gmail.com, arnd@arndb.de, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

CONFIG_FORTIFY_SOURCE detects various overflows at compile-time.
(6974f0c4555e ("include/linux/string.h:
add the option of fortified string.h functions)

ARCH_HAS_FORTIFY_SOURCE means that the architecture can be built and
run with CONFIG_FORTIFY_SOURCE.

Since ARM can be built and run with that flag like other architectures,
select ARCH_HAS_FORTIFY_SOURCE as default.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
v2: Add fortify_panic() in arch/arm/boot/compressed/misc.c,
    Because there will be a build error if without that function.
---
 arch/arm/Kconfig                | 1 +
 arch/arm/boot/compressed/misc.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7e3d535..3765336 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -7,6 +7,7 @@ config ARM
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 16a8a80..4a247ac 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -167,3 +167,8 @@ void __stack_chk_fail(void)
 	else
 		putstr(" done, booting the kernel.\n");
 }
+
+void fortify_panic(const char *name)
+{
+	error("detected buffer overflow");
+}
-- 
1.9.1
