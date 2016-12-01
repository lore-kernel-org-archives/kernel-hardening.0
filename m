Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 1 Dec 2016 20:15:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161201191543.GG3124@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 29, 2016 at 03:35:15PM +0000, Reshetova, Elena wrote:
> but Hans will be finishing processing 

> > > The following functions are also needed quite commonly:
> > 
> > > refcount_inc_return()
> > > refcount_dec_return()
> > 
> > What for? They don't typicaly make sense for refcounting? Other than the
> > trivial pattern of dec_return() == 0, which is already well covered.

Hans, could you point me to a few users of {inc,dec}_return() that I can
audit for (in)sanity?
