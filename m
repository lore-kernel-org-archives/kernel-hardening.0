Date: Thu, 22 Feb 2018 09:47:58 +0000
From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] fork: Allow stack to be wiped on fork
Message-ID: <20180222094758.4qzvhoiu4hnmqkzq@techsingularity.net>
References: <20180117055015.GA15256@beast>
 <20180220163142.15366a82a7bece715b997597@linux-foundation.org>
 <CALCETrVNBAWPAyrKKaiasehxDXKku3GSjc0+mQrvc4RC4+jUGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CALCETrVNBAWPAyrKKaiasehxDXKku3GSjc0+mQrvc4RC4+jUGw@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Sahara <keun-o.park@darkmatter.ae>, "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 01:56:33AM +0000, Andrew Lutomirski wrote:
> > It would be much nicer to be able to control this at runtime rather
> > than compile-time.  Why not a /proc tunable?  We could always use more
> > of those ;)
> 
> /proc/sys/kernel/hardening_features_that_cost_essentially_nothing?
> 
> Seriously, though, why don't we just enable it unconditionally?  It
> wouldn't surprise me if it really is a speedup on more workloads than
> it slows down -- it'll fill the kernel stack into the CPU cache with
> exclusive ownership very quickly (streamily and without actually
> reading from memory, I imagine, at least on new enough CPUs) rather
> than grabbing each cache line one by one as they get used.

Note that this is not unconditionally true, it depends on the calling
context that clears the page. If this is during fork, then the parent may
be doing the clear (I didn't check) which means it's quite likely when the
child wakes for the first time that it will not necessary wake on the same
CPU. Up until recently on NUMA machines, the child was almost guaranteed
to be running on a remote node (mitigated in tip for sched now).

I'm not claiming I've measured the overhead of this, just pointing out that
"cache hotness" may actually result in double the cache line bounces --
first clear, then write on first wake. If only zeroing pages was a bit
faster :/

-- 
Mel Gorman
SUSE Labs
