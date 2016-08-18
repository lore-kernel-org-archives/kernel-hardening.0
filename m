Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 18 Aug 2016 13:57:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
 <1471542175.2581.22.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471542175.2581.22.camel@redhat.com>
Message-Id: <20160818205700.GZ3482@linux.vnet.ibm.com>
Subject: Re: [kernel-hardening] [PATCH v3 0/5] bug: Provide toggle for BUG on
 data corruption
To: Rik van Riel <riel@redhat.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 18, 2016 at 01:42:55PM -0400, Rik van Riel wrote:
> On Wed, 2016-08-17 at 14:42 -0700, Kees Cook wrote:
> > This adds CONFIG_BUG_ON_DATA_CORRUPTION to trigger BUG()s when the
> > kernel
> > encounters unexpected data structure integrity as currently detected
> > with CONFIG_DEBUG_LIST.
> > 
> > Specifically list operations have been a target for widening flaws to
> > gain
> > "write anywhere" primitives for attackers, so this also consolidates
> > the
> > debug checking to avoid code and check duplication (e.g. RCU list
> > debug
> > was missing a check that got added to regular list debug). It also
> > stops
> > manipulations when corruption is detected, since worsening the
> > corruption
> > makes no sense. (Really, everyone should build with CONFIG_DEBUG_LIST
> > since the checks are so inexpensive.)
> > 
> > This is mostly a refactoring of similar code from PaX and Grsecurity,
> > along with MSM kernel changes by Syed Rameez Mustafa.
> > 
> > Along with the patches is a new lkdtm test to validate that setting
> > CONFIG_DEBUG_LIST actually does what is desired.
> 
> Series looks good to me, too.

Reviewed-by?  Acked-by?  Ephemeral accolades?  ;-)

							Thanx, Paul
