Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 17:26:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207162618.GP3124@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
 <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <CAEXv5_ia+iR_4k0Tc-isv=q0o8QKEeJwJ0nGBptwESj7rJra3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_ia+iR_4k0Tc-isv=q0o8QKEeJwJ0nGBptwESj7rJra3g@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: David Windsor <dwindsor@gmail.com>
Cc: Liljestrand Hans <ishkamiel@gmail.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 07, 2016 at 10:59:47AM -0500, David Windsor wrote:
> On Wed, Dec 7, 2016 at 8:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> > All in all I'm not inclined to add {add,sub.inc,dec}_return() to
> > refcount, as previously stated, they don't make sense.
> 
> Is the plan now to audit all {add,sub,inc,dec}_return() call sites?
> This should probably happen anyway, due to the amount of funkiness
> uncovered by Hans' mini-audit. Then we can rewrite actual reference
> counting code that calls the unsupported {add,sub,inc,dec}_return() to
> use something else?

The ip_vs_dest cache thing would receive 2 patches, one doing the global
+1, the second conversion to refcount_t.

For BPF we'd need to talk to Alexei to see if the custom limit still
makes sense, but I'd be inclined to simply drop that in the refcount_t
conversion.

As to the tty and usb-gadget ones, those constructs are actually racy,
but I'm not sure the races matter. But I would certainly prefer to
rework then to be race-free.

But I wouldn't go so far as to audit all *_return calls, just those that
pop up while hunting refcounts.
