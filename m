Date: Wed, 18 Oct 2017 17:04:06 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171018060406.GA28753@eros>
References: <1508300515-28824-1-git-send-email-me@tobin.cc>
 <20171018054431.GA597@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171018054431.GA597@jagdpanzerIV>
Subject: [kernel-hardening] Re: [PATCH v4] printk: hash addresses printed with %p
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 02:44:31PM +0900, Sergey Senozhatsky wrote:
> On (10/18/17 15:21), Tobin C. Harding wrote:
> [..]
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index 86c3385b9eb3..4609738cd2cd 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -33,6 +33,8 @@
> >  #include <linux/uuid.h>
> >  #include <linux/of.h>
> >  #include <net/addrconf.h>
> > +#include <linux/siphash.h>
> > +#include <linux/spinlock.h>
> >  #ifdef CONFIG_BLOCK
> >  #include <linux/blkdev.h>
> >  #endif
> > @@ -1591,6 +1593,70 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
> >  	return widen_string(buf, buf - buf_start, end, spec);
> >  }
> >  
> > +/* protects ptr_secret and have_key */
> > +DEFINE_SPINLOCK(key_lock);
> > +static siphash_key_t ptr_secret __read_mostly;
> > +static atomic_t have_key = ATOMIC_INIT(0);
> > +
> > +static int initialize_ptr_secret(void)
> > +{
> > +	spin_lock(&key_lock);
> > +	if (atomic_read(&have_key) == 1)
> > +		goto unlock;
> > +
> > +	get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> > +	atomic_set(&have_key, 1);
> > +
> > +unlock:
> > +	spin_unlock(&key_lock);
> > +	return 0;
> > +}
> 
> is this spinlock legal? what happens if we are getting interrupted by NMI?

I think we can do without the spinlock. I think I was already told that when
I tried to put it [some where else] in v1.

It's fun failing in public ;)

> printk()
>  vprintk_emit()
>   vscnprintf()
>    pointer()
>     ptr_to_id()
>      initialize_ptr_secret()
>       spin_lock(&key_lock)
> 
> ----> NMI
> 
>       printk()
>        printk_safe_log_store()
>         vscnprintf()
>          pointer()
>           ptr_to_id()
>            initialize_ptr_secret()
>             spin_lock(&key_lock)   <<<<
> 
> 
> or am I completely misreading the patch? sorry if so.
> 
> 	-ss

thanks,
Tobin.
