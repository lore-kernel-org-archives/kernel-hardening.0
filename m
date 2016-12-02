Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161202011759.GA28026@tardis.cn.ibm.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net> <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net> <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
 <20161202011759.GA28026@tardis.cn.ibm.com>
From: David Windsor <dwindsor@gmail.com>
Date: Fri, 2 Dec 2016 15:25:42 -0500
Message-ID: <CAEXv5_gfPM3BJyoDwPN=0afhO0oQPm=ix1mQvfYuKJephZBAGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 1, 2016 at 8:17 PM, Boqun Feng <boqun.feng@gmail.com> wrote:
> On Thu, Dec 01, 2016 at 03:20:29PM -0800, Kees Cook wrote:
>> On Thu, Dec 1, 2016 at 3:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, Dec 01, 2016 at 04:31:16PM -0500, David Windsor wrote:
>> >> Also, I'd like to point out that while identifying stats_t instances, I
>> >> have found a similar distribution of non-standard functions (as agreed upon
>> >> for the stats_t API).
>> >
>> >> First, usage of atomic_long_wrap_t (there currently isn't a stats_long_t
>> >> planned for implementation):
>> >
>> > There isn't even a stats_t planned. I'm still very much not convinced
>> > stats_t is needed or even makes sense.
>> >
>> > It wouldn't have any different semantics from atomic_t, and the only
>> > argument Kees made was that reduced atomic_t usage would make it easier
>> > to spot refcounts, but you're already building tools to find those.
>> >
>> > Once the tools work, who cares.
>>
>> The tool is only part of the whole thing. By distinctly splitting the
>> other major atomic_t usage pattern away from atomic_t, it solidifies a
>> stats_t as NOT a reference counter. It's the slow feature-creep or bad
>> example situations that I'd like to avoid. Also, tools won't catch
>> everything, and doing manual inspection is much easier if we know a
>> stats_t cannot be misused.
>>
>> There doesn't seem to be a good reason NOT to have stats_t, beyond the
>> work needed to create it and audit the places it should be used.
>>
>
> So we currently don't have a clear semantics for stats_t, do we?

We had a discussion about the stats_t API in another thread.  We
agreed upon add(), sub(), inc(), dec(), read() and set().

> What kind of atomic_t should be replaced with stats_t?

stats_t is used for those cases in which an atomic variable is
required, but the overflow of this variable isn't of much concern.
Typically, these types of variables are counters of some kind (rx/tx
counts, etc), but not always.  Perhaps "stats_t" isn't the best type
name.  We actually used "atomic_wrap_t" in previous iterations.

> In the link David  pointed out, there are a few cases where a stats_t is put on a
> correctness-related variable. I don't think that's a good place to use
> stats_t.
>

Yeah, I just grabbed a few examples I noted during my stats_t
conversion work.  The drivers/ tree is littered with stats_t
instances.

> Besides, there are many statistics-purpose variables in kernel which are
> not atomic, given those, only calling atomic statistic variables stats_t
> seems inappropriate and misleading.
>
> How about provide a modifier, say __stats, like __rcu, __percpu. We can
> add it to the types of the variables that are only for
> statistics-purpose. I think it won't be difficult to find all related
> callsites of a __stats with the help of some compiler frontend tools, we
> can then detect a possible problem if we do a cmpxchg on a __stats,
> which is unlikely a proper usage for a statistic variable. And we don't
> need to change or use special APIs, we just need to mark variables and
> fields.
>

The modifier would definitely allow us to identify abuse of "stats"
variables.  But, this should be used in conjunction with mandatory
overflow protection on atomic_t.  As Kees said, tools won't find
everything; we need to secure the atomic_t type itself.

> Thoughts?
>
> Regards,
> Boqun
>
>> -Kees
>>
>> --
>> Kees Cook
>> Nexus Security
