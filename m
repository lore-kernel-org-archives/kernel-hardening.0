Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2016 17:00:50 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
Message-ID: <20160617200050.GL13337@kernel.org>
References: <20160111151958.GQ28542@decadent.org.uk>
 <1466180207.849.50.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466180207.849.50.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-doc@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Em Fri, Jun 17, 2016 at 12:16:47PM -0400, Daniel Micay escreveu:
> On Fri, 2016-06-17 at 08:54 +0200, Peter Zijlstra wrote:
> > This Changelog is completely devoid of information. _WHY_ are you
> > doing this?
 
> Attack surface reduction. It's possible to use seccomp-bpf for some
> limited cases, but it's not flexible enough. There are lots of
> information leaks and local privilege escalation vulnerabilities via
> perf events, yet on most Linux installs it's not ever being used. So
> turning it off by default on those installs is an easy win. The holes
> are reduced to root -> kernel (and that's not a meaningful boundary in
> mainline right now - although as is the case here, Debian has a bunch of
> securelevel patches for that).

Is ptrace also disabled on such systems, or any of the other more recent
syscalls? The same arguments could probably be used to disable those:
reduce attack surface, possibly the new ones have bugs as they are
relatively new and it takes a long time for new syscalls to be more
generally used, if we go on disabling them in such a way, they will
probably never get used :-\

Wouldn't the recent bump in perf_event_paranoid to 2 enough? I.e. only
allow profiling of user tasks?

Or is there something more specific that we should disable/constrain to
reduce such surface contact without using such a big hammer?

- Arnaldo
