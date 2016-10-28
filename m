Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 16:18:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161028141840.GI3142@twins.programming.kicks-ass.net>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028140522.GH5806@leverpostej>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Mark Rutland <mark.rutland@arm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 03:05:22PM +0100, Mark Rutland wrote:
> 
> > > * the precise semantics of performance counter events varies drastically
> > >   across implementations. PERF_COUNT_HW_CACHE_MISSES, might only map to
> > >   one particular level of cache, and/or may not be implemented on all
> > >   cores.
> > 
> > If it maps to one particular cache level, we are fine (or maybe will
> > trigger protection too often). If some cores are not counted, that's bad.
> 
> Perhaps, but that depends on a number of implementation details. If "too
> often" means "all the time", people will turn this off when they could
> otherwise have been protected (e.g. if we can accurately monitor the
> last level of cache).

Right, so one of the things mentioned in the paper is x86 NT stores.
Those are not cached and I'm not at all sure they're accounted in the
event we use for cache misses.
