Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 14:47:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161031144739.GA6007@remoulade>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161031082705.GA2863@amd>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 31, 2016 at 09:27:05AM +0100, Pavel Machek wrote:
> > On Fri, Oct 28, 2016 at 01:21:36PM +0200, Pavel Machek wrote:
> > > > Has this been tested on a system vulnerable to rowhammer, and if so, was
> > > > it reliable in mitigating the issue?

> > > I do not have vulnerable machine near me, so no "real" tests, but
> > > I'm pretty sure it will make the error no longer reproducible with the
> > > newer version. [Help welcome ;-)]
> > 
> > Even if we hope this works, I think we have to be very careful with that
> > kind of assertion. Until we have data is to its efficacy, I don't think
> > we should claim that this is an effective mitigation.
> 
> Ok, so it turns out I was right. On my vulnerable machine, normally
> bug is reproducible in less than 500 iterations:

> With nohammer, I'm at 2300 iterations, and still no faults.

To be quite frank, this is anecdotal. It only shows one particular attack is
made slower (or perhaps defeated), and doesn't show that the mitigation is
reliable or generally applicable (to other machines or other variants of the
attack).

Even if this happens to work on some machines, I still do not think one can
sell this as a generally applicable and reliable mitigation. Especially given
that others working in this area seem to have evidence otherwise, e.g. [1] (as
noted by spender in the LWN comments).

Thanks,
Mark.

[1] https://twitter.com/halvarflake/status/792314613568311296
