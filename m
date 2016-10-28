Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 11:04:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161028090423.GY3102@twins.programming.kicks-ass.net>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028070701.GA11376@gmail.com>
 <20161028085039.GA15032@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028085039.GA15032@amd>
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 10:50:39AM +0200, Pavel Machek wrote:
> On Fri 2016-10-28 09:07:01, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > +static void rh_overflow(struct perf_event *event, struct perf_sample_data *data, struct pt_regs *regs)
> > > +{
> > > +	u64 *ts = this_cpu_ptr(&rh_timestamp); /* this is NMI context */
> > > +	u64 now = ktime_get_mono_fast_ns();
> > > +	s64 delta = now - *ts;
> > > +
> > > +	*ts = now;
> > > +
> > > +	/* FIXME msec per usec, reverse logic? */
> > > +	if (delta < 64 * NSEC_PER_MSEC)
> > > +		mdelay(56);
> > > +}
> > 
> > I'd suggest making the absolute delay sysctl tunable, because 'wait 56 msecs' is 
> > very magic, and do we know it 100% that 56 msecs is what is needed
> > everywhere?
> 
> I agree this needs to be tunable (and with the other suggestions). But
> this is actually not the most important tunable: the detection
> threshold (rh_attr.sample_period) should be way more important.

So being totally ignorant of the detail of how rowhammer abuses the DDR
thing, would it make sense to trigger more often and delay shorter? Or
is there some minimal delay required for things to settle or something.
