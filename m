Date: Fri, 22 Dec 2017 09:04:18 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171221220418.GG6618@eros>
References: <1513718237-24140-1-git-send-email-me@tobin.cc>
 <20171221122141.10604612@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221122141.10604612@lwn.net>
Subject: [kernel-hardening] Re: [PATCH v4 0/3] doc: update printk documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 21, 2017 at 12:21:41PM -0700, Jonathan Corbet wrote:
> On Wed, 20 Dec 2017 08:17:14 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > This set converts printk-formats.txt -> core-api/printk-formats.rst
> > 
> > We also update the documentation around printing kernel addresses.
> > 
> > This is my first documentation conversion. Please do be hard on this
> > patch series. I'd like to get it _really_ correct so that future
> > conversions will require less review effort. Also if there are any
> > peculiarities to patching docs (as apposed to C files) please say so.
> > 
> > Thank you for the time already given to reviewing previous versions.
> 
> So I spent a while thinking hard about how I could make Tobin do another
> round or two on these patches.  But then I figure that it's the holidays,
> and I should just apply them.  So that's done.  Thanks for all of your
> work on this!

Oh ok, I would have been happy to drag it over the holiday period and
get it super correct. I'm always chasing perfection (even if seemingly a
long way from it ;) so please never feel you have to rush things
through. I'm happy to learn how to do it correctly and that will save
everyone time in the future.

> That said...

I am happy also to patch on top of what was applied after Christmas
break :) I don't want to create any extra work for anyone else.

>  - I don't quite understand why you capitalize "kernel" everywhere.  I
>    vaguely recall some sort of discussion on that.  To me it looks
>    strange...oh well.

Ok, I'm going to go with 'kernel' everywhere from now on. Despite having
two degrees I am particularly crap at English [grammar]. Please do pick
me up on any mistakes no matter how trivial. That is the only way to
learn IMO.

>  - There's a dangling reference to printk-formats.txt in lib/vsprintf.c
>    that we'll want to fix up.

Bad Tobin, no biscuit.

>  - The vsprintf kerneldoc currently gets pulled into the big "kernel API"
>    dumpster.  Someday, it would be nice to turn printk-formats.rst into a
>    "how to output data from the kernel" section, with documentation on
>    vnsprintf, printk, trace_printk, and format strings all in one place.
>    What a fine day that would be...

I don't quite understand this yet. (I added to my kernel list of things
to learn and work on ;)

thanks Jon. Merry Christmas,
Tobin.
