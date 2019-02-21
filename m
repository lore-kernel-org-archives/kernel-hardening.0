MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-5-tobin@kernel.org>
 <CAGXu5jJe7CiQ0aResT4Hnsuhm+grZyLTcVAkdwsBdtbdrnBbuQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJe7CiQ0aResT4Hnsuhm+grZyLTcVAkdwsBdtbdrnBbuQ@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 21 Feb 2019 14:02:57 +0200
Message-ID: <CAHp75VfO0SQ41zV1r3R2h2n2eRuGJzdsgHFzK7nRj85m7Xahgw@mail.gmail.com>
Subject: Re: [PATCH 4/6] lib/string: Add string copy/zero function
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 2:49 AM Kees Cook <keescook@chromium.org> wrote:
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

> > +/* Wrapper function, no arch specific code required */
> > +ssize_t strscpy_zeroed(char *dest, const char *src, size_t count);
>
> bikeshed: I think "pad" is shorter and more descriptive. How about
> something like strspad() strscpy_pad() or strscpy_zero()? (just to
> shorten it slightly)

zero / zeroed examples in the kernel have semantics of getting some
area completely zeroed. OTOH pad means different and we have examples
as well (see seq_pad() as one).

So, I would definitely vote for _pad b/c of semantics.

-- 
With Best Regards,
Andy Shevchenko
