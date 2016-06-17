Reply-To: kernel-hardening@lists.openwall.com
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
In-Reply-To: <20160111152355.GS28542@decadent.org.uk>
References: <20160111151958.GQ28542@decadent.org.uk> <20160111152355.GS28542@decadent.org.uk>
Date: Fri, 17 Jun 2016 08:56:46 +0300
Message-ID: <871t3wuzmp.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 2/2] security,perf: Allow further restriction of perf_event_open
To: Ben Hutchings <ben@decadent.org.uk>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Ben Hutchings <ben@decadent.org.uk> writes:

> When kernel.perf_event_open is set to 3 (or greater), disallow all
> access to performance events by users without CAP_SYS_ADMIN.
> Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
> makes this value the default.

So this patch does two things, can it then be made into two patches?

>
> This is based on a similar feature in grsecurity
> (CONFIG_GRKERNSEC_PERF_HARDEN).  This version doesn't include making
> the variable read-only.  It also allows enabling further restriction
> at run-time regardless of whether the default is changed.

This paragraph doesn't seem to belong in the commit message.

What this commit message is missing entirely is the rationale behind
this change other than "grsecurity does the same". Can you please
elaborate?

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> I made a similar change to Debian's kernel packages in August,
> including the more restrictive default, and no-one has complained yet.

As a debian user, is this a good place to complain? Because it does get
it the way.

Thanks,
--
Alex
