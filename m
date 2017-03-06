From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:42 -0800
Message-Id: <1488827386-87193-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1488827386-87193-1-git-send-email-keescook@chromium.org>
References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/6] bug: Improve unlikely() in data corruption check
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This improves the compiler branch-hinting used in CHECK_DATA_CORRUPTION(),
similar to how it is done in WARN_ON() and friends.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 5828489309bb..5ef65dc2ed8b 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -129,15 +129,15 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 static inline __must_check bool check_data_corruption(bool v) { return v; }
 #define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
 	check_data_corruption(({					 \
-		bool corruption = unlikely(condition);			 \
-		if (corruption) {					 \
+		bool corruption = !!(condition);			 \
+		if (unlikely(corruption)) {				 \
 			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
 				pr_err(fmt, ##__VA_ARGS__);		 \
 				BUG();					 \
 			} else						 \
 				WARN(1, fmt, ##__VA_ARGS__);		 \
 		}							 \
-		corruption;						 \
+		unlikely(corruption);					 \
 	}))
 
 #endif	/* _LINUX_BUG_H */
-- 
2.7.4
