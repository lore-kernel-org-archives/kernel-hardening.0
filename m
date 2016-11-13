Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 13 Nov 2016 12:03:34 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161113110334.GF8388@kroah.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161110235714.GR3568@worktop.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 12:57:14AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
> > On Thu, Nov 10, 2016 at 2:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Thu, Nov 10, 2016 at 10:13:10PM +0100, Peter Zijlstra wrote:
> 
> > >> As it stands kref is a pointless wrapper. If it were to provide
> > >> something actually useful, like wrap protection, then it might actually
> > >> make sense to use it.
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

No, it's an abstraction that shows what you are trying to have the
driver code do (drop a reference), and is simple to track and verify
that the driver is doing stuff properly (automated tools can do it too).

It's also easier to review and audit, if I see a developer use a kref, I
know how to easily read the code to verify it works correctly.  If they
use a "raw" atomic, I need to spend more time and effort to review that
they got it all correctly (always test the same way, call the correct
function the same way, handle the lock that needs to be somewhere
involved here, etc.)

So it saves both new developers time and effort (how do I write a
reference count properly...) and experienced developers (easy to audit
and read), which is why we have kref in the first place.

I'm all for having it use a wrap-free type, if possible, to catch these
types of errors, and yes, you are right in that it would only take 3
functions to implement it correctly.  I'd love to have it, but please,
don't say that krefs are pointless, they aren't.

thanks,

greg k-h
