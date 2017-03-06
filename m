From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:45 -0800
Message-Id: <1488827386-87193-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 5/6] notifiers: Use CHECK_DATA_CORRUPTION() on checks
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
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
index 42c61cfe7d19..70e9f2c1bb30 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1277,7 +1277,7 @@ config DEBUG_SG
 
 config DEBUG_NOTIFIERS
 	bool "Debug notifier call chains"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on sanity checking for notifier call chains.
 	  This is most useful for kernel developers to make sure that
@@ -1995,6 +1995,7 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
+	select DEBUG_NOTIFIERS
 	select DEBUG_SG
 	help
 	  This option enables several inexpensive data corruption checks.
-- 
2.7.4
