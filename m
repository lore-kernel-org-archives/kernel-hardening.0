Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 11:28:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160804102854.GB4483@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <1470252976.22643.41.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470252976.22643.41.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 03, 2016 at 03:36:16PM -0400, Daniel Micay wrote:
> There's a lot of architecture and vendor specific perf events code and
> lots of bleeding edge features. On Android, a lot of the perf events
> vulnerabilities have been specific to the Qualcomm SoC platform. Other
> platforms are likely just receiving a lot less attention.

Are the relevant perf drivers for those platforms upstream? I've seen no
patches addressing security issues in the ARMv7 krait+Scorpion PMU
driver since it was added, and there's no ARMv8 QCOM PMU driver.

If there are outstanding issues, please report them upstream.

FWIW, I've used Vince Weaver's perf fuzzer to test the ARM PMU code
(both the framework and drivers), so other platforms are seeing some
attention. That said, I haven't done that recently.

Thanks,
Mark.
