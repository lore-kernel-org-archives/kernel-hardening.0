Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 2 Aug 2016 11:52:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160802095243.GD6862@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469630746-32279-1-git-send-email-jeffv@google.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further restriction of
 perf_event_open
To: Jeff Vander Stoep <jeffv@google.com>
Cc: kernel-hardening@lists.openwall.com, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
> When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> all access to performance events by users without CAP_SYS_ADMIN.
> 
> This new level of restriction is intended to reduce the attack
> surface of the kernel. Perf is a valuable tool for developers but
> is generally unnecessary and unused on production systems. Perf may
> open up an attack vector to vulnerable device-specific drivers as
> recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843.

We have bugs we fix them, we don't kill complete infrastructure because
of them.

> This new level of
> restriction allows for a safe default to be set on production systems
> while leaving a simple means for developers to grant access [1].

So the problem I have with this is that it will completely inhibit
development of things like JITs that self-profile to re-compile
frequently used code.

I would much rather have an LSM hook where the security stuff can do
more fine grained control of things. Allowing some apps perf usage while
denying others.
