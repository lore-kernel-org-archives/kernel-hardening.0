From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:41 -0800
Message-Id: <1488827386-87193-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/6] bug: Clarify help text for BUG_ON_DATA_CORRUPTION
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This expands on the Kconfig help text for CONFIG_BUG_ON_DATA_CORRUPTION.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 97d62c2da6c2..4a73d46711fb 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1995,9 +1995,11 @@ config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
 	select DEBUG_LIST
 	help
-	  Select this option if the kernel should BUG when it encounters
-	  data corruption in kernel memory structures when they get checked
-	  for validity.
+	  This option enables several inexpensive data corruption checks.
+	  Most of these checks normally just WARN and try to further avoid
+	  the corruption. Selecting this option upgrades these to BUGs, so
+	  that a system owner can furhter configure the system for immediate
+	  reboots or crash dumps.
 
 	  If unsure, say N.
 
-- 
2.7.4
