Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 10:51:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161028095141.GA5806@leverpostej>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161027212747.GA18147@amd>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I missed the original, so I've lost some context.

Has this been tested on a system vulnerable to rowhammer, and if so, was
it reliable in mitigating the issue?

Which particular attack codebase was it tested against?

On Thu, Oct 27, 2016 at 11:27:47PM +0200, Pavel Machek wrote:
> --- /dev/null
> +++ b/kernel/events/nohammer.c
> @@ -0,0 +1,66 @@
> +/*
> + * Thanks to Peter Zijlstra <peterz@infradead.org>.
> + */
> +
> +#include <linux/perf_event.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +
> +struct perf_event_attr rh_attr = {
> +	.type	= PERF_TYPE_HARDWARE,
> +	.config = PERF_COUNT_HW_CACHE_MISSES,
> +	.size	= sizeof(struct perf_event_attr),
> +	.pinned	= 1,
> +	/* FIXME: it is 1000000 per cpu. */
> +	.sample_period = 500000,
> +};

I'm not sure that this is general enough to live in core code, because:

* there are existing ways around this (e.g. in the drammer case, using a
  non-cacheable mapping, which I don't believe would count as a cache
  miss).

  Given that, I'm very worried that this gives the false impression of
  protection in cases where a software workaround of this sort is
  insufficient or impossible.

* the precise semantics of performance counter events varies drastically
  across implementations. PERF_COUNT_HW_CACHE_MISSES, might only map to
  one particular level of cache, and/or may not be implemented on all
  cores.

* On some implementations, it may be that the counters are not
  interchangeable, and for those this would take away
  PERF_COUNT_HW_CACHE_MISSES from existing users.

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
> +	/* FIXME msec per usec, reverse logic? */
> +	if (delta < 64 * NSEC_PER_MSEC)
> +		mdelay(56);
> +}

If I round-robin my attack across CPUs, how much does this help?

Thanks,
Mark.
