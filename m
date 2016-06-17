Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2016 08:54:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160617065427.GL30154@twins.programming.kicks-ass.net>
References: <20160111151958.GQ28542@decadent.org.uk>
 <20160111152355.GS28542@decadent.org.uk>
 <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>
 <CABXk95BE3wpgq-Y08G+Z3ZJbxJwgiuVvtQGaV4n-tD6GKNiFKg@mail.gmail.com>
 <CAGXu5j+D00zz7dVPX4LpW41Gk=m7G_h25vZgOyYdVbW+wyvj6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+D00zz7dVPX4LpW41Gk=m7G_h25vZgOyYdVbW+wyvj6Q@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 03:27:55PM -0700, Kees Cook wrote:
> Hi guys,
> 
> This patch wasn't originally CCed to you (I'm fixing that now). Would
> you consider taking this into the perf tree? 

No.

> It's been in active use
> in both Debian and Android for a while now.

Very nice of you all to finally inform us I suppose :/

> >>> When kernel.perf_event_open is set to 3 (or greater), disallow all
> >>> access to performance events by users without CAP_SYS_ADMIN.
> >>> Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
> >>> makes this value the default.
> >>>
> >>> This is based on a similar feature in grsecurity
> >>> (CONFIG_GRKERNSEC_PERF_HARDEN).  This version doesn't include making
> >>> the variable read-only.  It also allows enabling further restriction
> >>> at run-time regardless of whether the default is changed.

This Changelog is completely devoid of information. _WHY_ are you doing
this?

Also, hate the CONFIG.
