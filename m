From: Jess Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 17:37:55 -0800
Message-Id: <20170211013758.3288-2-me@jessfraz.com>
In-Reply-To: <20170211013758.3288-1-me@jessfraz.com>
References: <20170211013758.3288-1-me@jessfraz.com>
Subject: [kernel-hardening] [PATCH v2 2/5] time: mark syscore_ops as __ro_after_init
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jess Frazelle <me@jessfraz.com>, Rik van Riel <riel@redhat.com>, open list <linux-kernel@vger.kernel.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
called only during init. Most of the caller functions were already annotated as
__init.
unregister_syscore_ops() was never called on these ops.
This protects the data structure from accidental corruption.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jess Frazelle <me@jessfraz.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 kernel/time/sched_clock.c | 2 +-
 kernel/time/timekeeping.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index a26036d37a38..5df2fc07300b 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -289,7 +289,7 @@ static void sched_clock_resume(void)
 	rd->read_sched_clock = cd.actual_read_sched_clock;
 }

-static struct syscore_ops sched_clock_ops = {
+static struct syscore_ops sched_clock_ops __ro_after_init = {
 	.suspend	= sched_clock_suspend,
 	.resume		= sched_clock_resume,
 };
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index db087d7e106d..467e3021723a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1756,7 +1756,7 @@ int timekeeping_suspend(void)
 }

 /* sysfs resume/suspend bits for timekeeping */
-static struct syscore_ops timekeeping_syscore_ops = {
+static struct syscore_ops timekeeping_syscore_ops __ro_after_init = {
 	.resume		= timekeeping_resume,
 	.suspend	= timekeeping_suspend,
 };
--
2.11.0
