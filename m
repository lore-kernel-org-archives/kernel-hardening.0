Reply-To: kernel-hardening@lists.openwall.com
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <20160226225706.GA11672@kroah.com>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org> <CAGXu5jKgOwPivXh=eWpX4zuEVd6MfEtJNbh7nwRjitnfNP7_Sw@mail.gmail.com>
In-Reply-To: <CAGXu5jKgOwPivXh=eWpX4zuEVd6MfEtJNbh7nwRjitnfNP7_Sw@mail.gmail.com>
Date: Fri, 26 Feb 2016 22:57:07 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2 0/3] LKDTM use after free test updates
To: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@fedoraproject.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 26, 2016 at 01:39:14PM -0800, Kees Cook wrote:
> On Thu, Feb 25, 2016 at 4:36 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
> > Hi,
> >
> > This is v2 of the LKDTM test update. This is mostly taking the updates
> > Kees gave for the previous series and bringing it in.
> >
> > Laura Abbott (3):
> >   lkdtm: Add READ_AFTER_FREE test
> >   lkdtm: Update WRITE_AFTER_FREE test
> >   lkdtm: Add read/write after free tests for buddy memory
> >
> >  drivers/misc/lkdtm.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 95 insertions(+), 3 deletions(-)
> 
> Thanks!
> 
> Please consider the series:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> And, say, while we're at it... Greg, would you mind if I became the
> lkdtm maintainer?

Not at all, I was treating you as one anyway, waiting till I got acks
from you before committing anything :)

Feel free to send a patch to MAINTAINERS for me to add for this.

thanks,

greg k-h
