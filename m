From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] module: Make srcu_struct ptr array as read-only
Date: Thu, 30 May 2019 08:04:48 -0700
In-Reply-To: <20190530150347.GA31311@linux.ibm.com>
References: <20190530150347.GA31311@linux.ibm.com>
Message-Id: <20190530150449.31885-3-paulmck@linux.ibm.com>
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, paulmck@linux.vnet.ibm.com, kernel-hardening@lists.openwall.com, kernel-team@android.com, "Paul E . McKenney" <paulmck@linux.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

Since commit title ("srcu: Allocate per-CPU data for DEFINE_SRCU() in
modules"), modules that call DEFINE_{STATIC,}SRCU will have a new array
of srcu_struct pointers, which is used by srcu code to initialize and
clean up these structures and save valuable per-cpu reserved space.

There is no reason for this array of pointers to be writable, and can
cause security or other hidden bugs. Mark these are read-only after the
module init has completed.

Tested with the following diff to ensure array not writable:

(diff is a bit reduced to avoid patch command getting confused)
 a/kernel/module.c
 b/kernel/module.c
  -3506,6 +3506,14  static noinline int do_init_module [snip]
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
 	module_enable_ro(mod, true);
+
+	if (mod->srcu_struct_ptrs) {
+		// Check if srcu_struct_ptrs access is possible
+		char x = *(char *)mod->srcu_struct_ptrs;
+		*(char *)mod->srcu_struct_ptrs = 0;
+		*(char *)mod->srcu_struct_ptrs = x;
+	}
+
 	mod_tree_remove_init(mod);
 	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: rcu@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: kernel-team@android.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
---
 include/linux/srcutree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 8af1824c46a8..9cfcc8a756ae 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -123,7 +123,7 @@ struct srcu_struct {
 #ifdef MODULE
 # define __DEFINE_SRCU(name, is_static)					\
 	is_static struct srcu_struct name;				\
-	struct srcu_struct *__srcu_struct_##name			\
+	struct srcu_struct * const __srcu_struct_##name			\
 		__section("___srcu_struct_ptrs") = &name
 #else
 # define __DEFINE_SRCU(name, is_static)					\
-- 
2.17.1
