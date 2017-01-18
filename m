Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 13:52:47 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170118215247.GA129388@gmail.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 11:11:29AM +0200, Elena Reshetova wrote:
> Changes since v1:
>  - kref INIT fixes are moved to a proper separate commit
>  - Peter's commits are now properly integrated into series 
>  - various small fixes are incorporated based on testing
>    results and feedback
> 
> This patch series is build on top of Peter's Zijlstra patches
> that provide refcount_t type and API definition.

Hi Elena,

There seems to be a lot of focus on converting things to use refcount_t but much
less focus on providing a refcount_t implementation that actually meets the
performance and security goals of the feature.  Notably, the proposed patchset
provides no information about why the proposed implementation was chosen over
the PaX implementation (note that I'm talking about the actual implementation of
safe reference counts, not the atomic_t/atomic_unchecked_t division) which as
I've already mentioned is much more efficient (less bloated and faster) while
still meeting the security goal.  I'm especially worried that people will be put
in a position where they need to take performance concerns into account when
deciding whether to use refcount_t or not.  And the patch even still includes
the "don't allow incrementing a zero refcount" check which AFAICS is bogus from
a security perspective.

Even if you and Peter disagree with the comments that I and also PaX Team have
made, the patch must at least explain the design decisions made.

I also find it strange that the actual refcount_t implementation is hidden in
patch 7/18 in the series and has subject "kref: ...", when in fact it's actually
the most important patch and will affect much more than kref.

Thanks,

Eric
