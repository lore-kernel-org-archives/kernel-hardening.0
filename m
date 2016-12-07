Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 14:24:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207132457.GG3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net>
 <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
 <20161202011759.GA28026@tardis.cn.ibm.com>
 <CAEXv5_gfPM3BJyoDwPN=0afhO0oQPm=ix1mQvfYuKJephZBAGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_gfPM3BJyoDwPN=0afhO0oQPm=ix1mQvfYuKJephZBAGQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: David Windsor <dwindsor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 02, 2016 at 03:25:42PM -0500, David Windsor wrote:
> On Thu, Dec 1, 2016 at 8:17 PM, Boqun Feng <boqun.feng@gmail.com> wrote:

> > So we currently don't have a clear semantics for stats_t, do we?
> 
> We had a discussion about the stats_t API in another thread.  We
> agreed upon add(), sub(), inc(), dec(), read() and set().
> 
> > What kind of atomic_t should be replaced with stats_t?
> 
> stats_t is used for those cases in which an atomic variable is
> required, but the overflow of this variable isn't of much concern.
> Typically, these types of variables are counters of some kind (rx/tx
> counts, etc), but not always.  Perhaps "stats_t" isn't the best type
> name.  We actually used "atomic_wrap_t" in previous iterations.

And atomic_wrap_t is a horrid trainwreck. Please as to explain the
semantics of atomic_wrap_cmpxchg(). How does wrapping apply to something
that doesn't do sign bits.

> > In the link David  pointed out, there are a few cases where a
> > stats_t is put on a correctness-related variable. I don't think
> > that's a good place to use stats_t.
> >
> 
> Yeah, I just grabbed a few examples I noted during my stats_t
> conversion work.  The drivers/ tree is littered with stats_t
> instances.

Not sure how to respond to this, if you're converting all that to
stats_t then you're doing it wrong.

Most of what you showed should very emphatically not be stats_t.
