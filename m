From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1496665366.343.1.camel@gmail.com>
References: <1496642591-1373-1-git-send-email-bhsharma@redhat.com> <1496665366.343.1.camel@gmail.com>
Date: Wed, 07 Jun 2017 19:29:37 +1000
Message-ID: <87d1agp2m6.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH] powerpc: Increase ELF_ET_DYN_BASE to 1TB for 64-bit applications
To: Daniel Micay <danielmicay@gmail.com>, Bhupesh Sharma <bhsharma@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: bhupesh.linux@gmail.com, Anton Blanchard <anton@samba.org>, Daniel Cashman <dcashman@android.com>, Kees Cook <keescook@chromium.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

Daniel Micay <danielmicay@gmail.com> writes:

> Rather than doing this, the base should just be split for an ELF
> interpreter like PaX.

I don't quite parse that, I think you mean PaX uses a different base for
an ELF interpreter vs a regular ET_DYN?

That would be cool. How do you know that it's an ELF interpreter you're
loading? Is it just something that's PIE but doesn't request an
interpreter?

Is the PaX code somewhere I can look at?

> It makes sense for a standalone executable to be as low in the address
> space as possible.

More or less. There are performance reasons why 1T could be good for us,
but I want to see some performance numbers to justify that change. And
it does mean you have a bit less address space to play with.

cheers
