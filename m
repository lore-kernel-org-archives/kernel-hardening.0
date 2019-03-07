MIME-Version: 1.0
References: <20190306214226.14598-1-tobin@kernel.org> <20190306214934.GA16461@eros.localdomain>
 <20190307211858.GA28495@eros.localdomain>
In-Reply-To: <20190307211858.GA28495@eros.localdomain>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 7 Mar 2019 14:43:57 -0800
Message-ID: <CAGXu5jLdCQ0QtCdbbfE+=JccZk01aSdV_5dWVj6g8X-dKpOr8Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] lib/string: Add strscpy_pad() function
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 7, 2019 at 1:19 PM Tobin C. Harding <me@tobin.cc> wrote:
>
> On Thu, Mar 07, 2019 at 08:49:34AM +1100, Tobin C. Harding wrote:
> > On Thu, Mar 07, 2019 at 08:42:19AM +1100, Tobin C. Harding wrote:
> > > Hi,
> >
> > Man, I didn't see the merge window was open, I thought rc8 only came out
> > on Sunday.
> >
> > Sorry, please ignore this.  Will re-send again later in the cycle.
>
> Multiple people have suggested to me (offlist) that it is fine to go
> right ahead and send patches whenever.
>
> Shuah, do you take patches to kselftest at any stage of the dev cycle?
>
> Kees, same question please?

I don't official "close" my tree, but I'm certainly less likely to
respond in a timeline manner near the merge window. ;) (And as a
result, I haven't had a chance to look these over yet.)

-- 
Kees Cook
