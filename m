Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 21:37:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110203749.GV3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:35PM +0200, Elena Reshetova wrote:
> This series brings the PaX/Grsecurity PAX_REFCOUNT
> feature support to the upstream kernel. All credit for the
> feature goes to the feature authors.
> 
> The name of the upstream feature is HARDENED_ATOMIC
> and it is configured using CONFIG_HARDENED_ATOMIC and
> HAVE_ARCH_HARDENED_ATOMIC.
> 
> This series only adds x86 support; other architectures are expected
> to add similar support gradually.
> 
> More information about the feature can be found in the following
> commit messages.

No, this should be here. As it stands this is completely without
content.

In any case, NAK on this approach. Its the wrong way around.

_IF_ you want to do a non-wrapping variant, it must not be the default.

Since you need to audit every single atomic_t user in the kernel anyway,
it doesn't matter. But changing atomic_t to non-wrap by default is not
robust, if you forgot one, you can then trivially dos the kernel.

That said, I still don't much like this.

I would much rather you make kref useful and use that. It still means
you get to audit all refcounts in the kernel, but hey, you had to do
that anyway.
