Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160226225706.GA11672@kroah.com>
References: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jKgOwPivXh=eWpX4zuEVd6MfEtJNbh7nwRjitnfNP7_Sw@mail.gmail.com>
	<20160226225706.GA11672@kroah.com>
Date: Fri, 26 Feb 2016 14:57:38 -0800
Message-ID: <CAGXu5j+c-yo3v8tHqK9Wn7L5dw6qk3PM1=At4CKhYsc-kvPLgg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 0/3] LKDTM use after free test updates
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@fedoraproject.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 26, 2016 at 2:57 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Feb 26, 2016 at 01:39:14PM -0800, Kees Cook wrote:
>> On Thu, Feb 25, 2016 at 4:36 PM, Laura Abbott <labbott@fedoraproject.org> wrote:
>> > Hi,
>> >
>> > This is v2 of the LKDTM test update. This is mostly taking the updates
>> > Kees gave for the previous series and bringing it in.
>> >
>> > Laura Abbott (3):
>> >   lkdtm: Add READ_AFTER_FREE test
>> >   lkdtm: Update WRITE_AFTER_FREE test
>> >   lkdtm: Add read/write after free tests for buddy memory
>> >
>> >  drivers/misc/lkdtm.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>> >  1 file changed, 95 insertions(+), 3 deletions(-)
>>
>> Thanks!
>>
>> Please consider the series:
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>>
>> And, say, while we're at it... Greg, would you mind if I became the
>> lkdtm maintainer?
>
> Not at all, I was treating you as one anyway, waiting till I got acks
> from you before committing anything :)
>
> Feel free to send a patch to MAINTAINERS for me to add for this.

Sounds good, thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
