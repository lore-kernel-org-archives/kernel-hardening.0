Date: Tue, 26 Feb 2019 08:37:03 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2 1/1] lib/string: Add strscpy_pad() function
Message-ID: <20190225213703.GC5177@eros.localdomain>
References: <20190225041534.27186-1-tobin@kernel.org>
 <20190225041534.27186-2-tobin@kernel.org>
 <CAHp75Vfq5KQupcyx_84YcSOQ8mvNDvFE3R20KdyLEqEz74p3OQ@mail.gmail.com>
 <20190225213109.GB5177@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225213109.GB5177@eros.localdomain>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 26, 2019 at 08:31:09AM +1100, Tobin C. Harding wrote:
> On Mon, Feb 25, 2019 at 10:19:47AM +0200, Andy Shevchenko wrote:
> > On Mon, Feb 25, 2019 at 6:17 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > >
> > > We have a function to copy strings safely and we have a function to copy
> > > strings and zero the tail of the destination (if source string is
> > > shorter than destination buffer) but we do not have a function to do
> > > both at once.  This means developers must write this themselves if they
> > > desire this functionality.  This is a chore, and also leaves us open to
> > > off by one errors unnecessarily.
> > >
> > > Add a function that calls strscpy() then memset()s the tail to zero if
> > > the source string is shorter than the destination buffer.
> > >
> > > Add test module for the new code.
> > 
> > > --- /dev/null
> > > +++ b/lib/test_strscpy.c
> > > @@ -0,0 +1,175 @@
> > 
> > > +// SPDX-License-Identifier: GPL-2.0
> > 
> > > +MODULE_LICENSE("GPL");
> > 
> > License mismatch.
> 
> Thanks, will re-spin with 
> 
>   // SPDX-License-Identifier: GPL-2.0+
> 
> > Do we need a separate module for this test?
> 
> Separate as in not in lib/test_string.h?  I intend on moving the test
> into that file once I've done some cleanup in tools/testing/selftest/lib/
> 
> I also tried to do this without using a module using
> tools/testing/selftest/kselftest_harness.h but I could not get the
> compiler to see read the patched version of
> linux/include/linux/string.h?
> 
> Related question if you feel like answering it; why are test modules for
> lib/ in lib/ and not in tools/testing/?
> 
> Very much open to suggestions on current best practices for kernel testing.

I just read Andy mirskFrom: "Tobin C. Harding" <me@tobin.cc>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Bcc: 
Subject: Re: [PATCH v2 1/1] lib/string: Add strscpy_pad() function
Reply-To: 
In-Reply-To: <20190225213109.GB5177@eros.localdomain>
X-Mailer: Mutt 1.11.3 (2019-02-01)

On Tue, Feb 26, 2019 at 08:31:09AM +1100, Tobin C. Harding wrote:
> On Mon, Feb 25, 2019 at 10:19:47AM +0200, Andy Shevchenko wrote:
> > On Mon, Feb 25, 2019 at 6:17 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > >
> > > We have a function to copy strings safely and we have a function to copy
> > > strings and zero the tail of the destination (if source string is
> > > shorter than destination buffer) but we do not have a function to do
> > > both at once.  This means developers must write this themselves if they
> > > desire this functionality.  This is a chore, and also leaves us open to
> > > off by one errors unnecessarily.
> > >
> > > Add a function that calls strscpy() then memset()s the tail to zero if
> > > the source string is shorter than the destination buffer.
> > >
> > > Add test module for the new code.
> > 
> > > --- /dev/null
> > > +++ b/lib/test_strscpy.c
> > > @@ -0,0 +1,175 @@
> > 
> > > +// SPDX-License-Identifier: GPL-2.0
> > 
> > > +MODULE_LICENSE("GPL");
> > 
> > License mismatch.
> 
> Thanks, will re-spin with 
> 
>   // SPDX-License-Identifier: GPL-2.0+
> 
> > Do we need a separate module for this test?
> 
> Separate as in not in lib/test_string.h?  I intend on moving the test
> into that file once I've done some cleanup in tools/testing/selftest/lib/
> 
> I also tried to do this without using a module using
> tools/testing/selftest/kselftest_harness.h but I could not get the
> compiler to see read the patched version of
> linux/include/linux/string.h?
> 
> Related question if you feel like answering it; why are test modules for
> lib/ in lib/ and not in tools/testing/?
> 
> Very much open to suggestions on current best practices for kernel testing.

I just read Andy mirskFrom: "Tobin C. Harding" <me@tobin.cc>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Bcc: 
Subject: Re: [PATCH v2 1/1] lib/string: Add strscpy_pad() function
Reply-To: 
In-Reply-To: <20190225213109.GB5177@eros.localdomain>
X-Mailer: Mutt 1.11.3 (2019-02-01)

On Tue, Feb 26, 2019 at 08:31:09AM +1100, Tobin C. Harding wrote:
> On Mon, Feb 25, 2019 at 10:19:47AM +0200, Andy Shevchenko wrote:
> > On Mon, Feb 25, 2019 at 6:17 AM Tobin C. Harding <tobin@kernel.org> wrote:
> > >
> > > We have a function to copy strings safely and we have a function to copy
> > > strings and zero the tail of the destination (if source string is
> > > shorter than destination buffer) but we do not have a function to do
> > > both at once.  This means developers must write this themselves if they
> > > desire this functionality.  This is a chore, and also leaves us open to
> > > off by one errors unnecessarily.
> > >
> > > Add a function that calls strscpy() then memset()s the tail to zero if
> > > the source string is shorter than the destination buffer.
> > >
> > > Add test module for the new code.
> > 
> > > --- /dev/null
> > > +++ b/lib/test_strscpy.c
> > > @@ -0,0 +1,175 @@
> > 
> > > +// SPDX-License-Identifier: GPL-2.0
> > 
> > > +MODULE_LICENSE("GPL");
> > 
> > License mismatch.
> 
> Thanks, will re-spin with 
> 
>   // SPDX-License-Identifier: GPL-2.0+
> 
> > Do we need a separate module for this test?
> 
> Separate as in not in lib/test_string.h?  I intend on moving the test
> into that file once I've done some cleanup in tools/testing/selftest/lib/
> 
> I also tried to do this without using a module using
> tools/testing/selftest/kselftest_harness.h but I could not get the
> compiler to see read the patched version of
> linux/include/linux/string.h?
> 
> Related question if you feel like answering it; why are test modules for
> lib/ in lib/ and not in tools/testing/?
> 
> Very much open to suggestions on current best practices for kernel testing.

I just read Andy Lutomirski's patch

       [PATCH 2/2] uaccess: Add a selftest for strncpy_from_user()

That's a better approach for this one also, right?  Put the test in
string.c and ifdef guard it with a config option.

thanks,
Tobin.
