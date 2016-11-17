Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Nov 2016 10:36:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161117093600.GE3142@twins.programming.kicks-ass.net>
References: <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
 <1479228602.4622.64.camel@redhat.com>
 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
 <1479316156.21171.30.camel@redhat.com>
 <2236FBA76BA1254E88B949DDB74E612B41C1196C@IRSMSX102.ger.corp.intel.com>
 <20161117083718.GA3142@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C13F55@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C13F55@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Rik van Riel <riel@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 17, 2016 at 09:04:44AM +0000, Reshetova, Elena wrote:
> > I have a coccinelle rule now that found about 15 usages of it. 
> 
> >Right, so can coccinelle detect the call_rcu/free call that is
> >conditional on the dec_and_test when its hidden inside a few function
> >calls?
> 
> Yes, it can. However, I haven't expanded the rule yet to cover cases
> when "hidden inside a few function calls" goes outside of one .c or .h
> file. Coccinelle supports that, but I have to experiment fist if it
> doesn't bring more false positives that current setup. 

Sure, I can see cross translation unit being slightly more challenging
:-)

> >Also, we should really have a "make spatch" target so that we can run
> >the thing concurrently with -j80 or somesuch, because as is
> >coccinelle is unbearably slow.
> 
> The currents rules are very simple, the full run on the whole tree
> even without any pre-indexing, multithreading and etc. takes around 1
> min only.  

I tried to run something like (thanks to Thomas):


@r1@
struct kref K;
@@
-atomic_read(&K.refcount)
+kref_read(&K)

@r2@
struct kref *x;
@@
-atomic_read(&x->refcount)
+kref_read(x)

@r3@
struct kref K;
@@
-K.refcount.counter
+kref_read(&K)

@r4@
struct kref *x;
@@
-x->refcount.counter
+kref_read(x)

@@
expression K;
@@
-atomic_read(&K.refcount)
+CHECKKREF(kref_read(&K))

//@@
//expression K;
//@@
//- atomic_read(&K->refcount)
//+ CHECKBAD(kref_read(K))



using:

 spatch --in-place --sp-file kref.cocci --recursive-includes
 --include-headers -I include -I include/drm -I include/uapi
 --use-gitgrep --dir .


And that took for bloody ever, far longer than building a full bzImage.

That basically renders the thing useless in my view.

Another advantage of integrating it with make is that we get all the
right -I parameters for free.
