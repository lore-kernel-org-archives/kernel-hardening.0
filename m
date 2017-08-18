MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAJ2oMhLanOniQHJ79LkwGB8ctaJKKc73+iGmnvo5RX4x1PHpsA@mail.gmail.com>
References: <CAJ2oMhLanOniQHJ79LkwGB8ctaJKKc73+iGmnvo5RX4x1PHpsA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 18 Aug 2017 13:44:05 -0700
Message-ID: <CAGXu5j+_AwCDAqbNsH-nEZM3NhSq8jU1BbRZQJ041aab9nrF+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] hardening mmc driver
To: Ran Shalit <ranshalit@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 17, 2017 at 10:57 PM, Ran Shalit <ranshalit@gmail.com> wrote:
> Hello,

Hi!

> What action should be taken to make mmc driver secured ?
>
> If there any wiki or document, which can help to understand better
> when a driver (like mmc)  is considered secured ?

I don't have any specific pointers at the moment, but I think the main
focus for drivers (or really any software) is being extremely careful
with data processing and the validation of command arguments. Never
assume the commands you're getting will follow an expected protocol:
pretend the device at the other end of the bus (or the bus itself!) is
trying to attack the driver. Same for any commands coming from
userspace.

Are there particular things you're concerned about for MMC security?

-Kees

-- 
Kees Cook
Pixel Security
