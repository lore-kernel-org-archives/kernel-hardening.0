Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 22:39:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110213952.GB3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <CAGXu5jL0m8_x-eBPQPBvj_O_JRXmh=nc87L0rpPkYUEo+jK97A@mail.gmail.com>
 <CAEXv5_i3Ju5JNs6g-jA-WkMR38g43Aj5we0+GXeHcuUAM3nziQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_i3Ju5JNs6g-jA-WkMR38g43Aj5we0+GXeHcuUAM3nziQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: David Windsor <dave@progbits.org>
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 04:23:08PM -0500, David Windsor wrote:
> Discussions have been occurring since KSPP has begun: do we need a

Note that I was not included in any of that. If you hide in a corner on
the intartubes don't be surprised people have no clue what you're on
about.

> specialized type for reference counters?  Oh, wait, we do: kref.
> Wait!  kref is implemented with atomic_t.
> 
> So, what?  We obviously need an atomicity for a reference counter
> type.  So, do we simply implement the HARDENED_ATOMIC protected
> version of atomic_t "inside" of kref and leave atomic_t alone?

But you could provide a small subset of the atomic_t API for that, under
a different type.

That way you don't get utter shite like atomic_cmpxchg_wrap() for
instance.

>From what I can see only all the add/sub variants have overflow checks,
but all the operations get _wrap() prefixes, even where it doesn't make
any bloody sense. _wrap() on bitops?, _wrap() on cmpxchg(). You must be
bloody joking right?
