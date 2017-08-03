MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu_AiynfdBVvm6fbFX8sRi7ZwWGFGG9rUhoVCP0Bc-EaZg@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
 <CAGXu5j+FDprZBxBKPoBV0mw_oAEG+6Rh-8QNBcniVPxVTQ5gaQ@mail.gmail.com>
 <CAGXu5jJJ4FY1BZrA6X2zKe92oJfcGBXqZr6OMx+4mXX34psrKg@mail.gmail.com>
 <CAGXu5jL2TobMXH_UXasHCC2GrGrie7GOYn_J_=E23Qn_J66Ziw@mail.gmail.com> <CAKv+Gu_AiynfdBVvm6fbFX8sRi7ZwWGFGG9rUhoVCP0Bc-EaZg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Aug 2017 15:14:45 -0700
Message-ID: <CAGXu5j+3EEeVqS7ZpBb=Gp-ex1Rjcyku7OZx3qm6pOmemY04iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 3, 2017 at 11:27 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 3 August 2017 at 05:35, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jul 6, 2017 at 4:16 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Thu, Jul 6, 2017 at 2:44 PM, Kees Cook <keescook@chromium.org> wrote=
:
>>>> On Thu, Jul 6, 2017 at 4:09 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
>>>>> <ard.biesheuvel@linaro.org> wrote:
>>>>>> To prevent leaking stack contents in cases where it is not possible
>>>>>> for the compiler to figure out whether an automatic variable has bee=
n
>>>>>> initialized or not, add a plugin that forcibly initializes all autom=
atic
>>>>>> variables of struct/union types if their address is taken at any poi=
nt.
>>>>>>
>>>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>>
>>>> Ard, I'd be curious what you see for "size" difference between builds
>>>> and if it's visible with hackbench or other things?
>>>
>>> Hm, not all that bad on the size front:
>>>
>>>    text                 data            bss                 dec
>>>             hex filename
>>> 10950705        5592525 13955072        30498302        1d15dfe vmlinux
>>> 11048035        5592365 13955072        30595472        1d2d990
>>> vmlinux.initautobyref
>>>
>>> And yes, as expected, wow there are a lot of notices in verbose mode. ;=
)
>>>
>>> My pet favorite, from the NAKed patch I sent forever ago, is covered
>>> (as expected):
>>>
>>> net/socket.c: In function =E2=80=98SYSC_getsockname=E2=80=99:
>>> net/socket.c:1605:26: note: auto variable will be forcibly initialized
>>>   struct sockaddr_storage address;
>>>                           ^~~~~~~
>>
>> While this was an RFC, it seems to work well and, as Daniel mentioned,
>> provides another benchmark for future optimizations of this kind of
>> protection. Besides the COMPILE_TEST change already discussed, any
>> other changes or objections before I carry this in -next?
>>
>
> Sounds reasonable to me.

Actually, I just looked at the diff between structleak and
initautobyref, and it's essentially 1 test (and the removal of all the
__user-detection code):

-               /* if the type is of interest, examine the variable */
-               if (TYPE_USERSPACE(type))
+               /* initialize the variable if its address is taken */
+               if (TREE_ADDRESSABLE (var))

Perhaps instead of a whole new plugin, could we just add the
functionality to the existing structleak plugin as a Kconfig option?
Like maybe CONFIG_GCC_PLUGIN_STRUCTLEAK_TAKEN?

-Kees

--=20
Kees Cook
Pixel Security
