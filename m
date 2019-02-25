Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
 <20190221052435.GF11758@eros.localdomain>
 <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
 <8f002798-f68b-14cd-d321-f96b653fb51d@rasmusvillemoes.dk>
 <CAGXu5j+4ia0OLHop81D8D4eSJV6765hr-m=3LPeL2490ER++Hg@mail.gmail.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <39f5b81f-16b3-19d6-86b5-cc2ab6bc45ea@rasmusvillemoes.dk>
Date: Mon, 25 Feb 2019 16:41:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+4ia0OLHop81D8D4eSJV6765hr-m=3LPeL2490ER++Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jann Horn <jannh@google.com>, "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 22/02/2019 00.03, Kees Cook wrote:
> On Thu, Feb 21, 2019 at 6:58 AM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>>
>> On 21/02/2019 07.02, Kees Cook wrote:
>>
> 
>>> ... snprintf returns what it WOULD have written, much like strlcpy
>>> above. At least snprintf has an excuse: it can be used to calculate an
>>> allocation size (called with a NULL dest and 0 size) ... but shouldn't
>>> "how big is this format string going to be?" be a separate function?
>>
>> Why? Sure, you can make a wrapper vhowmuch(const char *fmt, va_args ap),
>> but its implementation would have to be "return vsnprintf(NULL, 0, fmt,
>> ap);", since we really must reuse the exact same logic for computing the
>> length as for doing the actual printf'ing (otherwise they'd get out of
>> sync).
> 
> Well, I'd likely go the opposite directly: make snprintf() a wrapper
> and call vhowmuch(), etc, convert until snprintf could be removed.But
> really the best might be removal of snprintf first, then refactor it
> with vhowmuch() etc. Lots of ways to solve it, I suppose.

I'd really like to see how vsprintf.c would look in a world where the
workhorse (which is vsnprintf() and its tree of helpers) would not
format and measure at the same time.

But dropping
> the unfriendly API would be nice.
> 
>> Please no. snprintf() is standardized, has sane semantics (though one
> 
> No, it doesn't -- it has well-defined semantics, 

We'll just have to disagree on what sane means.

> but using it
> correctly is too hard. It's a regular source of bugs. (Not *nearly* as
> bad as strncpy, so let's stick to dropping one bad API at a time...)
> 
>> sometimes _want_ scnprintf semantics - in which case one can and should
>> use that...), and, importantly, gcc understands those semantics. So we
>> get optimizations and diagnostics that we'd miss if we kill off explicit
>> snprintf and replace with non-standard howmuch+scnprintf.
> 
> Those diagnostics can be had with the __printf() markings already...

No. You're thinking of the type-checking things. Those are important, of
course, but have nothing at all to do with the s or n parts of snprintf
- what I'm thinking of is the fact that gcc knows that buf is a
char-buffer of length len into which snprintf() may/will write, so we
have the Wformat-truncation and Warray-bounds kind of warnings. And the
optimization part is where gcc can replace a snprintf() with a simpler
string op (e.g. a memcpy), or know that an overflow check can be elided
because "%d" does fit in the buf[16], or...

One thing I've had on my wishlist for a long time is a
buffer_size(ptrarg, expr, r/w/rw) attribute that would say that the
function treats the pointer argument ptrarg as a buffer of size given by
the expr (in bytes), and accesses it according to the third parameter.
Then the compiler could automatically check with its builtin_objsize
machinery for mismatched buffer size computations (e.g., using sizeof()
when the interface expects ARRAY_SIZE()) violations or uninitialized
reads, or any number of optional run-time instrumentations in caller or
callee... So

memcpy(void *dst, const void *src, size_t len) __buffer_size(dst, len,
"w") __buffer_size(src, len, "r")

or

int poll(struct pollfd *fds, nfds_t nfds, int timeout)
__buffer_size(fds, nfds*sizeof(struct pollfd), "rw")

the latter being an example of where an arbitrary expression in terms of
the formal parameters is needed - but I don't think gcc's attribute
machinery supports this syntax at all.

Bonus points if one could attach buffer_size to a struct definition as
well, saying that the ->foo member points to ->bar*4  of storage.


Rasmus
