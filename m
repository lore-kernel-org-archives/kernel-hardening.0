Date: Wed, 4 Oct 2017 09:31:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171004093147.6270557a@gandalf.local.home>
In-Reply-To: <20171004092815.71b6243c@gandalf.local.home>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
	<20171004085850.GH28247@kroah.com>
	<20171004105051.GE16685@eros>
	<20171004124233.GA19372@kroah.com>
	<20171004092815.71b6243c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


As Greg stated that he helped author the patch, you can ignore this
email. Sorry for the noise.

-- Steve

On Wed, 4 Oct 2017 09:28:15 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 4 Oct 2017 14:42:33 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > Is correct protocol for me to add your Signed-off-by tag to each patch from this RFC? Or is the
> > > protocol for you to add the tag yourself when the real version is posted?     
> > 
> > You can add my signed-off-by to your new patches,  
> 
> I was always told that one should never add someone else's
> signed-off-by, because that's not what it means. 
> 
> I was told that this would be an Acked-by or Reviewed-by.
> 
> From Documentation/process/submitting-patches.rst:
> 
> ====
> 12) When to use Acked-by: and Cc:
> ---------------------------------
> 
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path.
> 
> If a person was not directly involved in the preparation or handling of a
> patch but wishes to signify and record their approval of it then they can
> ask to have an Acked-by: line added to the patch's changelog.
> 
> Acked-by: is often used by the maintainer of the affected code when that
> maintainer neither contributed to nor forwarded the patch.
> 
> Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
> has at least reviewed the patch and has indicated acceptance.  Hence patch
> mergers will sometimes manually convert an acker's "yep, looks good to me"
> into an Acked-by: (but note that it is usually better to ask for an
> explicit ack).
> ====
> 
> -- Steve
