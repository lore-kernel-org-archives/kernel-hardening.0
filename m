Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2016 15:36:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160803133610.GF6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <20160803082830.GA3163@gmail.com>
 <1470227290.19955.30.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470227290.19955.30.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 03, 2016 at 08:28:10AM -0400, Daniel Micay wrote:
> I don't think there are runtimes using this for JIT tracing. Perhaps it
> doesn't actually suit their needs. It's a theoretical use case.

I know there are compiler teams using perf for FDO, see for example:

  https://gcc.gnu.org/wiki/AutoFDO/Tutorial

LLVM also has AutoFDO support AFAIU.

There is no reason JITs could not also do this, and IIRC there's JITs
build on top of LLVM, so it shouldn't be too hard to imagine an AutoFDO
enabled JIT.
