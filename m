MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org> <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Jul 2017 13:25:49 +0200
Message-ID: <CAK8P3a3Xra=9aTRAWJ8DbRRYL4J2ieMDveeV9Ahp6dE9xXqsrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 6, 2017 at 1:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> To prevent leaking stack contents in cases where it is not possible
>> for the compiler to figure out whether an automatic variable has been
>> initialized or not, add a plugin that forcibly initializes all automatic
>> variables of struct/union types if their address is taken at any point.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> If we only do this for variables that have their address taken, we miss
> a lot of cases that the compiler (both clang and gcc) decide not to warn
> about but that can still cause undefined behavior, e.g.:
>
> extern int g(void);
> int f(void)
> {
>         int i;
>
>         switch (g()) {
>         case 1:
>                 i = 0;
>         }
>
>         return i;
> }
>
> which gets compiled without warning under the assumption that
> g() always returns '1':
>
> 0000000000000000 <f>:
>    0: 48 83 ec 08           sub    $0x8,%rsp
>    4: e8 00 00 00 00       callq  9 <f+0x9>
> 5: R_X86_64_PC32 g-0x4
>    9: b8 00 00 00 00       mov    $0x0,%eax
>    e: 48 83 c4 08           add    $0x8,%rsp
>   12: c3                   retq
>
> Detecting those cases from the plugin may be a lot harder.

Sorry, bad example, that one is a bit less undefined than
I thought, as it will produce the same result every time,
regardless of the stack contents. I'll try to come up
with another test program instead.

       Arnd
