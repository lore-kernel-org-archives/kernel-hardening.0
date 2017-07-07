MIME-Version: 1.0
In-Reply-To: <CAK8P3a1ppGV9MuvkMxZkXmmmt_QrD3TA8CX8KTNHnNMgKrmKzw@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com>
 <CAK8P3a3Xra=9aTRAWJ8DbRRYL4J2ieMDveeV9Ahp6dE9xXqsrg@mail.gmail.com> <CAK8P3a1ppGV9MuvkMxZkXmmmt_QrD3TA8CX8KTNHnNMgKrmKzw@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 7 Jul 2017 09:16:17 +0100
Message-ID: <CAKv+Gu88yhvAFzAxkGUeigQux2LHjcATXeFrENzUrxgmgsfS5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 July 2017 at 23:08, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 6, 2017 at 1:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Jul 6, 2017 at 1:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
>>
>> Sorry, bad example, that one is a bit less undefined than
>> I thought, as it will produce the same result every time,
>> regardless of the stack contents. I'll try to come up
>> with another test program instead.
>
> I've tried a few more things, but couldn't actually come up with an example
> that ends up using uninitialized stack values without also warning about it,
> so your plugin may actually cover the most important cases.
>
> The remaining cases I found are either uninitialized uses that we get
> a compile-time warning for, or other kinds of undefined behavior
> (as in my earlier example).
>

Yes, so your original example is actually the opposite side of the
same coin. The compiler notices that 'i' may be returned
uninitialized, but since 0 is equally suitable as any other value in
this case, it just makes the assignment unconditional.

So imagine a function call h(&i) preceding the switch. This forces the
compiler to return whatever value i happens to have, because it cannot
know whether calling h() amounts to an initialization.

This all comes back to the way we pass structs by reference only,
which is why I retained the struct/union type test in the plugin, even
though stack buffers (i.e, u8 buf[xxx]) would probably deserve the
same treatment.

I think we should be able to deal with this more elegantly by
annotating function parameters that are guaranteed to be set by the
function, e.g,

extern h(int * __out i)

where we would on the one hand enforce that every code path in the
definition of h() contains an assignment of *i, and on the other hand,
omit the forced initialization of variables that appear as __out
parameters.

Alternatively (or to complement the effort), we could at least start
making the effort to convert byref initializers to struct assignment,
in cases where the function is a void type to begin with.
