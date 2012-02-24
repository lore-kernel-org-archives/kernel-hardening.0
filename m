Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Feb 2012 11:41:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20120224194150.GE24120@kroah.com>
References: <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
 <20120217233908.GA24047@dztty>
 <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
 <20120218161849.GA4176@kroah.com>
 <CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
 <20120224183726.GB23284@kroah.com>
 <20120224185825.GA11818@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224185825.GA11818@albatros>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Windsor <dwindsor@gmail.com>, Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2012 at 10:58:25PM +0400, Vasiliy Kulikov wrote:
> On Fri, Feb 24, 2012 at 10:37 -0800, Greg KH wrote:
> > On Fri, Feb 24, 2012 at 12:58:35PM -0500, David Windsor wrote:
> > >  static inline void kref_get(struct kref *kref)
> > >  {
> > > +   int rc = 0;
> > >     WARN_ON(!atomic_read(&kref->refcount));
> > > -   atomic_inc(&kref->refcount);
> > > +   smp_mb__before_atomic_inc();
> > > +   rc = atomic_add_unless(&kref->refcount, 1, INT_MAX);
> > > +   smp_mb__after_atomic_inc();
> > > +   BUG_ON(!rc);
> > 
> > So you are guaranteeing to crash a machine here if this fails?  And you
> > were trying to say this is a "security" based fix?
> > 
> > And people wonder why I no longer have any hair...
> 
> If a refcounter overflows there is NO WAY to recover.  The choise is to BUG()
> and not allow any security harm to the system (privilege escalation, etc.)
> or to try to do some more CPU cycles until actual use after free, privilege
> escalation, etc.  The former is a _guarantee_ that nothing bad (in security
> sense) doesn't happen.  The latter is an opportunistic approach, which
> doesn't work with security.

The only way you could legimitaly get a real use-after-free problem if
you were overflowing the reference counter and pegged it at the max
value, was if you had code that could decrement the reference count as
many times as you incremented it.  So far, all bugs we've seen are
one-off where on an error path, we forgot to decrement the count.  So
how could the decrement ever happen?

> Do you claim that a refcounter overflow is a recoverable state?  I'd want to
> know what you can do with it.

I'm not saying it is a "recoverable" state, but to crash the machine is
not acceptable.  At the very least, let the user know something went
wrong, and stick around long enough to let them know and do something,
before shutting the thing down.

But before people start micro-engineering this whole thing, remember,
I'm still not sold on this type of change at all.

greg k-h

p.s. Has anyone ever tried an endless open() loop on a sysfs file to see
     what happens today?...
