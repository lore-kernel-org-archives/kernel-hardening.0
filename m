Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Feb 2016 13:49:04 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160216214904.GA23723@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] lkdtm: add test for executing .rodata
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laura Abbott <laura@labbott.name>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Make sure that the read-only data section isn't executable.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 11fdadc68e53..9835fcc0506e 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -100,6 +100,7 @@ enum ctype {
 	CT_EXEC_STACK,
 	CT_EXEC_KMALLOC,
 	CT_EXEC_VMALLOC,
+	CT_EXEC_RODATA,
 	CT_EXEC_USERSPACE,
 	CT_ACCESS_USERSPACE,
 	CT_WRITE_RO,
@@ -137,6 +138,7 @@ static char* cp_type[] = {
 	"EXEC_STACK",
 	"EXEC_KMALLOC",
 	"EXEC_VMALLOC",
+	"EXEC_RODATA",
 	"EXEC_USERSPACE",
 	"ACCESS_USERSPACE",
 	"WRITE_RO",
@@ -315,6 +317,12 @@ static int recursive_loop(int remaining)
 		return recursive_loop(remaining - 1);
 }
 
+static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
+do_nothing_rodata(void)
+{
+	return;
+}
+
 static void do_nothing(void)
 {
 	return;
@@ -335,15 +343,18 @@ static noinline void corrupt_stack(void)
 	memset((void *)data, 0, 64);
 }
 
-static void execute_location(void *dst)
+static void execute_location(void *dst, bool write)
 {
 	void (*func)(void) = dst;
 
 	pr_info("attempting ok execution at %p\n", do_nothing);
 	do_nothing();
 
-	memcpy(dst, do_nothing, EXEC_SIZE);
-	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
+	if (write) {
+		memcpy(dst, do_nothing, EXEC_SIZE);
+		flush_icache_range((unsigned long)dst,
+				   (unsigned long)dst + EXEC_SIZE);
+	}
 	pr_info("attempting bad execution at %p\n", func);
 	func();
 }
@@ -438,25 +449,28 @@ static void lkdtm_do_action(enum ctype which)
 		schedule();
 		break;
 	case CT_EXEC_DATA:
-		execute_location(data_area);
+		execute_location(data_area, true);
 		break;
 	case CT_EXEC_STACK: {
 		u8 stack_area[EXEC_SIZE];
-		execute_location(stack_area);
+		execute_location(stack_area, true);
 		break;
 	}
 	case CT_EXEC_KMALLOC: {
 		u32 *kmalloc_area = kmalloc(EXEC_SIZE, GFP_KERNEL);
-		execute_location(kmalloc_area);
+		execute_location(kmalloc_area, true);
 		kfree(kmalloc_area);
 		break;
 	}
 	case CT_EXEC_VMALLOC: {
 		u32 *vmalloc_area = vmalloc(EXEC_SIZE);
-		execute_location(vmalloc_area);
+		execute_location(vmalloc_area, true);
 		vfree(vmalloc_area);
 		break;
 	}
+	case CT_EXEC_RODATA:
+		execute_location(do_nothing_rodata, false);
+		break;
 	case CT_EXEC_USERSPACE: {
 		unsigned long user_addr;
 
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
