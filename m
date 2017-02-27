From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:43:00 -0800
Message-Id: <1488228186-110679-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1488228186-110679-1-git-send-email-keescook@chromium.org>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH 2/8] lkdtm: add test for rare_write() infrastructure
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds the WRITE_RARE_WRITE test to validate variables marked with
__wr_rare. This isn't the final form of the test, since right now the
result is inverted from what is normally expected from LKDTM: it should
BUG on success...

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.h       |  1 +
 drivers/misc/lkdtm_core.c  |  1 +
 drivers/misc/lkdtm_perms.c | 21 ++++++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index cfa1039c62e7..42b5bb1f0062 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -35,6 +35,7 @@ void lkdtm_READ_BUDDY_AFTER_FREE(void);
 void __init lkdtm_perms_init(void);
 void lkdtm_WRITE_RO(void);
 void lkdtm_WRITE_RO_AFTER_INIT(void);
+void lkdtm_WRITE_RARE_WRITE(void);
 void lkdtm_WRITE_KERN(void);
 void lkdtm_EXEC_DATA(void);
 void lkdtm_EXEC_STACK(void);
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index 7eeb71a75549..cc5a0186d80b 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -219,6 +219,7 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(ACCESS_USERSPACE),
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
+	CRASHTYPE(WRITE_RARE_WRITE),
 	CRASHTYPE(WRITE_KERN),
 	CRASHTYPE(ATOMIC_UNDERFLOW),
 	CRASHTYPE(ATOMIC_OVERFLOW),
diff --git a/drivers/misc/lkdtm_perms.c b/drivers/misc/lkdtm_perms.c
index c7635a79341f..70559c76592e 100644
--- a/drivers/misc/lkdtm_perms.c
+++ b/drivers/misc/lkdtm_perms.c
@@ -20,12 +20,15 @@
 /* This is non-const, so it will end up in the .data section. */
 static u8 data_area[EXEC_SIZE];
 
-/* This is cost, so it will end up in the .rodata section. */
+/* This is const, so it will end up in the .rodata section. */
 static const unsigned long rodata = 0xAA55AA55;
 
 /* This is marked __ro_after_init, so it should ultimately be .rodata. */
 static unsigned long ro_after_init __ro_after_init = 0x55AA5500;
 
+/* This is marked __wr_rare, so it should ultimately be .rodata. */
+static unsigned long wr_rare __wr_rare = 0xAA66AA66;
+
 /*
  * This just returns to the caller. It is designed to be copied into
  * non-executable memory regions.
@@ -103,6 +106,22 @@ void lkdtm_WRITE_RO_AFTER_INIT(void)
 	*ptr ^= 0xabcd1234;
 }
 
+void lkdtm_WRITE_RARE_WRITE(void)
+{
+	/* Explicitly cast away "const" for the test. */
+	unsigned long *ptr = (unsigned long *)&wr_rare;
+
+#ifdef CONFIG_HAVE_ARCH_RARE_WRITE
+	pr_info("attempting good rare write at %p\n", ptr);
+	rare_write(*ptr, 0x11335577);
+	if (wr_rare != 0x11335577)
+		pr_warn("Yikes: wr_rare did not actually change!\n");
+#endif
+
+	pr_info("attempting bad rare write at %p\n", ptr);
+	*ptr ^= 0xbcd12345;
+}
+
 void lkdtm_WRITE_KERN(void)
 {
 	size_t size;
-- 
2.7.4
