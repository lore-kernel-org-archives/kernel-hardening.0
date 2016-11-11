Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161110233835.GA23164@kroah.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net> <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com> <20161110233835.GA23164@kroah.com>
From: David Windsor <dave@progbits.org>
Date: Fri, 11 Nov 2016 02:50:41 -0500
Message-ID: <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 6:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
>> (PeterZ went missing from your reply? I've added him back to the thread...)
>
> argh, not intentional at all, thanks for that...
>
>> On Thu, Nov 10, 2016 at 2:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Nov 10, 2016 at 10:13:10PM +0100, Peter Zijlstra wrote:
>> >> On Thu, Nov 10, 2016 at 08:48:38PM +0000, Will Deacon wrote:
>> >> > > That said, I still don't much like this.
>> >> > >
>> >> > > I would much rather you make kref useful and use that. It still means
>> >> > > you get to audit all refcounts in the kernel, but hey, you had to do
>> >> > > that anyway.
>> >> >
>> >> > What needs to happen to kref to make it useful? Like many others, I've
>> >> > been guilty of using atomic_t for refcounts in the past.
>> >>
>> >> As it stands kref is a pointless wrapper. If it were to provide
>> >> something actually useful, like wrap protection, then it might actually
>> >> make sense to use it.
>> >
>> > It provides the correct cleanup ability for a reference count and the
>> > object it is in, so it's not all that pointless :)
>> >
>> > But I'm always willing to change it to make it work better for people,
>> > if kref did the wrapping protection (i.e. used a non-wrapping atomic
>> > type), then you would have that.  I thought that was what this patchset
>> > provided...
>> >
>> > And yes, this is a horridly large patchset.  I've looked at these
>> > changes, and in almost all of them, people are using atomic_t as merely
>> > a "counter" for something (sequences, rx/tx stats, etc), to get away
>> > without having to lock it with an external lock.
>> >
>> > So, does it make more sense to just provide a "pointless" api for this
>> > type of "counter" pattern:
>> >         counter_inc()
>> >         counter_dec()
>> >         counter_read()
>> >         counter_set()
>> >         counter_add()
>> >         counter_subtract()
>> > Those would use the wrapping atomic type, as they can wrap all they want
>> > and no one really is in trouble.  Once those changes are done, just make
>> > atomic_t not wrap and all should be fine, no other code should need to
>> > be changed.
>> >
>> > We can bikeshed on the function names for a while, to let everyone feel
>> > they contributed (counter, kcount, ksequence, sequence_t, cnt_t, etc.)...
>>
>> Bikeshed: "counter" doesn't tell me anything about its behavior at max value.
>
> True :)
>
>> > And yes, out-of-tree code will work differently, but really, the worse
>> > that could happen is their "sequence number" stops wrapping :)
>> >
>> > Would that be a better way to implement this?
>>
>> A thought I had if the opt-out approach is totally unacceptable would
>> be to make it a CONFIG option that can toggle the risk as desired. It
>> would require splitting into three cases:
>>
>> reference counters (say, "refcount" implemented with new atomic_nowrap_t)
>

Not sure if "refcount" is a label meant just for convenience in this
thread, or a newly proposed type name.  If the latter, I see no need
for it: kref should be the type name used for reference counters.

> These should almost always be just using a kref.  Yes, there are some
> vfs reference counters that can't use a kref, but those are rare.  And
> make kref use atomic_nowrap_t.
>
> This should be a very rare type, hopefully.
>

While I really, really don't want to go down the opt-in route, here
are the three relevant types and their associated use cases:

1) kref: Used for honest-to-goodness reference counters that want
overflow protection.  Uses a new type: atomic_nowrap_t that has
HARDENED_ATOMIC protection.
2) statistical counters: Atomic in all cases, but wraps.
3) atomic_t: All other users of atomics (locks, etc.).  Wrapping
behavior depends on a CONFIG setting.

We'd need to audit the kernel and identify all reference counter users
of atomic_t and convert them to kref.  This isn't nearly as large a
task as enumerating all statistical counter users of atomic_t.

The third category, users of atomic_t that fit neither into the
category of reference counters or stat counters, is the interesting
case.  I'm drawing a blank as to which of these users would require
overflow protection?  If none do, we could drastically reduce the size
of this patchset: leave atomic_t alone and implement kref with
atomic_nowrap_t.  Again, it's very late and I'm drawing a blank as to
"misc" users of atomic_t (non-refcount and non-stat-counters).

>> statistic counters (say, "statcount" implemented with new atomic_wrap_t)
>
> Lots of these are also "sequences", that drivers rely on.  Hopefully
> they can wrap as that's what happens today.  So that might not be the
> best name, but naming is hard...
>
>> everything else (named "atomic_t", implemented as either
>> atomic_nowrap_t or atomic_wrap_t, depending on CONFIG)
>

I don't like rerfcount/refcount_t: kref should be used.  In the same
spirit, kstatcount might be more consistent.

Pure, unadulterated bikeshedding.  =)

> Sounds reasonable, will that still give you the protection that you want
> here?
>

For

> thanks,
>
> greg k-h
