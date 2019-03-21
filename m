Date: Thu, 21 Mar 2019 18:58:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 0/4] RCU fixes for rcu_assign_pointer() usage
Message-ID: <20190321175847.GP6058@hirez.programming.kicks-ass.net>
References: <20190321003426.160260-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321003426.160260-1-joel@joelfernandes.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Lai Jiangshan <jiangshanlai@gmail.com>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Morten Rasmussen <morten.rasmussen@arm.com>, "Paul E. McKenney" <paulmck@linux.ibm.com>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 20, 2019 at 08:34:22PM -0400, Joel Fernandes (Google) wrote:
> This is just a resend with scheduler patches split from the driver fixes and
> Paul's Reviewed-by(s) added.
> 
> These patches fix various sparse errors ccaused as a result of the recent check
> to add rcu_check_sparse() to rcu_assign_pointer().  The errors are due to
> missing annotations. The annotations added in the series can also help avoid
> future incorrect usages and bugs so it is a good idea to do in any case.
> 
> RFC v1 -> Patch v2:
> Made changes based on Peter Zijlstra review.
> 
> Joel Fernandes (Google) (4):
> sched/cpufreq: Annotate cpufreq_update_util_data pointer with __rcu
> sched_domain: Annotate RCU pointers properly
> rcuwait: Annotate task_struct with __rcu
> sched: Annotate perf_domain pointer with __rcu
> 
> include/linux/rcuwait.h        |  2 +-
> include/linux/sched/topology.h |  4 ++--
> kernel/sched/cpufreq.c         |  2 +-
> kernel/sched/sched.h           | 18 +++++++++---------
> kernel/sched/topology.c        | 10 +++++-----
> 5 files changed, 18 insertions(+), 18 deletions(-)

Thanks Joel
