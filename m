Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 16:11:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160804141109.GM6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <1470252976.22643.41.camel@gmail.com>
 <20160804102854.GB4483@leverpostej>
 <1470318323.22643.70.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470318323.22643.70.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 04, 2016 at 09:45:23AM -0400, Daniel Micay wrote:
> Qualcomm's perf driver is out-of-tree along with most of their other
> drivers. 


So you're asking us to maim upstream perf for some out of tree junk?
Srously? *plonk*
