MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CACXcFmkdMbn6xHnJvwtkPJQ0ZSUUK26-9DB+V0oq6Sj6U+gMTA@mail.gmail.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
 <20170620093642.3ri6dct5qkf7vhuc@thunk.org> <CAH8yC8nD3kn1DZVzvruvq3tMZ=JLED_9RWkfRGUWgsNx-gBKCQ@mail.gmail.com>
 <CACXcFmkdMbn6xHnJvwtkPJQ0ZSUUK26-9DB+V0oq6Sj6U+gMTA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 11:14:37 -0700
Message-ID: <CAGXu5j+PQ1unqbJa6hh9OMxBx3+sKUmfycjFAb1FFH0e5C0FtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH] random: silence compiler warnings
 and fix race
To: Sandy Harris <sandyinchina@gmail.com>
Cc: Jeffrey Walton <noloader@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 10:50 AM, Sandy Harris <sandyinchina@gmail.com> wrote:
> On Tue, Jun 20, 2017 at 5:49 AM, Jeffrey Walton <noloader@gmail.com> wrote:
>> On Tue, Jun 20, 2017 at 5:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> On Tue, Jun 20, 2017 at 10:53:35AM +0200, Jason A. Donenfeld wrote:
>
>>>> > Suppressing all messages for all configurations cast a wider net than
>>>> > necessary. Configurations that could potentially be detected and fixed
>>>> > likely will go unnoticed. If the problem is not brought to light, then
>>>> > it won't be fixed.
>
>> Are there compelling reasons a single dmesg warning cannot be provided?
>>
>> A single message avoids spamming the logs. It also informs the system
>> owner of the problem. An individual or organization can then take
>> action based on their risk posture. Finally, it avoids the kernel
>> making policy decisions for a user or organization.
>
> I'd say the best solution is to have no configuration option
> specifically for these messages. Always give some, but let
> DEBUG_KERNEL control how many.
>
> If DEBUG_KERNEL is not set, emit exactly one message & ignore any
> other errors of this type. On some systems, that message may have to
> be ignored, on some it might start an incremental process where one
> problem gets fixed only to have another crop up & on some it might
> prompt the admin to explore further by compiling with DEBUG_KERNEL.
>
> If DEBUG_KERNEL is set, emit a message for every error of this type.

How about doing this:

   default DEBUG_KERNEL

Most distro kernel select DEBUG_KERNEL because it unhides a bunch of
other useful configs. Since it doesn't strictly _depend_ on
DEBUG_KERNEL, I think it's probably a mistake to enforce a false
dependency. Using it as a hint for the default seems maybe like a good
middle ground. (And if people can't agree on that, then I guess
"default n"...)

-Kees

-- 
Kees Cook
Pixel Security
