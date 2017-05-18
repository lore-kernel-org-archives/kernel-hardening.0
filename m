Date: Thu, 18 May 2017 16:13:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170518141323.GD23654@kroah.com>
References: <20170506040641.GA32707@kroah.com>
 <20170511013737.GD801@jagdpanzerIV.localdomain>
 <476DC76E7D1DF2438D32BFADF679FC563362B030@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC563362B030@ORSMSX103.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [RFC 00/06] printk: add more new kernel pointer filter options.
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 16, 2017 at 09:36:37PM +0000, Roberts, William C wrote:
> 
> 
> > -----Original Message-----
> > From: Sergey Senozhatsky [mailto:sergey.senozhatsky.work@gmail.com]
> > Sent: Wednesday, May 10, 2017 6:38 PM
> > To: Greg KH <gregkh@linuxfoundation.org>
> > Cc: kernel-hardening@lists.openwall.com; Petr Mladek <pmladek@suse.com>;
> > Sergey Senozhatsky <sergey.senozhatsky@gmail.com>; linux-
> > kernel@vger.kernel.org; Catalin Marinas <catalin.marinas@arm.com>; Will
> > Deacon <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Roberts, William C <william.c.roberts@intel.com>; Chris Fries
> > <cfries@google.com>; Dave Weinstein <olorin@google.com>
> > Subject: Re: [RFC 00/06] printk: add more new kernel pointer filter options.
> > 
> > Hello Greg,
> > 
> > On (05/05/17 21:06), Greg KH wrote:
> > > Here's a short patch series from Chris Fries and Dave Weinstein that
> > > implement some new restrictions when printing out kernel pointers, as
> > > well as the ability to whitelist kernel pointers where needed.
> > >
> > > These patches are based on work from William Roberts, and also is
> > > inspired by grsecurity's %pP to specifically whitelist a kernel
> > > pointer, where it is always needed, like the last patch in the series
> > > shows, in the UIO drivers (UIO requires that you know the address,
> > > it's a hardware address, nothing wrong with seeing that...)
> > >
> > > I haven't done much to this patch series, only forward porting it from
> > > an older kernel release (4.4) and a few minor tweaks.  It applies
> > > cleanly on top of 4.11 as well as Linus's current development tree
> > > (10502 patches into the 4.12-rc1 merge window).  I'm posting it now
> > > for comments if anyone sees anything wrong with this approach
> > 
> > overall, I don't see anything wrong.
> > 
> > > or thinks the things that are being whitelisted should not be?
> > 
> > can't say for sure, sorry.
> > 
> > 	-ss
> 
> I almost missed this, none of the mail was delivered to my inbox...

Why not?  Did I get the address wrong?

> Anyways, I am glad to see this revived and I don't have any
> Comments besides thanks.

Acks for the patches are always appreciated :)

I'll revise this in the next few weeks and send out a new series.

thanks,

greg k-h
