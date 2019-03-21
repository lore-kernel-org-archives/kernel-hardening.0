From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 1/4] sched/cpufreq: Annotate cpufreq_update_util_data pointer with __rcu
Date: Wed, 20 Mar 2019 20:34:23 -0400
Message-Id: <20190321003426.160260-2-joel@joelfernandes.org>
In-Reply-To: <20190321003426.160260-1-joel@joelfernandes.org>
References: <20190321003426.160260-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Lai Jiangshan <jiangshanlai@gmail.com>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

Recently I added an RCU annotation check to rcu_assign_pointer(). All
pointers assigned to RCU protected data are to be annotated with __rcu
inorder to be able to use rcu_assign_pointer() similar to checks in
other RCU APIs.

This resulted in a sparse error: kernel//sched/cpufreq.c:41:9: sparse:
error: incompatible types in comparison expression (different address
spaces)

Fix this by annotating cpufreq_update_util_data pointer with __rcu. This
will also help sparse catch any future RCU misuage bugs.

[From an RCU perspective]
Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/sched/cpufreq.c | 2 +-
 kernel/sched/sched.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
index 835671f0f917..b5dcd1d83c7f 100644
--- a/kernel/sched/cpufreq.c
+++ b/kernel/sched/cpufreq.c
@@ -7,7 +7,7 @@
  */
 #include "sched.h"
 
-DEFINE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
+DEFINE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
 
 /**
  * cpufreq_add_update_util_hook - Populate the CPU's update_util_data pointer.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index efa686eeff26..713715dd00cf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2185,7 +2185,7 @@ static inline u64 irq_time_read(int cpu)
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 #ifdef CONFIG_CPU_FREQ
-DECLARE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
+DECLARE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
 
 /**
  * cpufreq_update_util - Take a note about CPU utilization changes.
-- 
2.21.0.225.g810b269d1ac-goog
