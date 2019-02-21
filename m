Date: Thu, 21 Feb 2019 16:24:35 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Message-ID: <20190221052435.GF11758@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 05:05:10PM -0800, Kees Cook wrote:
> On Mon, Feb 18, 2019 at 4:52 PM Jann Horn <jannh@google.com> wrote:
> > AFAICS the byte_at_a_time loop exits when max==0 is reached, and then
> > if `res >= count` (in other words, if we've copied as many bytes as
> > requested, haven't encountered a null byte so far, and haven't reached
> > the end of the address space), we return `res`, which is the same as
> > `count`. Are you sure?
> 
> Oh, whew, there is only 1 arch-specific implementation of this. I
> thought you meant there was multiple implementations.
> 
> So, generally speaking, I'd love to split all strncpy* uses into
> strscpy_zero() (when expecting to do str->str copies), and some new
> function, named like mempadstr() or str2mem() that copies a str to a
> __nonstring char array, with trailing padding, if there is space. Then
> there is no more mixing the two cases and botching things.

Oh cool, treewide changes, I'm down with that.  So to v2 I'll add
str2mem() and then attack the tree as suggested.  What could possibly go
wrong :)?

	Tobin
