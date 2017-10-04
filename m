Date: Wed, 4 Oct 2017 14:42:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004124233.GA19372@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <20171004085850.GH28247@kroah.com>
 <20171004105051.GE16685@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004105051.GE16685@eros>
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 04, 2017 at 09:50:51PM +1100, Tobin C. Harding wrote:
> On Wed, Oct 04, 2017 at 10:58:50AM +0200, Greg KH wrote:
> > On Sun, Oct 01, 2017 at 11:06:44AM +1100, Tobin C. Harding wrote:
> > > Version 2 of Greg's patch series with changes made as suggested by comments to V1.
> > > 
> > > Applies on top of Linus' current development tree
> > > 
> > > a8c964eacb21288b2dbfa9d80cee5968a3b8fb21
> > > 
> > > V1 cover letter:
> > > 
> > > Here's a short patch series from Chris Fries and Dave Weinstein that
> > > implements some new restrictions when printing out kernel pointers, as
> > > well as the ability to whitelist kernel pointers where needed.
> > > 
> > > These patches are based on work from William Roberts, and also are
> > > inspired by grsecurity's %pP to specifically whitelist a kernel pointer,
> > > where it is always needed, like the last patch in the series shows, in
> > > the UIO drivers (UIO requires that you know the address, it's a hardware
> > > address, nothing wrong with seeing that...)
> > > 
> > > I haven't done much to this patch series, only forward porting it from
> > > an older kernel release (4.4) and a few minor tweaks. [snip]
> > 
> > Nice!  Thanks for doing this work, looks great to me.  Care to resend
> > the next version as a "real" one (i.e. no RFC)?
> 
> First thing tomorrow!
> 
> Is correct protocol for me to add your Signed-off-by tag to each patch from this RFC? Or is the
> protocol for you to add the tag yourself when the real version is posted? 

You can add my signed-off-by to your new patches, they shouldn't change
much with the exception of:

> I intend splitting one of the patches into two as suggested by Will.

And that's fine to keep my s-o-b for.

thanks for asking,

greg k-h
