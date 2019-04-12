Date: Thu, 11 Apr 2019 22:14:22 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] module: Make srcu_struct ptr array as read-only
Message-ID: <20190412021422.GA208673@google.com>
References: <20190411202421.131779-1-joel@joelfernandes.org>
 <20190411213155.GD14111@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411213155.GD14111@linux.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <jiangshanlai@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 02:31:55PM -0700, Paul E. McKenney wrote:
> On Thu, Apr 11, 2019 at 04:24:21PM -0400, Joel Fernandes (Google) wrote:
> > Since commit title ("srcu: Allocate per-CPU data for DEFINE_SRCU() in
> > modules"), modules that call DEFINE_{STATIC,}SRCU will have a new array
> > of srcu_struct pointers, which is used by srcu code to initialize and
> > clean up these structures and save valuable per-cpu reserved space.
> > 
> > There is no reason for this array of pointers to be writable, and can
> > cause security or other hidden bugs. Mark these are read-only after the
> > module init has completed.
> > 
> > Tested with the following diff to ensure array not writable:
> > 
> > (diff is a bit reduced to avoid patch command getting confused)
> >  a/kernel/module.c
> >  b/kernel/module.c
> >   -3506,6 +3506,14  static noinline int do_init_module [snip]
> >  	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
> >  #endif
> >  	module_enable_ro(mod, true);
> > +
> > +	if (mod->srcu_struct_ptrs) {
> > +		// Check if srcu_struct_ptrs access is possible
> > +		char x = *(char *)mod->srcu_struct_ptrs;
> > +		*(char *)mod->srcu_struct_ptrs = 0;
> > +		*(char *)mod->srcu_struct_ptrs = x;
> > +	}
> > +
> >  	mod_tree_remove_init(mod);
> >  	disable_ro_nx(&mod->init_layout);
> >  	module_arch_freeing_init(mod);
> > 
> > Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > Cc: paulmck@linux.vnet.ibm.com
> > Cc: rostedt@goodmis.org
> > Cc: mathieu.desnoyers@efficios.com
> > Cc: rcu@vger.kernel.org
> > Cc: kernel-hardening@lists.openwall.com
> > Cc: kernel-team@android.com
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Queued for testing and further review, thank you, Joel!

Thanks a lot! I also just saw you added the rcutorture module to be built as
a part kselftests which is really cool ;-)

thanks,

 - Joel
