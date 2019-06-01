From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [RFC 0/6] Harden list_for_each_entry_rcu() and family
Date: Sat,  1 Jun 2019 18:27:32 -0400
Message-Id: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, linux-pm@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com, "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>, peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,
Please consider this as an RFC / proof-of-concept to gather some feedback. This
series aims to provide lockdep checking to RCU list macros.

RCU has a number of primitives for "consumption" of an RCU protected pointer.
Most of the time, these consumers make sure that such accesses are under a RCU
reader-section (such as rcu_dereference{,sched,bh} or under a lock, such as
with rcu_dereference_protected()).

However, there are other ways to consume RCU pointers, such as by
list_for_each_enry_rcu or hlist_for_each_enry_rcu. Unlike the rcu_dereference
family, these consumers do no lockdep checking at all. And with the growing
number of RCU list uses, it is possible for bugs to creep in and go unnoticed
which lockdep checks can catch.

Since RCU consolidation efforts last year, the different traditional RCU
flavors (preempt, bh, sched) are all consolidated. In other words, any of these
flavors can cause a reader section to occur and all of them must cease before
the reader section is considered to be unlocked.

Now, the list_for_each_entry_rcu and family are different from the
rcu_dereference family in that, there is no _bh or _sched version of this
macro. They are used under many different RCU reader flavors, and also SRCU.
This series adds a new internal function rcu_read_lock_any_held() which checks
if any reader section is active at all, when these macros are called. If no
reader section exists, then the optional fourth argument to
list_for_each_entry_rcu() can be a lockdep expression which is evaluated
(similar to how rcu_dereference_check() works).

The optional argument trick to list_for_each_entry_rcu() can also be used in
the future to possibly remove rcu_dereference_{,bh,sched}_protected() API and
we can pass an optional lockdep expression to rcu_dereference() itself. Thus
eliminating 3 more RCU APIs.

Note that some list macro wrappers already do their own lockdep checking in the
caller side. These can be eliminated in favor of the built-in lockdep checking
in the list macro that this series adds. For example, workqueue code has a
assert_rcu_or_wq_mutex() function which is called in for_each_wq().  This
series replaces that in favor of the built-in one.

Also in the future, we can extend these checks to list_entry_rcu() and other
list macros as well.

Joel Fernandes (Google) (6):
rcu: Add support for consolidated-RCU reader checking
ipv4: add lockdep condition to fix for_each_entry
driver/core: Convert to use built-in RCU list checking
workqueue: Convert for_each_wq to use built-in list check
x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator
acpi: Use built-in RCU list checking for acpi_ioremaps list

arch/x86/pci/mmconfig-shared.c |  5 +++--
drivers/acpi/osl.c             |  6 +++--
drivers/base/base.h            |  1 +
drivers/base/core.c            | 10 +++++++++
drivers/base/power/runtime.c   | 15 ++++++++-----
include/linux/rculist.h        | 40 ++++++++++++++++++++++++++++++----
include/linux/rcupdate.h       |  7 ++++++
kernel/rcu/update.c            | 26 ++++++++++++++++++++++
kernel/workqueue.c             |  5 ++---
net/ipv4/fib_frontend.c        |  3 ++-
10 files changed, 101 insertions(+), 17 deletions(-)

--
2.22.0.rc1.311.g5d7573a151-goog
