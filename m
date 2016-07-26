Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 22:42:34 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160726224234.c680b28a327365604664cb2b@gmail.com>
In-Reply-To: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 6/7] Mark a few functions with the printf attribute
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

This allows not only compile time format string checking but can also
increase the coverage of the initify plugin.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/scsi/esas2r/esas2r_log.h | 4 ++--
 include/acpi/acpiosxf.h          | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.h b/drivers/scsi/esas2r/esas2r_log.h
index 7b6397b..75b9d23 100644
--- a/drivers/scsi/esas2r/esas2r_log.h
+++ b/drivers/scsi/esas2r/esas2r_log.h
@@ -61,8 +61,8 @@ enum {
 #endif
 };
 
-int esas2r_log(const long level, const char *format, ...);
-int esas2r_log_dev(const long level,
+__printf(2, 3) int esas2r_log(const long level, const char *format, ...);
+__printf(3, 4) int esas2r_log_dev(const long level,
 		   const struct device *dev,
 		   const char *format,
 		   ...);
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 562603d..7ee4475 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -337,11 +337,12 @@ acpi_status acpi_os_signal(u32 function, void *info);
  * Debug print routines
  */
 #ifndef ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_printf
+__printf(1, 2)
 void ACPI_INTERNAL_VAR_XFACE acpi_os_printf(const char *format, ...);
 #endif
 
 #ifndef ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_vprintf
-void acpi_os_vprintf(const char *format, va_list args);
+__printf(1, 0) void acpi_os_vprintf(const char *format, va_list args);
 #endif
 
 #ifndef ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_redirect_output
-- 
2.8.1
