From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:24 -0700
Message-Id: <1495829844-69341-21-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 20/20] ACPICA: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The struct layout randomization plugin detects and randomizes any structs
that contain only function pointers. Once layout is randomized, all
initialization must be designated or the compiler will misalign the
assignments. This switches all the ACPICA function pointer struct to
use designated initializers, using the proposed upstream ACPICA macro:
https://github.com/acpica/acpica/pull/248/

Cc: Bob Moore <robert.moore@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/acpica/hwxfsleep.c               | 14 +++++++++-----
 include/acpi/platform/acenv.h                 |  4 ++++
 include/acpi/platform/aclinux.h               |  2 ++
 scripts/gcc-plugins/randomize_layout_plugin.c |  4 ----
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 5733b1167e46..558fe4cdf29a 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -70,11 +70,15 @@ static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
 /* Legacy functions are optional, based upon ACPI_REDUCED_HARDWARE */
 
 static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_sleep),
-	 acpi_hw_extended_sleep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake_prep),
-	 acpi_hw_extended_wake_prep},
-	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake), acpi_hw_extended_wake}
+	{ACPI_STRUCT_INIT (legacy_function,
+			   ACPI_HW_OPTIONAL_FUNCTION (acpi_hw_legacy_sleep)),
+	 ACPI_STRUCT_INIT (extended_function, acpi_hw_extended_sleep) },
+	{ACPI_STRUCT_INIT (legacy_function,
+			   ACPI_HW_OPTIONAL_FUNCTION (acpi_hw_legacy_wake_prep)),
+	 ACPI_STRUCT_INIT (extended_function, acpi_hw_extended_wake_prep) },
+	{ACPI_STRUCT_INIT (legacy_function,
+			   ACPI_HW_OPTIONAL_FUNCTION (acpi_hw_legacy_wake)),
+	 ACPI_STRUCT_INIT (extended_function, acpi_hw_extended_wake) }
 };
 
 /*
diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
index 09994b063243..912563c66948 100644
--- a/include/acpi/platform/acenv.h
+++ b/include/acpi/platform/acenv.h
@@ -382,4 +382,8 @@
 #define ACPI_INIT_FUNCTION
 #endif
 
+#ifndef ACPI_STRUCT_INIT
+#define ACPI_STRUCT_INIT(field, value) value
+#endif
+
 #endif				/* __ACENV_H__ */
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index a39e3f67616f..047f13865608 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -178,6 +178,8 @@
 #define ACPI_MSG_BIOS_ERROR     KERN_ERR "ACPI BIOS Error (bug): "
 #define ACPI_MSG_BIOS_WARNING   KERN_WARNING "ACPI BIOS Warning (bug): "
 
+#define ACPI_STRUCT_INIT(field, value)	.field = value
+
 #else				/* !__KERNEL__ */
 
 #define ACPI_USE_STANDARD_HEADERS
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index bb2c6789c4b7..e1526554487e 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -346,10 +346,6 @@ static int relayout_struct(tree type)
 	    !strcmp((const char *)ORIG_TYPE_NAME(type), "RAWPCIFACTORY"))
 		return 0;
 
-	/* Skip ACPICA structs until refreshed with designated_init. */
-	if (!strcmp((const char *)ORIG_TYPE_NAME(type), "acpi_sleep_functions"))
-		return 0;
-
 	/* throw out any structs in uapi */
 	xloc = expand_location(DECL_SOURCE_LOCATION(TYPE_FIELDS(type)));
 
-- 
2.7.4
