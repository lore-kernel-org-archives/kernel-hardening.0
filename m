MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com> <CAG48ez34MMBfTzQFxj2o5brYDrUS89_gvX9=SnpWZ+TjMUV-BQ@mail.gmail.com>
In-Reply-To: <CAG48ez34MMBfTzQFxj2o5brYDrUS89_gvX9=SnpWZ+TjMUV-BQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 14:52:22 -0800
Message-ID: <CAGXu5j+da7frEM62vV+WZUTDSuNnUQCxEc7FCL01=jtqDAUb9Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 6:28 AM Jann Horn <jannh@google.com> wrote:
> On Thu, Feb 21, 2019 at 2:05 AM Kees Cook <keescook@chromium.org> wrote:
> > On Mon, Feb 18, 2019 at 4:52 PM Jann Horn <jannh@google.com> wrote:
> > > AFAICS the byte_at_a_time loop exits when max==0 is reached, and then
> > > if `res >= count` (in other words, if we've copied as many bytes as
> > > requested, haven't encountered a null byte so far, and haven't reached
> > > the end of the address space), we return `res`, which is the same as
> > > `count`. Are you sure?
> >
> > Oh, whew, there is only 1 arch-specific implementation of this. I
> > thought you meant there was multiple implementations.
>
> Not sure what you're talking about. Are you talking about
> implementations of strncpy_from_user()?

Ah, I used a bad match. But it seems it's only about half (and not
x86, arm, powerpc).

-- 
Kees Cook
