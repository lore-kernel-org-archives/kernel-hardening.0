Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 17 Oct 2016 14:44:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161017134413.GK29095@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469630746-32279-1-git-send-email-jeffv@google.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Attempt to revive discussions below...

On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
> When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> all access to performance events by users without CAP_SYS_ADMIN.
> 
> This new level of restriction is intended to reduce the attack
> surface of the kernel. Perf is a valuable tool for developers but
> is generally unnecessary and unused on production systems. Perf may
> open up an attack vector to vulnerable device-specific drivers as
> recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843. This new level of
> restriction allows for a safe default to be set on production systems
> while leaving a simple means for developers to grant access [1].
> 
> This feature is derived from CONFIG_GRKERNSEC_PERF_HARDEN by Brad
> Spengler. It is based on a patch by Ben Hutchings [2]. Ben's patches
> have been modified and split up to address on-list feedback.
> 
> kernel.perf_event_paranoid=3 is the default on both Debian [2] and
> Android [3].

While people weren't particularly happy with this global toggle
approach, my understanding from face-to-face discussions at LSS2016 was
that people were happy with a more scoped restriction (e.g. using
capabilities or some other access control mechanism), but no-one had the
time to work on that.

Does that match everyone's understanding, or am I mistaken?

It's also my understanding that for Android, perf_event_paranoid is
lowered when the user enables developer mode (rather than only when an
external debugger is attached); is that correct?

Thanks,
Mark.
