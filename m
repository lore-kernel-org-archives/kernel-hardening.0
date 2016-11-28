Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 28 Nov 2016 13:44:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161128124440.GK3174@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161128121347.GY3092@twins.programming.kicks-ass.net>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, aik@ozlabs.ru, david@gibson.dropbear.id.au
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 28, 2016 at 01:13:47PM +0100, Peter Zijlstra wrote:
> On Mon, Nov 28, 2016 at 11:56:17AM +0000, Reshetova, Elena wrote:
> > -    if (atomic_cmpxchg(&p->refcnt, 0, -1) == 0) {..} (typical for networking code)
> 
> That's really weird, a refcount of -1 doesn't really make sense.

I looked at the one in inetpeer.c, and I think we can simply do +1 on
the entire refcount scheme and it'll work.

There is no dec_and_test anywhere, the only one doing deletion is that
GC. If that were to do dec_if_one(), then lookup_rcu() can do the normal
inc_not_zero().
