Date: Wed, 20 Feb 2019 08:52:45 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Message-ID: <20190219215245.GA16094@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 01:51:45AM +0100, Jann Horn wrote:
> +cc Andy because he's also preparing a patch for this function
> 
> On Tue, Feb 19, 2019 at 12:25 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > Current function documentation for strncpy_from_user() is incorrect.  If
> > @count (size of destination buffer) is less than the length of the user
> > string the function does _not_ return @count but rather returns -EFAULT.
> >
> > Document correctly the function return value, also add note that string
> > may be left non-null terminated.
> >
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  lib/strncpy_from_user.c | 17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> >
> > diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> > index 58eacd41526c..11fe9a4a00fd 100644
> > --- a/lib/strncpy_from_user.c
> > +++ b/lib/strncpy_from_user.c
> > @@ -82,22 +82,19 @@ static inline long do_strncpy_from_user(char *dst, const char __user *src, long
> >  }
> >
> >  /**
> > - * strncpy_from_user: - Copy a NUL terminated string from userspace.
> > + * strncpy_from_user() - Copy a NUL terminated string from userspace.
> >   * @dst:   Destination address, in kernel space.  This buffer must be at
> >   *         least @count bytes long.
> >   * @src:   Source address, in user space.
> > - * @count: Maximum number of bytes to copy, including the trailing NUL.
> > + * @count: Maximum number of bytes to copy, including the trailing %NUL.
> >   *
> >   * Copies a NUL-terminated string from userspace to kernel space.
> >   *
> > - * On success, returns the length of the string (not including the trailing
> > - * NUL).
> > - *
> > - * If access to userspace fails, returns -EFAULT (some data may have been
> > - * copied).
> > - *
> > - * If @count is smaller than the length of the string, copies @count bytes
> > - * and returns @count.
> > + * Return: If access to userspace fails, returns -EFAULT.  Otherwise,
> > + *         return the number of characters copied excluding the trailing
> > + *         %NUL, if the length of the user string exceeds @count return
> > + *         -EFAULT (in which case @dst will be left without a %NUL
> > + *         terminator).
> >   */
> 
> AFAICS the byte_at_a_time loop exits when max==0 is reached, and then
> if `res >= count` (in other words, if we've copied as many bytes as
> requested, haven't encountered a null byte so far, and haven't reached
> the end of the address space), we return `res`, which is the same as
> `count`. Are you sure?

Thanks for the review Jaan.  Seems I was in a world of confused, I
misread count to be the size of the destination buffer not the size of
the source string.

Also, re-reading strscpy() and why its better I think I may not be the
correct person to implement strscpy_from_user() since I'm not across all
the subtleties.

If v2 seems wanted for the first patches in this set I'll drop the
*_from_user() stuff.

thanks,
Tobin.
