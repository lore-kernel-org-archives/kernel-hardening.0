Date: Wed, 20 Feb 2019 08:55:26 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 1/6] lib/string: Enable string selftesting
Message-ID: <20190219215526.GC16094@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-2-tobin@kernel.org>
 <CAHp75VfP_gyx_+8XKhyJMShooPubpR2KJ7gvzu0Mbv3+TaFTxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfP_gyx_+8XKhyJMShooPubpR2KJ7gvzu0Mbv3+TaFTxg@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 12:55:09PM +0200, Andy Shevchenko wrote:
> On Tue, Feb 19, 2019 at 4:44 AM Tobin C. Harding <tobin@kernel.org> wrote:
> >
> > Currently we have a test module but it is not tied into the kselftest
> > infrastructure.  In preparation for adding string manipulation functions
> > and testing we should enable kselftest to utilize the test module.
> >
> > Enable string testing via kselftest infrastructure.
> >
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  lib/Kconfig.debug                     | 14 ++++++++++++++
> >  lib/Makefile                          |  2 +-
> >  lib/test_string.c                     |  4 ++--
> >  tools/testing/selftests/lib/Makefile  |  2 +-
> >  tools/testing/selftests/lib/config    |  1 +
> >  tools/testing/selftests/lib/string.sh | 19 +++++++++++++++++++
> >  6 files changed, 38 insertions(+), 4 deletions(-)
> >  create mode 100755 tools/testing/selftests/lib/string.sh
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index d4df5b24d75e..0dca64c1d8a4 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -1802,8 +1802,22 @@ config ASYNC_RAID6_TEST
> >  config TEST_HEXDUMP
> >         tristate "Test functions located in the hexdump module at runtime"
> >
> > +config TEST_STRING
> > +       tristate "Perform selftest on string manipulation functions"
> 
> > +       default n
> 
> Redundant

Cool, thanks.

> > +       help
> > +        Enable this option to test string manipulation functions.
> > +       Currently this only tests memset_{16,32,64}.
> > +
> > +       If unsure, say N.

Does that mean that this is redundant too?


thanks,
Tobin.
