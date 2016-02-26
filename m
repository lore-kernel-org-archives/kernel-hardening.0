Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
Date: Fri, 26 Feb 2016 13:39:14 -0800
Message-ID: <CAGXu5jKgOwPivXh=eWpX4zuEVd6MfEtJNbh7nwRjitnfNP7_Sw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 0/3] LKDTM use after free test updates
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@fedoraproject.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 25, 2016 at 4:36 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
> Hi,
>
> This is v2 of the LKDTM test update. This is mostly taking the updates
> Kees gave for the previous series and bringing it in.
>
> Laura Abbott (3):
>   lkdtm: Add READ_AFTER_FREE test
>   lkdtm: Update WRITE_AFTER_FREE test
>   lkdtm: Add read/write after free tests for buddy memory
>
>  drivers/misc/lkdtm.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 95 insertions(+), 3 deletions(-)

Thanks!

Please consider the series:

Acked-by: Kees Cook <keescook@chromium.org>

And, say, while we're at it... Greg, would you mind if I became the
lkdtm maintainer?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
