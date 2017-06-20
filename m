Date: Mon, 19 Jun 2017 23:56:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170620065631.GA25354@infradead.org>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
 <1497905801-69164-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497905801-69164-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 3/4] randstruct: Disable randomization of ACPICA structs
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 01:56:40PM -0700, Kees Cook wrote:
> Since the ACPICA source is maintained externally to the kernel, we can
> neither switch it to designated initializers nor mark it
> __no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
> designated initialization, explicitly skip it in the plugin.

NAK.  ACPI has no business rejecting kernel changes to start with, but
independent of that your patch was complete garbage anyway.

There is no need for function pointers here, please include the patch
below instead:

---
>From e8046f6507c2ed60bc501a0c0caa5a3f15f5e3e4 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 28 May 2017 09:53:45 +0300
Subject: acpi: get rid of acpi_sleep_dispatch

No need for the array of structs of function pointers when we can just
call the handfull of functions directly.

This could be further cleaned up if acpi_gbl_reduced_hardware was defined
true in the ACPI_REDUCED_HARDWARE case, but that's material for the next
round.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/acpi/acpica/hwxfsleep.c | 89 +++++++++--------------------------------
 include/acpi/actypes.h          |  9 -----
 2 files changed, 18 insertions(+), 80 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 5733b1167e46..66fa3ebddd57 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -57,26 +57,6 @@ acpi_hw_set_firmware_waking_vector(struct acpi_table_facs *facs,
 				   acpi_physical_address physical_address64);
 #endif
 
-static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
-
-/*
- * Dispatch table used to efficiently branch to the various sleep
- * functions.
- */
-#define ACPI_SLEEP_FUNCTION_ID         0
-#define ACPI_WAKE_PREP_FUNCTION_ID     1
-#define ACPI_WAKE_FUNCTION_ID          2
-
-/* Legacy functions are optional, based upon ACPI_REDUCED_HARDWARE */
-
-static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_sleep),
-	 acpi_hw_extended_sleep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake_prep),
-	 acpi_hw_extended_wake_prep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake), acpi_hw_extended_wake}
-};
-
 /*
  * These functions are removed for the ACPI_REDUCED_HARDWARE case:
  *      acpi_set_firmware_waking_vector
@@ -236,53 +216,6 @@ acpi_status acpi_enter_sleep_state_s4bios(void)
 
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
 #endif				/* !ACPI_REDUCED_HARDWARE */
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_sleep_dispatch
- *
- * PARAMETERS:  sleep_state         - Which sleep state to enter/exit
- *              function_id         - Sleep, wake_prep, or Wake
- *
- * RETURN:      Status from the invoked sleep handling function.
- *
- * DESCRIPTION: Dispatch a sleep/wake request to the appropriate handling
- *              function.
- *
- ******************************************************************************/
-static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
-{
-	acpi_status status;
-	struct acpi_sleep_functions *sleep_functions =
-	    &acpi_sleep_dispatch[function_id];
-
-#if (!ACPI_REDUCED_HARDWARE)
-	/*
-	 * If the Hardware Reduced flag is set (from the FADT), we must
-	 * use the extended sleep registers (FADT). Note: As per the ACPI
-	 * specification, these extended registers are to be used for HW-reduced
-	 * platforms only. They are not general-purpose replacements for the
-	 * legacy PM register sleep support.
-	 */
-	if (acpi_gbl_reduced_hardware) {
-		status = sleep_functions->extended_function(sleep_state);
-	} else {
-		/* Legacy sleep */
-
-		status = sleep_functions->legacy_function(sleep_state);
-	}
-
-	return (status);
-
-#else
-	/*
-	 * For the case where reduced-hardware-only code is being generated,
-	 * we know that only the extended sleep registers are available
-	 */
-	status = sleep_functions->extended_function(sleep_state);
-	return (status);
-
-#endif				/* !ACPI_REDUCED_HARDWARE */
-}
 
 /*******************************************************************************
  *
@@ -389,7 +322,12 @@ acpi_status acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
 	}
 
-	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_SLEEP_FUNCTION_ID);
+#if !ACPI_REDUCED_HARDWARE
+	if (!acpi_gbl_reduced_hardware)
+		status = acpi_hw_legacy_sleep(sleep_state);
+	else
+#endif
+		status = acpi_hw_extended_sleep(sleep_state);
 	return_ACPI_STATUS(status);
 }
 
@@ -415,8 +353,12 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
 
-	status =
-	    acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_PREP_FUNCTION_ID);
+#if !ACPI_REDUCED_HARDWARE
+	if (!acpi_gbl_reduced_hardware)
+		status = acpi_hw_legacy_wake_prep(sleep_state);
+	else
+#endif
+		status = acpi_hw_extended_wake_prep(sleep_state);
 	return_ACPI_STATUS(status);
 }
 
@@ -440,7 +382,12 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
-	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_FUNCTION_ID);
+#if !ACPI_REDUCED_HARDWARE
+	if (!acpi_gbl_reduced_hardware)
+		status = acpi_hw_legacy_wake(sleep_state);
+	else
+#endif
+		status = acpi_hw_extended_wake(sleep_state);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index d549e31c6d18..cfcb3abc65b9 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -894,15 +894,6 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_ENABLE_EVENT                       1
 #define ACPI_DISABLE_EVENT                      0
 
-/* Sleep function dispatch */
-
-typedef acpi_status (*acpi_sleep_function) (u8 sleep_state);
-
-struct acpi_sleep_functions {
-	acpi_sleep_function legacy_function;
-	acpi_sleep_function extended_function;
-};
-
 /*
  * External ACPI object definition
  */
-- 
2.11.0
