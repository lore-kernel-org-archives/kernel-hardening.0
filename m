MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
 <20190221052435.GF11758@eros.localdomain> <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
 <20190222072652.2441e8a2@canb.auug.org.au>
In-Reply-To: <20190222072652.2441e8a2@canb.auug.org.au>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 15:16:14 -0800
Message-ID: <CAGXu5jLbcqDJWvn1cES3OvWMvnd3OArFKLOJMqWc=youte5Haw@mail.gmail.com>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Content-Type: text/plain; charset="UTF-8"
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jann Horn <jannh@google.com>, "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 12:27 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Kees,
>
> On Wed, 20 Feb 2019 22:02:32 -0800 Kees Cook <keescook@chromium.org> wrote:
> >
> > What I can't quite figure out yet is how to find a way for sfr to flag
> > newly added users of strcpy, strncpy, and strlcpy. We might need to
> > bring back __deprecated, but hide it behind a W=linux-next flag or
> > something crazy. Stephen, in your builds you're already injecting
> > -Wimplicit-fallthrough: do you do W=1 or anything like that? If not, I
> > think we need some W= setting for your linux-next builds that generate
> > the maintainer-nag warnings...
>
> I just have a set of compiler flags that my build scripts explicitly
> enable by setting KCFLAGS.

Okay, so you could include some -D option to enable it. I'll see if I
can cook something up.

-- 
Kees Cook
