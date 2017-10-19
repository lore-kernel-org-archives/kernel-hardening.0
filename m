Date: Thu, 19 Oct 2017 09:00:44 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Message-ID: <20171019000044.GA604@jagdpanzerIV>
References: <1508300515-28824-1-git-send-email-me@tobin.cc>
 <20171018054431.GA597@jagdpanzerIV>
 <20171018060406.GA28753@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171018060406.GA28753@eros>
Subject: [kernel-hardening] Re: [PATCH v4] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On (10/18/17 17:04), Tobin C. Harding wrote:
[..]
> > > +/* protects ptr_secret and have_key */
> > > +DEFINE_SPINLOCK(key_lock);
> > > +static siphash_key_t ptr_secret __read_mostly;
> > > +static atomic_t have_key = ATOMIC_INIT(0);
> > > +
> > > +static int initialize_ptr_secret(void)
> > > +{
> > > +	spin_lock(&key_lock);
> > > +	if (atomic_read(&have_key) == 1)
> > > +		goto unlock;
> > > +
> > > +	get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> > > +	atomic_set(&have_key, 1);
> > > +
> > > +unlock:
> > > +	spin_unlock(&key_lock);
> > > +	return 0;
> > > +}
> > 
> > is this spinlock legal? what happens if we are getting interrupted by NMI?
> 
> I think we can do without the spinlock. I think I was already told that when
> I tried to put it [some where else] in v1.
> 
> It's fun failing in public ;)

another note is that printk()->vscnprintf()->get_random_bytes()->warn_unseeded_randomness()
causes a printk() recursion, but we should be fine now, we are in printk_safe
mode by the time we vscnprintf().

but a bigger problem might the following thing:

vscnprintf()
 pointer()
  ptr_to_id()
   initialize_ptr_secret()
    get_random_bytes()
     _get_random_bytes()
      extract_crng()
       _extract_crng()
        spin_lock_irqsave(&crng->lock, flags);   <<<<<


this, once again, can deadlock. can it? just like before:

> > printk()
> >  vprintk_emit()
> >   vscnprintf()
> >    pointer()
> >     ptr_to_id()
> >      initialize_ptr_secret()
> >       spin_lock(&key_lock)
> > 
> > ----> NMI
> > 
> >       printk()
> >        printk_safe_log_store()
> >         vscnprintf()
> >          pointer()
> >           ptr_to_id()
> >            initialize_ptr_secret()
> >             spin_lock(&key_lock)   <<<<

	-ss
