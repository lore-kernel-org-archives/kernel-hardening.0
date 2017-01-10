Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 Jan 2017 15:58:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170110145829.GB5680@worktop>
References: <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
 <20161219101243.GB3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C22713@IRSMSX102.ger.corp.intel.com>
 <20161220094152.GK3124@twins.programming.kicks-ass.net>
 <1482231302.28665.56.camel@cs-046.org.aalto.fi>
 <20161220131345.GM3124@twins.programming.kicks-ass.net>
 <1482247208.28665.121.camel@cs-046.org.aalto.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482247208.28665.121.camel@cs-046.org.aalto.fi>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Liljestrand Hans <ishkamiel@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 20, 2016 at 05:20:08PM +0200, Liljestrand Hans wrote:
> fs/inode.c:813                  find_inode_fast
> 
> This seems to be doing a search for freed up objects that are then
> reused, maybe. Not sure if we can guarantee the refcount is 0, nor if it
> would be appropriate to use refcount_set even if we could?

This one is actually quite difficult. I'll try and poke at it some.
