Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1478824161.7326.5.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Fri, 11 Nov 2016 01:29:21 +0100
In-Reply-To: <20161110235714.GR3568@worktop.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
	 <20161110203749.GV3117@twins.programming.kicks-ass.net>
	 <20161110204838.GE17134@arm.com>
	 <20161110211310.GX3117@twins.programming.kicks-ass.net>
	 <20161110222744.GD8086@kroah.com>
	 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
	 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2016-11-11 at 00:57 +0100, Peter Zijlstra wrote:
> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
> > 
> > On Thu, Nov 10, 2016 at 2:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > On Thu, Nov 10, 2016 at 10:13:10PM +0100, Peter Zijlstra wrote:
> 
> > 
> > > 
> > > > 
> > > > As it stands kref is a pointless wrapper. If it were to provide
> > > > something actually useful, like wrap protection, then it might actually
> > > > make sense to use it.
> > > 
> > > It provides the correct cleanup ability for a reference count and the
> > > object it is in, so it's not all that pointless :)
> 
> I really fail to see the point of:
> 
> 	kref_put(&obj->ref, obj_free);
> 
> over:
> 
> 	if (atomic_dec_and_test(&obj->ref))
> 		obj_free(obj);
> 
> Utter pointless wrappery afaict.
> 
> > 
> > > 
> > > But I'm always willing to change it to make it work better for people,
> > > if kref did the wrapping protection (i.e. used a non-wrapping atomic
> > > type), then you would have that.  I thought that was what this patchset
> > > provided...
> 
> So kref could simply do something like the below patch. But this patch
> set completely rapes the atomic interface.
> 
> > 
> > > 
> > > And yes, this is a horridly large patchset.  I've looked at these
> > > changes, and in almost all of them, people are using atomic_t as merely
> > > a "counter" for something (sequences, rx/tx stats, etc), to get away
> > > without having to lock it with an external lock.
> > > 
> > > So, does it make more sense to just provide a "pointless" api for this
> > > type of "counter" pattern:
> > >         counter_inc()
> > >         counter_dec()
> > >         counter_read()
> > >         counter_set()
> > >         counter_add()
> > >         counter_subtract()
> > > Those would use the wrapping atomic type, as they can wrap all they want
> > > and no one really is in trouble.  Once those changes are done, just make
> > > atomic_t not wrap and all should be fine, no other code should need to
> > > be changed.
> 
> Still hate; yes there's a lot of stats which are just fine to wrap. But
> there's a lot more atomic out there than refcounts and stats.
> 
> The locking primitives for example use atomic_t, and they really don't
> want the extra overhead associated with this overflow crap, or the
> namespace pollution.
> 
> > 
> > reference counters (say, "refcount" implemented with new atomic_nowrap_t)
> > 
> > statistic counters (say, "statcount" implemented with new atomic_wrap_t)
> > 
> > everything else (named "atomic_t", implemented as either
> > atomic_nowrap_t or atomic_wrap_t, depending on CONFIG)
> 
> So the problem is that atomic_t has _much_ _much_ more than just add/sub
> operations, which are the only ones modified for this patch set.
> 
> The whole wrap/nowrap thing doesn't make any bloody sense what so ever
> for !arith operators like bitops or just plain cmpxchg.

I wonder if we didn't make a confusion between naming and
specifications. I have thought about Kees idea and what you're saying:

- The name "atomic_t" name didn't tell anything about if the variable
  can wrap or not. It just tells there is no race condition on
  concurrent access, nothing else, and users are well with that. OK
  then, we don't modify atomic_t, it makes sense.

- Hence, let's say a new type "refcount_t". It names exactly what we
  try to protect in this patch set. A much more simpler interface than
  atomic_t would be needed, and it protects on race condition and
  overflows (precisely what is expected of a counter reference). Not
  an opt-in solution, but it is much less invasive since we "just"
  have to modify the kref implementation and some vfs reference
  counters.

That didn't tell us how actually implements refcount_t: reuse some
atomic_t code or not (it would be simpler anyways, since we don't have
to implement the whole atomic_t interface). Still, this is another
problem.

Sounds better?

Thanks,

Colin
