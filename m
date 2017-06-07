MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87d1agp2m6.fsf@concordia.ellerman.id.au>
References: <1496642591-1373-1-git-send-email-bhsharma@redhat.com>
 <1496665366.343.1.camel@gmail.com> <87d1agp2m6.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Jun 2017 11:29:32 -0700
Message-ID: <CAGXu5jJE84GP8JCwtxKEp5Q_d0oVDScku4XJf7sAG2TPthVyZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] powerpc: Increase ELF_ET_DYN_BASE to
 1TB for 64-bit applications
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Micay <danielmicay@gmail.com>, Bhupesh Sharma <bhsharma@redhat.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Anton Blanchard <anton@samba.org>, Daniel Cashman <dcashman@android.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 7, 2017 at 2:29 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Daniel Micay <danielmicay@gmail.com> writes:
>
>> Rather than doing this, the base should just be split for an ELF
>> interpreter like PaX.
>
> I don't quite parse that, I think you mean PaX uses a different base for
> an ELF interpreter vs a regular ET_DYN?
>
> That would be cool. How do you know that it's an ELF interpreter you're
> loading? Is it just something that's PIE but doesn't request an
> interpreter?

I talk a bit about the situation here:
http://www.openwall.com/lists/kernel-hardening/2017/06/03/6

> Is the PaX code somewhere I can look at?

It's near here:
https://github.com/linux-scraping/linux-grsecurity/blob/grsec-test/fs/binfmt_elf.c#L1362

(Note the "&& elf_interpreter" part.) It's replacing the
arch_rnd_mmap() result with its own under some situations, etc.

To do something like this in upstream, we need to be sure we've sanely
dealt with the brk region, which follows the first loaded ELF, and if
it's the interpreter, that means brk ends up in mmap area, up near the
executable area (near what would become the misnomer of
ELF_ET_DYN_BASE -- should be ELF_PIE_BASE).

-Kees

-- 
Kees Cook
Pixel Security
