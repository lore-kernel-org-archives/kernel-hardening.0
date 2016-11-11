Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 11 Nov 2016 08:49:59 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BFF68E@IRSMSX102.ger.corp.intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-4-git-send-email-elena.reshetova@intel.com>
 <20161110215845.GD3117@twins.programming.kicks-ass.net>
In-Reply-To: <20161110215845.GD3117@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC v4 PATCH 03/13] kernel: identify wrapping atomic usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:38PM +0200, Elena Reshetova wrote:
>  include/linux/blktrace_api.h         |   2 +-
>  include/linux/irqdesc.h              |   2 +-
>  include/linux/kgdb.h                 |   2 +-
>  include/linux/padata.h               |   2 +-
>  include/linux/perf_event.h           |  10 ++--
>  include/linux/sched.h                |   2 +-
>  kernel/audit.c                       |   8 +--
>  kernel/auditsc.c                     |   4 +-
>  kernel/debug/debug_core.c            |  16 +++---
>  kernel/events/core.c                 |  27 +++++-----
>  kernel/irq/manage.c                  |   2 +-
>  kernel/irq/spurious.c                |   2 +-
>  kernel/locking/lockdep.c             |   2 +-

>That's it for kernel/locking/ ? So qspinlock really needs the overflow tes=
ts?
>Colour me less than impressed with the quality of audit.

The subsystem changes haven't been yet audited on a wider scale and I am su=
re there are more things to catch.
The intend was to make more audits later and also include each subsystem ma=
intainers for reviews.
To date our primary focus was on getting the approach working/looking less =
invasive, which wasn't really easy given amount of changes it requires in a=
tomic...

>  kernel/padata.c                      |   4 +-
>  kernel/profile.c                     |  14 ++---
>  kernel/rcu/rcutorture.c              |  61 ++++++++++-----------
>  kernel/rcu/tree.c                    |  36 +++++++------
>  kernel/rcu/tree.h                    |  18 ++++---
>  kernel/rcu/tree_exp.h                |   6 +--
>  kernel/rcu/tree_plugin.h             |  12 ++---
>  kernel/rcu/tree_trace.c              |  14 ++---
>  kernel/sched/auto_group.c            |   4 +-
>  kernel/time/timer_stats.c            |  11 ++--
>  kernel/trace/blktrace.c              |   6 +--
>  kernel/trace/ftrace.c                |   4 +-
>  kernel/trace/ring_buffer.c           | 100 ++++++++++++++++++-----------=
------
>  kernel/trace/trace_clock.c           |   4 +-
>  kernel/trace/trace_functions_graph.c |   4 +-
>  kernel/trace/trace_mmiotrace.c       |   8 +--
>  29 files changed, 199 insertions(+), 188 deletions(-)
