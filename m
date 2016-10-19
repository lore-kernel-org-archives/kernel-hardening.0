Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 19 Oct 2016 10:41:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161019094115.GC9616@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20161017134413.GK29095@leverpostej>
 <1476716073.4032.5.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476716073.4032.5.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 17, 2016 at 10:54:33AM -0400, Daniel Micay wrote:
> On Mon, 2016-10-17 at 14:44 +0100, Mark Rutland wrote:
> > It's also my understanding that for Android, perf_event_paranoid is
> > lowered when the user enables developer mode (rather than only when an
> > external debugger is attached); is that correct?
> 
> It's exposed as a "system property" marked as writable by the shell
> user, so the Android Debug Bridge shell can lower it. The debugging
> tools learned how to toggle it off automatically when they're used. It
> intentionally isn't a persist. prefixed property so the setting also
> goes away on reboot.
> 
> ADB (incl. the shell user) isn't available until developer mode is
> enabled + ADB is toggled on in the developer settings, and then it still
> requires whitelisting keys.

Ah; so I'd misunderstood somewhat.

I was under the (clearly mistaken) impression that this was lowered when
developer mode was enabled, rather than only when it was both enabled
and ADB was connected, for example.

Thanks for clearing that up!

Thanks,
Mark.
