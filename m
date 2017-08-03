MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJJ4FY1BZrA6X2zKe92oJfcGBXqZr6OMx+4mXX34psrKg@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
 <CAGXu5j+FDprZBxBKPoBV0mw_oAEG+6Rh-8QNBcniVPxVTQ5gaQ@mail.gmail.com> <CAGXu5jJJ4FY1BZrA6X2zKe92oJfcGBXqZr6OMx+4mXX34psrKg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 2 Aug 2017 21:35:04 -0700
Message-ID: <CAGXu5jL2TobMXH_UXasHCC2GrGrie7GOYn_J_=E23Qn_J66Ziw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 6, 2017 at 4:16 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 6, 2017 at 2:44 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jul 6, 2017 at 4:09 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> To prevent leaking stack contents in cases where it is not possible
>>>> for the compiler to figure out whether an automatic variable has been
>>>> initialized or not, add a plugin that forcibly initializes all automat=
ic
>>>> variables of struct/union types if their address is taken at any point=
.
>>>>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> Ard, I'd be curious what you see for "size" difference between builds
>> and if it's visible with hackbench or other things?
>
> Hm, not all that bad on the size front:
>
>    text                 data            bss                 dec
>             hex filename
> 10950705        5592525 13955072        30498302        1d15dfe vmlinux
> 11048035        5592365 13955072        30595472        1d2d990
> vmlinux.initautobyref
>
> And yes, as expected, wow there are a lot of notices in verbose mode. ;)
>
> My pet favorite, from the NAKed patch I sent forever ago, is covered
> (as expected):
>
> net/socket.c: In function =E2=80=98SYSC_getsockname=E2=80=99:
> net/socket.c:1605:26: note: auto variable will be forcibly initialized
>   struct sockaddr_storage address;
>                           ^~~~~~~

While this was an RFC, it seems to work well and, as Daniel mentioned,
provides another benchmark for future optimizations of this kind of
protection. Besides the COMPILE_TEST change already discussed, any
other changes or objections before I carry this in -next?

-Kees

--=20
Kees Cook
Pixel Security
