From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:15 -0700
Message-Id: <1491343938-75336-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 4/7] bug: Enable DEBUG_CREDENTIALS under BUG_ON_DATA_CORRUPTION
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Since CONFIG_DEBUG_CREDENTIALS already handles reporting and issuing a
BUG when it encounters corruption, add this to the list of corruption
test CONFIGs that are enabled under CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5ac4d1148385..9a1b6b56cef4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1288,7 +1288,7 @@ config DEBUG_NOTIFIERS
 
 config DEBUG_CREDENTIALS
 	bool "Debug credential management"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on some debug checking for credential
 	  management.  The additional code keeps track of the number of
@@ -1996,6 +1996,7 @@ config TEST_STATIC_KEYS
 
 config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
+	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
 	help
 	  This option enables several inexpensive data corruption checks.
-- 
2.7.4
