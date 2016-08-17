Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 17 Aug 2016 13:17:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <20160817201736.GB361@codeaurora.org>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471393229-27182-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 0/5] bug: Provide toggle for BUG on data corruption
To: Kees Cook <keescook@chromium.org>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 08/16, Kees Cook wrote:
> This adds a CONFIG to trigger BUG()s when the kernel encounters
> unexpected data structure integrity as currently detected with
> CONFIG_DEBUG_LIST.
> 
> Specifically list operations have been a target for widening flaws to gain
> "write anywhere" primitives for attackers, so this also consolidates the
> debug checking to avoid code and check duplication (e.g. RCU list debug
> was missing a check that got added to regular list debug). It also stops
> manipulations when corruption is detected, since worsening the corruption
> makes no sense. (Really, everyone should build with CONFIG_DEBUG_LIST
> since the checks are so inexpensive.)
> 
> This is mostly a refactoring of similar code from PaX and Grsecurity,
> along with MSM kernel changes by Stephen Boyd.

Which commit in the MSM kernel from me? I wonder if perhaps
you're thinking of a patch from Syed Rameez Mustafa like commit
1c014f321e6d67f47 in the msm-3.4 kernel.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
