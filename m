Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAEXv5_jnsM8z9kNF5Woq-u3m2_Wi3Lnep-aWKNqzULHSqvF0EQ@mail.gmail.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net> <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net> <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
 <20161202011759.GA28026@tardis.cn.ibm.com> <CAEXv5_gfPM3BJyoDwPN=0afhO0oQPm=ix1mQvfYuKJephZBAGQ@mail.gmail.com>
 <20161207132457.GG3107@twins.programming.kicks-ass.net> <CAEXv5_jnsM8z9kNF5Woq-u3m2_Wi3Lnep-aWKNqzULHSqvF0EQ@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Fri, 9 Dec 2016 09:48:27 -0500
Message-ID: <CAEXv5_i92ds+hNyHpO8Uxs3Row2NEko-S=GTS_JBwaCHs6GYSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 7, 2016 at 2:03 PM, David Windsor <dwindsor@gmail.com> wrote:
> On Wed, Dec 7, 2016 at 8:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Dec 02, 2016 at 03:25:42PM -0500, David Windsor wrote:
>>> On Thu, Dec 1, 2016 at 8:17 PM, Boqun Feng <boqun.feng@gmail.com> wrote:
>>
>>> > So we currently don't have a clear semantics for stats_t, do we?
>>>
>>> We had a discussion about the stats_t API in another thread.  We
>>> agreed upon add(), sub(), inc(), dec(), read() and set().
>>>
>>> > What kind of atomic_t should be replaced with stats_t?
>>>
>>> stats_t is used for those cases in which an atomic variable is
>>> required, but the overflow of this variable isn't of much concern.
>>> Typically, these types of variables are counters of some kind (rx/tx
>>> counts, etc), but not always.  Perhaps "stats_t" isn't the best type
>>> name.  We actually used "atomic_wrap_t" in previous iterations.
>>
>> And atomic_wrap_t is a horrid trainwreck. Please as to explain the
>> semantics of atomic_wrap_cmpxchg(). How does wrapping apply to something
>> that doesn't do sign bits.
>>
>
> atomic_wrap_t grew out of a desire to fix an already broken system for
> doing reference counting.  atomic_t is being widely used for both
> reference counting (which should not overflow), non-reference
> counting, and other operations.  atomic_wrap_t provides the semantics
> of the "original" atomic_t: atomic operations with no overflow
> protection.  Thus, atomic_wrap_cmpxchg(): the cmpxchg operation for
> atomic_wrap_t types.  Abominations like this sometimes exist in RFC
> series.  In this case, we came up with the atomic_wrap API by mostly
> creating an atomic_wrap-ified version of each atomic_t API function.
>

After giving this some more thought, I feel I should mention that
kernel reference counting is obviously not "broken" as stated above.
I was just referring to the fact that a single type is used for both
reference counting and non-reference counting, so any protection (and
added performance hit) added to atomic_t will be picked up in the
non-reference counter cases as well.
