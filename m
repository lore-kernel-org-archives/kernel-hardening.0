MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-2-tobin@kernel.org>
 <CAHp75VfP_gyx_+8XKhyJMShooPubpR2KJ7gvzu0Mbv3+TaFTxg@mail.gmail.com> <20190219215526.GC16094@eros.localdomain>
In-Reply-To: <20190219215526.GC16094@eros.localdomain>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 20 Feb 2019 12:49:06 +0200
Message-ID: <CAHp75VeW34Me+pPUgixfhZU036fEmHBkJ6igkeHPr4hN=rhF7g@mail.gmail.com>
Subject: Re: [PATCH 1/6] lib/string: Enable string selftesting
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 11:55 PM Tobin C. Harding <me@tobin.cc> wrote:
> On Tue, Feb 19, 2019 at 12:55:09PM +0200, Andy Shevchenko wrote:
> > On Tue, Feb 19, 2019 at 4:44 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > >
> > > Currently we have a test module but it is not tied into the kselftest
> > > infrastructure.  In preparation for adding string manipulation functions
> > > and testing we should enable kselftest to utilize the test module.

> > > +       default n
> >
> > Redundant
>
> Cool, thanks.

> > > +       If unsure, say N.
>
> Does that mean that this is redundant too?

It's usual pattern in many help summaries, I don't know what way is better.

-- 
With Best Regards,
Andy Shevchenko
