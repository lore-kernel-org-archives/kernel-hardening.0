From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:17 -0700
Message-Id: <1491343938-75336-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 6/7] notifiers: Use CHECK_DATA_CORRUPTION() on checks
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When performing notifier function pointer sanity checking, allow
CONFIG_BUG_ON_DATA_CORRUPTION to upgrade from a WARN to a BUG.
Additionally enables CONFIG_DEBUG_NOTIFIERS when selecting
CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/notifier.c | 5 +++--
 lib/Kconfig.debug | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 6196af8a8223..58cc14958d92 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -84,8 +84,9 @@ static int notifier_call_chain(struct notifier_block **nl,
 		next_nb = rcu_dereference_raw(nb->next);
 
 #ifdef CONFIG_DEBUG_NOTIFIERS
-		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
-			WARN(1, "Invalid notifier called!");
+		if (CHECK_DATA_CORRUPTION(
+				!func_ptr_is_kernel_text(nb->notifier_call),
+				"Invalid notifier called!")) {
 			nb = next_nb;
 			continue;
 		}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 45bfc0be38fc..0dc8f6065be8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1278,7 +1278,7 @@ config DEBUG_SG
 
 config DEBUG_NOTIFIERS
 	bool "Debug notifier call chains"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on sanity checking for notifier call chains.
 	  This is most useful for kernel developers to make sure that
@@ -1998,6 +1998,7 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
+	select DEBUG_NOTIFIERS
 	select DEBUG_SG
 	help
 	  This option enables several inexpensive data corruption checks.
-- 
2.7.4
