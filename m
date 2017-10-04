Date: Wed, 4 Oct 2017 15:54:47 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004135447.GA32316@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-2-git-send-email-me@tobin.cc>
 <20171004085542.GA28247@kroah.com>
 <20171004090857.019a1235@gandalf.local.home>
 <20171004132650.GA30219@kroah.com>
 <20171004092908.6c4b679b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004092908.6c4b679b@gandalf.local.home>
Subject: Re: [kernel-hardening] [RFC V2 1/6] lib: vsprintf: additional kernel
 pointer filtering options
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 04, 2017 at 09:29:08AM -0400, Steven Rostedt wrote:
> On Wed, 4 Oct 2017 15:26:50 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> 
> > > I'm curious to why you are adding a "Signed-off-by"? That usually means
> > > that you either help author it, or it is going through your tree. I've
> > > never seen a "Signed-off-by" in passing. That's usually a "Acked-by" or
> > > "Reviewed-by".  
> > 
> > I did help author it :)
> > 
> > Hope that helps,
> 
> Ah! Than than makes a huge difference. I just didn't see anything in
> the change log that suggested that you did.

It's hard to show that, I know others on the cc: helped author it as
well, it's a complex patchset that has gone through many different
authors over many months.  Hopefully Tobin will be the one to finally
finish it up and get it merged.

thanks,

greg k-h
