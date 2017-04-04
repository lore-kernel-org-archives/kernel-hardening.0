From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:14 -0700
Message-Id: <1491343938-75336-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 3/7] bug: Use WARN_ONCE() for CHECK_DATA_CORRUPTION()
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Since users of CHECK_DATA_CORRUPTION() should be failing safe, the
condition that triggers a WARN() may recur. This would mean a logging
DoS of the system, so switch to WARN_ONCE() instead. (Those wanting
per-instance notifications should already be building with
CONFIG_BUG_ON_DATA_CORRUPTION so there is no change in that case.)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index b6cfcb7f778f..c011438a7c6c 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -136,7 +136,7 @@ static inline __must_check bool check_data_corruption(bool v) { return v; }
 				pr_err(fmt, ##__VA_ARGS__);		 \
 				BUG();					 \
 			} else						 \
-				WARN(1, fmt, ##__VA_ARGS__);		 \
+				WARN_ONCE(1, fmt, ##__VA_ARGS__);	 \
 		}							 \
 		unlikely(corruption);					 \
 	}))
-- 
2.7.4
