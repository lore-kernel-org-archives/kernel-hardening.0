Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Nov 2016 11:16:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161117101642.GG3142@twins.programming.kicks-ass.net>
References: <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
 <1479228602.4622.64.camel@redhat.com>
 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
 <1479316156.21171.30.camel@redhat.com>
 <2236FBA76BA1254E88B949DDB74E612B41C1196C@IRSMSX102.ger.corp.intel.com>
 <20161117083718.GA3142@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1611171035480.2913@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1611171035480.2913@hadrien>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Rik van Riel <riel@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 17, 2016 at 10:36:47AM +0100, Julia Lawall wrote:
> 
> 
> On Thu, 17 Nov 2016, Peter Zijlstra wrote:
> 
> > On Wed, Nov 16, 2016 at 05:34:48PM +0000, Reshetova, Elena wrote:
> >
> > > I have a coccinelle rule now that found about 15 usages of it.
> >
> > Right, so can coccinelle detect the call_rcu/free call that is
> > conditional on the dec_and_test when its hidden inside a few function
> > calls?
> >
> > Also, we should really have a "make spatch" target so that we can run
> > the thing concurrently with -j80 or somesuch, because as is coccinelle
> > is unbearably slow.
> 
> In the kernel, there is already the make coccicheck infrastructure.  It
> suffices to add the semantic patch to a subdirectory of
> scripts/coccinelle.

Shiny.. however:

$ make coccicheck COCCI=kref.cocci MODE=patch V=1
/bin/bash ./scripts/coccicheck

Please check for false positives in the output before submitting a patch.
When using "patch" mode, carefully review the patch before submitting it.

Processing kref.cocci
with option(s) ""

Message example to submit a patch:
 The semantic patch that makes this change is available
 in kref.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Running (8 in parallel): /usr/bin/spatch -D patch --very-quiet --cocci-file kref.cocci --dir . -I ./arch/x86/include -I ./arch/x86/include/generated/uapi -I ./arch/x86/include/generated -I ./include -I ./arch/x86/include/uapi -I ./include/uapi -I ./include/generated/uapi --include ./include/linux/kconfig.h --jobs 8 --chunksize 1
coccicheck failed


No joy :-(
