MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAGXu5j+FDprZBxBKPoBV0mw_oAEG+6Rh-8QNBcniVPxVTQ5gaQ@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com> <CAGXu5j+FDprZBxBKPoBV0mw_oAEG+6Rh-8QNBcniVPxVTQ5gaQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 7 Jul 2017 00:00:59 +0200
Message-ID: <CAK8P3a2otwdQvy9oXzZ_88nTwU5e1KHsYqfPDzLBiSQQ4+e_Tg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 6, 2017 at 11:44 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 6, 2017 at 4:09 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel

>> I think this should be
>>
>>       depends on GCC_PLUGIN_INITAUTOBYREF || COMPILE_TEST
>>
>> to avoid producing output in an allmodconfig build.
>
> Err, surely you mean:
>
> depends on GCC_PLUGIN_INITAUTOBYREF && !COMPILE_TEST
>
> ?

Yes, sorry for the confusion.

        Arnd
