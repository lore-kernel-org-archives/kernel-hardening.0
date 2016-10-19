Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 19 Oct 2016 07:26:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
Message-ID: <20161019102602.GA25522@kernel.org>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20161017134413.GK29095@leverpostej>
 <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
 <1476825301.4032.7.camel@gmail.com>
 <20161019100126.GI3102@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161019100126.GI3102@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Micay <danielmicay@gmail.com>, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Em Wed, Oct 19, 2016 at 12:01:26PM +0200, Peter Zijlstra escreveu:
> On Tue, Oct 18, 2016 at 05:15:01PM -0400, Daniel Micay wrote:
> > It's also worth noting that fine-grained control via a scoped mechanism
> > would likely only be used to implement *more restrictions* on Android,
> > not to make the feature less aggressive.
 
> > It's desirable for perf events to be disabled by default for non-root
> > across the board on Android.
 
> Right, but this is Android. The knob seems to now also live in Debian
> (and derived) distros. And there it is utter crap.
 
> It completely defeats having perf for a fairly large segment of
> corporate developers who do not get to have root on their own machines
> (which is stupid policy but whatever).
 
> It similarly defeats development of self profiling JITs and whatnot.
 
> A capability would allow people to run perf (or another sanctioned
> binary), even though in general they cannot do sys_perf_event_open().

But self profiling JITs would be useful for non-developers, on Android
(anywhere, really), and for that it would require being able to at
least, well, self profile, using sys_perf_event_open() by a normal
process, limited to profiling itself, no?

This not being possible, self profiling will use some other means, its
like sys_perf_event_open() never existed for them.

- Arnaldo
