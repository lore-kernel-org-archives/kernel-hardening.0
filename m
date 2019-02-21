Date: Thu, 21 Feb 2019 16:17:36 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 2/6] lib/string: Fix erroneous 'overflow' documentation
Message-ID: <20190221051736.GD11758@eros.localdomain>
References: <20190218232308.11241-1-tobin@kernel.org>
 <20190218232308.11241-3-tobin@kernel.org>
 <CAGXu5jJcf8S3vS5d7B9oC2V7F6Gjbeu5vUCQiAFXTzeXcrno0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJcf8S3vS5d7B9oC2V7F6Gjbeu5vUCQiAFXTzeXcrno0w@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 04:02:37PM -0800, Kees Cook wrote:
> On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
> >
> > Current documentation uses 'overflow' to describe a situation where less
> > data is written to a buffer than buffer size not more.  'overflow' is
> > the wrong word here - since we don't typically say 'underflow' change
> > the whole sentence.
> >
> > Fix erroneous 'overflow' documentation for under filled buffer.
> >
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  lib/string.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/string.c b/lib/string.c
> > index 38e4ca08e757..7f1d72db53c5 100644
> > --- a/lib/string.c
> > +++ b/lib/string.c
> > @@ -173,8 +173,8 @@ EXPORT_SYMBOL(strlcpy);
> >   *
> >   * Preferred to strncpy() since it always returns a valid string, and
> >   * doesn't unnecessarily force the tail of the destination buffer to be
> > - * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy()
> > - * with an overflow test, then just memset() the tail of the dest buffer.
> > + * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
> > + * check the return size, then just memset() the tail of the dest buffer.
> >   */
> 
> I'd just fold this patch into the strscpy_zeroed() patch. No need for
> a kind of "no op" change here when we'll just change it again with a
> better advice ("use strscpy_zeroed()!")

Got it.

thanks,
Tobin.
