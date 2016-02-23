Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56CCD677.1316.1C5E89E6@pageexec.freemail.hu>
References: <20160216214904.GA23723@www.outflux.net>
	<56CB97EE.29381.17824260@pageexec.freemail.hu>
	<CAGXu5jLhZMMS_StwD_2yDPoF1tL1OwfBrfo3n217RYnrHkwMww@mail.gmail.com>
	<56CCD677.1316.1C5E89E6@pageexec.freemail.hu>
Date: Tue, 23 Feb 2016 14:02:54 -0800
Message-ID: <CAGXu5jJpULmVV_XneyhB8zpNgY-cKk-mtHL9v_veAbgU7gOZGw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: PaX Team <pageexec@freemail.hu>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 23, 2016 at 2:00 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 23 Feb 2016 at 12:53, Kees Cook wrote:
>
>> I prefer using all the "regular" mechanisms so that I really know I'm
>> exercising the actual case I want to be testing. (i.e. I don't want to
>> bypass the linker.)
>>
>> If only there were some way to filter gcc output, like with plugins. ;)
>
> plugins can set/override section flags, initify and constify both do in
> fact but i guess that's little help for your generic case that has to
> work without them as well.

I don't mind using a plugin to get the linker to see the right flags. :)

I'm hoping someone will take pity on me in the kbuild list.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
