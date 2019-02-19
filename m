Date: Wed, 20 Feb 2019 08:53:45 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 6/6] lib: Add function strscpy_from_user()
Message-ID: <20190219215345.GB16094@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-7-tobin@kernel.org>
 <CAG48ez1n=+GsvhMxHhxL=EBxD6VEqopdLRPcEAff9vrP3+a30g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1n=+GsvhMxHhxL=EBxD6VEqopdLRPcEAff9vrP3+a30g@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 03:12:33AM +0100, Jann Horn wrote:
> On Tue, Feb 19, 2019 at 12:25 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > Currently we have strncpy_from_userspace().  If the user string is
> > longer than the destination kernel buffer we get an error code -EFAULT.
> > We are unable to recover from here because this is the same error
> > returned if the access to userspace fails totally.
> >
> > There is no reason we cannot continue execution with the user string
> > truncated.
> >
> > Add a function strscpy_from_user() that guarantees the string written is
> > null-terminated.  If user string is longer than destination buffer
> > truncates the string.  Returns the number of characters written
> > excluding the null-terminator.
> >
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  lib/strncpy_from_user.c | 43 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 43 insertions(+)
> >
> > diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> > index 11fe9a4a00fd..6bd603ccec7a 100644
> > --- a/lib/strncpy_from_user.c
> > +++ b/lib/strncpy_from_user.c
> 
> This file is only built when CONFIG_GENERIC_STRNCPY_FROM_USER is set.
> Some architectures have their own versions of strncpy_from_user() and
> don't set that, so on those architectures, your code wouldn't be built
> into the kernel.

thanks!  Dropping *_from_user() stuff from set.

	Tobin
