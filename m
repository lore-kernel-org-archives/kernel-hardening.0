Date: Fri, 5 May 2017 22:00:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506050022.GA11385@kroah.com>
References: <20170506040641.GA32707@kroah.com>
 <20170506040747.GF32707@kroah.com>
 <1494045760.31950.21.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494045760.31950.21.camel@perches.com>
Subject: [kernel-hardening] Re: [RFC 5/6] lib: vsprintf: Add "%paP", "%padP" options
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 05, 2017 at 09:42:40PM -0700, Joe Perches wrote:
> On Fri, 2017-05-05 at 21:07 -0700, Greg KH wrote:
> > From: Chris Fries <cfries@google.com>
> > 
> > Add %paP and %padP for physical address that need to always be shown
> > regardless of kptr restrictions.
> 
> The commit message could be improved.

Good point, I'll work on that, thanks.

> I had to look at the actual code to see if %papP was supported.
> 
> > diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> []
> > @@ -82,18 +82,20 @@ Struct Resources:
> >  
> >  Physical addresses types phys_addr_t:
> >  
> > -	%pa[p]	0x01234567 or 0x0123456789abcdef
> > +	%pa[p][P] 0x01234567 or 0x0123456789abcdef
> 
> Well, that's good.
> 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1394,23 +1394,29 @@ static noinline_for_stack
> >  char *address_val(char *buf, char *end, const void *addr, const char *fmt)
> >  {
> >  	unsigned long long num;
> > +	int cleanse = kptr_restrict_cleanse_addresses();
> 
> bool

I'll change this, thanks.

greg k-h
