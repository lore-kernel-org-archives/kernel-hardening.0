Date: Wed, 3 Apr 2019 11:25:27 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v3 0/7] lib/string: Add strscpy_pad() function
Message-ID: <20190403002527.GB29296@eros.localdomain>
References: <20190306214226.14598-1-tobin@kernel.org>
 <CAGXu5jJeFOBBiofjG6_rqbf+_0fbKC46pzyfoACWt+NBg-bXtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJeFOBBiofjG6_rqbf+_0fbKC46pzyfoACWt+NBg-bXtg@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 02, 2019 at 02:37:57PM -0700, Kees Cook wrote:
> On Wed, Mar 6, 2019 at 1:43 PM Tobin C. Harding <tobin@kernel.org> wrote:
> > This set makes an attempt at adding a framework to kselftest for writing
> > kernel test modules.  It also adds a script for use in creating script
> > test runners for kselftest.  My macro-foo is not great, all criticism
> > and suggestions very much appreciated.  The design is based on test
> > modules lib/test_printf.c, lib/test_bitmap.c, lib/test_xarray.c.
> 
> Hi Shuah,
> 
> The bulk of this series is in the kselftests. Would you be willing to
> carry this series?
> 
> I think it might be able to use a v4 just to clean up the
> script-finding logic, but I might be entirely missing something about
> the best way to do it.

v4 to come once I grok the bash stuff you suggested in 'PATCH v3.1'.

thanks,
Tobin.
