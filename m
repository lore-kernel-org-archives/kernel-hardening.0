From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:54:09 +0100
Message-Id: <20170814125411.22604-29-ard.biesheuvel@linaro.org>
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 28/30] efi/libstub: check for vmalloc= command line argument
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Check for and record the presence of a vmalloc= argument on the
kernel command line. We need this information on ARM systems when
implementing KASLR, given that the size of the vmalloc region will
affect the size of the lowmem region, therefore affecting the
available randomization range as well.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 9 +++++++++
 drivers/firmware/efi/libstub/efistub.h         | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index b0184360efc6..f3e9d43030ac 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -34,6 +34,7 @@ static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
 static int __section(.data) __nokaslr;
 static int __section(.data) __quiet;
+static int __section(.data) __vmalloc_arg;
 
 int __pure nokaslr(void)
 {
@@ -43,6 +44,10 @@ int __pure is_quiet(void)
 {
 	return __quiet;
 }
+int __pure have_vmalloc(void)
+{
+	return __vmalloc_arg;
+}
 
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
@@ -433,6 +438,10 @@ efi_status_t efi_parse_options(char const *cmdline)
 	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
 		__quiet = 1;
 
+	str = strstr(cmdline, "vmalloc=");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__vmalloc_arg = 1;
+
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 3a670a5f759f..aaf2aeb785ea 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -26,6 +26,7 @@
 
 extern int __pure nokaslr(void);
 extern int __pure is_quiet(void);
+extern int __pure have_vmalloc(void);
 
 #define pr_efi(sys_table, msg)		do {				\
 	if (!is_quiet()) efi_printk(sys_table, "EFI stub: "msg);	\
-- 
2.11.0
