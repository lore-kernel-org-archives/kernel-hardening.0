Date: Thu, 21 Dec 2017 12:21:41 -0700
From: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20171221122141.10604612@lwn.net>
In-Reply-To: <1513718237-24140-1-git-send-email-me@tobin.cc>
References: <1513718237-24140-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v4 0/3] doc: update printk documentation
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 20 Dec 2017 08:17:14 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> This set converts printk-formats.txt -> core-api/printk-formats.rst
> 
> We also update the documentation around printing kernel addresses.
> 
> This is my first documentation conversion. Please do be hard on this
> patch series. I'd like to get it _really_ correct so that future
> conversions will require less review effort. Also if there are any
> peculiarities to patching docs (as apposed to C files) please say so.
> 
> Thank you for the time already given to reviewing previous versions.

So I spent a while thinking hard about how I could make Tobin do another
round or two on these patches.  But then I figure that it's the holidays,
and I should just apply them.  So that's done.  Thanks for all of your
work on this!

That said...

 - I don't quite understand why you capitalize "kernel" everywhere.  I
   vaguely recall some sort of discussion on that.  To me it looks
   strange...oh well.

 - There's a dangling reference to printk-formats.txt in lib/vsprintf.c
   that we'll want to fix up.

 - The vsprintf kerneldoc currently gets pulled into the big "kernel API"
   dumpster.  Someday, it would be nice to turn printk-formats.rst into a
   "how to output data from the kernel" section, with documentation on
   vnsprintf, printk, trace_printk, and format strings all in one place.
   What a fine day that would be...

Thanks again,

jon
