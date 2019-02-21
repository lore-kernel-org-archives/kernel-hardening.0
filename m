Date: Thu, 21 Feb 2019 16:15:00 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 0/6] lib: Add safe string funtions
Message-ID: <20190221051500.GB11758@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <CAGXu5j+gHMCjxMr3k0UNBcsT6DYuALtpROxazf7YVX=SUja_cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+gHMCjxMr3k0UNBcsT6DYuALtpROxazf7YVX=SUja_cQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 03:31:07PM -0800, Kees Cook wrote:
> On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
> > During your talk at LCA you mentioned that we could do with a couple
> > more safe string functions.  One to zero the tail of the destination
> > buffer after call to strscpy() and also the self explanatory
> > strscpy_from_user().
> 
> Thanks for jumping in with this! :)

Good to be working with you again.

> > I couldn't work out if this is a false positive or not?  Does the new
> > config option CONFIG_TEST_STRING need more documentation?  I don't see
> > where extra docs should be added and it seems self explanatory as is.
> 
> Usually this just means the help string in Kconfig is "too short".
> Sometimes this is a false positive -- really up to you if you think it
> needs more. :)

Cool, thanks.
