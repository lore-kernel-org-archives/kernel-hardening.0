From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:44 -0800
Message-Id: <1488827386-87193-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/6] bug: Enable DEBUG_SG under BUG_ON_DATA_CORRUPTION
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Similar to CONFIG_DEBUG_CREDENTIALS, CONFIG_DEBUG_SG already handles
calling BUG, and performs inexpensive checks. This enables it under
CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 009d6f8c7e5a..42c61cfe7d19 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1267,7 +1267,7 @@ config DEBUG_PI_LIST
 
 config DEBUG_SG
 	bool "Debug SG table operations"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
 	help
 	  Enable this to turn on checks on scatter-gather tables. This can
 	  help find problems with drivers that do not properly initialize
@@ -1995,6 +1995,7 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_CREDENTIALS
 	select DEBUG_LIST
+	select DEBUG_SG
 	help
 	  This option enables several inexpensive data corruption checks.
 	  Most of these checks normally just WARN and try to further avoid
-- 
2.7.4
