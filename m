MIME-Version: 1.0
In-Reply-To: <CAGXu5j+_AwCDAqbNsH-nEZM3NhSq8jU1BbRZQJ041aab9nrF+g@mail.gmail.com>
References: <CAJ2oMhLanOniQHJ79LkwGB8ctaJKKc73+iGmnvo5RX4x1PHpsA@mail.gmail.com>
 <CAGXu5j+_AwCDAqbNsH-nEZM3NhSq8jU1BbRZQJ041aab9nrF+g@mail.gmail.com>
From: Ran Shalit <ranshalit@gmail.com>
Date: Sun, 20 Aug 2017 09:53:00 +0300
Message-ID: <CAJ2oMh+XPRDu_+VxZ1+thNnSpz9S1GXjNvng8+mWDH3GxZfu1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] hardening mmc driver
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 18, 2017 at 11:44 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Aug 17, 2017 at 10:57 PM, Ran Shalit <ranshalit@gmail.com> wrote:
>> Hello,
>
> Hi!
>
>> What action should be taken to make mmc driver secured ?
>>
>> If there any wiki or document, which can help to understand better
>> when a driver (like mmc)  is considered secured ?
>
> I don't have any specific pointers at the moment, but I think the main
> focus for drivers (or really any software) is being extremely careful
> with data processing and the validation of command arguments. Never
> assume the commands you're getting will follow an expected protocol:
> pretend the device at the other end of the bus (or the bus itself!) is
> trying to attack the driver. Same for any commands coming from
> userspace.
>
> Are there particular things you're concerned about for MMC security?
>

Hello Kees,

Thank you very much for your feedback.
I've found an interesing article by Intel, which tried to define and
strandarize hardening of device driver.
https://software.intel.com/sites/default/files/m/d/4/1/d/8/matassa.pdf
I have no special concern now for the driver, except trying to grasp
better how to make a driver "secured".
I will follow the article guidelines and your comment at the moment.

Best Regards,
Ran




> -Kees
>
> --
> Kees Cook
> Pixel Security
