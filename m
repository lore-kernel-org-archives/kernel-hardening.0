Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161201230328.GS3045@worktop.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net> <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 1 Dec 2016 15:20:29 -0800
Message-ID: <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Windsor <dwindsor@gmail.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 1, 2016 at 3:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Dec 01, 2016 at 04:31:16PM -0500, David Windsor wrote:
>> Also, I'd like to point out that while identifying stats_t instances, I
>> have found a similar distribution of non-standard functions (as agreed upon
>> for the stats_t API).
>
>> First, usage of atomic_long_wrap_t (there currently isn't a stats_long_t
>> planned for implementation):
>
> There isn't even a stats_t planned. I'm still very much not convinced
> stats_t is needed or even makes sense.
>
> It wouldn't have any different semantics from atomic_t, and the only
> argument Kees made was that reduced atomic_t usage would make it easier
> to spot refcounts, but you're already building tools to find those.
>
> Once the tools work, who cares.

The tool is only part of the whole thing. By distinctly splitting the
other major atomic_t usage pattern away from atomic_t, it solidifies a
stats_t as NOT a reference counter. It's the slow feature-creep or bad
example situations that I'd like to avoid. Also, tools won't catch
everything, and doing manual inspection is much easier if we know a
stats_t cannot be misused.

There doesn't seem to be a good reason NOT to have stats_t, beyond the
work needed to create it and audit the places it should be used.

-Kees

-- 
Kees Cook
Nexus Security
