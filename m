Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 22:13:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110211310.GX3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161110204838.GE17134@arm.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Will Deacon <will.deacon@arm.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 08:48:38PM +0000, Will Deacon wrote:
> > That said, I still don't much like this.
> > 
> > I would much rather you make kref useful and use that. It still means
> > you get to audit all refcounts in the kernel, but hey, you had to do
> > that anyway.
> 
> What needs to happen to kref to make it useful? Like many others, I've
> been guilty of using atomic_t for refcounts in the past.

As it stands kref is a pointless wrapper. If it were to provide
something actually useful, like wrap protection, then it might actually
make sense to use it.
