Date: Wed, 17 Jan 2018 10:17:29 +0100
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20180117091729.GB2900@dhcp22.suse.cz>
References: <20180117055015.GA15256@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117055015.GA15256@beast>
Subject: [kernel-hardening] Re: [PATCH] fork: Allow stack to be wiped on fork
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Sahara <keun-o.park@darkmatter.ae>, "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue 16-01-18 21:50:15, Kees Cook wrote:
> One of the classes of kernel stack content leaks is exposing the contents
> of prior heap or stack contents when a new process stack is allocated.
> Normally, those stacks are not zeroed, and the old contents remain in
> place. With some types of stack content exposure flaws, those contents
> can leak to userspace. Kernels built with CONFIG_CLEAR_STACK_FORK will
> no longer be vulnerable to this, as the stack will be wiped each time
> a stack is assigned to a new process. There's not a meaningful change
> in runtime performance; it almost looks like it provides a benefit.

Have you tried something as simple as /bin/true in a loop. kbuild will
certainly amortize few cycles for the clearing and I would expect, most
reasonable applications would do as well. But it would be better to know
the worst case scenario IMHO.

> Performing back-to-back kernel builds before:
> 	Run times: 157.86 157.09 158.90 160.94 160.80
> 	Mean: 159.12
> 	Std Dev: 1.54
> 
> With CONFIG_CLEAR_STACK_FORK=y:
> 	Run times: 159.31 157.34 156.71 158.15 160.81
> 	Mean: 158.46
> 	Std Dev: 1.46
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

The change seems reasonable to me. Although it would be better to extend
on the types of attacks this prevents from, with some examples ideally.
How many attacks of that kind we had in the past and how often they
appear. That might help people to decide whether to deserve few cycles
on each fork. Also the config option sounds rather limiting. Consider
distros, should they enable it just to be on the safe side? This is kind
of generic concern with other hardening options though.
-- 
Michal Hocko
SUSE Labs
