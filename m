Date: Thu, 26 Oct 2017 17:27:34 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171026062734.GH12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <1508986436-31966-2-git-send-email-me@tobin.cc>
 <1508993843.10651.22.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508993843.10651.22.camel@perches.com>
Subject: [kernel-hardening] Re: [PATCH V8 1/2] printk: remove tabular output for NULL pointer
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Joe,

thanks for your review.

On Wed, Oct 25, 2017 at 09:57:23PM -0700, Joe Perches wrote:
> On Thu, 2017-10-26 at 13:53 +1100, Tobin C. Harding wrote:
> > Currently pointer() checks for a NULL pointer argument and then if so
> > attempts to print "(null)" with _some_ standard width. This width cannot
> > correctly be ascertained here because many of the printk specifiers
> > print pointers of varying widths.
> 
> I believe this is not a good change.
> Only pointers without a <foo> extension call pointer()

Sorry, I don't understand what you mean here. All the %p<foo> specifier code is
handled by pointer()?

> > Remove the attempt to print NULL pointers with a correct width.
> 
> the correct width for a %p is the default width.

It is the default width if we are printing addresses. Once we hash 64
bit address to a 32 bit identifier then we don't have a default width.

> The correct width for %p<foo> is unknown.

I agree.

If I have misunderstood you, please forgive me. I am very appreciative
of the reviews this patch is getting and the patience the list is having
with the many iterations.

thanks,
Tobin.
