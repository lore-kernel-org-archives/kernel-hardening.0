Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 16 Nov 2016 18:32:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161116173243.GX3142@twins.programming.kicks-ass.net>
References: <20161110233835.GA23164@kroah.com>
 <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
 <1479228602.4622.64.camel@redhat.com>
 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
 <1479316156.21171.30.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479316156.21171.30.camel@redhat.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Rik van Riel <riel@redhat.com>
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 16, 2016 at 12:09:16PM -0500, Rik van Riel wrote:
> On Tue, 2016-11-15 at 09:23 -0800, Kees Cook wrote:

> > Right, but it's the continuing atomic_t use that concerns me...
> 
> Can we remove inc_not_zero and dec_and_test functionality
> from the atomic_t macros?
> 
> It would require fixing all of the in tree code, and after
> that people with out of tree code would have to switch to
> refcount_t to make their code work again.

People will just use (atomic_add_return(-1, &refcount) == 0) instead, or
any other variant along those lines.

And the inc_not_zero() users are typically more advanced, since that
almost always implies them using RCU.
