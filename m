From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:12 -0700
Message-Id: <1491343938-75336-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 1/7] bug: Clarify help text for BUG_ON_DATA_CORRUPTION
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This expands on the Kconfig help text for CONFIG_BUG_ON_DATA_CORRUPTION to
more clearly explain the rationale of BUG vs WARN. Additionally fixes a
grammar glitch in the macro comment.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h | 3 ++-
 lib/Kconfig.debug   | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 687b557fc5eb..db1e41c69bac 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -124,7 +124,8 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 
 /*
  * Since detected data corruption should stop operation on the affected
- * structures. Return value must be checked and sanely acted on by caller.
+ * structures, require that the condition is checked and sanely acted on
+ * by the caller.
  */
 static inline __must_check bool check_data_corruption(bool v) { return v; }
 #define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 77fadface4f9..5ac4d1148385 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1998,9 +1998,12 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_LIST
 	help
-	  Select this option if the kernel should BUG when it encounters
-	  data corruption in kernel memory structures when they get checked
-	  for validity.
+	  This option enables several inexpensive data corruption checks.
+	  Most of these checks normally just WARN and try to further avoid
+	  the corruption. Selecting this option upgrades these to BUGs so
+	  that the offending process is killed. Additionally, the system
+	  owner can furhter configure the system for immediate reboots
+	  (via panic_on_oops sysctl) or crash dumps.
 
 	  If unsure, say N.
 
-- 
2.7.4
