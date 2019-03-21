From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 4/4] sched: Annotate perf_domain pointer with __rcu
Date: Wed, 20 Mar 2019 20:34:26 -0400
Message-Id: <20190321003426.160260-5-joel@joelfernandes.org>
In-Reply-To: <20190321003426.160260-1-joel@joelfernandes.org>
References: <20190321003426.160260-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Lai Jiangshan <jiangshanlai@gmail.com>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

This fixes the following sparse errors in sched/fair.c:

fair.c:6506:14: error: incompatible types in comparison expression
fair.c:8642:21: error: incompatible types in comparison expression

Using __rcu will also help sparse catch any future bugs.

[From an RCU perspective]
Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/sched/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2b452d68ab2e..b52ed1ada0be 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -780,7 +780,7 @@ struct root_domain {
 	 * NULL-terminated list of performance domains intersecting with the
 	 * CPUs of the rd. Protected by RCU.
 	 */
-	struct perf_domain	*pd;
+	struct perf_domain __rcu *pd;
 };
 
 extern struct root_domain def_root_domain;
-- 
2.21.0.225.g810b269d1ac-goog
