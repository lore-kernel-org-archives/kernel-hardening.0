Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 17:20:24 -0700
Message-Id: <1471393229-27182-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 0/5] bug: Provide toggle for BUG on data corruption
To: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds a CONFIG to trigger BUG()s when the kernel encounters
unexpected data structure integrity as currently detected with
CONFIG_DEBUG_LIST.

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
