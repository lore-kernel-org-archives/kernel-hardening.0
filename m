From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Feb 2017 15:26:49 -0800
Message-Id: <1486164412-7338-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1486164412-7338-1-git-send-email-keescook@chromium.org>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/4] refcount_t: fix Kconfig help
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Minor fix to build refcount_t series.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6f61d32ee536..20fde8d4523a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -731,7 +731,7 @@ source "lib/Kconfig.kasan"
 
 config DEBUG_REFCOUNT
 	bool "Verbose refcount checks"
-	--help--
+	help
 	  Say Y here if you want reference counters (refcount_t and kref) to
 	  generate WARNs on dubious usage. Without this refcount_t will still
 	  be a saturating counter and avoid Use-After-Free by turning it into
-- 
2.7.4
