Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Dec 2016 00:03:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161201230328.GS3045@worktop.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: David Windsor <dwindsor@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 01, 2016 at 04:31:16PM -0500, David Windsor wrote:
> Also, I'd like to point out that while identifying stats_t instances, I
> have found a similar distribution of non-standard functions (as agreed upon
> for the stats_t API).

> First, usage of atomic_long_wrap_t (there currently isn't a stats_long_t
> planned for implementation):

There isn't even a stats_t planned. I'm still very much not convinced
stats_t is needed or even makes sense.

It wouldn't have any different semantics from atomic_t, and the only
argument Kees made was that reduced atomic_t usage would make it easier
to spot refcounts, but you're already building tools to find those.

Once the tools work, who cares.

> Next, API calls outside of the proposed stats_t API:
> 
> kernel/auditsc.c:2029:
>    if (uid_valid(loginuid))
>         sessionid = (unsigned int)atomic_inc_return_wrap(&session_id);

This is _NOT_ a statistic counter and should not be stats_t

> kernel/padata.c:58:
>     seq_nr = atomic_inc_return_wrap(&pd->seq_nr);

Idem

> kernel/rcu/tree_trace.c:192:
>     s0 += atomic_long_read_wrap(&rdp->exp_workdone0);

Don't get the point, this one is actually trivial.

> kernel/trace/trace_mmiotrace.c:123
>     atomic_xchg_wrap(&dropped_count, 0);
> 
> ... and several others.  Note, these are only from stats_t conversions in
> the kernel/ directory.

And while that thing counts, its not actually a statistics thing.
