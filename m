From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 3/4] rcuwait: Annotate task_struct with __rcu
Date: Wed, 20 Mar 2019 20:34:25 -0400
Message-Id: <20190321003426.160260-4-joel@joelfernandes.org>
In-Reply-To: <20190321003426.160260-1-joel@joelfernandes.org>
References: <20190321003426.160260-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Lai Jiangshan <jiangshanlai@gmail.com>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

This suppresses sparse error generated due to the recently added
rcu_assign_pointer sparse check.

percpu-rwsem.c:162:9: sparse: error: incompatible types in comparison expression
exit.c:316:16: sparse: error: incompatible types in comparison expression

[From an RCU perspective]
Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rcuwait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 90bfa3279a01..563290fc194f 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -18,7 +18,7 @@
  * awoken.
  */
 struct rcuwait {
-	struct task_struct *task;
+	struct task_struct __rcu *task;
 };
 
 #define __RCUWAIT_INITIALIZER(name)		\
-- 
2.21.0.225.g810b269d1ac-goog
