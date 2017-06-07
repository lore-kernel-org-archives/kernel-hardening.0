MIME-Version: 1.0
In-Reply-To: <87d1agp2m6.fsf@concordia.ellerman.id.au>
References: <1496642591-1373-1-git-send-email-bhsharma@redhat.com>
 <1496665366.343.1.camel@gmail.com> <87d1agp2m6.fsf@concordia.ellerman.id.au>
From: Bhupesh SHARMA <bhupesh.linux@gmail.com>
Date: Wed, 7 Jun 2017 16:04:43 +0530
Message-ID: <CAFTCetQr+TAAfBi1+gOzSP_uk2sFo4g+W9=bWOxYpLYzZe7Z7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] powerpc: Increase ELF_ET_DYN_BASE to
 1TB for 64-bit applications
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Micay <danielmicay@gmail.com>, Bhupesh Sharma <bhsharma@redhat.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Anton Blanchard <anton@samba.org>, Daniel Cashman <dcashman@android.com>, Kees Cook <keescook@chromium.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 7, 2017 at 2:59 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Daniel Micay <danielmicay@gmail.com> writes:
>
>> Rather than doing this, the base should just be split for an ELF
>> interpreter like PaX.
>
> I don't quite parse that, I think you mean PaX uses a different base for
> an ELF interpreter vs a regular ET_DYN?

I am also not very conversant with PaX. AFAIU, we can use the
following methods to print the shared object dependencies instead of
ldd:

1. One can load the binary directly with LD_TRACE_LOADED_OBJECTS=1.

So, instead of:

# /lib64/ld-2.24.so ./large-bss-test-app
Segmentation fault (core dumped)

One can do:
# LD_TRACE_LOADED_OBJECTS=1 ./large-bss-test-app
        linux-vdso64.so.1 (0x00007fffa67a0000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fffa6590000)
        /lib64/ld64.so.2 (0x00007fffa67c0000)

2. There are other utils like pax-utils etc that we can use.

But, we generally cannot force a user to not use ldd to determine the
shared object dependencies, especially when all the documentation
points to it and it works well on the other archs like x86 and arm64.

> That would be cool. How do you know that it's an ELF interpreter you're
> loading? Is it just something that's PIE but doesn't request an
> interpreter?
>
> Is the PaX code somewhere I can look at?
>
>> It makes sense for a standalone executable to be as low in the address
>> space as possible.
>
> More or less. There are performance reasons why 1T could be good for us,
> but I want to see some performance numbers to justify that change. And
> it does mean you have a bit less address space to play with.

Do you have any specific performance test(s) in mind which I can run
to see how the 1TB impacts them? I am trying to run ltp after this
change and will be able to share the results shortly, but I am not
sure it provides the right data to validate such a change.

Regards,
Bhupesh
