Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2016 11:12:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161219101243.GB3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
 <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Liljestrand Hans <ishkamiel@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 19, 2016 at 07:55:15AM +0000, Reshetova, Elena wrote:
> Well, again, you are right in theory, but in practice for example for struct sched_group { atomic_t ref; ... }:
> 
> http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178
> 
> To me this is a refcounter that needs the protection.

Only if you have more than UINT_MAX CPUs or something like that.

And if you really really want to use refcount_t there, you could +1 the
scheme and it'd work again.

One could also split the refcount and initialized state and avoid the
problem that way.
