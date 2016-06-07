Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  7 Jun 2016 14:57:08 -0700
Message-Id: <1465336628-18219-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1465336628-18219-1-git-send-email-keescook@chromium.org>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 5/5] lkdtm: split atomic test into over and underflow
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Each direction of the atomic wrapping should be individually testable.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm_core.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index f212f865f9c6..b5a544f2b645 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -111,7 +111,8 @@ enum ctype {
 	CT_WRITE_RO,
 	CT_WRITE_RO_AFTER_INIT,
 	CT_WRITE_KERN,
-	CT_WRAP_ATOMIC,
+	CT_ATOMIC_UNDERFLOW,
+	CT_ATOMIC_OVERFLOW,
 	CT_USERCOPY_HEAP_SIZE_TO,
 	CT_USERCOPY_HEAP_SIZE_FROM,
 	CT_USERCOPY_HEAP_FLAG_TO,
@@ -160,7 +161,8 @@ static char* cp_type[] = {
 	"WRITE_RO",
 	"WRITE_RO_AFTER_INIT",
 	"WRITE_KERN",
-	"WRAP_ATOMIC",
+	"ATOMIC_UNDERFLOW",
+	"ATOMIC_OVERFLOW",
 	"USERCOPY_HEAP_SIZE_TO",
 	"USERCOPY_HEAP_SIZE_FROM",
 	"USERCOPY_HEAP_FLAG_TO",
@@ -894,13 +896,25 @@ static void lkdtm_do_action(enum ctype which)
 		do_overwritten();
 		break;
 	}
-	case CT_WRAP_ATOMIC: {
+	case CT_ATOMIC_UNDERFLOW: {
 		atomic_t under = ATOMIC_INIT(INT_MIN);
-		atomic_t over = ATOMIC_INIT(INT_MAX);
 
-		pr_info("attempting atomic underflow\n");
+		pr_info("attempting good atomic increment\n");
+		atomic_inc(&under);
+		atomic_dec(&under);
+
+		pr_info("attempting bad atomic underflow\n");
 		atomic_dec(&under);
-		pr_info("attempting atomic overflow\n");
+		break;
+	}
+	case CT_ATOMIC_OVERFLOW: {
+		atomic_t over = ATOMIC_INIT(INT_MAX);
+
+		pr_info("attempting good atomic decrement\n");
+		atomic_dec(&over);
+		atomic_inc(&over);
+
+		pr_info("attempting bad atomic overflow\n");
 		atomic_inc(&over);
 
 		return;
-- 
2.7.4
