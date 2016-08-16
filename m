Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 14:11:00 -0700
Message-Id: <1471381865-25724-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/5] bug: Provide toggle for BUG on data corruption
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds a CONFIG to trigger BUG()s when the kernel encounters
unexpected data structure integrity as currently detected with
CONFIG_DEBUG_LIST, CONFIG_DEBUG_SPINLOCK, and with workqueues.

Specifically list operations have been a target for widening flaws to gain
"write anywhere" primitives for attackers, so this also consolidates the
debug checking to avoid code and check duplication (e.g. RCU list debug
was missing a check that got added to regular list debug). It also stops
manipulations when corruption is detected, since worsening the corruption
makes no sense. (Really, everyone should build with CONFIG_DEBUG_LIST
since the checks are so inexpensive.)

This is mostly a refactoring of similar code from PaX and Grsecurity,
along with MSM kernel changes by Stephen Boyd.

Along with the patches is a new lkdtm test to validate that setting
CONFIG_DEBUG_LIST actually does what is desired.

Thanks,

-Kees
