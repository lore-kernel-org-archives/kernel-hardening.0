Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110222744.GD8086@kroah.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net> <20161110222744.GD8086@kroah.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Nov 2016 15:15:44 -0800
Message-ID: <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

(PeterZ went missing from your reply? I've added him back to the thread...)

On Thu, Nov 10, 2016 at 2:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 10, 2016 at 10:13:10PM +0100, Peter Zijlstra wrote:
>> On Thu, Nov 10, 2016 at 08:48:38PM +0000, Will Deacon wrote:
>> > > That said, I still don't much like this.
>> > >
>> > > I would much rather you make kref useful and use that. It still means
>> > > you get to audit all refcounts in the kernel, but hey, you had to do
>> > > that anyway.
>> >
>> > What needs to happen to kref to make it useful? Like many others, I've
>> > been guilty of using atomic_t for refcounts in the past.
>>
>> As it stands kref is a pointless wrapper. If it were to provide
>> something actually useful, like wrap protection, then it might actually
>> make sense to use it.
>
> It provides the correct cleanup ability for a reference count and the
> object it is in, so it's not all that pointless :)
>
> But I'm always willing to change it to make it work better for people,
> if kref did the wrapping protection (i.e. used a non-wrapping atomic
> type), then you would have that.  I thought that was what this patchset
> provided...
>
> And yes, this is a horridly large patchset.  I've looked at these
> changes, and in almost all of them, people are using atomic_t as merely
> a "counter" for something (sequences, rx/tx stats, etc), to get away
> without having to lock it with an external lock.
>
> So, does it make more sense to just provide a "pointless" api for this
> type of "counter" pattern:
>         counter_inc()
>         counter_dec()
>         counter_read()
>         counter_set()
>         counter_add()
>         counter_subtract()
> Those would use the wrapping atomic type, as they can wrap all they want
> and no one really is in trouble.  Once those changes are done, just make
> atomic_t not wrap and all should be fine, no other code should need to
> be changed.
>
> We can bikeshed on the function names for a while, to let everyone feel
> they contributed (counter, kcount, ksequence, sequence_t, cnt_t, etc.)...

Bikeshed: "counter" doesn't tell me anything about its behavior at max value.

> And yes, out-of-tree code will work differently, but really, the worse
> that could happen is their "sequence number" stops wrapping :)
>
> Would that be a better way to implement this?

A thought I had if the opt-out approach is totally unacceptable would
be to make it a CONFIG option that can toggle the risk as desired. It
would require splitting into three cases:

reference counters (say, "refcount" implemented with new atomic_nowrap_t)

statistic counters (say, "statcount" implemented with new atomic_wrap_t)

everything else (named "atomic_t", implemented as either
atomic_nowrap_t or atomic_wrap_t, depending on CONFIG)

-Kees

-- 
Kees Cook
Nexus Security
