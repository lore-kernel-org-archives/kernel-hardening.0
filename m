Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 18 Aug 2016 09:46:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20160818094657.5572a19a@gandalf.local.home>
In-Reply-To: <1471470132-29499-1-git-send-email-keescook@chromium.org>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 0/5] bug: Provide toggle for BUG on data corruption
To: Kees Cook <keescook@chromium.org>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 17 Aug 2016 14:42:07 -0700
Kees Cook <keescook@chromium.org> wrote:

> This adds CONFIG_BUG_ON_DATA_CORRUPTION to trigger BUG()s when the kernel
> encounters unexpected data structure integrity as currently detected
> with CONFIG_DEBUG_LIST.
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
> along with MSM kernel changes by Syed Rameez Mustafa.
> 
> Along with the patches is a new lkdtm test to validate that setting
> CONFIG_DEBUG_LIST actually does what is desired.
> 

The series looks fine by me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Thanks,
> 
> -Kees
> 
> v3:
> - fix MSM attribution, sboyd
> - use pr_err, joe
> 
> v2:
> - consolidate printk/WARN/BUG/return logic into a CONFIG-specific macro
> - drop non-list BUGs, labbott
