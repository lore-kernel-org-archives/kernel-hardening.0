Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 17:55:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160804155523.GO6879@twins.programming.kicks-ass.net>
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
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 04, 2016 at 11:44:28AM -0400, Daniel Micay wrote:

> This feature doesn't come from Android. The perf events subsystem in the
> mainline kernel is packed full of vulnerabilities too. 

Uhh, not so much. I spend a _lot_ of time a while back to get the core
and x86 solid. I could run the fuzzers for hours on end at some point.

> The problem is so bad that pointing one of the public fuzzers at it
> for a short period of time is all that's required to start finding
> them.

If you know of any that reproduce on x86 I'll go fix. For anything else
you need to complain elsewhere as I don't have hardware nor bandwidth.
