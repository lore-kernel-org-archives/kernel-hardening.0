From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:08 +0100
Message-Id: <20170814125411.22604-28-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 27/30] efi/libstub: add 'max' parameter to efi_random_alloc()
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add an upper limit to efi_random_alloc() so we can use it to randomly
allocate the ARM kernel in lowmem.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |  2 +-
 drivers/firmware/efi/libstub/efistub.h    |  3 ++-
 drivers/firmware/efi/libstub/random.c     | 10 ++++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index b4c2589d7c91..940766f90adb 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -94,7 +94,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 		*reserve_size = kernel_memsize + offset;
 		status = efi_random_alloc(sys_table_arg, *reserve_size,
 					  MIN_KIMG_ALIGN, reserve_addr,
-					  (u32)phys_seed);
+					  (u32)phys_seed, ULONG_MAX);
 
 		*image_addr = *reserve_addr + offset;
 	} else {
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 83f268c05007..3a670a5f759f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -60,7 +60,8 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
 
 efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long size, unsigned long align,
-			      unsigned long *addr, unsigned long random_seed);
+			      unsigned long *addr, unsigned long random_seed,
+			      unsigned long max);
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 7e72954d5860..85b80a4a85b3 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -42,7 +42,8 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
  */
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long size,
-					 unsigned long align_shift)
+					 unsigned long align_shift,
+					 unsigned long max)
 {
 	unsigned long align = 1UL << align_shift;
 	u64 first_slot, last_slot, region_end;
@@ -50,7 +51,7 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
 		return 0;
 
-	region_end = min((u64)ULONG_MAX, md->phys_addr + md->num_pages*EFI_PAGE_SIZE - 1);
+	region_end = min((u64)max, md->phys_addr + md->num_pages*EFI_PAGE_SIZE - 1);
 
 	first_slot = round_up(md->phys_addr, align);
 	last_slot = round_down(region_end - size + 1, align);
@@ -73,7 +74,8 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long size,
 			      unsigned long align,
 			      unsigned long *addr,
-			      unsigned long random_seed)
+			      unsigned long random_seed,
+			      unsigned long max)
 {
 	unsigned long map_size, desc_size, total_slots = 0, target_slot;
 	unsigned long buff_size;
@@ -101,7 +103,7 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 		efi_memory_desc_t *md = (void *)memory_map + map_offset;
 		unsigned long slots;
 
-		slots = get_entry_num_slots(md, size, ilog2(align));
+		slots = get_entry_num_slots(md, size, ilog2(align), max);
 		MD_NUM_SLOTS(md) = slots;
 		total_slots += slots;
 	}
-- 
2.11.0
