From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v3 3/3] module: Make __tracepoints_ptrs as read-only
Date: Wed, 10 Apr 2019 15:57:08 -0400
Message-Id: <20190410195708.162185-3-joel@joelfernandes.org>
In-Reply-To: <20190410195708.162185-1-joel@joelfernandes.org>
References: <20190410195708.162185-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, paulmck@linux.vnet.ibm.com, keescook@chromium.org, mathieu.desnoyers@efficios.com, rostedt@goodmis.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This series hardens the tracepoints in modules by making the array of
pointers referring to the tracepoints as read-only. This array is needed
during module unloading to verify that the tracepoint is quiescent.
There is no reason for the array to be to be writable after init, and
can cause security or other hidden bugs. Mark these as ro_after_init.

Suggested-by: paulmck@linux.vnet.ibm.com
Suggested-by: keescook@chromium.org
Suggested-by: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/module.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 8b9631e789f0..be980aaa8804 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3320,6 +3320,12 @@ static const char * const ro_after_init_sections[] = {
 	 * by the SRCU notifiers
 	 */
 	"___srcu_struct_ptrs",
+
+	/*
+	 * Array of tracepoint pointers used for checking if tracepoints are
+	 * quiescent during unloading.
+	 */
+	"__tracepoints_ptrs",
 };
 
 static struct module *layout_and_allocate(struct load_info *info, int flags)
-- 
2.21.0.392.gf8f6787159e-goog
