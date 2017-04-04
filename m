From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:16 -0700
Message-Id: <1491343938-75336-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 5/7] bug: Enable DEBUG_SG under BUG_ON_DATA_CORRUPTION
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Similar to CONFIG_DEBUG_CREDENTIALS, CONFIG_DEBUG_SG already handles
calling BUG, and performs inexpensive checks. This enables it under
CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9a1b6b56cef4..45bfc0be38fc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1268,7 +1268,7 @@ config DEBUG_PI_LIST
 
 config DEBUG_SG
 	bool "Debug SG table operations"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on checks on scatter-gather tables. This can
 	  help find problems with drivers that do not properly initialize
@@ -1998,6 +1998,7 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
+	select DEBUG_SG
 	help
 	  This option enables several inexpensive data corruption checks.
 	  Most of these checks normally just WARN and try to further avoid
-- 
2.7.4
