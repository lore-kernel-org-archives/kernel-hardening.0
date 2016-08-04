Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 18:09:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160804170944.GA16464@leverpostej>
References: <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <1470252976.22643.41.camel@gmail.com>
 <20160804102854.GB4483@leverpostej>
 <1470318323.22643.70.camel@gmail.com>
 <20160804141109.GM6879@twins.programming.kicks-ass.net>
 <1470325468.22643.95.camel@gmail.com>
 <20160804161000.GA11673@leverpostej>
 <1470328352.22643.110.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470328352.22643.110.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 04, 2016 at 12:32:32PM -0400, Daniel Micay wrote:
> On Thu, 2016-08-04 at 17:10 +0100, Mark Rutland wrote:
> I wasn't talking specifically about perf.

Then this is irrelevant to a discussion about limiting access to the
perf interface.

Hardening drivers in general is a very interesting topic, but it is a
different topic.

> > But please, let's frame the argument to match reality.
> 
> The argument is framed in reality. Stating that it now often takes a
> few hours to find a vulnerability with the unaltered, widely known
> public perf fuzzer is not impressive. It's really an argument for
> claiming that it's a significant security issue.

My claim was not that the mainline code was impressively perfect, but
rather that the vendor code was worse, countering a prior claim
otherwise. Hence, reality.

There is cetainly much that can be done to improve things, if we discuss
that which is actually applicable.

Thanks,
Mark.
