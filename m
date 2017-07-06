MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK8P3a3Xra=9aTRAWJ8DbRRYL4J2ieMDveeV9Ahp6dE9xXqsrg@mail.gmail.com>
References: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
 <CAK8P3a3-yd3c_Psi5zo1yug5eJvADYxHkfWTa4++_5WFuENo7g@mail.gmail.com> <CAK8P3a3Xra=9aTRAWJ8DbRRYL4J2ieMDveeV9Ahp6dE9xXqsrg@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 7 Jul 2017 00:08:47 +0200
Message-ID: <CAK8P3a1ppGV9MuvkMxZkXmmmt_QrD3TA8CX8KTNHnNMgKrmKzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC/RFT PATCH] gcc-plugins: force initialize auto variables
 whose addresses are taken
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 6, 2017 at 1:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 6, 2017 at 1:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Jul 6, 2017 at 12:13 PM, Ard Biesheuvel
>
> Sorry, bad example, that one is a bit less undefined than
> I thought, as it will produce the same result every time,
> regardless of the stack contents. I'll try to come up
> with another test program instead.

I've tried a few more things, but couldn't actually come up with an example
that ends up using uninitialized stack values without also warning about it,
so your plugin may actually cover the most important cases.

The remaining cases I found are either uninitialized uses that we get
a compile-time warning for, or other kinds of undefined behavior
(as in my earlier example).

         Arnd
