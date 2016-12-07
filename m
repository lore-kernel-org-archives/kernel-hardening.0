Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161207132457.GG3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net> <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net> <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
 <20161202011759.GA28026@tardis.cn.ibm.com> <CAEXv5_gfPM3BJyoDwPN=0afhO0oQPm=ix1mQvfYuKJephZBAGQ@mail.gmail.com>
 <20161207132457.GG3107@twins.programming.kicks-ass.net>
From: David Windsor <dwindsor@gmail.com>
Date: Wed, 7 Dec 2016 14:03:16 -0500
Message-ID: <CAEXv5_jnsM8z9kNF5Woq-u3m2_Wi3Lnep-aWKNqzULHSqvF0EQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 7, 2016 at 8:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Dec 02, 2016 at 03:25:42PM -0500, David Windsor wrote:
>> On Thu, Dec 1, 2016 at 8:17 PM, Boqun Feng <boqun.feng@gmail.com> wrote:
>
>> > So we currently don't have a clear semantics for stats_t, do we?
>>
>> We had a discussion about the stats_t API in another thread.  We
>> agreed upon add(), sub(), inc(), dec(), read() and set().
>>
>> > What kind of atomic_t should be replaced with stats_t?
>>
>> stats_t is used for those cases in which an atomic variable is
>> required, but the overflow of this variable isn't of much concern.
>> Typically, these types of variables are counters of some kind (rx/tx
>> counts, etc), but not always.  Perhaps "stats_t" isn't the best type
>> name.  We actually used "atomic_wrap_t" in previous iterations.
>
> And atomic_wrap_t is a horrid trainwreck. Please as to explain the
> semantics of atomic_wrap_cmpxchg(). How does wrapping apply to something
> that doesn't do sign bits.
>

atomic_wrap_t grew out of a desire to fix an already broken system for
doing reference counting.  atomic_t is being widely used for both
reference counting (which should not overflow), non-reference
counting, and other operations.  atomic_wrap_t provides the semantics
of the "original" atomic_t: atomic operations with no overflow
protection.  Thus, atomic_wrap_cmpxchg(): the cmpxchg operation for
atomic_wrap_t types.  Abominations like this sometimes exist in RFC
series.  In this case, we came up with the atomic_wrap API by mostly
creating an atomic_wrap-ified version of each atomic_t API function.

>> > In the link David  pointed out, there are a few cases where a
>> > stats_t is put on a correctness-related variable. I don't think
>> > that's a good place to use stats_t.
>> >
>>
>> Yeah, I just grabbed a few examples I noted during my stats_t
>> conversion work.  The drivers/ tree is littered with stats_t
>> instances.
>
> Not sure how to respond to this, if you're converting all that to
> stats_t then you're doing it wrong.
>
> Most of what you showed should very emphatically not be stats_t.
>

Yes, none of those examples were appropriate.  My apologies; they were
quickly chosen from a pool of potential stats_t conversions.

Further audit of atomic_wrap_t indicates that much of what we marked
as atomic_wrap_t are actually things like sequence numbers, IDs, etc.
Examples:

http://lxr.free-electrons.com/source/include/linux/padata.h#L132
struct parallel_data.seq_nr

http://lxr.free-electrons.com/source/fs/btrfs/delayed-inode.h#L46
struct btrfs_delayed_root.items_seq

http://lxr.free-electrons.com/source/drivers/ata/libata-core.c#L108
ata_print_id

These "identifier" types make up a good number of atomic_wrap_t cases.

With respect to stats_t variables, here are two more examples.

First, cm_listens_created and cm_listens_destroyed from
drivers/infiniband/hw/nes/nes_cm.c:
http://lxr.free-electrons.com/source/drivers/infiniband/hw/nes/nes_cm.c#L72.
Only atomic_inc() and atomic_read() are used on these variables:

http://lxr.free-electrons.com/source/drivers/infiniband/hw/nes/nes_cm.c#L3499
atomic_inc(&cm_listens_created);

http://lxr.free-electrons.com/source/drivers/infiniband/hw/nes/nes_cm.c#L1336
atomic_inc(&cm_listens_destroyed);

http://lxr.free-electrons.com/source/drivers/infiniband/hw/nes/nes_nic.c#L1284
target_stat_values[++index] = atomic_read(&cm_listens_created);

http://lxr.free-electrons.com/source/drivers/infiniband/hw/nes/nes_nic.c#L1285
target_stat_values[++index] = atomic_read(&cm_listens_destroyed);


Next, struct irq_desc.threads_handled.  It is defined in
include/linux/irqdesc.h and, in the struct's comments, is described
as, "[a] stats field for deferred spurious detection of threaded
handlers."

Only atomic_inc() and atomic_read() are called to manage this variable:

atomic_read():
kernel/irq/spurious.c:
handled = atomic_read(&desc->threads_handled);

irq_desc.threads_handled is part of threaded interrupt handlers and is
incremented in irq_thread():.

atomic_inc():
kernel/irq/manage.c:949
static int irq_thread(void *data)
{
    ....
    while (!irq_wait_for_interrupt(action)) {
        irqreturn_t action_ret;

        irq_thread_check_affinity(desc, action);

        action_ret = handler_fn(desc, action);
        if (action_ret == IRQ_HANDLED)
            atomic_inc(&desc->threads_handled);
    ...
}
