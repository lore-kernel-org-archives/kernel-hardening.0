From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 13:07:30 +0100
Message-Id: <20170903120757.14968-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 02/29] asm-generic: add .data.rel.ro sections to __ro_after_init
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

When running in PIC mode, the compiler will emit const structures
containing runtime relocatable quantities into .data.rel.ro.* sections,
so that the linker can be smart about placing them together in a segment
that is read-write initially, and is remapped read-only afterwards. This
is exactly what __ro_after_init aims to provide, so move these sections
together.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index da0be9a8d1de..d16537b0b102 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -261,7 +261,7 @@
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
 	VMLINUX_SYMBOL(__start_ro_after_init) = .;			\
-	*(.data..ro_after_init)						\
+	*(.data..ro_after_init .data.rel.ro.*)				\
 	VMLINUX_SYMBOL(__end_ro_after_init) = .;
 #endif
 
-- 
2.11.0
