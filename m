MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
 <20190221052435.GF11758@eros.localdomain> <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
 <8f002798-f68b-14cd-d321-f96b653fb51d@rasmusvillemoes.dk>
In-Reply-To: <8f002798-f68b-14cd-d321-f96b653fb51d@rasmusvillemoes.dk>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 15:03:16 -0800
Message-ID: <CAGXu5j+4ia0OLHop81D8D4eSJV6765hr-m=3LPeL2490ER++Hg@mail.gmail.com>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Content-Type: text/plain; charset="UTF-8"
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jann Horn <jannh@google.com>, "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 6:58 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> On 21/02/2019 07.02, Kees Cook wrote:
>
> > P.S. Here's C string API Rant (I just had to get this out, please feel
> > free to ignore):
>
> I'll bite. First, it's "linux kernel string API", only some of string.h
> interfaces are in std C. Sure, none of those satisfy all use cases, but
> adding Yet Another One also has its costs.

Well, yes, strscpy and scnprintf appear to be only in the kernel (did
the originate externally somewhere I'm not aware of?)

> > strcpy returns dest ... which is already known, so it's a meaningless
> > return value.
> >
> > strncpy returns dest (still meaningless)
>
> Yeah, same for memcpy, memset. Those are classic C interfaces. It does
> allow some micro-optimizations in some cases - since one is likely to

Right, yes, but this level of optimization is best left to the
compiler. There's much more interesting results a caller should care
about. :)

> > strlcpy returns strlen(src) ... the length we WOULD have copied. Why
> > would we care about that? I'm operating on dest. Were there callers
> > that needed to both copy part of src and learn how long it was at the
> > same time?
>
> The rationale is exactly the same as for snprintf - to allow you to

Okay, but there's as separate function for that: strlen().

> > strscpy returns -E2BIG or non-NUL bytes copied: yay, a return about
> > what actually happened from the operation!
>
> Well, strictly speaking, strlcpy()'s return value also tells you exactly
> what happened, just not in the kernel "negative errno for error
> condition" style.

True, yes, but it's unfriendly: it requires careful math, just like
snprintf, which depends on rechecking the args, making sure you're not
doing an off-by-one from the NUL, etc etc.

> > ... snprintf returns what it WOULD have written, much like strlcpy
> > above. At least snprintf has an excuse: it can be used to calculate an
> > allocation size (called with a NULL dest and 0 size) ... but shouldn't
> > "how big is this format string going to be?" be a separate function?
>
> Why? Sure, you can make a wrapper vhowmuch(const char *fmt, va_args ap),
> but its implementation would have to be "return vsnprintf(NULL, 0, fmt,
> ap);", since we really must reuse the exact same logic for computing the
> length as for doing the actual printf'ing (otherwise they'd get out of
> sync).

Well, I'd likely go the opposite directly: make snprintf() a wrapper
and call vhowmuch(), etc, convert until snprintf could be removed. But
really the best might be removal of snprintf first, then refactor it
with vhowmuch() etc. Lots of ways to solve it, I suppose. But dropping
the unfriendly API would be nice.

> Please no. snprintf() is standardized, has sane semantics (though one

No, it doesn't -- it has well-defined semantics, but using it
correctly is too hard. It's a regular source of bugs. (Not *nearly* as
bad as strncpy, so let's stick to dropping one bad API at a time...)

> sometimes _want_ scnprintf semantics - in which case one can and should
> use that...), and, importantly, gcc understands those semantics. So we
> get optimizations and diagnostics that we'd miss if we kill off explicit
> snprintf and replace with non-standard howmuch+scnprintf.

Those diagnostics can be had with the __printf() markings already...

> > So scnprintf() does the right thing (count of non-NUL bytes copied out).
>
> The right thing, when that's the thing you want to know. Which it is in
> the "build a string in a buffer by repeated printf calls, perhaps
> intermixed with a little flow control logic". But not so in a "format
> this stuff to this fixed-size char buffer inside that struct, and let me
> know [i.e., 'give me a way of knowing'] if it all fit".

Do we need ssprintf() to get the -E2BIG result like strscpy()?

> Hello, I'm you super-fantastic-one-size-fits-all string copying API.
> Please carefully fill out the following form, and I'll get back to you ASAP.

I mean, this is kinda what we have already. We just keep exposing too
many knobs. :)

-- 
Kees Cook
