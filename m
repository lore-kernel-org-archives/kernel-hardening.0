Date: Fri, 22 Dec 2017 08:59:26 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171221215926.GF6618@eros>
References: <1513718237-24140-1-git-send-email-me@tobin.cc>
 <20171221122141.10604612@lwn.net>
 <427c0072-8bdc-82a6-2efb-d43c22ee8eb1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427c0072-8bdc-82a6-2efb-d43c22ee8eb1@infradead.org>
Subject: [kernel-hardening] Re: [PATCH v4 0/3] doc: update printk documentation
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 21, 2017 at 11:26:22AM -0800, Randy Dunlap wrote:
> On 12/21/2017 11:21 AM, Jonathan Corbet wrote:
> > On Wed, 20 Dec 2017 08:17:14 +1100
> > "Tobin C. Harding" <me@tobin.cc> wrote:
> > 
> >> This set converts printk-formats.txt -> core-api/printk-formats.rst
> >>
> >> We also update the documentation around printing kernel addresses.
> >>
> >> This is my first documentation conversion. Please do be hard on this
> >> patch series. I'd like to get it _really_ correct so that future
> >> conversions will require less review effort. Also if there are any
> >> peculiarities to patching docs (as apposed to C files) please say so.
> >>
> >> Thank you for the time already given to reviewing previous versions.
> > 
> > So I spent a while thinking hard about how I could make Tobin do another
> > round or two on these patches.  But then I figure that it's the holidays,
> > and I should just apply them.  So that's done.  Thanks for all of your
> > work on this!
> > 
> > That said...
> > 
> >  - I don't quite understand why you capitalize "kernel" everywhere.  I
> >    vaguely recall some sort of discussion on that.  To me it looks
> >    strange...oh well.
> 
> Mauro explained that he capitalizes Kernel when it is being used as a
> shortened version of "the Linux kernel," i.e., as a proper name,
> so I think that Tobin appropriated that style.
> 
> It would be OK to undo that IMO.

I'm happy to write it however, if everyone is happy with 'kernel'
everywhere then that is good (and easier). I think Mauro is correct but
I also think Jon is correct, it does look funny. Code language doesn't
always follow English grammar rules after all.

thanks,
Tobin.
