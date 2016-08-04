Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 17:10:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160804161000.GA11673@leverpostej>
References: <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <1470252976.22643.41.camel@gmail.com>
 <20160804102854.GB4483@leverpostej>
 <1470318323.22643.70.camel@gmail.com>
 <20160804141109.GM6879@twins.programming.kicks-ass.net>
 <1470325468.22643.95.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470325468.22643.95.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 04, 2016 at 11:44:28AM -0400, Daniel Micay wrote:
> Qualcomm's drivers might be lower quality than core kernel code, but
> they're way above the baseline set by mainline kernel drivers...

I don't think that's true for the arm/arm64 perf code.

I think we've done a reasonable job of testing and fixing those, along
with core infrastructure issues. The perf fuzzer runs for a very long
time on a mainline kernel without issues, while on my Nexus 5x I get a
hard lockup after ~85 seconds (and prior to the last android update the
lockup was instantaneous).

> Shining the same light on mainline drivers wouldn't be pretty. The work
> going into hardening the Qualcomm drivers isn't happening upstream to
> any comparable extent.

>From my personal experience (and as above), and talking specifically
about PMU drivers, I think that the opposite is true. This is not to say
there aren't issues; I would not be surprised if there are. But it's
disingenuous to say that mainline code is worse than that which exists
in a vendor kernel when the latter is demonstrably much easier to break
than the former.

If there are issues you are aware of, please report them. If those
issues only exist in non-upstream code, then the applicable concerns are
somewhat different (though certainly still exist).

But please, let's frame the argument to match reality.

Thanks,
Mark.
