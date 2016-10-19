Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 19 Oct 2016 10:56:05 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161019095605.GD9616@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20161017134413.GK29095@leverpostej>
 <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
 <1476825301.4032.7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476825301.4032.7.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 05:15:01PM -0400, Daniel Micay wrote:
> It's also worth noting that fine-grained control via a scoped
> mechanism would likely only be used to implement *more restrictions*
> on Android, not to make the feature less aggressive. It's desirable
> for perf events to be disabled by default for non-root across the
> board on Android.  The part that's imperfect is that when a developer
> uses a profiling tool, unprivileged usage is automatically enabled
> across the board until reboot. Ideally, it would be enabled only for
> the scope where it's needed. 

Sure; understood.

> It would be very tricky to implement though, especially without adding
> friction, and it would only have value for protecting devices being
> used for development. It really doesn't seem to be worth the trouble,
> especially since it doesn't persist on reboot. It's only a temporary
> security hole and only for developer devices.

I can see that for Android this isn't much of a win. It is beneficial
elsewhere, and covers a larger set of use-cases.

If perf were a filesystem object, we'd only allow access by a given
'perf' group, and that would be sufficient to avoid most of that
friction (IIUC). I wonder what we can do that's similar.

Thanks,
Mark.
