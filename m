Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 15:05:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161028140522.GH5806@leverpostej>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028112136.GA5635@amd>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Fri, Oct 28, 2016 at 01:21:36PM +0200, Pavel Machek wrote:
> > Has this been tested on a system vulnerable to rowhammer, and if so, was
> > it reliable in mitigating the issue?
> > 
> > Which particular attack codebase was it tested against?
> 
> I have rowhammer-test here,
> 
> commit 9824453fff76e0a3f5d1ac8200bc6c447c4fff57
> Author: Mark Seaborn <mseaborn@chromium.org>

... from which repo?

> I do not have vulnerable machine near me, so no "real" tests, but
> I'm pretty sure it will make the error no longer reproducible with the
> newer version. [Help welcome ;-)]

Even if we hope this works, I think we have to be very careful with that
kind of assertion. Until we have data is to its efficacy, I don't think
we should claim that this is an effective mitigation.

> > > +struct perf_event_attr rh_attr = {
> > > +	.type	= PERF_TYPE_HARDWARE,
> > > +	.config = PERF_COUNT_HW_CACHE_MISSES,
> > > +	.size	= sizeof(struct perf_event_attr),
> > > +	.pinned	= 1,
> > > +	/* FIXME: it is 1000000 per cpu. */
> > > +	.sample_period = 500000,
> > > +};
> > 
> > I'm not sure that this is general enough to live in core code, because:
> 
> Well, I'd like to postpone debate 'where does it live' to the later
> stage. The problem is not arch-specific, the solution is not too
> arch-specific either. I believe we can use Kconfig to hide it from
> users where it does not apply. Anyway, lets decide if it works and
> where, first.

You seem to have forgotten the drammer case here, which this would not
have protected against. I'm not sure, but I suspect that we could have
similar issues with mappings using other attributes (e.g write-through),
as these would cause the memory traffic without cache miss events.

> > * the precise semantics of performance counter events varies drastically
> >   across implementations. PERF_COUNT_HW_CACHE_MISSES, might only map to
> >   one particular level of cache, and/or may not be implemented on all
> >   cores.
> 
> If it maps to one particular cache level, we are fine (or maybe will
> trigger protection too often). If some cores are not counted, that's bad.

Perhaps, but that depends on a number of implementation details. If "too
often" means "all the time", people will turn this off when they could
otherwise have been protected (e.g. if we can accurately monitor the
last level of cache).

> > * On some implementations, it may be that the counters are not
> >   interchangeable, and for those this would take away
> >   PERF_COUNT_HW_CACHE_MISSES from existing users.
> 
> Yup. Note that with this kind of protection, one missing performance
> counter is likely to be small problem.

That depends. Who chooses when to turn this on? If it's down to the
distro, this can adversely affect users with perfectly safe DRAM.

> > > +	/* FIXME msec per usec, reverse logic? */
> > > +	if (delta < 64 * NSEC_PER_MSEC)
> > > +		mdelay(56);
> > > +}
> > 
> > If I round-robin my attack across CPUs, how much does this help?
> 
> See below for new explanation. With 2 CPUs, we are fine. On monster
> big-little 8-core machines, we'd probably trigger protection too
> often.

We see larger core counts in mobile devices these days. In China,
octa-core phones are popular, for example. Servers go much larger.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e24e981..c6ffcaf 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -315,6 +315,7 @@ config PGTABLE_LEVELS
>  
>  source "init/Kconfig"
>  source "kernel/Kconfig.freezer"
> +source "kernel/events/Kconfig"
>  
>  menu "Processor type and features"
>  
> diff --git a/kernel/events/Kconfig b/kernel/events/Kconfig
> new file mode 100644
> index 0000000..7359427
> --- /dev/null
> +++ b/kernel/events/Kconfig
> @@ -0,0 +1,9 @@
> +config NOHAMMER
> +        tristate "Rowhammer protection"
> +        help
> +	  Enable rowhammer attack prevention. Will degrade system
> +	  performance under attack so much that attack should not
> +	  be feasible.


I think that this must make it clear that this is a best-effort approach
(i.e. it does not guarantee that an attack is not possible), and also
should make clear that said penalty may occur in other situations.

[...]

> +static struct perf_event_attr rh_attr = {
> +	.type	= PERF_TYPE_HARDWARE,
> +	.config = PERF_COUNT_HW_CACHE_MISSES,
> +	.size	= sizeof(struct perf_event_attr),
> +	.pinned	= 1,
> +	.sample_period = 10000,
> +};

What kind of overhead (just from taking the interrupt) will this come
with?

> +/*
> + * How often is the DRAM refreshed. Setting it too high is safe.
> + */

Stale comment? Given the check against delta below, this doesn't look to
be true.

> +static int dram_refresh_msec = 64;
> +
> +static DEFINE_PER_CPU(struct perf_event *, rh_event);
> +static DEFINE_PER_CPU(u64, rh_timestamp);
> +
> +static void rh_overflow(struct perf_event *event, struct perf_sample_data *data, struct pt_regs *regs)
> +{
> +	u64 *ts = this_cpu_ptr(&rh_timestamp); /* this is NMI context */
> +	u64 now = ktime_get_mono_fast_ns();
> +	s64 delta = now - *ts;
> +
> +	*ts = now;
> +
> +	if (delta < dram_refresh_msec * NSEC_PER_MSEC)
> +		mdelay(dram_refresh_msec);
> +}

[...]

> +/*
> + * DRAM is shared between CPUs, but these performance counters are per-CPU.
> + */
> +	int max_attacking_cpus = 2;

As above, many systems today have more than two CPUs. In the drammmer
paper, it looks like the majority had four.

Thanks
Mark.
