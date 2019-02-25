Date: Tue, 26 Feb 2019 07:09:38 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 4/6] lib/string: Add string copy/zero function
Message-ID: <20190225200938.GA5177@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-5-tobin@kernel.org>
 <CAGXu5jJe7CiQ0aResT4Hnsuhm+grZyLTcVAkdwsBdtbdrnBbuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJe7CiQ0aResT4Hnsuhm+grZyLTcVAkdwsBdtbdrnBbuQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 04:48:18PM -0800, Kees Cook wrote:
> On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
> >
> > We have a function to copy strings safely and we have a function to copy
> > strings _and_ zero the tail of the destination (if source string is
> > shorter than destination buffer) but we do not have a function to do
> > both at once.  This means developers must write this themselves if they
> > desire this functionality.  This is a chore, and also leaves us open to
> > off by one errors unnecessarily.
> >
> > Add a function that calls strscpy() then memset()s the tail to zero if
> > the source string is shorter than the destination buffer.
> >
> > Add testing via kselftest.
> >
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  include/linux/string.h |  4 ++++
> >  lib/Kconfig.debug      |  2 +-
> >  lib/string.c           | 30 ++++++++++++++++++++++++++++--
> >  lib/test_string.c      | 31 +++++++++++++++++++++++++++++++
> >  4 files changed, 64 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/string.h b/include/linux/string.h
> > index 7927b875f80c..695a5e6a31e3 100644
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> > @@ -31,6 +31,10 @@ size_t strlcpy(char *, const char *, size_t);
> >  #ifndef __HAVE_ARCH_STRSCPY
> >  ssize_t strscpy(char *, const char *, size_t);
> >  #endif
> > +
> > +/* Wrapper function, no arch specific code required */
> > +ssize_t strscpy_zeroed(char *dest, const char *src, size_t count);
> 
> bikeshed: I think "pad" is shorter and more descriptive. How about
> something like strspad() strscpy_pad() or strscpy_zero()? (just to
> shorten it slightly)
> 
> Not a blocker, just a TODO: we need a wrapper to do
> CONFIG_FORTIFY_SOURCE checking for strscpy() (and strscpy_zeroed()) to
> check for __builtin_object_size() vs the "size" argument, as done in
> strlcpy() in include/linux/string.h
> 
> > @@ -238,6 +237,33 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
> >  EXPORT_SYMBOL(strscpy);
> >  #endif
> >
> > +/**
> > + * strscopy_zeroed() - Copy a C-string into a sized buffer
> > + * @dest: Where to copy the string to
> > + * @src: Where to copy the string from
> > + * @count: Size of destination buffer
> > + *
> > + * If the source string is shorter than the destination buffer, zeros
> > + * the tail of the destination buffer.
> > + *
> > + * Return: The number of characters copied (not including the trailing
> > + *         NUL) or -E2BIG if the destination buffer wasn't big enough.
> > + */
> > +ssize_t strscpy_zeroed(char *dest, const char *src, size_t count)
> > +{
> > +       ssize_t written;
> > +
> > +       written = strscpy(dest, src, count);
> > +       if (written < 0)
> > +               return written;
> 
> If written < 0 we filled everything (i.e. we wrote "count - 1" bytes).
> If we also exactly wrote "count - 1", then we also don't need the zero
> padding either, since strscpy wrote the trailing NUL.
> 
> so:
> 
> if (written < 0 || (count && written == count - 1))

(I meant to reply yesterday before posting v2).  At this stage we know
count >= 0 otherwise written would be less than 0.  So I removed the
'count' from the second part of this statement, leaving

  if (written < 0 || written == count - 1)

>     return written;
> 
> > +
> > +       if (written < count)
> > +               memset(dest + written, 0, count - written);

I used this :)

thanks,
Tobin.
