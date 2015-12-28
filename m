Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:54 +0100
Message-Id: <1451301654-32019-11-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 10/10] arm64: efi: invoke EFI_RNG_PROTOCOL to supply KASLR randomness
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since arm64 does not use a decompressor that supplies an execution
environment where it is feasible to some extent to provide a source of
randomness, the arm64 KASLR kernel depends on the bootloader to supply
some random bits in register x1 upon kernel entry.

On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
some random bits.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi-entry.S           |  7 +++--
 drivers/firmware/efi/libstub/arm-stub.c | 31 ++++++++++++++++++++
 include/linux/efi.h                     |  5 +++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index f82036e02485..e9bd55de14dd 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -110,7 +110,7 @@ ENTRY(entry)
 2:
 	/* Jump to kernel entry point */
 	mov	x0, x20
-	mov	x1, xzr
+	ldr	x1, efi_random_bytes
 	mov	x2, xzr
 	mov	x3, xzr
 	br	x21
@@ -119,6 +119,9 @@ efi_load_fail:
 	mov	x0, #EFI_LOAD_ERROR
 	ldp	x29, x30, [sp], #32
 	ret
+ENDPROC(entry)
+
+ENTRY(efi_random_bytes)
+	.quad	0
 
 entry_end:
-ENDPROC(entry)
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 950c87f5d279..ebdf7137fe97 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -145,6 +145,31 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
 	out->output_string(out, str);
 }
 
+struct efi_rng_protocol_t {
+	efi_status_t (*get_info)(struct efi_rng_protocol_t *, unsigned long *, efi_guid_t *);
+	efi_status_t (*get_rng)(struct efi_rng_protocol_t *, efi_guid_t *, unsigned long, u8 *out);
+};
+
+static int efi_get_random_bytes(efi_system_table_t *sys_table)
+{
+	extern u64 efi_random_bytes;
+
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	efi_status_t status;
+	struct efi_rng_protocol_t *rng;
+
+	status = sys_table->boottime->locate_protocol(&rng_proto, NULL,
+						      (void **)&rng);
+	if (status == EFI_NOT_FOUND) {
+		pr_efi(sys_table, "EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
+		return EFI_SUCCESS;
+	}
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	return rng->get_rng(rng, NULL, sizeof(u64), (u8 *)&efi_random_bytes);
+}
 
 /*
  * This function handles the architcture specific differences between arm and
@@ -267,6 +292,12 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		pr_efi_err(sys_table, "Failed initrd from command line!\n");
 
+	if (IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL)) {
+		status = efi_get_random_bytes(sys_table);
+		if (status != EFI_SUCCESS)
+			pr_efi_err(sys_table, "efi_get_random_bytes() failed\n");
+	}
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
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
