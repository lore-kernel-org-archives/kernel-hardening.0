Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 22:09:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161031220907.GA6248@remoulade>
References: <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161031082705.GA2863@amd>
 <20161031144739.GA6007@remoulade>
 <20161031211303.GA15724@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161031211303.GA15724@amd>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 31, 2016 at 10:13:03PM +0100, Pavel Machek wrote:
> On Mon 2016-10-31 14:47:39, Mark Rutland wrote:
> > On Mon, Oct 31, 2016 at 09:27:05AM +0100, Pavel Machek wrote:
> > > > On Fri, Oct 28, 2016 at 01:21:36PM +0200, Pavel Machek wrote:
> > > > > > Has this been tested on a system vulnerable to rowhammer, and if so, was
> > > > > > it reliable in mitigating the issue?
> > 
> > > > > I do not have vulnerable machine near me, so no "real" tests, but
> > > > > I'm pretty sure it will make the error no longer reproducible with the
> > > > > newer version. [Help welcome ;-)]
> > > > 
> > > > Even if we hope this works, I think we have to be very careful with that
> > > > kind of assertion. Until we have data is to its efficacy, I don't think
> > > > we should claim that this is an effective mitigation.
> ...
> > 
> > To be quite frank, this is anecdotal. It only shows one particular attack is
> > made slower (or perhaps defeated), and doesn't show that the mitigation is
> > reliable or generally applicable (to other machines or other variants of the
> > attack).
> 
> So... I said that I'm pretty sure it will fix problem in my testing,
> then you say that I should be careful with my words, I confirm it was
> true, and now you complain that it is anecdotal?

Clearly I have chosen my words poorly here. I believe that this may help
against some attacks on some machines and workloads, and I believe your results
for your machine.

My main concern was that this appears to be described as a general solution, as
in the Kconfig text:

	Enable rowhammer attack prevention. Will degrade system
	performance under attack so much that attack should not
	be feasible.

... yet there are a number of reasons why this may not be the case given varied
attack mechanisms (e.g. using non-cacheable mappings, movnt, etc), given some
hardware configurations (e.g. "large" SMP machines or where timing is
marginal), given some workloads may incidentally trip often enough to be
severely penalised, and given that performance counter support is sufficiently
varied (across architectures, CPU implementations, and even boards using the
same CPU if one considers things like interrupt routing).

Given that, I think that makes an overly-strong, and perhaps misleading claim
(i.e. people could turn the option on and believe that they are protected, when
they are not, leaving them worse off). It isn't really possible to fail
gracefully here, and even if this is suitable for some hardware, very few
people are in a position to determine whether their hardware falls in that
category.

Unfortunately, I do not believe that there is a simple and/or general software
mitigation.

> Would it be less confusing if we redefined task description from
> "prevent rowhammer" to "prevent more than X memory accesses in 64
> msec"?

Definitely. Quantifying exactly what you're trying to defend against (and
therefore what you are not) would help to address at least one of my concerns.

Thanks,
Mark.
