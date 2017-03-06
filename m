From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:43 -0800
Message-Id: <1488827386-87193-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/6] bug: Enable DEBUG_CREDENTIALS under BUG_ON_DATA_CORRUPTION
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Since CONFIG_DEBUG_CREDENTIALS already handles reporting and issuing a
BUG when it encounters corruption, add this to the list of corruption
test CONFIGs that are enabled under CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4a73d46711fb..009d6f8c7e5a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1287,7 +1287,7 @@ config DEBUG_NOTIFIERS
 
 config DEBUG_CREDENTIALS
 	bool "Debug credential management"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on some debug checking for credential
 	  management.  The additional code keeps track of the number of
@@ -1993,6 +1993,7 @@ config TEST_STATIC_KEYS
 
 config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
+	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
 	help
 	  This option enables several inexpensive data corruption checks.
-- 
2.7.4
