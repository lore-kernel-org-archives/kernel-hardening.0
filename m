Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:19:12 +0100
Message-Id: <1452518355-4606-20-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 18/21] efi: stub: implement efi_get_random_bytes() based on EFI_RNG_PROTOCOL
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This exposes the firmware's implementation of EFI_RNG_PROTOCOL via a new
function efi_get_random_bytes().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/Makefile  |  2 +-
 drivers/firmware/efi/libstub/efistub.h |  3 ++
 drivers/firmware/efi/libstub/random.c  | 35 ++++++++++++++++++++
 include/linux/efi.h                    |  5 ++-
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index c0ddd1b8dca3..9f0c813d739c 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -23,7 +23,7 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 
-lib-y				:= efi-stub-helper.o
+lib-y				:= efi-stub-helper.o random.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 6b6548fda089..206b7252b9d1 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -43,4 +43,7 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count);
 
+efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
+				  unsigned long size, u8 *out);
+
 #endif
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
new file mode 100644
index 000000000000..f539b1e31459
--- /dev/null
+++ b/drivers/firmware/efi/libstub/random.c
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd;  <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
+struct efi_rng_protocol_t {
+	efi_status_t (*get_info)(struct efi_rng_protocol_t *,
+				 unsigned long *, efi_guid_t *);
+	efi_status_t (*get_rng)(struct efi_rng_protocol_t *,
+				efi_guid_t *, unsigned long, u8 *out);
+};
+
+efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
+				  unsigned long size, u8 *out)
+{
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	efi_status_t status;
+	struct efi_rng_protocol_t *rng;
+
+	status = sys_table->boottime->locate_protocol(&rng_proto, NULL,
+						      (void **)&rng);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	return rng->get_rng(rng, NULL, size, out);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a866bb1..13783fdc9bdd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -299,7 +299,7 @@ typedef struct {
 	void *open_protocol_information;
 	void *protocols_per_handle;
 	void *locate_handle_buffer;
-	void *locate_protocol;
+	efi_status_t (*locate_protocol)(efi_guid_t *, void *, void **);
 	void *install_multiple_protocol_interfaces;
 	void *uninstall_multiple_protocol_interfaces;
 	void *calculate_crc32;
@@ -599,6 +599,9 @@ void efi_native_runtime_setup(void);
 #define EFI_PROPERTIES_TABLE_GUID \
     EFI_GUID(  0x880aaca3, 0x4adc, 0x4a04, 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5 )
 
+#define EFI_RNG_PROTOCOL_GUID \
+    EFI_GUID(  0x3152bca5, 0xeade, 0x433d, 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
2.5.0
