Date: Wed, 4 Oct 2017 09:08:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171004090857.019a1235@gandalf.local.home>
In-Reply-To: <20171004085542.GA28247@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
	<1506816410-10230-2-git-send-email-me@tobin.cc>
	<20171004085542.GA28247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC V2 1/6] lib: vsprintf: additional
 kernel pointer filtering options
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 4 Oct 2017 10:55:42 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Oct 01, 2017 at 11:06:45AM +1100, Tobin C. Harding wrote:
> > Add the kptr_restrict setting of 3 which results in both
> > %p and %pK values being replaced by zeros.
> > 
> > Add an additional %pP value inspired by the Grsecurity
> > option which explicitly whitelists pointers for output.
> > 
> > Amend scripts/checkpatch.pl to handle %pP.
> > 
> > This patch is based on work by William Roberts
> > <william.c.roberts@intel.com>
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>  
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg,

I'm curious to why you are adding a "Signed-off-by"? That usually means
that you either help author it, or it is going through your tree. I've
never seen a "Signed-off-by" in passing. That's usually a "Acked-by" or
"Reviewed-by".

In other words, I was told that a "Signed-off-by" should never be added
by anyone but the one who writes it. The original author adds it to the
patch they send, and the maintainer adds it when they pull in that
patch. But sending out a "Signed-off-by" like this, to be added, would
require someone else writing it for you. Which I was told was a no-no.

-- Steve
