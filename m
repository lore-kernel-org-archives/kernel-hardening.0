From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v3 2/3] module: Make srcu_struct ptr array as read-only post init
Date: Wed, 10 Apr 2019 15:57:07 -0400
Message-Id: <20190410195708.162185-2-joel@joelfernandes.org>
In-Reply-To: <20190410195708.162185-1-joel@joelfernandes.org>
References: <20190410195708.162185-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, paulmck@linux.vnet.ibm.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org, rostedt@goodmis.org
List-ID: <kernel-hardening.lists.openwall.com>

Since commit title ("srcu: Allocate per-CPU data for DEFINE_SRCU() in
modules"), modules that call DEFINE_{STATIC,}SRCU will have a new array
of srcu_struct pointers which is used by srcu code to initialize and
clean up these structures.

There is no reason for this array of pointers to be writable, and can
cause security or other hidden bugs. Mark these are read-only after the
module init has completed.

Suggested-by: paulmck@linux.vnet.ibm.com
Suggested-by: keescook@chromium.org
Acked-by: keescook@chromium.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/module.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 42e4e289d6c7..8b9631e789f0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3314,6 +3314,12 @@ static const char * const ro_after_init_sections[] = {
 	 * annotated as such at module load time.
 	 */
 	"__jump_table",
+
+	/*
+	 * Used for SRCU structures which need to be initialized/cleaned up
+	 * by the SRCU notifiers
+	 */
+	"___srcu_struct_ptrs",
 };
 
 static struct module *layout_and_allocate(struct load_info *info, int flags)
-- 
2.21.0.392.gf8f6787159e-goog
