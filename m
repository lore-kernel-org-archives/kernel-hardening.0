Reply-To: kernel-hardening@lists.openwall.com
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com> <20161004124156.GE2040@pc.thejh.net>
 <57F51EB3.1030605@intel.com> <20161005161845.GR14666@pc.thejh.net>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57F52B03.8070300@intel.com>
Date: Wed, 5 Oct 2016 09:32:03 -0700
MIME-Version: 1.0
In-Reply-To: <20161005161845.GR14666@pc.thejh.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/05/2016 09:18 AM, Jann Horn wrote:
> 1. Pipeline flushes because of branch prediction failures caused by
>    more-or-less random cmpxchg retries? Pipeline flushes are pretty
>    expensive, right?
> 2. Repeated back-and-forth bouncing of the cacheline because an increment
>    via cmpxchg needs at least two accesses instead of one, and the
>    cacheline could be "stolen" by the other thread between the READ_ONCE
>    and the cmpxchg.
> 3. Simply the cost of retrying if the value has changed in the meantime.
> 4. Maybe if two CPUs try increments at the same time, with exactly the
>    same timing, they get stuck in a tiny livelock where every cmpxchg
>    fails because the value was just updated by the other core? And then
>    something slightly disturbs the timing (interrupt / clock speed
>    change / ...), allowing one task to win the race?

I can speculate about it, but I don't know for sure.  The topdown tool
from pmu-tools is usually a great way to figure out what's causing these
kinds of bottlenecks in the CPU:

	https://github.com/andikleen/pmu-tools
