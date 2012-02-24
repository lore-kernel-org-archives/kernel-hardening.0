Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Feb 2012 14:35:57 -0500
From: Nick Bowler <nbowler@elliptictech.com>
Message-ID: <20120224193557.GB8140@elliptictech.com>
References: <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
 <20120217233908.GA24047@dztty>
 <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
 <20120218161849.GA4176@kroah.com>
 <CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
 <20120224183726.GB23284@kroah.com>
 <CAGXu5jJGQgDSueZeZfSAVoSJLPEybmE_7csQA8dK4T0GwDe-Dg@mail.gmail.com>
 <20120224190549.GA8034@elliptictech.com>
 <20120224191300.GA12553@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120224191300.GA12553@albatros>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dwindsor@gmail.com>, Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, kernel-hardening@lists.openwall.com, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 2012-02-24 23:13 +0400, Vasiliy Kulikov wrote:
> On Fri, Feb 24, 2012 at 14:05 -0500, Nick Bowler wrote:
> > On 2012-02-24 10:52 -0800, Kees Cook wrote:
> > > On Fri, Feb 24, 2012 at 10:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Fri, Feb 24, 2012 at 12:58:35PM -0500, David Windsor wrote:
> > [...]
> > > >> diff --git a/include/linux/kref.h b/include/linux/kref.h
> > > >> index 9c07dce..fc0756a 100644
> > > >> --- a/include/linux/kref.h
> > > >> +++ b/include/linux/kref.h
> > > >> @@ -38,8 +38,12 @@ static inline void kref_init(struct kref *kref)
> > > >>   */
> > > >>  static inline void kref_get(struct kref *kref)
> > > >>  {
> > > >> +   int rc = 0;
> > > >>     WARN_ON(!atomic_read(&kref->refcount));
> > > >> -   atomic_inc(&kref->refcount);
> > > >> +   smp_mb__before_atomic_inc();
> > > >> +   rc = atomic_add_unless(&kref->refcount, 1, INT_MAX);
> > > >> +   smp_mb__after_atomic_inc();
> > > >> +   BUG_ON(!rc);
> > > >
> > > > So you are guaranteeing to crash a machine here if this fails?  And you
> > > > were trying to say this is a "security" based fix?
> > > 
> > > This is the same principle as the stack protector. When something has
> > > gone horribly wrong and cannot be sensibly recovered from, crash the
> > > machine. Wrapping the refcount would cause all kinds of problems, so
> > > that certainly seems worthy of a BUG().
> > 
> > But in this case, the principle does not apply because we can recover.
> > The reason we cannot recover from the stack protector case is because
> > the stack protector is reacting after the fact, which is not the case
> > here.  Simply peg the reference count at the maximum value, neither
> > incrementing it nor decrementing it further.
> 
> ...and simply loose one reference, which leads to use-after-free.

Please explain how a use-after-free could possibly occur if the
reference count is never incremented or decremented again?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
