Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 20:48:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161028184804.GN3142@twins.programming.kicks-ass.net>
References: <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
 <20161028112136.GA5635@amd>
 <20161028140522.GH5806@leverpostej>
 <20161028141840.GI3142@twins.programming.kicks-ass.net>
 <20161028183013.GA13354@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028183013.GA13354@amd>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 08:30:14PM +0200, Pavel Machek wrote:
> Would you (or someone) have pointer to good documentation source on
> available performance counters?

The Intel SDM has a section on them and the AMD Bios and Kernel
Developers Guide does too.

That is, they contain lists of available counters for the various parts
from these vendors and that's pretty much all there is.
