Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 19 Oct 2016 11:16:45 +0200
From: Greg KH <greg@kroah.com>
Message-ID: <20161019091645.GA8456@kroah.com>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-2-git-send-email-colin@cvidal.org>
 <2236FBA76BA1254E88B949DDB74E612B41BE01A7@IRSMSX102.ger.corp.intel.com>
 <20161019083110.GD6447@kroah.com>
 <1476867489.21069.19.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476867489.21069.19.camel@cvidal.org>
Subject: Re: [kernel-hardening] RE: [RFC 1/2] Reordering / guard definition
 on atomic_*_wrap function in order to avoid implicitly defined / redefined
 error on them, when CONFIG_HARDENED_ATOMIC is unset.
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 19, 2016 at 10:58:09AM +0200, Colin Vidal wrote:
> > > +#ifndef CONFIG_HARDENED_ATOMIC
> > > +#define atomic_read_wrap(v) atomic_read(v)
> > > +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> > > +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> > > +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> > > +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> > > +#define atomic_inc_wrap(v) atomic_inc(v)
> > > +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> > > +#ifndef atomic_inc_return_wrap
> > > +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> > > +#endif
> > > +#ifndef atomic_add_return_wrap
> > > +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> > > +#endif
> > > +#define atomic_dec_wrap(v) atomic_dec(v)
> > > +#ifndef atomic_xchg_wrap
> > > +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> > > +#endif
> > > +#define atomic_long_inc_wrap(v) atomic_long_inc(v)
> > > +#define atomic_long_dec_wrap(v) atomic_long_dec(v)
> > > +#define atomic_long_xchg_wrap(v, n) atomic_long_xchg(v, n)
> > > +#define atomic_long_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg(l, o, n)
> > > +#endif /* CONFIG_HARDENED_ATOMIC */
> > 
> > That doesn't look correct to me at all, does it to you?
> 
> That patch will be removed in next version since it will be not needed
> anymore (Elena's RFC will include those changes). However, I wonder
> what is obviously wrong here? (in order to avoid it in futures
> patches). Complex nested #ifdef/#ifndef?

Odd, the version I had had all of the line-ends gone, and it was wrapped
horribly, but this email shows it correctly.  email is fun...

greg k-h
