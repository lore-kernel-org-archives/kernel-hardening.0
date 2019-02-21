Date: Thu, 21 Feb 2019 16:20:34 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 4/6] lib/string: Add string copy/zero function
Message-ID: <20190221052034.GE11758@eros.localdomain>
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

I like strscpy_pad()

> Not a blocker, just a TODO: we need a wrapper to do
> CONFIG_FORTIFY_SOURCE checking for strscpy() (and strscpy_zeroed()) to
> check for __builtin_object_size() vs the "size" argument, as done in
> strlcpy() in include/linux/string.h

I'll look into this for v2

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
>     return written;
> 
> > +
> > +       if (written < count)
> > +               memset(dest + written, 0, count - written);
> 
> Now we know written must be [0, count - 2], so we can just:
> 
> memset(dest + written + 1, 0, count - written - 1);
> 
> The pattern (which should be added to the seltest) is:
> 
> count           source  written                                 pad@
> 0               *       -E2BIG (0 char, 0 NUL, 0 to zero)
> 
> 1               "a"     -E2BIG (0 char, 1 NUL, 0 to zero)
> 1               ""      0 (0 char, 1 NUL, 0 to zero)
> 
> 2               "ab"    -E2BIG (1 char, 1 NUL, 0 to zero)
> 2               "a"     1 (1 char, 1 NUL, 0 to zero)
> 2               ""      0 (0 char, 1 NUL, 1 to zero)            dest + 1
> 
> 3               "abc"   -E2BIG (2 char, 1 NUL, 0 to zero)
> 3               "ab"    2 (2 char, 1 NUL, 0 to zero)
> 3               "a"     1 (1 char, 1 NUL, 1 to zero)            dest + 2
> 3               ""      0 (0 char, 1 NUL, 2 to zero)            dest + 1
> 
> 4               "abcd"  -E2BIG (3 char, 1 NUL, 0 to zero)
> 4               "abc"   3 (3 char, 1 NUL, 0 to zero)
> 4               "ab"    2 (2 char, 1 NUL, 1 to zero)            dest + 3
> 4               "a"     1 (1 char, 1 NUL, 2 to zero)            dest + 2
> 4               ""      0 (0 char, 1 NUL, 3 to zero)            dest + 1

So thorough, you're the man.

> > +
> > +       return written;
> > +}
> > +EXPORT_SYMBOL(strscpy_zeroed);
> > +
> >  #ifndef __HAVE_ARCH_STRCAT
> >  /**
> >   * strcat - Append one %NUL-terminated string to another
> > diff --git a/lib/test_string.c b/lib/test_string.c
> > index a9cba442389a..cc4eef51a395 100644
> > --- a/lib/test_string.c
> > +++ b/lib/test_string.c
> > @@ -111,6 +111,32 @@ static __init int memset64_selftest(void)
> >         return 0;
> >  }
> >
> > +static __init int strscpy_zeroed_selftest(void)
> > +{
> > +       char buf[6];
> > +       int written;
> > +
> > +       memset(buf, 'a', sizeof(buf));
> > +
> > +       written = strscpy_zeroed(buf, "bb", 4);
> > +       if (written != 2)
> > +               return 1;
> > +
> > +       /* Copied correctly */
> > +       if (buf[0] != 'b' || buf[1] != 'b')
> > +               return 2;
> > +
> > +       /* Zeroed correctly */
> > +       if (buf[2] != '\0' || buf[3] != '\0')
> > +               return 3;
> > +
> > +       /* Only touched what it was supposed to */
> > +       if (buf[4] != 'a' || buf[5] != 'a')
> > +               return 4;
> > +
> > +       return 0;
> > +}
> 
> Cool, I like both the positive and negative tests. :) Can you add all
> the cases above, too, which should validate the various corners?

Sure thing.

> > +
> >  static __init int test_string_init(void)
> >  {
> >         int test, subtest;
> > @@ -130,6 +156,11 @@ static __init int test_string_init(void)
> >         if (subtest)
> >                 goto fail;
> >
> > +       test = 4;
> > +       subtest = strscpy_zeroed_selftest();
> > +       if (subtest)
> > +               goto fail;
> > +
> >         pr_info("String selftests succeeded\n");
> >         return 0;
> >  fail:
> > --
> > 2.20.1
> >
> 
> Nice! :)

Cheers.  And they said we don't test in kernel land :)

	Tobin
