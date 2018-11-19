Date: Mon, 19 Nov 2018 11:46:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v1 2/2]: Documentation/admin-guide: introduce
 perf-security.rst file
Message-ID: <20181119104646.GB9761@hirez.programming.kicks-ass.net>
References: <0ac97cd0-4773-fff6-7d4e-74c4a1f076c4@linux.intel.com>
 <a44df303-d962-c1a4-4fe0-6bad887ebcdc@linux.intel.com>
 <aDN4nC6p93nK7ILVP3EH-Y4RcKK4KH0ppQKFkIgxTVxkfbOHWjAYJXdTeuq39nbPkySKItZ_8VHN2PfQS_T08GBzeooD5cvc2Xd8oZxSp9s=@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDN4nC6p93nK7ILVP3EH-Y4RcKK4KH0ppQKFkIgxTVxkfbOHWjAYJXdTeuq39nbPkySKItZ_8VHN2PfQS_T08GBzeooD5cvc2Xd8oZxSp9s=@protonmail.ch>
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andi Kleen <ak@linux.intel.com>, Jonatan Corbet <corbet@lwn.net>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 19, 2018 at 10:35:59AM +0000, Jordan Glover wrote:
> On Monday, November 19, 2018 6:42 AM, Alexey Budankov <alexey.budankov@linux.intel.com> wrote:
> > +>=3:
> >
> > -       Restrict *access* to PCL performance monitoring for unprivileged processes.
> >
> >
> > -       This is the default on Debian and Android [7]_ , [8]_ .
> 
> AFAIK there is no support for '+>=3' in mainline kernel[1].
> Debian and Android use out-of-tree patch for that[2].
> Maybe someone should upstream it?

NAK still stands on that. Alternative's have been proposed but so far
nobody that cared seems to care enough to implement those.
